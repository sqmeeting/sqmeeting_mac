#import <Cocoa/Cocoa.h>
#import "FrtcInCallModel.h"
#import "FrtcMediaStaticsModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CallWindowSendContentFlag) {
    CallWindowSendContentFlagNone = 0,
    CallWindowSendContentFlagSending
};

@protocol FrtcCallWindowControllerDelegate <NSObject>

- (void)closedByUserCallWindow:(BOOL)close;

- (void)showRecordingAndStreamingTips:(NSString *)tips;

- (void)initializedState:(NSInteger)state;

- (void)sendContentWithDesktopID:(uint32_t)selectID withAppWinswoID:(unsigned int)appWindowID withContentType:(NSInteger)type withAppName:(NSString *)name withConentAudio:(BOOL)isSendContentAudio;

@end

@interface FrtcCallWindowController : NSWindowController

@property (nonatomic, strong) FrtcInCallModel *inCallModel;

@property (nonatomic, strong) NSMutableArray<NSString *> *lectureArray;

@property (nonatomic, assign) CallWindowSendContentFlag contentSendFlag;

@property (nonatomic, strong) FrtcMediaStaticsModel *mediaStaticModel;

@property (nonatomic, getter=isReceivingContent) BOOL receivingContent;

@property (nonatomic, getter=isGridLayoutMode) BOOL gridLayoutMode;

@property (nonatomic, getter=isRecording) BOOL recording;

@property (nonatomic, getter=isStreaming) BOOL streaming;

@property (nonatomic, getter=isShareContent) BOOL shareContent;

@property (nonatomic, getter=isClosedByUser) BOOL closedByUser;

@property (nonatomic, copy) NSString *currentName;

@property (nonatomic, weak) id<FrtcCallWindowControllerDelegate> closedDelegate;

- (void)setupWindowLayout ;

- (void)setupRosterList:(NSMutableArray<NSString *> *)rosterListArray;

- (void)setBarViewHidden:(BOOL)hidden;

- (void)updateMediaStatics:(FrtcMediaStaticsModel *)mediaStaticsModel;

- (void)muteByServer:(BOOL)mute allowUserUnmute:(BOOL)allowUserUnmute;

- (void)handleRequestUnmuteUser:(NSMutableDictionary *)nameDictionary;

- (void)closeAllWindows;

- (void)closeWinowByCloseButton;

- (void)reConnectCall;

- (void)reConnectCallByToastWindowWithReCallBlock:(void(^)(void))reCallBlock;

- (void)stopReConnectCall;

- (void)stopReConnectUI:(NSInteger)reConnectCount;

- (void)setLectureArrayList:(NSMutableArray<NSString *> *)lectureList;

- (void)updateOverlayMessageButtonState:(NSControlStateValue)stateVaule;

- (void)setupRosterFullList:(NSMutableArray<NSString *> *)rosterListArray;

- (void)recordingStatus:(NSDictionary *)params isShareContent:(BOOL)shareContent;

- (void)updateRecordingAndStreamingUILocation:(BOOL)isShareContent;

- (void)reMasTitleBarLayout:(BOOL)isShelterByMenu;

- (void)handleAllowUnMuteNotify;

- (void)isPin:(BOOL)pin;

- (void)showRosterList;

- (void)showSetting;

- (void)onWindowSizeChanged:(NSSize)aSize;

- (void)updataButtonNameWithSettingComboxUserSelectGridMode:(BOOL)isGridMode;

- (void)updataSettingComboxWithUserSelectMenuButtonGridMode:(BOOL)isGridMode;

- (void)alreadyInCall;

- (void)toastInfomation;

- (void)fullScreenState:(NSInteger)state;

- (void)handleMeetingOverlayMessage:(NSString *)message;

- (void)resetOverLay;

- (void)resetOverlayForContentType:(NSInteger)type;

- (void)loadDesktopList;

- (void)updateDisplayRemoveEvent;

@end

NS_ASSUME_NONNULL_END
