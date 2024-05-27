#import "FrtcDatePickerView.h"

@interface FrtcDatePickerView()

@property (nonatomic, strong) NSTrackingArea      *trackingArea;

@end

@implementation FrtcDatePickerView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    CGFloat width = self.bounds.size.height * 0.9;
    CGFloat height = self.bounds.size.height * 0.9;
    CGRect pathFrame = CGRectMake((self.bounds.size.width - width)/2.0, (self.bounds.size.height - height)/2.0, width, height);
    
    //let path = NSBezierPath(ovalIn: pathFrame)
    NSBezierPath * path = [NSBezierPath bezierPathWithOvalInRect:pathFrame];
    
    if(self.isSelected) {
        NSColor *color = self.selectedBackgroundColor;
        [color setFill];
        [path fill];
        
        color = self.selectedBorderColor;
        [color setStroke];
        [path stroke];
        
    } else if(self.isHighlighted) {
        NSColor *color = self.highlightedBackgroundColor;
        [color setFill];
        [path fill];
        
        color = self.highlightedBorderColor;
        [color setStroke];
        [path stroke];
    } else {
        NSColor *color = self.backgroundColor;
        self.backgroundColor = [NSColor whiteColor];
        [color setFill];
        [path fill];
        
        
        self.borderColor = [NSColor whiteColor];
        color = self.borderColor;
        [color setStroke];
        [path stroke];
    }
    
    if(self.isMarked) {
        CGRect pathFrame = CGRectMake((self.bounds.size.width - 4.0)/2.0, self.label.frame.origin.y - 5.0, 4.0, 4.0);
        NSBezierPath * path = [NSBezierPath bezierPathWithOvalInRect:pathFrame];
        NSColor *color = self.markColor;
       // self.markColor = [NSColor whiteColor];
        [color setFill];
        [path fill];
    }

}

- (instancetype)initWithDateComponents:(NSDateComponents *)dateComponents {
    self = [super initWithFrame:NSZeroRect];
    
    if(self) {
        self.dateComponents = dateComponents;
        self.font = [NSFont systemFontOfSize:12.0];
        //self.lineHeight = NMDatePicker.lineHeightForFont(self.font);
        
        self.label = [[NSTextField alloc] initWithFrame:NSZeroRect];
        self.label.editable = NO;
        self.label.backgroundColor = [NSColor clearColor];
        self.label.bordered = NO;
        self.label.alignment = NSTextAlignmentCenter;
        self.label.textColor = [NSColor blackColor];
        self.label.font = self.font;
        self.label.stringValue = [NSString stringWithFormat:@"%ld", self.dateComponents.day];
        
        [self addSubview:self.label];
        
        self.marked = NO;
        
        [self setupLayView];
        
    }
    
    return self;
}

- (void)updateTrackingAreas {
    if (self.trackingArea) {
        [self removeTrackingArea:_trackingArea];
        //[_trackingArea release];
    }
    self.trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds
                                                 options:NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited
                                                   owner:self
                                                userInfo:nil];
    [self addTrackingArea:self.trackingArea];
}

- (void)setDayViewSelected:(BOOL)state {
    self.selected = state;
    
    if(state) {
        NSColor *color = self.selectedTextColor;
        self.label.textColor = color;
    } else {
        NSColor *color = self.textColor;
        self.label.textColor = color;
    }
    
    [self setNeedsDisplayInRect:self.bounds];
}

- (void)setViewHighlighted:(BOOL)state {
    self.highlighted = state;
    
    [self setNeedsDisplayInRect:self.bounds];
}

- (void)mouseExited:(NSEvent *)event {
    self.dayHighlightedAction(NO);
}

- (void)mouseEntered:(NSEvent *)event {
    self.dayHighlightedAction(YES);
}

- (void)mouseDown:(NSEvent *)event {
    self.daySelectedAction();
}

- (void)setupLayView {
    CGRect rect = CGRectMake(2.5, (self.bounds.size.height - self.lineHeight) / 2 + 0.5, self.bounds.size.width - 4, self.lineHeight);
    rect = CGRectMake(2.5, 10.5, 32, 16);
    self.label.frame = rect;
}



@end
