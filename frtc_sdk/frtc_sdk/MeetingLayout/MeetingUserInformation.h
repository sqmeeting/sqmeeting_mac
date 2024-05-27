#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MeetingUserType) {
    USER_TYPE_LOCAL,
    USER_TYPE_REMOTE,
    USER_TYPE_CONTENT,
    USER_TYPE_INVALID
};

@interface MeetingUserInformation : NSObject

@property (nonatomic, copy) NSString *mediaID;
@property (nonatomic, copy) NSString *strDisplayName;
@property (nonatomic, copy) NSString *strUUID;


@property (nonatomic)  NSInteger resolutionWidth;
@property (nonatomic)  NSInteger resolutionHeight;

@property (nonatomic) MeetingUserType userType;

@property (nonatomic, assign, getter = isRemoved) BOOL removed;
@property (nonatomic, assign, getter = isActive)  BOOL active;
@property (nonatomic, assign, getter = isMaxResolution) BOOL maxResolution;
@property (nonatomic, assign, getter = isPin) BOOL pin;

@end

NS_ASSUME_NONNULL_END
