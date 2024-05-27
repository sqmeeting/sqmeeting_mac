#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppListModel : JSONModel

@property (nonatomic, assign) unsigned int contentType; //1: App Content.
@property (nonatomic, assign) unsigned int contentKey;
@property (nonatomic, strong) NSImage *contentIcon;
@property (nonatomic, strong) NSImage *contentWindowSnapshot;
@property (nonatomic, assign) BOOL contentShareable;
@property (nonatomic, copy) NSString *contentName;
@property (nonatomic, assign) pid_t processId;
@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, copy) NSString *processName;

@end

@interface DesktopListModel : JSONModel

@property (nonatomic, assign) unsigned int contentType; //0: Desktop Display Content.
@property (nonatomic, assign) unsigned int contentKey;
@property (nonatomic, strong) NSImage     *contentIcon;
@property (nonatomic, assign) BOOL         contentShareable;

@property (nonatomic, assign) unsigned int displayID;
@property (nonatomic, copy) NSString      *displayName;
@property (nonatomic, copy) NSImage       *snapShotImage;

@end

NS_ASSUME_NONNULL_END
