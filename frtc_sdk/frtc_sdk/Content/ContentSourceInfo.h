#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContentSourceInfo : NSObject

@property (nonatomic, assign) unsigned int contentType;
@property (nonatomic, assign) unsigned int contentKey;
@property (nonatomic, retain) NSImage *contentIcon;
@property (nonatomic, assign) BOOL contentShareable;
@property (nonatomic, copy)   NSString *contentName;
@property (nonatomic, assign) pid_t processId;
@property (nonatomic, copy)   NSString *sessionId;

@property (assign) BOOL isHideIntoTrayLyoutCtrl;
@property (assign) BOOL isFullScreenLyoutCtrl;

@property (nonatomic, copy) NSString *processName;

@end

NS_ASSUME_NONNULL_END
