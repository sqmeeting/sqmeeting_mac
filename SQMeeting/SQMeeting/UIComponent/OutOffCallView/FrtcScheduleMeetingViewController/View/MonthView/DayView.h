#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DayViewDelegate <NSObject>

- (void)updateDayOfMonth:(NSInteger)day select:(BOOL)selected;

- (void)popupTipsForCurrentDay;

@end

@interface DayView : NSView

@property (nonatomic, strong) NSTextField *titleTextField;

@property (nonatomic, assign, getter=isStartDay) BOOL startDay;

@property (nonatomic, assign, getter=isValid) BOOL valid;

@property (nonatomic, weak) id<DayViewDelegate> dayViewDelegate;

@property (nonatomic, assign, getter=isClicked) BOOL clicked;

- (void)updateStartDayBKColor:(BOOL)flag;


@end

NS_ASSUME_NONNULL_END
