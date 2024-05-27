#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define STORAGE_SERVER_ADDRESS          @"storage_server_address"
#define STORAGE_USER_NAME               @"storage_user_name"
#define STORAGE_MEETING_NUMBER          @"storage_meeting_number"
#define CALL_MEETING_CAMERA_ON_OFF      @"call_meeting_camera_on_off"
#define CALL_MEETING_MICPHONE_ON_OFF    @"call_meeting_microphone_on_off"
#define CALL_MEETING_AUDIO_ONLY         @"call_meeting_with_audio_only"

#define MEETING_RATE                @"meeting_rate"
#define LOGIN_NAME                  @"login_name"
#define LOGIN_PASSWORD              @"login_password"
#define STORAGE_PASSWORD            @"storage_password"
#define AGREE_PROTOCOL              @"agree_protocol"
#define NEW_FEATURE                 @"new_feature"

#define INTELLIGENG_NOISE_REDUCTION         @"intelligent_noise_reduction"
#define ENABLE_LAB_FEATURE                  @"enable_lab_feature"
#define ENABLE_STREAM_PASSWORD              @"enable_stream_password"
#define ENABLE_CAMREA_MIRROR                @"enable_camera_mirror"

#define ENABLE  @"true"
#define DISABLE @"false"

#define DEFAULT_CAMERA              @"default_used_camera_device"
#define DEFAULT_MICROPHONE          @"default_used_microphone_device"
#define DEFAULT_SPEAKER             @"default_used_speaker_device"
#define DEFAULT_LAYOUT              @"default_used_layout_device"

#define USER_TOKEN                  @"user_token"
#define CAMERA_ENABLE               @"camera_enable"
#define USER_ID                     @"user_id"

#define RECEIVE_MEETING_REMINDER            @"receive_meeting_reminder"
#define RECEIVE_MEETING_REMINDER_ENABLE     @"true"
#define RECEIVE_MEETING_REMINDER_DISABLE    @"false"


@interface FrtcUserDefault : NSObject

+ (FrtcUserDefault *)defaultSingleton;

- (void)setObject:(NSString *)object forKey:(NSString *)objectKey;

- (NSString *)objectForKey:(NSString *)defaultKey;

- (void)setBoolObject:(BOOL)object forKey:(NSString *)objectKey;

- (BOOL)boolObjectForKey:(NSString *)defaultKey;

@end

NS_ASSUME_NONNULL_END
