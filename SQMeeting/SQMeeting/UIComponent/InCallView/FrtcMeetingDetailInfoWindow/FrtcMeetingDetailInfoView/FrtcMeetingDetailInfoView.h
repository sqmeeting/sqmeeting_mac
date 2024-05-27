#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrtcMeetingDetailInfoView : NSView

@property (nonatomic, strong) NSTextField *titleTextField;

@property (nonatomic, strong) NSTextField *themeTextField;

@property (nonatomic, strong) NSTextField *introductionTextField;

@property (nonatomic, strong) NSTextField *meetingBeginTimeTextField;

@property (nonatomic, strong) NSTextField *meetingNumberTextField;

@property (nonatomic, strong) NSTextField *meetingPasswordTextField;

@property (nonatomic, strong) NSTextField *secondIntroductionTextField;

@property (nonatomic, strong) NSTextField *meetingUrlTextFieldTips;

@property (nonatomic, strong) NSTextField *meetingUrlTextField;

@property (nonatomic, strong) NSTextField *beginTimeTextField;

@property (nonatomic, strong) NSTextField *beginTimeDetailTextField;

@property (nonatomic, strong) NSTextField *endTimeTextField;

@property (nonatomic, strong) NSTextField *endTimeDetailTextField;

@property (nonatomic, strong) NSTextField *recurrenceTextField;

@property (nonatomic, strong) NSTextField *recurrenceDetailTextField;

- (void)updateLayout;

- (void)updatePasswordLayout;

- (void)updateRecurrenceLayout;

@end

NS_ASSUME_NONNULL_END
