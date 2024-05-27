#import <Cocoa/Cocoa.h>
#import "HoverImageView.h"
#import "TipsBackgroundView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TipsViewType) {
    TipsRecording = 201,
    TipsStreaming
};

@protocol FrtcVideoRecordingTipsViewDelegate <NSObject>

- (void)showTipsView:(BOOL)show withViewType:(TipsViewType)type;

- (void)stopVideoRecording:(TipsViewType)type;

@end

@interface FrtcVideoRecordingTipsView : NSView

@property (nonatomic, strong) NSImageView *imageView;

@property (nonatomic, strong) NSTextField *title;

@property (nonatomic, strong) HoverImageView *endRecordingImageView;

@property (nonatomic, strong) TipsBackgroundView *tipsBackGroundView;

@property (nonatomic, weak) id<FrtcVideoRecordingTipsViewDelegate> tipsViewDelegate;

@property (nonatomic, assign) TipsViewType viewsType;

@end

NS_ASSUME_NONNULL_END
