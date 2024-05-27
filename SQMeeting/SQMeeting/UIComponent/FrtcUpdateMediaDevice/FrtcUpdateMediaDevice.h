#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrtcUpdateMediaDevice : NSObject

+ (FrtcUpdateMediaDevice *)mediaDeviceSingleton;

- (void)updateMediaDevice;

@end

NS_ASSUME_NONNULL_END
