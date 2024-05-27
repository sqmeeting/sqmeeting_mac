
#import "BaseViewController.h"
#import "Masonry.h"
#import "FrtcBaseImplement.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize startFlag;

/*- (void)dealloc {
    CAInfoLog(self.className, @"%@ dealloc", self.className);
    [managerClient release];
    [super dealloc];
}*/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ResRatio = 1;
    
    [self configBaseViewLayout];
}

- (instancetype)init {
    if (self = [super init]) {
        [self configBaseViewLayout];
    }
    return self;
}

-(void) configBaseViewLayout{
    int bkViewWidth = 400*self.ResRatio;
    int bkViewHeight = 657*self.ResRatio;
    int titleViewWidth = 400*self.ResRatio;
    int titleViewHeight = 56*self.ResRatio;
    int titleTextWidth = 220*self.ResRatio;
    int titleTextHeight = 19*self.ResRatio;
    
    [self.background mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(self.view.mas_top);
         make.centerX.mas_equalTo(self.view.mas_centerX);
         make.width.mas_greaterThanOrEqualTo(bkViewWidth);
         make.height.mas_greaterThanOrEqualTo(bkViewHeight);
     }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(self.background.mas_top);
         make.centerX.mas_equalTo(self.background.mas_centerX);
         make.width.mas_greaterThanOrEqualTo(titleViewWidth);
         make.height.mas_greaterThanOrEqualTo(titleViewHeight);
     }];
    
    [self.titleText mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.mas_equalTo(self.titleView.mas_centerY);
         make.centerX.mas_equalTo(self.background.mas_centerX);
         make.width.mas_greaterThanOrEqualTo(titleTextWidth);
         make.height.mas_greaterThanOrEqualTo(titleTextHeight);
     }];
}

- (NSImageView *) background{
    if (!_background){
        int bkViewWidth = 640*self.ResRatio;
        int bkViewHeight = 480*self.ResRatio;
        _background = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, bkViewWidth, bkViewHeight)];
        [_background setImage:[NSImage imageNamed:@"bg-white"]];
        _background.imageAlignment =  NSImageAlignTopLeft;
        _background.imageScaling =  NSImageScaleAxesIndependently;
        [self.view addSubview:_background];
    }
    return _background;
}

- (NSView *) titleView{
    if (!_titleView){
        int titleViewWidth = 400*self.ResRatio;
        int titleViewHeight = 56*self.ResRatio;
        _titleView = [[NSView alloc] initWithFrame:CGRectMake(0, 0, titleViewWidth, titleViewHeight)];
        _titleView.wantsLayer = YES;
        _titleView.layer.backgroundColor =[[FrtcBaseImplement baseImpleSingleton] buttonTitleColor].CGColor;
        [self.background addSubview:_titleView];
    }
    return _titleView;
}

- (NSTextField *) titleText {
    if (!_titleText){
        int titleTextWidth = 220*self.ResRatio;
        int titleTextHeight = 19*self.ResRatio;
        _titleText = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, titleTextWidth, titleTextHeight)];
        _titleText.stringValue = @"";
        _titleText.bordered = NO;
        _titleText.drawsBackground = NO;
        _titleText.backgroundColor = [NSColor clearColor];
        _titleText.textColor = [[FrtcBaseImplement baseImpleSingleton] whiteColor];
        _titleText.font = [NSFont systemFontOfSize:16];
        _titleText.alignment = NSTextAlignmentCenter;
        _titleText.editable = NO;
        [self.titleView addSubview:_titleText];
    }
    return _titleText;
}

- (void)setPageTitleText:(NSString *) titleText{
    self.titleText.stringValue = titleText;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
   
    }
    return self;
}

- (void)startWaitingProgress{}

- (void)stopWaitingProgress{}

- (void)showCallStateTipMessage:(NSString *)tipMsg{}

@end
