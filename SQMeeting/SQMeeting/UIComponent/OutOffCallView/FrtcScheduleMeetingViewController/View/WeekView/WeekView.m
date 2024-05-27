#import "WeekView.h"

@interface WeekView ()

@property (nonatomic, assign, getter=isClicked) BOOL clicked;

@property (nonatomic, assign, getter=isNotChanged) BOOL notChanged;

@end

@implementation WeekView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor colorWithString:@"#BBC3CE" andAlpha:1.0].CGColor;
        //self.layer.borderWidth = 1.0;
        //self.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        self.layer.cornerRadius = 6;
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
        _titleTextField.font = [NSFont systemFontOfSize:13 weight:NSFontWeightMedium];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;

        [self addSubview:_titleTextField];
    }
    
    return _titleTextField;
}


#pragma mark --Mouse Event--
//- (void)mouseEntered:(NSEvent *)event {
//    [[NSCursor pointingHandCursor] set];
//    [self updateBKColor:YES];
//}
//
//- (void)mouseExited:(NSEvent *)event {
//    if(self.isSelected) {
//        return;
//    }
//    
//    [[NSCursor arrowCursor] set];
//    [self updateBKColor:NO];
//}
//
- (void)updateBKColor:(BOOL)flag {
    if (flag) {
        self.layer.backgroundColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0].CGColor;
    } else {
        self.layer.backgroundColor = [NSColor colorWithString:@"#BBC3CE" andAlpha:1.0].CGColor;
    }
    
    if(self.weekDayOfDelegate && [self.weekDayOfDelegate respondsToSelector:@selector(updateDayOfWeek:select:)]) {
        [self.weekDayOfDelegate updateDayOfWeek:[self convertDayToInt:self.titleTextField.stringValue] select:flag];
    }
}

- (void)setSelectedColor:(BOOL)selectColor {
    if(selectColor) {
        if(self.isNotChanged) {
            self.layer.backgroundColor = [NSColor colorWithString:@"#6AAAFE" andAlpha:1.0].CGColor;
        } else {
            self.layer.backgroundColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0].CGColor;
            self.clicked = YES;
        }
    } else {
        if(self.isNotChanged) {
            self.layer.backgroundColor = [NSColor colorWithString:@"#6AAAFE" andAlpha:1.0].CGColor;
        } else {
            self.layer.backgroundColor = [NSColor colorWithString:@"#BBC3CE" andAlpha:1.0].CGColor;
            self.clicked = NO;
        }
    }
}

- (void)setCurrentColor:(BOOL)selectColor {
    if(selectColor) {
        self.layer.backgroundColor = [NSColor colorWithString:@"#6AAAFE" andAlpha:1.0].CGColor;
    } else if(self.notChanged && !selectColor) {
        self.layer.backgroundColor = [NSColor colorWithString:@"#BBC3CE" andAlpha:1.0].CGColor;
    }
    self.notChanged = selectColor;
}

- (NSInteger)convertDayToInt:(NSString *)day {
    if([day isEqualToString:NSLocalizedString(@"FM_MEETING_SUN", @"Sun")]) {
        return 1;
    } else if([day isEqualToString:NSLocalizedString(@"FM_MEETING_MON", @"Mon")]) {
        return 2;
    } else if([day isEqualToString:NSLocalizedString(@"FM_MEETING_TUE", @"Tue")]) {
        return 3;
    } else if([day isEqualToString:NSLocalizedString(@"FM_MEETING_WED", @"Wed")]) {
        return 4;
    } else if([day isEqualToString:NSLocalizedString(@"FM_MEETING_THU", @"Thu")]) {
        return 5;
    } else if([day isEqualToString:NSLocalizedString(@"FM_MEETING_FRI", @"Fri")]) {
        return 6;
    } else if([day isEqualToString:NSLocalizedString(@"FM_MEETING_SAT", @"Sat")]) {
        return 7;
    }
    
    return 0;
}

- (NSInteger)weekday {
    if([self.titleTextField.stringValue isEqualToString:NSLocalizedString(@"FM_MEETING_SUN", @"Sun")]) {
        return 7;
    } else if([self.titleTextField.stringValue  isEqualToString:NSLocalizedString(@"FM_MEETING_MON", @"Mon")]) {
        return 1;
    } else if([self.titleTextField.stringValue  isEqualToString:NSLocalizedString(@"FM_MEETING_TUE", @"Tue")]) {
        return 2;
    } else if([self.titleTextField.stringValue  isEqualToString:NSLocalizedString(@"FM_MEETING_WED", @"Wed")]) {
        return 3;
    } else if([self.titleTextField.stringValue  isEqualToString:NSLocalizedString(@"FM_MEETING_THU", @"Thu")]) {
        return 4;
    } else if([self.titleTextField.stringValue  isEqualToString:NSLocalizedString(@"FM_MEETING_FRI", @"Fri")]) {
        return 5;
    } else if([self.titleTextField.stringValue  isEqualToString:NSLocalizedString(@"FM_MEETING_SAT", @"Sat")]) {
        return 6;
    }
    
    return 0;
}

- (void)mouseDown:(NSEvent *)event {
    [super mouseDown:event];
    [NSApp sendAction:@selector(clicked:) to:self from:self];
}

- (void)clicked:(id)sender {
    if(self.isNotChanged) {
        if(self.weekDayOfDelegate && [self.weekDayOfDelegate respondsToSelector:@selector(canNotCancelCurrentDay)]) {
            [self.weekDayOfDelegate canNotCancelCurrentDay];
        }
        return;
    }
    self.clicked = !self.isClicked;
   
    [self updateBKColor:self.isClicked];
}

@end
