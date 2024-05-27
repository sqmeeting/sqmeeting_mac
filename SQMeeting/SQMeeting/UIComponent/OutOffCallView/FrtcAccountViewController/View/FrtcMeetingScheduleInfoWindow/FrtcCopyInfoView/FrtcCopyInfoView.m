#import "FrtcCopyInfoView.h"

@interface FrtcCopyInfoView ()

@property (nonatomic, strong) NSTextField *titleTextField;

@property (nonatomic, strong) NSImageView *imageView;

@end

@implementation FrtcCopyInfoView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0].CGColor;
        //self.layer.borderWidth = 1.0;
        //self.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        self.layer.cornerRadius = 4.0;
        self.layer.masksToBounds = YES;

        [self setViewLayout];
        
        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited;
        
        NSRect rect = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height);
        NSTrackingArea *focusTrackingArea = [[NSTrackingArea alloc] initWithRect:rect
                                                                         options:focusTrackingAreaOptions owner:self userInfo:nil];
        [self addTrackingArea:focusTrackingArea];
    }
    
    return self;
}

- (void)setViewLayout {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(19);
    }];
    
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}



- (NSTextField *)titleTextField {
    if(!_titleTextField) {
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightRegular];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0];
        _titleTextField.stringValue = NSLocalizedString(@"FM_MEETING_INFO_COPY", @"Copy Invitation");
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        [self addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (NSImageView *)imageView {
    if(!_imageView) {
        _imageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        _imageView.image = [NSImage imageNamed:@"icon_copy_info"];
        [self addSubview:_imageView];
    }
    
    return _imageView;
}

- (void)mouseEntered:(NSEvent *)event {
    [[NSCursor pointingHandCursor] set];
}

- (void)mouseExited:(NSEvent *)event {
    [[NSCursor arrowCursor] set];
}

- (void)mouseDown:(NSEvent *)event {
    [super mouseDown:event];
    [NSApp sendAction:@selector(clicked:) to:self from:self];
}

- (void)clicked:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(copyInfo)]) {
        [self.delegate copyInfo];
    }
}

@end
