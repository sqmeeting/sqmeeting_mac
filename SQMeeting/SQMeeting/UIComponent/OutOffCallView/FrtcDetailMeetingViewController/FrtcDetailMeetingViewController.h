#import <Cocoa/Cocoa.h>
#import "MeetingDetailModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol FrtcDetailMeetingViewControllerDelegate <NSObject>

- (void)joinCall:(MeetingDetailModel *)model;

- (void)removeInfomationItem:(NSString *)meetingStartTime;

@end

@interface FrtcDetailMeetingViewController : NSViewController

@property (nonatomic, strong) MeetingDetailModel *detailMeetingInfoModel;

@property (nonatomic, weak) id<FrtcDetailMeetingViewControllerDelegate> delegate;

- (void)updateMeetingInfomation:(MeetingDetailModel *)detailMeetingInfoModel;

@end

NS_ASSUME_NONNULL_END
