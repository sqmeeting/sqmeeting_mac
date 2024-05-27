#import "FrtcBaseViewController.h"
#import "Masonry.h"
#import "FrtcBaseImplement.h"
#import "FrtcMaskView.h"

@interface FrtcBaseViewController ()

//@property (nonatomic, strong) FrtcMaskView*    maskView;
@property (nonatomic, strong) NSProgressIndicator *progressIndicator;

@end

@implementation FrtcBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
}

- (instancetype)init {
    if (self = [super init]) {
       
    }
    return self;
}

-(void)configBaseViewLayout {
    int bkViewWidth     = 640;
    int bkViewHeight    = 480;
    
    [self.background mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(self.view.mas_top);
         make.centerX.mas_equalTo(self.view.mas_centerX);
         make.width.mas_greaterThanOrEqualTo(bkViewWidth);
         make.height.mas_greaterThanOrEqualTo(bkViewHeight);
     }];
}

- (NSImageView *) background {
    if (!_background){
        int bkViewWidth = 640;
        int bkViewHeight = 480;
        _background = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, bkViewWidth, bkViewHeight)];
       // [_background setImage:[NSImage imageNamed:@"icon-background"]];
        _background.imageAlignment =  NSImageAlignTopLeft;
        _background.imageScaling =  NSImageScaleAxesIndependently;
        [self.view addSubview:_background];
    }
    return _background;
}

- (FrtcMaskView *)maskView {
    if (!_maskView) {
        _maskView = [[FrtcMaskView alloc] initWithFrame:NSMakeRect(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _maskView.wantsLayer = YES;
        _maskView.layer.backgroundColor = [NSColor blackColor].CGColor;
    }
    return _maskView;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
       
    }
    return self;
}

- (void)startWaitingProgress{}

- (void)stopWaitingProgress{}

- (void)showCallStateTipMessage:(NSString *)tipMsg{}

- (void)showMaskView:(BOOL)show {
    self.maskView.alphaValue = 0.2;
    if (show) {
        [self.view addSubview:self.maskView];
    } else {
        [self.maskView removeFromSuperview];
    }
}

- (void)showMaskViewWithProgress:(BOOL)show {
    [self showMaskView:show];
    if (show) {
        [self.view addSubview:self.progressIndicator];
    }
    else {
        [self.progressIndicator removeFromSuperview];
    }
}

- (void)showInvisibleMaskView:(BOOL)show {
    self.maskView.alphaValue = 0;
    if (show) {
        [self.view addSubview:self.maskView];
    }else {
        [self.maskView removeFromSuperview];
    }
}

@end
