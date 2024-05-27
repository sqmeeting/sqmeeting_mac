#import "FrtcMTKRender.h"
#import <MetalKit/MetalKit.h>
#import "ObjectInterface.h"
#import <CoreVideo/CoreVideo.h>
#import <CoreVideo/CVPixelBuffer.h>
#import <CoreVideo/CVMetalTextureCache.h>
#import <Metal/MTLCommandQueue.h>
#import <Metal/MTLComputePipeline.h>
#import <CoreVideo/CVMetalTexture.h>
#import <Metal/MTLTexture.h>
#import "FrtcSDKBundle.h"

@interface FrtcMTKRender () <MTKViewDelegate>

@property (nonatomic, assign) unsigned int length;
@property (nonatomic, assign) unsigned int width;
@property (nonatomic, assign) unsigned int height;

@property (nonatomic, weak)   MTKView *view;
@property (nonatomic, strong) id<MTLCommandQueue> cmdQueue;
@property (nonatomic, strong) id<MTLDevice> mtlDevice;
@property (nonatomic, strong) CAMetalLayer *layer;
@property (nonatomic, strong) id<MTLRenderPipelineState> renderPipelineState;

// NV12
@property (nonatomic, strong) MTLTextureDescriptor *textureDescY;
@property (nonatomic, strong) id<MTLTexture>textureY;
@property (nonatomic, strong) MTLTextureDescriptor *textureDescUV;
@property (nonatomic, strong) id<MTLTexture>textureUV;

// I420
@property (nonatomic, strong) MTLTextureDescriptor *textureDescU;
@property (nonatomic, strong) MTLTextureDescriptor *textureDescV;
@property (nonatomic, strong) id<MTLTexture>textureU;
@property (nonatomic, strong) id<MTLTexture>textureV;

@property (nonatomic,assign) int  textureH;
@property (nonatomic,assign) int  textureW;

@end

@implementation FrtcMTKRender

- (MTLSize)threadGroupCount:(nonnull id<MTLTexture>)texture {
    return MTLSizeMake(8, 8, 1);
}

- (MTLSize)threadGroups:(nonnull id<MTLTexture>)texture {
    MTLSize size = [self threadGroupCount:texture];
    return MTLSizeMake(texture.width/size.width, texture.height/size.height, 1);
}

- (instancetype)initWithMetalKitView:(nonnull MTKView *)view {
    self = [super init];
    _colorFormat = RTC::kI420;
    self.view = view;
    [self initComponents];
    return  self;
}

#pragma mark - private methods
- (void)initComponents {
    [self initMetalLayer];
    [self initRenderPipeline];
    [self initCmdQueue];
}

- (void)initMetalLayer {
    self.view.device = MTLCreateSystemDefaultDevice();
    self.mtlDevice = self.view.device;
    self.layer = (CAMetalLayer*)self.view.layer;
    self.layer.pixelFormat = MTLPixelFormatBGRA8Unorm;
    self.layer.framebufferOnly = YES;
    self.layer.drawableSize = self.view.bounds.size;
    self.layer.device = self.mtlDevice;
}

- (void)initRenderPipeline {
    NSBundle *myBundle = [FrtcSDKBundle bundle];
    id<MTLLibrary>library = [self.mtlDevice newDefaultLibraryWithBundle:myBundle error:nil];
    id<MTLFunction>vertexFunction = [library newFunctionWithName:@"ProcessVertex"];
    id<MTLFunction>fragFunction = nil;
    
    switch (self.colorFormat) {
        case RTC::kI420:
            fragFunction = [library newFunctionWithName:@"I420Fragment"];
            break;
            
        case RTC::kNV12:
            fragFunction = [library newFunctionWithName:@"NV12Fragment"];
            break;
        default:
            NSAssert(fragFunction != nil, @"unknown color format type");
            break;
    }
    
    MTLRenderPipelineDescriptor *desc = [[MTLRenderPipelineDescriptor alloc] init];
    desc.vertexFunction = vertexFunction;
    desc.fragmentFunction = fragFunction;
    desc.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
    
    id<MTLRenderPipelineState> renderPipelineState = [self.mtlDevice newRenderPipelineStateWithDescriptor:desc error:nil];
    
    self.renderPipelineState = renderPipelineState;
}

- (void)initCmdQueue {
    id<MTLCommandQueue>cmdQueue = [self.mtlDevice newCommandQueue];
    self.cmdQueue = cmdQueue;
}

