#import "GridBackGroundView.h"

@implementation GridBackGroundView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor colorWithString:@"#F8F9FA" andAlpha:1.0].CGColor;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        
        [self gridBackGroundViewLayout];
        
        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited;
        
        NSRect rect = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height);
        NSTrackingArea *focusTrackingArea = [[NSTrackingArea alloc] initWithRect:rect
                                                                         options:focusTrackingAreaOptions owner:self userInfo:nil];
        [self addTrackingArea:focusTrackingArea];
    }
    
    return self;
}

#pragma mark --Mouse Event--
- (void)mouseEntered:(NSEvent *)event {
    [[NSCursor pointingHandCursor] set];
    [self updateBKColor:YES];
}

- (void)mouseExited:(NSEvent *)event {
    [[NSCursor arrowCursor] set];
    [self updateBKColor:NO];
}

- (void)updateBKColor:(BOOL)flag {
    if (flag) {
        self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
        self.layer.borderColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0].CGColor;
    } else {
        self.layer.backgroundColor = [NSColor colorWithString:@"F8F9FA" andAlpha:1.0].CGColor;
        self.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
    }
}

- (void)mouseDown:(NSEvent *)event {
    [super mouseDown:event];
    [NSApp sendAction:@selector(clicked:) to:self from:self];
}

- (void)clicked:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(gridBackGroundViewClicked:)]) {
        [self.delegate gridBackGroundViewClicked:self.type];
    }
}

#pragma mark --Layout
- (void)gridBackGroundViewLayout {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(12);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(48);
    }];
    
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(8);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

#pragma mark --Lazy Load--
- (NSImageView *)imageView {
    if(!_imageView) {
        _imageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        [self addSubview:_imageView];
    }
    
    return _imageView;
}

- (NSTextField *)titleTextField {
    if (!_titleTextField) {
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:12 weight:NSFontWeightRegular];
        _titleTextField.alignment = NSTextAlignmentLeft;
        _titleTextField.textColor = [NSColor colorWithString:@"#666666" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;

        [self addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

@end
