#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserBasicInformation : NSObject

@property (nonatomic, copy) NSString *userDisplayName;
@property (nonatomic, copy) NSString *mediaID;
@property (nonatomic, copy) NSString *userUUID;

@property (nonatomic, assign) NSInteger  resolutionWidth;
@property (nonatomic, assign) NSInteger  resolutionHeight;

@end

NS_ASSUME_NONNULL_END
