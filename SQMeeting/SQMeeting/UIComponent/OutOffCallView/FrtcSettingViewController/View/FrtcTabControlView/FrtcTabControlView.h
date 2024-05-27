#import <Cocoa/Cocoa.h>
#import "FrtcTabControlModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcTabControlViewViewDelegate <NSObject>

- (void)didSelectedIndex:(NSInteger)index;

@end

typedef NS_ENUM(NSInteger, FrtcSettingTag) {
    SettingNormalTag = 0,
    SettingMediaTag,
    SettingVideoTag,
    SettingAboutTag,
    SettingLabTag,
    SettingRecordingTag,
    SettingAccountTag,
    SettingDiagnosis
};

typedef NS_ENUM(NSInteger, FrtcSettingType) {
    SettingTypeGuest = 0,
    SettingTypeLogin,
    SettingTypeGuestCall,
    SettingTypeLoginCall
};

@interface FrtcTabControlView : NSView

- (instancetype)initWithFrame:(NSRect)frameRect withLoginStatus:(BOOL)loginStatus withSettingType:(FrtcSettingType)type;

@property (nonatomic, strong) NSArray *tabControlList;

@property (nonatomic, weak) id <FrtcTabControlViewViewDelegate> tabControlDelegate;

@property (nonatomic, assign, getter=isLogin) BOOL login;

@property (nonatomic, assign) FrtcSettingType settingType;

- (void)updateLayout:(BOOL)enableLabFeature;


@end

NS_ASSUME_NONNULL_END