- (void)renderI420:(uint8_t *)yBuffer uBuffer:(uint8_t *)uBuffer vBuffer:(uint8_t *)vBuffer width:(int)width height:(int)height {
    if (!self.textureDescY || self.textureW != width ||self.textureH != height) {
        self.textureDescY = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatR8Unorm width:width height:height mipmapped:NO];
    }
    
    if (!self.textureDescU || self.textureW != width ||self.textureH != height) {
        self.textureDescU = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatR8Unorm width:width/2 height:height/2 mipmapped:NO];
    }
    
    if (!self.textureDescV || self.textureW != width ||self.textureH != height) {
        self.textureDescV = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatR8Unorm width:width/2 height:height/2 mipmapped:NO];
    }
    
    MTLRegion mtlRegion = MTLRegionMake2D(0, 0, width, height);
    self.textureY = [self.mtlDevice newTextureWithDescriptor:self.textureDescY];
    [self.textureY replaceRegion:mtlRegion mipmapLevel:0 withBytes:yBuffer bytesPerRow:width];
    
    mtlRegion = MTLRegionMake2D(0, 0, width/2, height/2);
    self.textureU = [self.mtlDevice newTextureWithDescriptor:self.textureDescU];
    [self.textureU replaceRegion:mtlRegion mipmapLevel:0 withBytes:uBuffer bytesPerRow:width/2];
    
    self.textureV = [self.mtlDevice newTextureWithDescriptor:self.textureDescV];
    [self.textureV replaceRegion:mtlRegion mipmapLevel:0 withBytes:vBuffer bytesPerRow:width/2];
    
    
    id<MTLCommandBuffer>cmdBuffer = [self.cmdQueue commandBuffer];
    id<CAMetalDrawable>drawable = [self.layer nextDrawable];
    
    MTLRenderPassDescriptor*renderPass = [[MTLRenderPassDescriptor alloc]init];
    renderPass.colorAttachments[0].texture = [drawable texture];
    renderPass.colorAttachments[0].loadAction = MTLLoadActionClear;
    renderPass.colorAttachments[0].clearColor = MTLClearColorMake(1.0, 1.0, 1.0, 1.0);
    renderPass.colorAttachments[0].storeAction = MTLStoreActionStore;
    
    id<MTLRenderCommandEncoder>cmdEncoder = [cmdBuffer renderCommandEncoderWithDescriptor:renderPass];
    [cmdEncoder setRenderPipelineState:self.renderPipelineState];
    
    float vertexArray[] = {-1.0, -1.0, 0, 1.0,
                           1.0,  -1.0, 0, 1.0,
                           -1.0,  1.0, 0, 1.0,
                           1.0,  1.0,  0, 1.0};
    
    id<MTLBuffer>vertexBuf = [self.mtlDevice newBufferWithBytes:vertexArray length:sizeof(vertexArray) options:MTLResourceCPUCacheModeDefaultCache];
    
    [cmdEncoder setVertexBuffer:vertexBuf offset:0 atIndex:0];

    float textureCoordinate[] = {0, 1,
                                 1, 1,
                                 0, 0,
                                 1, 0};
    
    id<MTLBuffer>textureCoordinateBuf = [self.mtlDevice newBufferWithBytes:textureCoordinate length:sizeof(textureCoordinate) options:MTLResourceCPUCacheModeDefaultCache];
    
    [cmdEncoder setVertexBuffer:textureCoordinateBuf offset:0 atIndex:1];
    [cmdEncoder setFragmentTexture:self.textureY atIndex:0];
    [cmdEncoder setFragmentTexture:self.textureU atIndex:1];
    [cmdEncoder setFragmentTexture:self.textureV atIndex:2];
    
    [cmdEncoder drawPrimitives:MTLPrimitiveTypeTriangleStrip vertexStart:0 vertexCount:4];
    [cmdBuffer presentDrawable:drawable];
    [cmdEncoder endEncoding];
    [cmdBuffer commit];
}

