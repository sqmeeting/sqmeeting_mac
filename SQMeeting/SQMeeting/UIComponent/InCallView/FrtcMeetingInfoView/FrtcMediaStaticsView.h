#import <Cocoa/Cocoa.h>
#import "HoverImageView.h"
#import "FrtcMediaStaticsModel.h"
#import "FrtcHotViewAreaView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcMediaStaticsViewDelegate <NSObject>

- (void)staticsViewCursorIsInView:(BOOL)isInView;

- (void)popupStaticsWindow;

@end

@interface FrtcMediaStaticsView : NSView

@property (nonatomic, strong) NSTextField *latencyLabel;
@property (nonatomic, strong) NSTextField *latencyTextField;

@property (nonatomic, strong) NSTextField *rateLabel;
@property (nonatomic, strong) NSTextField *rateTextField;
@property (nonatomic, strong) NSTextField *rateDownTextField;

@property (nonatomic, strong) NSTextField *audioLabel;
@property (nonatomic, strong) NSTextField *audioTextField;
@property (nonatomic, strong) NSTextField *audioDownTextField;

@property (nonatomic, strong) NSTextField *videoLabel;
@property (nonatomic, strong) NSTextField *videoTextField;
@property (nonatomic, strong) NSTextField *videoDownTextField;

@property (nonatomic, strong) NSTextField *shareLabel;
@property (nonatomic, strong) NSTextField *shareTextField;
@property (nonatomic, strong) NSTextField *shareDownTextField;

@property (nonatomic, strong) NSImageView *upArrowImageView1;
@property (nonatomic, strong) NSImageView *upArrowImageView2;
@property (nonatomic, strong) NSImageView *upArrowImageView3;
@property (nonatomic, strong) NSImageView *upArrowImageView4;

@property (nonatomic, strong) NSImageView *downArrowImageView1;
@property (nonatomic, strong) NSImageView *downArrowImageView2;
@property (nonatomic, strong) NSImageView *downArrowImageView3;
@property (nonatomic, strong) NSImageView *downArrowImageView4;

@property (nonatomic, strong) HoverImageView *imageView;
@property (nonatomic, strong) NSTextField    *staticsInfoLabel;
@property (nonatomic, strong) FrtcHotViewAreaView *hotAreaView;

@property (nonatomic, weak) id<FrtcMediaStaticsViewDelegate> mediaStaticsDelegate;

@property (nonatomic, strong) FrtcMediaStaticsModel *staticsMediaModel;

- (void)updateStatics:(FrtcMediaStaticsModel *)mediaStaticsModel;

@end

NS_ASSUME_NONNULL_END
