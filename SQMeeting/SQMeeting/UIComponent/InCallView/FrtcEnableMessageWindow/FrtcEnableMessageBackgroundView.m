#import "FrtcEnableMessageBackgroundView.h"
#import "FrtcMultiTypesButton.h"

@interface FrtcEnableMessageBackgroundView ()

@property (nonatomic, assign, getter=isSelected) BOOL selected;

@end

@implementation FrtcEnableMessageBackgroundView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        
        [self FrtcEnableMessageBackGroundViewLayout];
        
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
    if(self.isSelected) {
        return;
    }
    
    [[NSCursor arrowCursor] set];
    [self updateBKColor:NO];
}

- (void)updateBKColor:(BOOL)flag {
    if (flag) {
        self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
        self.layer.borderColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0].CGColor;
    } else {
        self.layer.backgroundColor = [NSColor colorWithString:@"FFFFFF" andAlpha:1.0].CGColor;
        self.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
    }
}

- (void)messageBackgroundViewSelected:(BOOL)selected {
    self.selected = selected;
    [self updateBKColor:selected];
    self.selectedTagImageView.hidden = !selected;
}

- (void)mouseDown:(NSEvent *)event {
    [super mouseDown:event];
    [NSApp sendAction:@selector(clicked:) to:self from:self];
}

- (void)clicked:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(EnableMessageGroundViewClicked:)]) {
        [self.delegate EnableMessageGroundViewClicked:self.type];
    }
}

#pragma mark --Layout
- (void)FrtcEnableMessageBackGroundViewLayout {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(8);
        make.width.mas_equalTo(72);
        make.height.mas_equalTo(44);
    }];
    
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(2);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.selectedTagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(19);
        make.height.mas_equalTo(19);
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
        _titleTextField.font = [NSFont systemFontOfSize:10 weight:NSFontWeightRegular];
        _titleTextField.alignment = NSTextAlignmentLeft;
        _titleTextField.textColor = [NSColor colorWithString:@"#666666" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;

        [self addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (NSImageView *)selectedTagImageView {
    if(!_selectedTagImageView) {
        _selectedTagImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 19, 19)];
        [_selectedTagImageView setImage:[NSImage imageNamed:@"icon_selected_tag"]];
        _selectedTagImageView.hidden = YES;
        [self addSubview:_selectedTagImageView];
    }
    
    return _selectedTagImageView;
}


@end
