#import "FrtcRecurrenceView.h"

@implementation FrtcRecurrenceView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    
    NSColor *color1 = [NSColor colorWithString:@"#72E5A7" andAlpha:1.0];
    NSColor *color2 = [NSColor colorWithString:@"#3EC76E" andAlpha:1.0];
    NSGradient *gradient = [[NSGradient alloc] initWithColorsAndLocations:color1, 0.0, color2, 0.5, nil];
    [gradient drawInRect:dirtyRect angle:0];
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor colorWithString:@"#3EC76E" andAlpha:1.0].CGColor;
//        self.layer.borderWidth = 1.0;
//        self.layer.borderColor = [NSColor colorWithString:@"#3EC76E" andAlpha:1.0].CGColor;
        self.layer.cornerRadius = 2.0;
        self.layer.masksToBounds = YES;

        [self setViewLayout];
    }
    
    return self;
}

- (void)setViewLayout {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}


#pragma ---lazy code--
- (NSTextField *)titleTextField {
    if (!_titleTextField) {
        _titleTextField =  [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:10 weight:NSFontWeightMedium];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = NSLocalizedString(@"FM_MEETING_RECURRENCE_RECURRENT_TAG", @"Recurrence");
        [self addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

@end
