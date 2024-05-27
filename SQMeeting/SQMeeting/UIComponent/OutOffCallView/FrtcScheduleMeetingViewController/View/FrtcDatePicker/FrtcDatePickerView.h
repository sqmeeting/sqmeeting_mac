#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DaySelectedAction)(void);
typedef void (^DayHighlightedAction)(BOOL highlighted);

@interface FrtcDatePickerView : NSView

@property (nonatomic, strong) NSTextField *label;

@property (nonatomic, assign) CGFloat lineHeight;

@property (nonatomic, strong) NSDateComponents *dateComponents;

@property (nonatomic, strong) NSColor *backgroundColor;

@property (nonatomic, strong) NSColor *borderColor;

@property (nonatomic, assign, getter=isSelected) BOOL selected;

@property (nonatomic, assign, getter=isHighlighted) BOOL highlighted;

@property (nonatomic, strong) NSColor * highlightedBackgroundColor;

@property (nonatomic, strong) NSColor *highlightedBorderColor;

@property (nonatomic, strong) NSColor *selectedBackgroundColor;

@property (nonatomic, strong) NSColor *selectedBorderColor;

@property (nonatomic, strong) NSColor *todayBackgroundColor;

@property (nonatomic, strong) NSColor *todayBorderColor;

@property (nonatomic, strong) NSColor *textColor;

@property (nonatomic, strong) NSColor *selectedTextColor;

@property (nonatomic, strong) NSColor *highlightedTextColor;

@property (nonatomic, strong) NSFont *font;

@property (nonatomic, assign, getter=isMarked) BOOL marked;

@property (nonatomic, strong) NSColor *markColor;

@property (nonatomic, copy) DaySelectedAction daySelectedAction;

@property (nonatomic, copy) DayHighlightedAction dayHighlightedAction;

- (instancetype)initWithDateComponents:(NSDateComponents *)dateComponents;

- (void)setDayViewSelected:(BOOL)state;

- (void)setViewHighlighted:(BOOL)state;

@end

NS_ASSUME_NONNULL_END
