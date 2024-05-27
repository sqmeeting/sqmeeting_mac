#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WeekViewDelegate <NSObject>

- (void)updateDayOfWeek:(NSInteger)day select:(BOOL)selected;

- (void)canNotCancelCurrentDay;

@end

@interface WeekView : NSView

@property (nonatomic, strong) NSTextField *titleTextField;

@property (nonatomic, weak) id<WeekViewDelegate> weekDayOfDelegate;

- (NSInteger)weekday;

- (void)setSelectedColor:(BOOL)selectColor;

- (void)setCurrentColor:(BOOL)selectColor;

- (NSInteger)convertDayToInt:(NSString *)day;

@end

NS_ASSUME_NONNULL_END
