#import <Foundation/Foundation.h>
#import "FrtcStatisticalModel.h"
#import "FrtcMediaStaticsModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^FrtcMediaStaticsTimeBlock)(FrtcStatisticalModel *staticsModel, FrtcMediaStaticsModel *mediaStaticsModel);

@interface FrtcMediaStaticsInstance : NSObject

+ (FrtcMediaStaticsInstance *)sharedFrtcMediaStaticsInstance;

- (void)startGetStatics:(void (^)(FrtcStatisticalModel *staticsModel, FrtcMediaStaticsModel *mediaStaticsModel))getStaticsModelCompletionHandler;

- (void)startGetMediaStatics;

- (void)stopGetMediaStatics;

@end

NS_ASSUME_NONNULL_END
