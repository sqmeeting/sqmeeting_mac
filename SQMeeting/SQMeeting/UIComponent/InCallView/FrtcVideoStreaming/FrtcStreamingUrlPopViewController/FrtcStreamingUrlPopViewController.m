#import "FrtcStreamingUrlPopViewController.h"
#import "FrtcStreamingPopTabCell.h"

@interface FrtcStreamingUrlPopViewController () <FrtcStreamingPopTabCellDelegate>

@property (nonatomic, strong) FrtcStreamingPopTabCell *tabUrlCell;

@end

@implementation FrtcStreamingUrlPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.view.wantsLayer = YES;
    //self.view.layer.backgroundColor = [NSColor colorWithString:@"#000000" andAlpha:0.16].CGColor;
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
    [self setupPopUrllViewCellLayout];
}

- (void)setupPopUrllViewCellLayout {
    [self.tabUrlCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(NSMakeSize(127, 24));
    }];
}

#pragma mark --TabCell Sender--
- (void)popupSteamingUrlWindow {
    if(self.delegate && [self.delegate respondsToSelector:@selector(popupStreamingWindow)]) {
        [self.delegate popupStreamingWindow];
    }
}

#pragma mark -- getter lazy --
- (FrtcStreamingPopTabCell *)tabUrlCell {
    if(!_tabUrlCell) {
        _tabUrlCell = [[FrtcStreamingPopTabCell alloc] initStreamingPopCell];
        _tabUrlCell.imageView.image = [NSImage imageNamed:@"icon_invite_url_un_selected"];
        _tabUrlCell.titleView.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
        _tabUrlCell.titleView.stringValue = NSLocalizedString(@"FM_VIDEO_STREAMING_SHARE_URL_POP", @"Share Live");
        _tabUrlCell.target = self;
        _tabUrlCell.action = @selector(popupSteamingUrlWindow);
        [self.view addSubview:_tabUrlCell];
    }
    
    return _tabUrlCell;
}

@end

