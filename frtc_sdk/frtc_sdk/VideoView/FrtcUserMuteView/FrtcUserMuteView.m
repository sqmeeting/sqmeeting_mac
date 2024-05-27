#import "FrtcUserMuteView.h"
#import "FrtcSDKBundle.h"

@implementation FrtcUserMuteView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    if(self) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor colorWithRed:0 green:0 blue:0 alpha:0.8].CGColor;
        self.muteView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.pinView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.pinView.hidden = YES;
        [self addSubview:self.muteView];
        [self addSubview:self.pinView];
    }
    
    return self;
}

- (void)updateMuteView:(BOOL)userMute {
    if(userMute) {
        NSString *imagePath = [FrtcSDKBundle bundlePath:@"icon-incall-mute@2x.png"];
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
        [self.muteView setImage:image];
    } else {
        NSString *imagePath = [FrtcSDKBundle bundlePath:@"icon-incall-unmute@2x.png"];
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
        [self.muteView setImage:image];
    }
}

- (void)updatePin:(BOOL)pin {
    if(pin) {
        NSString *imagePath = [FrtcSDKBundle bundlePath:@"icon-status-pin@2x.png"];
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
        [self.pinView setImage:image];
        self.pinView.imageScaling = NSImageScaleAxesIndependently;
        
        self.muteView.frame = CGRectMake(0, 0, 30, 30);
        self.pinView.hidden = NO;
        self.pinView.frame = CGRectMake(30, 5, 20, 20);
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 60, 30);
    } else {
        self.muteView.frame = CGRectMake(0, 0, 30, 30);
        self.pinView.hidden = YES;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 30, 30);
    }
}

@end
