#import <Cocoa/Cocoa.h>
#import "FrtcMultiTypesButton.h"
#import "HoverImageView.h"
#import "FrtcBackGroundView.h"
#import "FrtcButton.h"
#import "FrtcRecurrenceView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol FrtcScheduleMeetingTableViewCellDelegate <NSObject>

- (void)popUpFunctionControllerWithFrame:(NSRect)frame withRow:(NSInteger)row;

- (void)joinTheConferenceWithRow:(NSInteger)row;

@end

@interface FrtcScheduleMeetingTableViewCell : NSTableCellView<HoverImageViewDelegate>

@property (nonatomic, strong) NSTextField           *numberLabel;
@property (nonatomic, strong) NSTextField           *numberTextField;
@property (nonatomic, strong) NSTextField           *meetingNameTextField;
@property (nonatomic, strong) NSTextField           *timeTextField;
@property (nonatomic, strong) FrtcBackGroundView    *backgroundView;
@property (nonatomic, strong) FrtcMultiTypesButton              *joinMeetingButton;
@property (nonatomic, strong) FrtcButton            *settingButton;
@property (nonatomic, strong) FrtcButton            *overTimeButton;
@property (nonatomic, strong) HoverImageView        *copyImageView;
@property (nonatomic, strong) HoverImageView        *moreImageView;
@property (nonatomic, strong) NSImageView           *arrowImageView;
@property (nonatomic, strong) NSTextField           *reminderBeginMeetingTextField;
@property (nonatomic, strong) NSTextField           *reminderNowMeetingTextField;
@property (nonatomic, strong) NSView                *lineView;
@property (nonatomic, strong) FrtcRecurrenceView    *recurrenceView;

@property (nonatomic, assign) NSInteger         row;
@property (nonatomic, assign, getter=isOverTime) BOOL overTime;

@property (nonatomic, weak) id<FrtcScheduleMeetingTableViewCellDelegate> controllerDelegate;

- (void)updateLayout;

- (void)remakeUpdateLayout;

@end

NS_ASSUME_NONNULL_END
