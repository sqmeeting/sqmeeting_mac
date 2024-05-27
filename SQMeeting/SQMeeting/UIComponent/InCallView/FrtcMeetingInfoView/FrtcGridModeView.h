#import <Cocoa/Cocoa.h>
#import "GridBackGroundView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcGridModeViewDelegate <NSObject>

- (void)selectGridMode:(BOOL)isGridMode;

@end

@interface FrtcGridModeView : NSView

@property (nonatomic, strong) GridBackGroundView *galleryBackgroundView;

@property (nonatomic, strong) GridBackGroundView *presenterBackgroundView;

@property (nonatomic, strong) NSTextField *presenterTitleTextField;

@property (nonatomic, weak) id<FrtcGridModeViewDelegate> gridModeDelegate;

@end

NS_ASSUME_NONNULL_END
