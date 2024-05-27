#import "FrtcPersonalViewController.h"
#import "FrtcPersonView.h"

@interface FrtcPersonalViewController () <FrtcPersonViewDelegate>

@end

@implementation FrtcPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
    
    FrtcPersonView *view = [[FrtcPersonView alloc] initWithFrame:CGRectMake(0, 0, 258, 245)];
    view.delegate = self;
    [self.view addSubview:view];
    view.model = self.model;
}

- (void)dealloc {
    NSLog(@"FrtcPersonalViewController dealloc");
}

#pragma mark --FrtcPersonViewDelegate--
- (void)frtcPersonalLogout {
    if(self.delegate && [self.delegate respondsToSelector:@selector(frtcPersonalViewLogout)]) {
        [self.delegate frtcPersonalViewLogout];
    }
}

- (void)frtcPersonalupdatePassword {
    if(self.delegate && [self.delegate respondsToSelector:@selector(frtcPersonalViewLogout)]) {
        [self.delegate frtcPersonalViewUpdatePassword];
    }
}

- (void)frtcPopupModifyNameWindow {
    if(self.delegate && [self.delegate respondsToSelector:@selector(frtcPersonalPopupModifyNameWindow)]) {
        [self.delegate frtcPersonalPopupModifyNameWindow];
    }
}

@end
