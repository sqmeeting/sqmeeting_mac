#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

NSString * const FMeetingUserStopContentNotification = @"com.fmeeting.user.stop.content";
NSString * const FMeetingUserStopContentKey = @"com.fmeeting.user.stop.content.key";

NSString * const FMeetingUserAppShareAllWindowClosedNotification = @"com.fmeeting.user.appsharing.allwindow.closed.content";
NSString * const FMeetingUserAppShareAllWindowClosedKey = @"com.fmeeting.user.appsharing.allwindow.closed.key";
NSString * const FMeetingUserAppShareAllWindowMinimizedStatusChangedNotification = @"com.fmeeting.user.appsharing.allwindow.minimized.content";
NSString * const FMeetingUserAppShareAllWindowMinimizedStatusChangedKey = @"com.fmeeting.user.appsharing.allwindow.minimized.key";

NSString * const FMeetingContentShouldStopForAdminStopMeetingNotification = @"com.fmeeting.content.state.stop.for.admin.stop.meeting";
NSString * const FMeetingContentShouldStopForAdminStopMeetingKey = @"com.fmeeting.content.state.stop.for.admin.stop.key";

NSString * const FMeetingDisplayAddRemoveNotification = @"com.fmeeting.display.add.remove";
NSString * const FMeetingDisplayAddRemoveKey = @"com.fmeeting.display.add.remove.key";

NSString * const FMeetingDisplayChangedNotification = @"com.fmeeting.display.changed.key";

NSString * const FMeetingUserActivelyHangupNotification = @"com.fmeeting.hangup.call.key";

NSString * const FMeetingInitializedNotification = @"com.fmeeting.initialized.key";

NSString * const FMeetingCallCloseNotification = @"com.fmeeting.call.close.key";

NSString * const FMeetingSettingViewCloseNotification = @"com.fmeeting.setting.close.key";

#define ObjectiveStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

@interface FrtcBaseImplement : NSObject

+ (FrtcBaseImplement *)baseImpleSingleton;

- (NSColor *)baseColor;
- (NSColor *)blueColor;
- (NSColor *)redColor;
- (NSColor *)whiteColor;
- (NSColor *)lightGrayColor;
- (NSColor *)buttonTitleColor;
- (NSColor *)sharingBarColor;
- (NSColor *)titleButtonBackGroundColor;


- (NSString *)bundleVersion;
- (NSString *)masterVersion;

- (CGFloat)baseScale;

- (CGFloat)screenWidth;
- (CGFloat)screenHeight;

- (NSString *)currentTimeString ;
- (NSString *)dateStringWithTimeString:(NSString *)timeString;
- (NSString *)dateStringWithAccountTimeString:(NSString *)timeString;
- (NSDate *)dateConvertFromTimeString:(NSString *)dataString;
- (NSDate *)DateConvertFromDateAndTimeString:(NSString *)dataString;
- (NSString *)getDateTimeFromDateString:(NSString *)dateString;
- (NSString *)getTimeFromDateString:(NSString *)dateString;
- (NSString *)dateStringWithMonthAndDayString:(NSString *)timeString;

- (BOOL)isTodayWithTimeString:(NSDate *)time;
- (NSDate *)getCurrentDateWithFormarter;
- (NSDate *)getDateFromSting:(NSString *)aDateString;
- (NSTimeInterval)getTimeIntervalFromNowToDateFromSting:(NSString *)aDateString;
- (NSTimeInterval)getTimeIntervalSinceNowToDate:(NSDate *)aDate;

@end

NS_ASSUME_NONNULL_END
