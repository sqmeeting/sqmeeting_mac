#import <Cocoa/Cocoa.h>
#import "FrtcDatePickerView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol FrtcDatePickerDelegate <NSObject>

- (void)updateTimeString:(NSString *)timeString timeDate:(NSDate *)date type:(NSInteger)dateTag;

@end

@interface FrtcDatePicker : NSView

- (instancetype)initWithFrame:(NSRect)frameRect withDate:(NSDate *)date;

@property (nonatomic, strong) NSDate *dateValue;

@property (nonatomic, assign) NSInteger firstDayOfWeek;

@property (nonatomic, strong) NSColor *backgroundColor;

@property (nonatomic, strong) NSFont *titleFont;

@property (nonatomic, strong) NSFont *font;

@property (nonatomic, strong) NSColor *textColor;

@property (nonatomic, strong) NSColor *todayTextColor;

@property (nonatomic, strong) NSColor *selectedTextColor;

@property (nonatomic, strong) NSColor *selectedBackgroundColor;

@property (nonatomic, strong) NSColor *selectedBorderColor;

@property (nonatomic, strong) NSColor *highlightedBackgroundColor;

@property (nonatomic, strong) NSColor *highlightedBorderColor;

@property (nonatomic, strong) NSColor *todayBackgroundColor;

@property (nonatomic, strong) NSColor *todayBorderColor;

@property (nonatomic, strong) NSColor *nextMonthTextColor;

@property (nonatomic, strong) NSColor *previousMonthTextColor;

@property (nonatomic, strong) NSColor *markColor;

@property (nonatomic, strong) NSColor *todayMarkColor;

@property (nonatomic, strong) NSColor *selectedMarkColor;

@property (nonatomic, strong) NSCalendar *calendar;

@property (nonatomic, assign) NSCalendarUnit dateUnitMask;

@property (nonatomic, assign) NSCalendarUnit dateTimeUnitMask;

@property (nonatomic, strong) NSDateComponents *firstDayComponents;

@property (nonatomic, strong) NSTextField *currentMonthLabel;

@property (nonatomic, strong) NSButton *monthBackButton;

@property (nonatomic, strong) NSButton *monthForwardButton;

@property (nonatomic, assign) int currentHeight;

@property (nonatomic, assign) CGFloat lineHeight;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) NSMutableArray<NSString *> *weekdays;

@property (nonatomic, strong) NSMutableArray<NSTextField *> *weekdayLabels;

@property (nonatomic, strong) NSMutableArray<FrtcDatePickerView *> *days;

@property (nonatomic, strong) NSMutableArray<NSDate *> *markedDates;

@property (nonatomic, assign) NSInteger datepickerTag;

@property (nonatomic, assign, getter=isNeedDisableSomeDay) BOOL needDisableSomeDay;

@property (nonatomic, assign, getter=isRangeOfSomeDay) BOOL rangeOfSomeDay;

@property (nonatomic, weak) id<FrtcDatePickerDelegate> datePickerDelegate;

- (void)setDatePickerrange:(NSDate *)beginDate;

- (void)setDatePickerrangeFromDate:(NSDate *)date endDate:(NSDate *)endDate;

- (void)datePickerValidRangeFromDate:(NSDate *)beginDate endDate:(NSDate *)endDate wihtCurrentMeetingStartTime:(NSDate *)meetingStartTime;

@end

NS_ASSUME_NONNULL_END
