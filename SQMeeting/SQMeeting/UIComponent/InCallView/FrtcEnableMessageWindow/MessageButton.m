#import "MessageButton.h"

@implementation MessageButton

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor colorWithString:@"#F8F9FA" andAlpha:1.0].CGColor;
        [self titleBarButtonLayout];
        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved |
                                                                 NSTrackingCursorUpdate |
                                                                 NSTrackingActiveWhenFirstResponder |
                                                                 NSTrackingActiveInKeyWindow |
                                                                 NSTrackingActiveInActiveApp |
                                                                 NSTrackingActiveAlways |
                                                                 NSTrackingAssumeInside |
                                                                 NSTrackingInVisibleRect |
                                                                    NSTrackingEnabledDuringMouseDrag;

        NSRect rect = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height);
        NSTrackingArea *focusTrackingArea = [[NSTrackingArea alloc] initWithRect:rect
                                                                         options:focusTrackingAreaOptions owner:self userInfo:nil];
        [self addTrackingArea:focusTrackingArea];
    }
    return self;
}

- (void)titleBarButtonLayout {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(11);
        make.height.mas_equalTo(11);
    }];
}

- (void)mouseDown:(NSEvent *)event {
    [super mouseDown:event];
    [NSApp sendAction:@selector(clicked:) to:self from:self];
}

- (void)clicked:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(messageButtonClicked:)]) {
        [self.delegate messageButtonClicked:self.buttonType];
    }
}

#pragma mark --getter load--
- (NSImageView *)imageView {
    if (!_imageView){
        _imageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 11, 11)];
        _imageView.imageAlignment = NSImageAlignTopLeft;
        _imageView.imageScaling   =  NSImageScaleAxesIndependently;
        [self addSubview:_imageView];
    }
    
    return _imageView;
}


@end
