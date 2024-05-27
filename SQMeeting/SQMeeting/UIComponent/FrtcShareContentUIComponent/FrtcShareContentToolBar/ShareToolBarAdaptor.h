
#import <Cocoa/Cocoa.h>
#import "FrtcInCallModel.h"
#import "FrtcInfoInstance.h"

@class FrtcShareContentToolBar;

typedef enum _MeetingStatus {
    MEETING_STAT_IDLE,
    MEETING_STAT_CONNECTING,
    MEETING_STAT_CONNECTED,
    MEETING_STAT_PLAYING,
} MeetingStatus;


@protocol contentControlToolBarResponderDelegate <NSObject>

- (void)closedByUser:(BOOL)closed;

- (void)showRosterList;

- (void)showSetting;

@end

@interface ShareToolBarAdaptor : NSResponder

@property (nonatomic, strong) FrtcShareContentToolBar *contentControlToolBar;

@property (nonatomic, strong) NSTimer *hideTimer;

@property (nonatomic, strong) NSTimer *showTimer;

@property (nonatomic, strong) NSTimer *displayTimer;

@property (nonatomic, assign) NSTrackingRectTag littleBarTrackingRectTag;

@property (nonatomic, assign) uint32_t  screenID;

@property (nonatomic, assign, getter=isColsedByUser) BOOL colsedByUser;

@property (nonatomic, strong) FrtcInCallModel *inCallModel;

@property (nonatomic, copy)   NSDictionary *params;

@property (nonatomic, weak) id<contentControlToolBarResponderDelegate> closedDelegate;

- (void)onMeetingStatusChangedFrom:(MeetingStatus)oldStatus to:(MeetingStatus)newStatus;

- (void)updatecontentControlToolBarInCallModel:(FrtcInCallModel *)incallModel;

- (void)showRecordingSuccess:(BOOL)isShow;

- (void)recordingStatus:(NSDictionary *)params;

- (void)updateRecordingUI:(NSDictionary *)params withHeight:(CGFloat)height;

- (void)handleRequestUnmuteUser:(NSMutableDictionary *)nameDictionary;

@end
