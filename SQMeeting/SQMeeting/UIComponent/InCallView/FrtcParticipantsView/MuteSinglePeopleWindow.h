#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MuteSinglePeopleWindowDelegate <NSObject>

- (void)muteWithUUID:(NSString *)uuid withRow:(NSInteger)row;

- (void)changeOldName:(NSInteger)row;

- (void)setSelecture:(NSInteger)row isSetSelceter:(BOOL)isSet;

- (void)setPin:(NSInteger)row isSetPin:(BOOL)isSet;

- (void)removeMeetingRoom:(NSInteger)row;

@end

@interface MuteSinglePeopleWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size withMuteStatus:(BOOL)muteStatus withAuthority:(BOOL)authority withLectureMode:(BOOL)lecture withPin:(BOOL)pin withRow:(NSInteger)row withMe:(BOOL)me;

@property (nonatomic, strong) NSTextField *titleTextField;
@property (nonatomic, copy)   NSString    *uuid;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign, getter=isMute) BOOL mute;
@property (nonatomic, assign, getter=isLecture) BOOL lecture;

@property (nonatomic, weak) id<MuteSinglePeopleWindowDelegate> muteSinglePeopleDelegate;

@end

NS_ASSUME_NONNULL_END
