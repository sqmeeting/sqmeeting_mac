#import <Foundation/Foundation.h>
#import <MetalKit/MetalKit.h>
#import "object_impl.h"

NS_ASSUME_NONNULL_BEGIN

@interface FrtcMTKRender : NSObject<MTKViewDelegate>

@property (nonatomic, copy) NSString *mediaID;

@property (readonly, nonatomic, getter=isVideoRendering) BOOL videoRendering;

@property (nonatomic, assign) RTC::VideoColorFormat colorFormat;

- (instancetype)initWithMetalKitView:(nonnull MTKView *)view;

- (void)initiateVideoRendering;

- (void)endupVideoRendering;

- (void)configVideoColorFormat:(RTC::VideoColorFormat)format;

@end

NS_ASSUME_NONNULL_END
