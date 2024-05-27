#import "DayView.h"

@interface DayView ()

@property (nonatomic, strong) NSColor *selectedBackgroundColor;

@end

@implementation DayView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    CGFloat width = self.bounds.size.height * 0.9;
    CGFloat height = self.bounds.size.height * 0.9;
    CGRect pathFrame = CGRectMake((self.bounds.size.width - width)/2.0, (self.bounds.size.height - height)/2.0, width, height);
    
    //let path = NSBezierPath(ovalIn: pathFrame)
    NSBezierPath * path = [NSBezierPath bezierPathWithOvalInRect:pathFrame];
    
    if(!self.isValid) {
        NSColor *color = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0];
        self.titleTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:0.3];
        [color setFill];
        [path fill];
        
        color = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0];
        [color setStroke];
        [path stroke];
    } else if(self.isClicked) {
        NSColor *color = [NSColor colorWithString:@"#026FFE" andAlpha:1.0];
        self.titleTextField.textColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0];
        [color setFill];
        [path fill];
        
        color = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0];
        [color setStroke];
        [path stroke];
        
    } else if(self.isStartDay) {
        NSColor *color = [NSColor colorWithString:@"#6AAAFE" andAlpha:1.0];
        self.titleTextField.textColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0];
        [color setFill];
        [path fill];
        
        color = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0];
        [color setStroke];
        [path stroke];
    } else if(!self.isClicked) {
        NSColor *color = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0];
        self.titleTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        [color setFill];
        [path fill];
        
        color = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0];
        [color setStroke];
        [path stroke];
    } else if(!self.isStartDay) {
        NSColor *color = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0];
        self.titleTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        [color setFill];
        [path fill];
        
        color = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0];
        [color setStroke];
        [path stroke];
    }
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        self.wantsLayer = YES;
//        self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
//        self.layer.borderWidth = 1.0;
//        self.layer.borderColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
        //self.layer.cornerRadius = 13.5;
        //self.layer.masksToBounds = YES;
        
       
        
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
        _titleTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightMedium];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = @"日";
        [self addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

#pragma mark --Mouse Event--
- (void)updateBKColor:(BOOL)flag {
    if(self.isStartDay) {
        if(self.dayViewDelegate && [self.dayViewDelegate respondsToSelector:@selector(popupTipsForCurrentDay)]) {
            [self.dayViewDelegate popupTipsForCurrentDay];
        }
        return;
    }
    if(self.dayViewDelegate && [self.dayViewDelegate respondsToSelector:@selector(updateDayOfMonth:select:)]) {
        [self.dayViewDelegate updateDayOfMonth:[self.titleTextField.stringValue integerValue] select:flag];
    }
    [self setNeedsDisplayInRect:self.bounds];
}

- (void)updateStartDayBKColor:(BOOL)flag {
    self.startDay = flag;
    self.clicked = NO;
    if(self.isStartDay) {
        self.clicked = !self.isStartDay;
    }
    [self setNeedsDisplayInRect:self.bounds];
}

- (void)mouseDown:(NSEvent *)event {
    [super mouseDown:event];
    [NSApp sendAction:@selector(clicked:) to:self from:self];
}

- (void)clicked:(id)sender {
    self.clicked = !self.isClicked;
   [self updateBKColor:self.isClicked];
}

@end
