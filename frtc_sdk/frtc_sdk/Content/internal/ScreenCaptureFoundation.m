#import "ScreenCaptureFoundation.h"
#include "common_interface.h"
#import <Cocoa/Cocoa.h>

#define    MAX_WIDTH        1920
#define    MAX_HEIGHT       1080

@interface  ScreenCaptureFoundation()

@property (nonatomic, strong) AVCaptureSession         *captureSession;
@property (nonatomic, strong) AVCaptureVideoDataOutput *screenDataOutput;
@property (nonatomic, strong) AVCaptureScreenInput     *screenDataInput;
@property (nonatomic, assign) CGDirectDisplayID        screenDisplayID;

@end

@implementation ScreenCaptureFoundation

- (instancetype)initWithDisplayID:(CGDirectDisplayID)id {
    self = [super init];
    self.screenDisplayID = id;
  
    [self addObersverOForScreenResolution];
    
    return self;
}

- (void)addObersverOForScreenResolution {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screrenResolutionChangeCallback:) name:NSApplicationDidChangeScreenParametersNotification object:nil];
}

- (void)configDirectDisplayID:(CGDirectDisplayID)displayID {
    self.screenDisplayID = displayID;
}

- (void)screrenResolutionChangeCallback:(NSNotification*)notification {
    [self.captureSession beginConfiguration];
    [self configCaptureScreenOutput];
    [self.captureSession commitConfiguration];
}

-(void)startCaptureScreen {
    self.captureSession = [[AVCaptureSession alloc] init];

    if (@available(macOS 10.15, *)) {
        self.captureSession.sessionPreset = AVCaptureSessionPreset1920x1080;
    } else {
        self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    }

    self.screenDataInput = [[AVCaptureScreenInput alloc] initWithDisplayID:self.screenDisplayID] ;
   
    if (!self.screenDataInput ) {
       return;
    }
    if ([self.captureSession canAddInput:self.screenDataInput])
        [self.captureSession addInput:self.screenDataInput];


    [self configCaptureScreenOutput];
    
    if([self.captureSession canAddOutput:self.screenDataOutput])
        [self.captureSession addOutput:self.screenDataOutput];

    [self.captureSession startRunning];
}

-(void)stopCaptureScreen {
    if(self.captureSession) {
        [self.captureSession stopRunning];
        if(self.screenDataOutput) {
            [self.captureSession removeOutput:self.screenDataOutput];
            self.screenDataOutput= nil;
        }
        
        if(self.screenDataInput) {
            [self.captureSession removeInput:self.screenDataInput];
            self.screenDataInput = nil;
        }
    }
}

- (void)dealloc {
    [self stopCaptureScreen];
}

- (void)configCaptureScreenOutput {
    self.screenDataOutput = [[AVCaptureVideoDataOutput alloc] init];

    BOOL isCapturingNV12 = NO;
        
    NSArray *avaiablePixelArrays = [self.screenDataOutput availableVideoCVPixelFormatTypes];
    NSNumber *pixlFormate         = [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange];
    
    for (NSNumber *pixel in avaiablePixelArrays) {
        if([pixel unsignedIntegerValue] == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange ||
            [pixel unsignedIntegerValue]  == kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange) {
            pixlFormate = pixel;
            isCapturingNV12 = YES;
        }
    }
        
    NSScreen *captureScreen;
    for (NSScreen *screen in NSScreen.screens) {
        NSNumber *screenNumber = [screen.deviceDescription objectForKey:@"NSScreenNumber"];
        
        if([screenNumber intValue] == self.screenDisplayID) {
            captureScreen = screen;
            
            break;
        }
    }
    
    BOOL isConfigSize = NO;
    
    NSDictionary *deviceDescription = [captureScreen deviceDescription];
    NSSize captureSize = [[deviceDescription objectForKey:NSDeviceSize] sizeValue];

    if(CGSizeEqualToSize(captureSize , NSMakeSize(1800, 1169))
       || CGSizeEqualToSize(captureSize , NSMakeSize(1512, 982))
       || CGSizeEqualToSize(captureSize , NSMakeSize(1352, 878))
       || CGSizeEqualToSize(captureSize , NSMakeSize(1147, 745))
       || CGSizeEqualToSize(captureSize , NSMakeSize(2048, 1280))) {
        isConfigSize = YES;
    }

    
    NSDictionary *captureSettings;
    
    if(isConfigSize) {
        captureSettings =
            @{((NSString *)kCVPixelBufferPixelFormatTypeKey):@(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange),
                          (NSString *)kCVPixelBufferWidthKey:[NSNumber numberWithInt:MAX_WIDTH],
                         (NSString *)kCVPixelBufferHeightKey:[NSNumber numberWithInt:MAX_HEIGHT]
              };
    } else {
        captureSettings =
            @{(NSString *)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)};
    }
        
    [self.screenDataOutput setVideoSettings:captureSettings];
        
    dispatch_queue_t inputQueue = dispatch_queue_create("com.fmeeting.content", NULL);
    dispatch_queue_t highPriority = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_set_target_queue(inputQueue, highPriority);
    [self.screenDataOutput setSampleBufferDelegate:self queue:inputQueue];
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CVImageBufferRef videoFrame = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(videoFrame, 0);

    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(videoFrame, 0);

    size_t width = CVPixelBufferGetWidth(videoFrame);
    size_t height = CVPixelBufferGetHeight(videoFrame);
    size_t stride = 0;

    if ([self.delegate respondsToSelector:@selector(screenCaptureOutBuffer:width:height:stride:)]) {
        [self.delegate screenCaptureOutBuffer:baseAddress width:width height:height stride:stride];
    }
    
    CVPixelBufferUnlockBaseAddress(videoFrame, 0);
}

@end
