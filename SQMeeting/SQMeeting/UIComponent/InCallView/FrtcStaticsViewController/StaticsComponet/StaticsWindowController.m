#import "StaticsWindowController.h"
#import "Masonry.h"
#import "FrtcBaseImplement.h"

@interface StaticsWindowController ()
@end

@implementation StaticsWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self.window standardWindowButton:NSWindowZoomButton].enabled = NO;
    [self.window standardWindowButton:NSWindowMiniaturizeButton].enabled = NO;
    
    
    self.window.title = @"Call Statistics";
    
    
}

@end