-(void)renderNV12:(uint8_t*)yBuffer uvBuffer:(uint8_t*)uvBuffer width:(int)width height:(int)height {
    if (!self.textureDescY || self.textureW != width ||self.textureH != height) {
        self.textureDescY = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatR8Unorm width:width height:height mipmapped:NO];
    }
    self.textureY = [self.mtlDevice newTextureWithDescriptor:self.textureDescY];
    MTLRegion mtlRegion = MTLRegionMake2D(0, 0, width, height);
    [self.textureY replaceRegion:mtlRegion mipmapLevel:0 withBytes:yBuffer bytesPerRow:width];
    
    if (!self.textureDescUV || self.textureW != width ||self.textureH != height) {
        self.textureDescUV = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatRG8Unorm width:width/2 height:height/2 mipmapped:NO];
    }
    
    mtlRegion = MTLRegionMake2D(0, 0, width/2, height/2);
    self.textureUV = [self.mtlDevice newTextureWithDescriptor:self.textureDescUV];
    [self.textureUV replaceRegion:mtlRegion mipmapLevel:0 withBytes:uvBuffer bytesPerRow:width];
    
    id<MTLCommandBuffer>cmdBuffer = [self.cmdQueue commandBuffer];
    id<CAMetalDrawable>drawable = [self.layer nextDrawable];
    
    MTLRenderPassDescriptor*renderPass = [[MTLRenderPassDescriptor alloc]init];
    renderPass.colorAttachments[0].texture = [drawable texture];
    renderPass.colorAttachments[0].loadAction = MTLLoadActionClear;
    renderPass.colorAttachments[0].clearColor = MTLClearColorMake(1.0, 1.0, 1.0, 1.0);
    renderPass.colorAttachments[0].storeAction = MTLStoreActionStore;
    
    
    id<MTLRenderCommandEncoder>cmdEncoder = [cmdBuffer renderCommandEncoderWithDescriptor:renderPass];
    [cmdEncoder setRenderPipelineState:self.renderPipelineState];
    
    float vertexArray[] = {-1.0, -1.0, 0, 1.0,
                           1.0, -1.0, 0, 1.0,
                           -1.0, 1.0, 0, 1.0,
                           1.0,  1.0, 0, 1.0};
    
    id<MTLBuffer>vertexBuf = [self.mtlDevice newBufferWithBytes:vertexArray length:sizeof(vertexArray) options:MTLResourceCPUCacheModeDefaultCache];
    
    [cmdEncoder setVertexBuffer:vertexBuf offset:0 atIndex:0];
    
    float textureCoordinate[] = {0, 1,
                                 1, 1,
                                 0, 0,
                                 1, 0};
    
    id<MTLBuffer>textureCoordinateBuf = [self.mtlDevice newBufferWithBytes:textureCoordinate length:sizeof(textureCoordinate) options:MTLResourceCPUCacheModeDefaultCache];
    
    [cmdEncoder setVertexBuffer:textureCoordinateBuf offset:0 atIndex:1];
    [cmdEncoder setFragmentTexture:self.textureY atIndex:0];
    [cmdEncoder setFragmentTexture:self.textureUV atIndex:1];
    
    [cmdEncoder drawPrimitives:MTLPrimitiveTypeTriangleStrip vertexStart:0 vertexCount:4];
    [cmdBuffer presentDrawable:drawable];
    [cmdEncoder endEncoding];
    [cmdBuffer commit];
}

- (void)drawInMTKView:(nonnull MTKView *)view {
    if(self.isVideoRendering) {
        void  *buffer = (void *)malloc(1920 * 1080 * 3 / 2);
        
        _width = 0;
        _height = 0;
        _length = 0;
        [[ObjectInterface sharedObjectInterface] receiveVideoFrameObject:self.mediaID buffer:&buffer length:&_length width:&_width height:&_height];
        
        if(buffer == NULL) {
            free(buffer);
            
            return;
        }
        
        if(_width == 0 || _height == 0) {
            free(buffer);
            
            return;
        }
        
        unsigned int size = _width * _height;
        uint8_t *yBuffer  = (uint8_t *)buffer;
        uint8_t *uvBuffer = yBuffer + size;
     
        if(self.colorFormat == RTC::VideoColorFormat::kI420) {
            uint8_t *vBuffer = uvBuffer + size/4;
            [self renderI420:yBuffer uBuffer:uvBuffer vBuffer:vBuffer width:_width height:_height];
        } else if(self.colorFormat == RTC::VideoColorFormat::kNV12) {
            [self renderNV12:yBuffer uvBuffer:uvBuffer width:_width height:_height];
        }

        
        free(buffer);
    }
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
    return;
}

#pragma mark public function
- (void)initiateVideoRendering {
    _videoRendering = true;
    
}
- (void)endupVideoRendering {
    _videoRendering = false;
}

- (void)configVideoColorFormat:(RTC::VideoColorFormat)format {
    _colorFormat = format;
    [self initRenderPipeline];
}


@end
