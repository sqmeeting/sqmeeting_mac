#import <Cocoa/Cocoa.h>
#import "HoverImageView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol FrtcMeetingInfoViewDelegate <NSObject>

- (void)cursorIsInView:(BOOL)isInView;

@end

@interface FrtcMeetingInfoView : NSView<HoverImageViewDelegate>

@property (nonatomic, strong) NSTextField *titleTextField;

@property (nonatomic, strong) NSTextField *meetingNumberLabel;
@property (nonatomic, strong) NSTextField *meetingNumberTextField;

@property (nonatomic, strong) NSTextField *meetingOwnerLabel;
@property (nonatomic, strong) NSTextField *meetingOwnerTextField;

@property (nonatomic, strong) NSTextField *meetingPasswordLabel;
@property (nonatomic, strong) NSTextField *meetingPasswordTextField;

@property (nonatomic, strong) HoverImageView *imageView;
@property (nonatomic, strong) NSTextField    *meetingCopyInfoLabel;

@property (nonatomic, weak) id<FrtcMeetingInfoViewDelegate> meetingInfoDelegate;

@end

NS_ASSUME_NONNULL_END
