#import "MonthView.h"
#import "DayView.h"

@interface MonthView () <DayViewDelegate>

@property (nonatomic, strong) NSMutableArray<DayView *> *dayViewArray;
@property (nonatomic, strong) NSMutableArray *dayValueArray;

@end

@implementation MonthView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        self.layer.cornerRadius = 4;
        self.dayViewArray = [NSMutableArray array];
        self.dayValueArray = [NSMutableArray array];
        [self setViewLayout];
        
        
        
        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited;
        
        NSRect rect = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height);
        NSTrackingArea *focusTrackingArea = [[NSTrackingArea alloc] initWithRect:rect
                                                                         options:focusTrackingAreaOptions owner:self userInfo:nil];
        [self addTrackingArea:focusTrackingArea];
    }
    
    return self;
}

- (BOOL)isFlipped {
    return YES;
}


- (void)setViewLayout {
    for(int i = 1 ; i <= 5; i++) {
        for(int j = 1; j <= 7; j++) {
            DayView *dayView = [[DayView alloc] initWithFrame:CGRectMake(5.5 * j + (j - 1) * 30, 5.5 * i + (i - 1) * 30 , 30, 30)];
            dayView.titleTextField.stringValue = [NSString stringWithFormat:@"%d", j + 7 *(i - 1)];
            dayView.dayViewDelegate = self;
            [self addSubview:dayView];
            [self.dayViewArray addObject:dayView];
            if(j + 7 *(i - 1) == 31) {
                break;
            }
        }
    }
    
//    NSLog(@"-----------");
//    for(DayView *view in self.dayViewArray) {
//        NSLog(@"%@", view.titleTextField.stringValue);
//    }
//    NSLog(@"-----------");
}

- (void)updateMonthView:(NSArray *)array {
    for(NSNumber *number in array) {
        NSLog(@"The number value is %ld", [number integerValue]);
        for(DayView *view in self.dayViewArray) {
            if([view.titleTextField.stringValue isEqualToString:[number stringValue]]) {
                NSLog(@"The string value is %@", view.titleTextField.stringValue);
                if([number integerValue] == self.day) {
                    NSLog(@"The self.day is %ld", self.day);
                    continue;
                }
                if(![self.dayValueArray containsObject:number]) {
                    [self.dayValueArray addObject:number];
                }
                view.clicked = YES;
                
            } 
            else {
                if(!view.isClicked) {
                    view.clicked = NO;
                }
            }
        }
    }
}

- (void)setMonthViewDay:(NSInteger)day {
    NSLog(@"The day is %ld, and the self.day is %ld", day, self.day);
    if(day != self.day) {
        NSLog(@"day != self.day");
        [self.dayValueArray removeObject:[NSNumber numberWithInteger:self.day]];
        if(![self.dayValueArray containsObject:[NSNumber numberWithInteger:day]]) {
            [self.dayValueArray addObject:[NSNumber numberWithInteger:day]];
        }
        self.day = day;
    }
    
    for(DayView *view in self.dayViewArray) {
        NSLog(@"The self.dayViewArray is %@", [NSString stringWithFormat:@"%ld", day]);
        
        NSInteger value = [view.titleTextField.stringValue integerValue];
        if(value < day) {
            view.valid = YES;
        } else {
            view.valid = YES;
        }
        
        NSLog(@"%@", view.titleTextField.stringValue);
        if([view.titleTextField.stringValue isEqualToString:[NSString stringWithFormat:@"%ld", day]]) {
            [view updateStartDayBKColor:YES];
        } else {
            [view updateStartDayBKColor:NO];
        }
    }
}

#pragma mark --DayViewDelegate--
- (void)updateDayOfMonth:(NSInteger)day select:(BOOL)selected {
    if(selected) {
        if(![self.dayValueArray containsObject:[NSNumber numberWithInteger:day]]) {
            [self.dayValueArray addObject:[NSNumber numberWithInteger:day]];
        }
    } else {
        if([self.dayValueArray containsObject:[NSNumber numberWithInteger:day]]) {
            [self.dayValueArray removeObject:[NSNumber numberWithInteger:day]];
        }
    }
    
    if(self.monthViewDelegate && [self.monthViewDelegate respondsToSelector:@selector(updateDayArrayOfMonth:)]) {
        [self.monthViewDelegate updateDayArrayOfMonth:self.dayValueArray];
    }
}

- (void)popupTipsForCurrentDay {
    if(self.monthViewDelegate && [self.monthViewDelegate respondsToSelector:@selector(popupTipsForNotCancelCurrentDay)]) {
        [self.monthViewDelegate popupTipsForNotCancelCurrentDay];
    }
}



@end
