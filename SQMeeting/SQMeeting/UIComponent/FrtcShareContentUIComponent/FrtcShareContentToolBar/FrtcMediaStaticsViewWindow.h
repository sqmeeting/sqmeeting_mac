#import <Cocoa/Cocoa.h>
#import "FrtcStatisticalModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol FrtcMediaStaticsViewWindowDelegate <NSObject>

- (void)pupupDetailStaticWindow;

- (void)handleStaticsEvent:(FrtcStatisticalModel *)staticsModel;

@end

@interface FrtcMediaStaticsViewWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size;

@property (nonatomic, weak) id<FrtcMediaStaticsViewWindowDelegate> staticsWindowDelegate;

@end

NS_ASSUME_NONNULL_END
