#import <Cocoa/Cocoa.h>
#import "FrtcInCallModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcEnableMessageWindowDelegate <NSObject>

- (void)startMessageSuccess;

@optional
- (void)cancelMessage;

@end

@interface FrtcEnableMessageWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size;

@property (nonatomic, strong) FrtcInCallModel *inCallModel;

@property (nonatomic, weak) id<FrtcEnableMessageWindowDelegate> messageWindwoDelegate;

- (void)showWindowWithWindow:(NSWindow *)window;

- (void)adjustToSize:(NSSize)size;

@end

NS_ASSUME_NONNULL_END
