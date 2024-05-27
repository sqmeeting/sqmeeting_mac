#import "FrtcContentWindowController.h"
#import "ContentCollectionViewController.h"


@interface FrtcContentWindowController ()

@end

@implementation FrtcContentWindowController

- (void)dealloc {
    //NSLog(@"[%s]", __func__);
}

- (void)createContentCollectionVC {
    ContentCollectionViewController *pVC = [[ContentCollectionViewController alloc] init];

    pVC.view.frame                  = NSMakeRect(0, 0, 600, 400);
    pVC.view.wantsLayer             = YES;
    pVC.view.layer.backgroundColor  = [NSColor cyanColor].CGColor;
    self.window.contentView         = pVC.view;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.window standardWindowButton:NSWindowZoomButton].enabled = NO;
    [self.window standardWindowButton:NSWindowMiniaturizeButton].enabled = NO;
    
    [self createContentCollectionVC];
}

- (void)windowWillClose:(NSNotification *)notification {
    if ([self.delegate respondsToSelector:@selector(onRleaseSelectContentWindow)]) {
        [self.delegate onRleaseSelectContentWindow];
    }
}

@end
