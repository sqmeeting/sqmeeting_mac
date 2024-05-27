#import "FrtcReminderImageButton.h"

#import "Masonry.h"
#import "NSColor+Enhancement.h"

@implementation FrtcReminderImageButton


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self reminderImageButtonLayout];
        
        //NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited;
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

- (void)reminderImageButtonLayout {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(12);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(6);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)mouseEntered:(NSEvent *)event {
    [[NSCursor pointingHandCursor] set];
    
    if (self.reminderImageButtonDelegate && [self.reminderImageButtonDelegate respondsToSelector:@selector(didIntoArea: withSenderType:)]) {
        [self.reminderImageButtonDelegate didIntoArea:YES withSenderType:self.buttonType];
    }
}

- (void)mouseExited:(NSEvent *)event {
    [[NSCursor arrowCursor] set];
    if (self.reminderImageButtonDelegate && [self.reminderImageButtonDelegate respondsToSelector:@selector(didIntoArea: withSenderType:)]) {
        [self.reminderImageButtonDelegate didIntoArea:NO withSenderType:self.buttonType];
    }
}

- (void)mouseDown:(NSEvent *)event {
    [super mouseDown:event];
    [NSApp sendAction:@selector(clicked:) to:self from:self];
}

- (void)clicked:(id)sender {
    if (self.reminderImageButtonDelegate && [self.reminderImageButtonDelegate respondsToSelector:@selector(reminderImageButtonClicked:)]) {
        [self.reminderImageButtonDelegate reminderImageButtonClicked:self.buttonType];
    }
}

#pragma mark --getter load--
- (NSImageView *)imageView {
    if (!_imageView){
        _imageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        [_imageView setImage:[NSImage imageNamed:@"icon-user"]];
        _imageView.imageAlignment = NSImageAlignTopLeft;
        _imageView.imageScaling   =  NSImageScaleAxesIndependently;
        [self addSubview:_imageView];
    }
    
    return _imageView;
}

- (NSTextField *)title {
    if (!_title){
        _title = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _title.bordered = NO;
        _title.drawsBackground = NO;
        _title.stringValue = NSLocalizedString(@"FM_MEETING_INFO", @"Meeting info");
        _title.backgroundColor = [NSColor clearColor];
        _title.layer.backgroundColor = [NSColor colorWithString:@"FFFFFF" andAlpha:1.0].CGColor;
        _title.font = [NSFont systemFontOfSize:12 weight:NSFontWeightRegular];
        //_title.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _title.textColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0];
        _title.alignment = NSTextAlignmentLeft;
        _title.editable = NO;
        [self addSubview:_title];
    }
    
    return _title;
}

@end
