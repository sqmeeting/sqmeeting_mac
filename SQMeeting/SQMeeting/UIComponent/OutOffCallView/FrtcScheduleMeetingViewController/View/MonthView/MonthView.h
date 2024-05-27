#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MonthViewDelegate <NSObject>

- (void)updateDayArrayOfMonth:(NSMutableArray *)array;

- (void)popupTipsForNotCancelCurrentDay;

@end

@interface MonthView : NSView

@property (nonatomic, weak) id<MonthViewDelegate> monthViewDelegate;

@property (nonatomic, assign) NSInteger day;

- (void)setMonthViewDay:(NSInteger)day;

- (void)updateMonthView:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
