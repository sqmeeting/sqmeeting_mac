#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UploadingLogWindowDelegate <NSObject>

- (void)loadingClose;

@end

@interface UploadingLogWindow : NSWindow

- (void)showWindowWithWindow:(NSWindow *)window;

- (void)adjustToSize:(NSSize)size;

- (void)upLoadLogProcess:(NSString *)logInfo;

- (instancetype)initWithSize:(NSSize)size;

@property (nonatomic, weak) id<UploadingLogWindowDelegate> loadingDelegate;

@end

NS_ASSUME_NONNULL_END
