#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FrtcTimeViewControllerDelegate <NSObject>

- (void)selectTimeValue:(NSString *)timeValue withTag:(NSInteger)tag;

@end

@interface FrtcTimeViewController : NSViewController

@property (nonatomic, weak) id<FrtcTimeViewControllerDelegate> delegate;

@property (nonatomic, assign) NSInteger viewControllerTag;

@property (nonatomic, strong) NSDate *scheduleMeetingStartTime;

@property (nonatomic, copy)   NSString *currentTimeString;

@property (nonatomic, copy)   NSString *scheduleEndDayTime;

@property (nonatomic, strong) NSDate *shceduleMeetingAllowEndTime;

@property (nonatomic, assign, getter=isBeginTimeSheet) BOOL beginTimeSheet;

@property (nonatomic, strong) NSDate *beginLatestTime;

@property (nonatomic, assign, getter=isBeginLastDay) BOOL beginLastDay;

@property (nonatomic, assign, getter=isBeginFirstDay) BOOL beginFirstDay;

@end

NS_ASSUME_NONNULL_END
