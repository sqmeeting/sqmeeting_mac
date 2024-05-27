#import "FrtcRecurrenceIntervalView.h"

@interface FrtcRecurrenceIntervalView() <HoverImageViewDelegate>

@end

@implementation FrtcRecurrenceIntervalView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    NSColor *color1 = [NSColor colorWithString:@"#E5FFF1" andAlpha:1.0];
    NSColor *color2 = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0];
    NSGradient *gradient = [[NSGradient alloc] initWithColorsAndLocations:color1, 0.0, color2, 0.5, nil];
    [gradient drawInRect:dirtyRect angle:0];
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [NSColor colorWithString:@"#3EC76E" andAlpha:1.0].CGColor;
        self.layer.cornerRadius = 2.0;
        self.layer.masksToBounds = YES;

        [self setViewLayout];
    }
    
    return self;
}

- (void)setViewLayout {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(8);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.arrayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.mas_equalTo(self.titleTextField.mas_right).offset(5);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-9);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(10);
    }];
}

#pragma mark --HoverImageViewDelegate--
- (void)hoverImageViewClickedwithSenderTag:(NSInteger)tag {
    if(self.internalViewDelegate && [self.internalViewDelegate respondsToSelector:@selector(popupScheduleRecurrencView)]) {
        [self.internalViewDelegate popupScheduleRecurrencView];
    }
}

- (NSTextField *)titleTextField {
    if (!_titleTextField) {
        _titleTextField =  [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:10 weight:NSFontWeightMedium];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = @"123";
        [self addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (HoverImageView *)arrayImageView {
    if(!_arrayImageView) {
        _arrayImageView = [[HoverImageView alloc] initWithFrame:CGRectMake(0, 0, 17, 16)];
        _arrayImageView.delegate = self;
        _arrayImageView.image = [NSImage imageNamed:@"icon_re_back"];
        [_arrayImageView setWantsLayer:YES];
        [self addSubview:_arrayImageView];
    }
    
    return _arrayImageView;
}

@end
