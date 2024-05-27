#import <Cocoa/Cocoa.h>
#import "FrtcInCallModel.h"
#import "FrtcInfoInstance.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcParticipantsViewControllerDelegate <NSObject>

@optional
- (void)showMeetingInfoWindow;

- (void)muteAll;

- (void)muteBySelf:(BOOL)mute;

- (void)showAskForUnmuteList;

@end

@interface FrtcParticipantsViewController : NSViewController

@property (nonatomic, weak) id<FrtcParticipantsViewControllerDelegate> controllerDelegate;

@property (nonatomic, strong) FrtcInCallModel *inCallModel;

- (void)handleRosterEvent:(NSArray *)rosterList;

@property (nonatomic, assign, getter=isAuthority) BOOL authority;

- (void)setLectureUUID:(NSMutableArray *)lecture;

- (void)updateRequestCell:(NSString *)name isShow:(BOOL)show isNewRequest:(BOOL)newRequest;

@end

NS_ASSUME_NONNULL_END
