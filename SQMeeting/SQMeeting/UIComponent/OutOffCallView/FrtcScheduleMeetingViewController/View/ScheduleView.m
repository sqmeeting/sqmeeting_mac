#import "ScheduleView.h"
#import "FrtcDefaultTextField.h"
#import "HoverImageView.h"
#import "FrtcButton.h"
#import "FrtcDatePickerViewController.h"
#import "FrtcTimeViewController.h"
#import "FrtcPopUpButton.h"
#import "FrtcMeetingManagement.h"
#import "FrtcAlertMainWindow.h"
#import "FrtcBorderTextField.h"
#import "NumberLimiteFormatter.h"
#import "CallResultReminderView.h"
#import "CanlanderView.h"
#import "WeekView.h"
#import "MonthView.h"
#import "FrtcDatePicker.h"
#import "FrtcDetailTimeView.h"
#import "IntegerFormatter.h"

@interface ScheduleView () <HoverImageViewDelegate, FrtcTimeViewControllerDelegate, FrtcDatePickerDelegate, CalanderViewDelegate, WeekViewDelegate, MonthViewDelegate>

@property (nonatomic, strong) NSTextField  *meetingObject;

@property (nonatomic, strong) NSTextField  *meetingDescriptionLabel;
@property (nonatomic, strong) NSTextField  *meetingDescriptionTextField;

@property (nonatomic, strong) NSTextField       *beginTimeTextLabel;
@property (nonatomic, strong) FrtcDefaultTextField       *beginTimeTextField;
@property (nonatomic, strong) HoverImageView    *canlanderImageView;
@property (nonatomic, strong) FrtcDefaultTextField       *beginDetailTextField;
@property (nonatomic, strong) HoverImageView    *timerImageView;

@property (nonatomic, strong) NSTextField       *endTimeTextLabel;
@property (nonatomic, strong) FrtcDefaultTextField       *endTimeTextField;
@property (nonatomic, strong) HoverImageView    *endCanlanderImageView;
@property (nonatomic, strong) FrtcDefaultTextField       *endDetailTextField;
@property (nonatomic, strong) HoverImageView    *endTimerImageView;

@property (nonatomic, strong) NSTextField       *timeZoneLabel;
@property (nonatomic, strong) FrtcDefaultTextField       *timeZoneTextField;

@property (nonatomic, strong) NSTextField       *recurrentlyLabel;
@property (nonatomic, strong) NSTextField       *recurrenceLabel;
@property (nonatomic, strong) FrtcPopUpButton   *recurrenceCombox;

@property (nonatomic, strong) NSTextField       *frequencyLabel;
@property (nonatomic, strong) FrtcPopUpButton   *frequencyCombox;
@property (nonatomic, strong) NSTextField       *frequencyDetailLabel;

@property (nonatomic, strong) NSTextField       *beginReTextLabel;
@property (nonatomic, strong) CanlanderView     *beginCanlanderView;

@property (nonatomic, strong) NSTextField       *endReTextLabel;
@property (nonatomic, strong) CanlanderView     *endCanlanderView;

@property (nonatomic, strong) NSButton          *personalConferenceNumberOnOffButton;
@property (nonatomic, strong) FrtcPopUpButton   *personalConferenceNumberOnOffSelectCombox;

@property (nonatomic, strong) NSButton          *enablePersonalPasswordOnOffButton;

@property (nonatomic, strong) NSTextField       *inviteTextLabel;
@property (nonatomic, strong) FrtcButton        *inviteButton;
@property (nonatomic, strong) NSTextField       *invitePeopleNumber;

@property (nonatomic, strong) HoverImageView    *iconImageView;
@property (strong, nonatomic) NSPopover *popover;

@property (nonatomic, strong) NSTextField       *rateTextField;
@property (nonatomic, strong) FrtcPopUpButton   *rateSelectCombox;

@property (nonatomic, strong) NSTextField       *advanceTextField;
@property (nonatomic, strong) FrtcPopUpButton   *advancePopUpButton;

@property (nonatomic, strong) NSButton      *micphoneOnOffButton;
@property (nonatomic, strong) NSButton      *allowGuestOnOffButton;
@property (nonatomic, strong) NSButton      *shareWaterMaskButton;
@property (nonatomic, strong) NSTextField   *contentWaterTypeTextField;

@property (nonatomic, strong) NSMutableArray<NSString *> *userList;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *userDictionary;

@property (nonatomic, assign, getter=isGuestDialIn) BOOL guestDialIn;
@property (nonatomic, assign, getter=isWaterMask)   BOOL waterMask;

@property (nonatomic, copy) NSString       *waterMaskType;
@property (nonatomic, copy) NSString       *reservationID;
@property (nonatomic, copy) NSString       *password;
@property (nonatomic, copy) NSString       *meetingRoomID;
@property (nonatomic, copy) NSString       *muteUponEntry;
@property (nonatomic, copy) NSString       *meetingType;
@property (nonatomic, copy) NSString       *passwordDescription;

@property (nonatomic, strong) FrtcBorderTextField *reminderConferenceTextField;
@property (nonatomic, strong) NSImageView   *reminderConferenceImageView;

@property (nonatomic, strong) FrtcBorderTextField *reminderConferenceTextField1;
@property (nonatomic, strong) NSImageView   *reminderConferenceImageView1;

@property (nonatomic, strong) WeekView *weekViewSunday;
@property (nonatomic, strong) WeekView *weekViewMonday;
@property (nonatomic, strong) WeekView *weekViewTuesday;
@property (nonatomic, strong) WeekView *weekViewWednesday;
@property (nonatomic, strong) WeekView *weekViewThursday;
@property (nonatomic, strong) WeekView *weekViewFriday;
@property (nonatomic, strong) WeekView *weekViewSaturday;
@property (nonatomic, strong) NSMutableArray<WeekView *> *weekDayArray;

@property (nonatomic, strong) MonthView *monthView;

@property (nonatomic, strong) FrtcDatePicker *datePicker;

@property (nonatomic, strong) FrtcDatePicker *endDatePicker;

@property (nonatomic, strong) NSDate *scheduleMeetingStartTime;

@property (nonatomic, copy) NSString *firstEndTime;
@property (nonatomic, copy) NSString *secondEndTime;

@property (nonatomic, copy) NSString *endMeetingTimeString;
@property (nonatomic, copy) NSString *sencondEndMeetingTimeString;

@property (nonatomic, strong) NSDate *scheduleMeetingAllowEndTime;

@property (nonatomic, strong) FrtcDatePicker *recurrenceStartDatePicker;
@property (nonatomic, strong) FrtcDatePicker *recurrenceEndDatePicker;

@property (nonatomic, assign, getter=isRecurrence) BOOL recurrence;
@property (nonatomic, assign) NSInteger recurrenceInterval;
@property (nonatomic, copy)   NSString *recurrenceType;
@property (nonatomic, strong) NSMutableArray *recurrenceDaysOfWeek;
@property (nonatomic, strong) NSMutableArray *recurrenceDaysOfMonth;
@property (nonatomic, copy)   NSString *updateType;
@property (nonatomic, strong) CallResultReminderView *reminderView;
@property (strong, nonatomic) NSTimer                   *reminderTipsTimer;

@property (nonatomic, strong) FrtcDetailTimeView *detaiTimeView;

@property (nonatomic, assign) NSInteger timeToJoin;

@end

@implementation ScheduleView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor whiteColor].CGColor;

        self.passwordDescription = @"null";
        self.recurrence = NO;
        self.recurrenceInterval = 1;
        self.recurrenceType = @"";
        self.meetingType = @"reservation";
        self.recurrenceDaysOfWeek  = [NSMutableArray array];
        self.recurrenceDaysOfMonth = [NSMutableArray array];
        self.weekDayArray = [NSMutableArray array];
        self.timeToJoin = 30;
        [self layoutScheduleView];
    }
    
    return self;
}

- (BOOL)isFlipped {
    return YES;
}

- (void)layoutScheduleView {
    [self.meetingObject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(15);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.meetingDetailObject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.meetingObject.mas_bottom).offset(12);
        make.width.mas_equalTo(332);
        make.height.mas_equalTo(36);
    }];
    
    [self.beginTimeTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.meetingDetailObject.mas_bottom).offset(20);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.beginTimeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.beginTimeTextLabel.mas_bottom).offset(12);
        make.width.mas_equalTo(207);
        make.height.mas_equalTo(36);
    }];
    
    [self.canlanderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(206);
        make.centerY.mas_equalTo(self.beginTimeTextField.mas_centerY);
        make.width.mas_equalTo(15.38);
        make.height.mas_equalTo(14.77);
    }];
    
    [self.beginDetailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.beginTimeTextField.mas_right).offset(8);
        make.centerY.mas_equalTo(self.beginTimeTextField.mas_centerY);
        make.width.mas_equalTo(117);
        make.height.mas_equalTo(36);
    }];
    
//    [self.detaiTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.beginTimeTextField.mas_right).offset(8);
//        make.bottom.mas_equalTo(self.beginDetailTextField.mas_top).offset(-10);
//        make.width.mas_equalTo(117);
//        make.height.mas_equalTo(36);
//    }];
    
    [self.timerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-32);
        make.centerY.mas_equalTo(self.beginTimeTextField.mas_centerY);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    
    [self.reminderConferenceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(24);
         make.top.mas_equalTo(self.beginTimeTextField.mas_bottom).offset(8);
         make.width.mas_equalTo(12);
         make.height.mas_equalTo(12);
     }];
    
    [self.reminderConferenceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.mas_equalTo(self.reminderConferenceImageView.mas_centerY);
         make.left.mas_equalTo(self.reminderConferenceImageView.mas_right).offset(3);
         make.width.mas_greaterThanOrEqualTo(0);
         make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.endTimeTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.beginTimeTextField.mas_bottom).offset(20);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.endTimeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.endTimeTextLabel.mas_bottom).offset(12);
        make.width.mas_equalTo(207);
        make.height.mas_equalTo(36);
    }];
    
    [self.endCanlanderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(206);
        make.centerY.mas_equalTo(self.endTimeTextField.mas_centerY);
        make.width.mas_equalTo(15.38);
        make.height.mas_equalTo(14.77);
    }];
    
    [self.endDetailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.endTimeTextField.mas_right).offset(8);
        make.centerY.mas_equalTo(self.endTimeTextField.mas_centerY);
        make.width.mas_equalTo(117);
        make.height.mas_equalTo(36);
    }];
    
    [self.endTimerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-32);
        make.centerY.mas_equalTo(self.endTimeTextField.mas_centerY);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    
    [self.reminderConferenceImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(24);
         make.top.mas_equalTo(self.endTimeTextField.mas_bottom).offset(8);
         make.width.mas_equalTo(12);
         make.height.mas_equalTo(12);
     }];
    
    [self.reminderConferenceTextField1 mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.mas_equalTo(self.reminderConferenceImageView1.mas_centerY);
         make.left.mas_equalTo(self.reminderConferenceImageView1.mas_right).offset(3);
         make.width.mas_greaterThanOrEqualTo(0);
         make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.timeZoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.endTimeTextField.mas_bottom).offset(20);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.timeZoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.timeZoneLabel.mas_bottom).offset(12);
        make.width.mas_equalTo(332);
        make.height.mas_equalTo(36);
    }];
    
    [self.recurrentlyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.timeZoneTextField.mas_bottom).offset(16);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.recurrenceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.recurrentlyLabel.mas_bottom).offset(16);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.recurrenceCombox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.recurrenceLabel.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(111);
        make.width.mas_equalTo(245);
        make.height.mas_equalTo(36);
    }];
    
    [self.frequencyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.recurrenceLabel.mas_bottom).offset(32);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.frequencyCombox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.frequencyLabel.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(111);
        make.width.mas_equalTo(91);
        make.height.mas_equalTo(36);
    }];
    
    [self.frequencyDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.frequencyLabel.mas_centerY);
        make.left.mas_equalTo(self.frequencyCombox.mas_right).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.monthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.frequencyCombox.mas_bottom).offset(4);
        make.left.mas_equalTo(self.frequencyCombox.mas_left);
        make.width.mas_equalTo(248);
        make.height.mas_equalTo(193);
    }];
    
    [self.weekViewSunday mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.frequencyCombox.mas_left);
        make.top.mas_equalTo(self.frequencyCombox.mas_bottom).offset(8);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.weekViewMonday mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.weekViewSunday.mas_right).offset(8);
        make.centerY.mas_equalTo(self.weekViewSunday.mas_centerY);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.weekViewTuesday mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.weekViewMonday.mas_right).offset(8);
        make.centerY.mas_equalTo(self.weekViewSunday.mas_centerY);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.weekViewWednesday mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.weekViewTuesday.mas_right).offset(8);
        make.centerY.mas_equalTo(self.weekViewSunday.mas_centerY);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.weekViewThursday mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.weekViewWednesday.mas_right).offset(8);
        make.centerY.mas_equalTo(self.weekViewSunday.mas_centerY);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.weekViewFriday mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.weekViewThursday.mas_right).offset(8);
        make.centerY.mas_equalTo(self.weekViewSunday.mas_centerY);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.weekViewSaturday mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.weekViewFriday.mas_right).offset(8);
        make.centerY.mas_equalTo(self.weekViewSunday.mas_centerY);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
//    [self.beginReTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(24);
//        make.top.mas_equalTo(self.frequencyLabel.mas_bottom).offset(29);
//        make.width.mas_greaterThanOrEqualTo(0);
//        make.height.mas_greaterThanOrEqualTo(0);
//    }];
    
//    [self.beginCanlanderView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.beginReTextLabel.mas_centerY);
//        make.left.mas_equalTo(111);
//        make.width.mas_equalTo(177);
//        make.height.mas_equalTo(36);
//    }];
    
    [self.endReTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.frequencyLabel.mas_bottom).offset(29);
       // make.top.mas_equalTo(self.beginReTextLabel.mas_bottom).offset(32);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.endCanlanderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.endReTextLabel.mas_centerY);
        make.left.mas_equalTo(111);
        make.width.mas_equalTo(177);
        make.height.mas_equalTo(36);
    }];
    
    [self.personalConferenceNumberOnOffButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.recurrenceCombox.mas_bottom).offset(32);
        make.width.mas_greaterThanOrEqualTo(360);
        make.height.mas_greaterThanOrEqualTo(16);
     }];
    
    [self.personalConferenceNumberOnOffSelectCombox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.personalConferenceNumberOnOffButton.mas_centerY);
        make.left.mas_equalTo([self leftDistance]);
        make.width.mas_equalTo([self selectBoxWidth]);
        make.height.mas_equalTo(36);
    }];
    
    [self.enablePersonalPasswordOnOffButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.personalConferenceNumberOnOffButton.mas_bottom).offset(25);
        make.width.mas_greaterThanOrEqualTo(360);
        make.height.mas_greaterThanOrEqualTo(16);
    }];
    
    [self.inviteTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.enablePersonalPasswordOnOffButton.mas_bottom).offset(30);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.inviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.inviteTextLabel.mas_centerY);
        make.left.mas_equalTo(self.inviteTextLabel.mas_right).offset(10);
        make.width.mas_equalTo(93);
        make.height.mas_equalTo(32);
    }];
    
    [self.invitePeopleNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.inviteTextLabel.mas_centerY);
        make.left.mas_equalTo(self.inviteTextLabel.mas_right).offset(10);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.rateTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.inviteTextLabel.mas_bottom).offset(38);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.rateSelectCombox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.rateTextField.mas_centerY);
        make.left.mas_equalTo(self.rateTextField.mas_right).offset(10);
        make.width.mas_equalTo(290);
        make.height.mas_equalTo(36);
    }];
    
    [self.advanceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.rateTextField.mas_bottom).offset(32);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.advancePopUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.advanceTextField.mas_centerY);
        make.left.mas_equalTo(self.advanceTextField.mas_right).offset(10);
        make.width.mas_equalTo(238);
        make.height.mas_equalTo(36);
    }];
    
    [self.micphoneOnOffButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.advancePopUpButton.mas_bottom).offset(24);
        make.width.mas_greaterThanOrEqualTo(360);
        make.height.mas_greaterThanOrEqualTo(16);
     }];
    
    [self.allowGuestOnOffButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.micphoneOnOffButton.mas_bottom).offset(24);
        make.width.mas_greaterThanOrEqualTo(360);
        make.height.mas_greaterThanOrEqualTo(16);
     }];
    
    [self.shareWaterMaskButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.allowGuestOnOffButton.mas_bottom).offset(24);
        make.width.mas_greaterThanOrEqualTo(360);
        make.height.mas_greaterThanOrEqualTo(16);
     }];
    
    [self.contentWaterTypeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shareWaterMaskButton.mas_right).offset(0);
        make.centerY.mas_equalTo(self.shareWaterMaskButton.mas_centerY).offset(-1);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

//FM_MEETING_RE_CAN_NOT_CANCEL_CURRENT_DAY = "Unable to cancel the selected meeting start date";

- (void)showReminderView {
    NSString *reminderValue = NSLocalizedString(@"FM_MEETING_RE_CAN_NOT_CANCEL_CURRENT_DAY", @"Unable to cancel the selected meeting start date");
    NSFont *font             = [NSFont systemFontOfSize:14.0f];
    NSDictionary *attributes = @{ NSFontAttributeName:font };
    CGSize size              = [reminderValue sizeWithAttributes:attributes];
    
    CGRect rect = [reminderValue boundingRectWithSize:CGSizeMake(350, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    
    [self.reminderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(rect.size.width + 28);
        make.height.mas_equalTo(rect.size.height + 20);
    }];
    
    self.reminderView.tipLabel.stringValue = reminderValue;
    self.reminderView.hidden = NO;
    [self runningTimer:2.0];
}

#pragma mark --timer--
- (void)runningTimer:(NSTimeInterval)timeInterval {
    self.reminderTipsTimer = [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(reminderTipsEvent) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.reminderTipsTimer forMode:NSRunLoopCommonModes];
}

- (void)cancelTimer {
    if(_reminderTipsTimer != nil) {
        [_reminderTipsTimer invalidate];
        _reminderTipsTimer = nil;
    }
}

- (void)reminderTipsEvent {
    [self.reminderView setHidden:YES];
}


- (CGFloat)selectBoxWidth {
    NSString * language = [FMLanguageConfig userLanguage] ? : [NSLocale preferredLanguages].firstObject;
    
    if([language hasPrefix:@"en"]) {
        return 120.0;
    } else {
        return 205.0;
    }
}

- (CGFloat)leftDistance {
    NSString * language = [FMLanguageConfig userLanguage] ? : [NSLocale preferredLanguages].firstObject;
    
    if([language hasPrefix:@"en"]) {
        return 210.0;
    } else {
        return 151.0;
    }
}

- (void)reLayoutForRecurrencyDay:(BOOL)isHidden {
    [self reCurrencyUIHiddenOrNot:isHidden];
}

- (void)reCurrencyUIHiddenOrNot:(BOOL)isHidden {
    self.frequencyLabel.hidden =  isHidden;
    self.frequencyCombox.hidden = isHidden ;
    self.frequencyDetailLabel.hidden = isHidden;

//    self.beginReTextLabel.hidden = isHidden;
//    self.beginCanlanderView.hidden = isHidden;

    self.endReTextLabel.hidden = isHidden;
    self.endCanlanderView.hidden = isHidden;
}

- (void)weeklyDayHiddenOrNot:(BOOL)isHidden {
    self.weekViewSunday.hidden    = isHidden;
    self.weekViewMonday.hidden    = isHidden;
    self.weekViewTuesday.hidden   = isHidden;
    self.weekViewWednesday.hidden = isHidden;
    self.weekViewThursday.hidden  = isHidden;
    self.weekViewFriday.hidden    = isHidden;
    self.weekViewSaturday.hidden  = isHidden;
}

- (NSString *)getVerificationCode {
    NSArray *strArr = [[NSArray alloc]initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",nil] ;
    NSMutableString *getStr = [[NSMutableString alloc]initWithCapacity:5];
    for(int i = 0; i < 6; i++) {
        int index = arc4random() % ([strArr count]);  //得到数组中随机数的下标
        [getStr appendString:[strArr objectAtIndex:index]];
        
    }
    NSLog(@"验证码:%@",getStr);

    return getStr;
}

- (void)scheduleMeeting {
    NSString *userToken = [[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN];
    __weak __typeof(self)weakSelf = self;
    
    if ([self.meetingDetailObject.stringValue isEqualToString:@""] || self.meetingDetailObject.stringValue == nil) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(showReminderView)]) {
            [self.delegate showReminderView];
        }
        return;
    }
    if(self.reservationID) {
        NSString *passwordDescription;
        
        if(self.personalConferenceNumberOnOffButton.state == NSControlStateValueOn) {
            passwordDescription = (NSString *)[NSNull null];
        } else {
            if(self.enablePersonalPasswordOnOffButton.state == NSControlStateValueOn) {
                if(self.password == nil || [self.password isEqualToString:@""]) {
                    passwordDescription = (NSString *)[NSNull null];
                    
                    passwordDescription = [self getVerificationCode];
                } else {
                    passwordDescription = self.password;
                }
            } else {
                passwordDescription = @"";
            }
        }
        
        [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcUpdateMeeting:userToken
                                                             withReservationID:self.reservationID
                                                                withUpdateType:self.updateType
                                                               withMeetingType:self.meetingType
                                                               withMeetingName:self.meetingDetailObject.stringValue
                                                        wtihMeetingDescription:@""
                                                                 withStartTime:[self startTime]
                                                                   withEndTime:[self endTime]
                                                             withMeetingRoomID:self.meetingRoomID
                                                              withCallRateType:self.rateSelectCombox.selectedItem.title
                                                           withMeetingPassword:passwordDescription
                                                                withInviteUser:self.userList
                                                             withMuteUponEntry:self.muteUponEntry
                                                               withGuestDialIn:self.guestDialIn
                                                                withTimeToJoin:self.timeToJoin
                                                                 withWaterMark:self.waterMask
                                                             withWaterMarkType:self.waterMaskType ? self.waterMaskType : @""
                                                            withRecurrenceType:self.recurrenceType
                                                        withRecurrenceInterval:self.recurrenceInterval
                                                       withRecurrenceStartTime:[self startTime]
                                                         withRecurrenceEndTime:[self endTime]
                                                        withRecurrenceStartDay:[self startDayTime]
                                                          withRecurrenceEndDay:[self endDayTime]
                                                     withrecurrenceDaysOfMonth:self.recurrenceDaysOfMonth
                                                      withrecurrenceDaysofWeek:self.recurrenceDaysOfWeek
                                                             completionHandler:^(NSDictionary * _Nonnull meetingInfo) {
            
            NSLog(@"Schedule a meeting success");
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if(strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(updateScheduleMeetingComplete:)]) {
                [strongSelf.delegate updateScheduleMeetingComplete:YES];
            }
        } failure:^(NSError * _Nonnull error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if(strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(scheduleMeetingComplete:withScheduleSuccessModel:)]) {
                [strongSelf.delegate scheduleMeetingComplete:NO withScheduleSuccessModel:nil];
            }
            
            if([error.localizedDescription isEqualToString:@"Request failed: unauthorized (401)"]) {
                FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_VERIFY_FAILURE", @"Verifyication failed") withMessage:NSLocalizedString(@"FM_RE_SIGN", @"Please sign in again")preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:self.window];
                
                FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
                    [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingMainViewShowNotification object:nil userInfo:nil];
                }];
                [alertWindow addAction:action];
            }
        }];
        
    } else {
        NSString *passwordDescription;
        
        if(self.personalConferenceNumberOnOffButton.state == NSControlStateValueOn) {
            passwordDescription =  (NSString *)[NSNull null];
        } else {
            if(self.enablePersonalPasswordOnOffButton.state == NSControlStateValueOn) {
                passwordDescription =  (NSString *)[NSNull null];
            } else {
                passwordDescription = @"";
            }
        }
        [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcCreateMeeting:userToken
                                                               withMeetingType:self.meetingType
                                                               withMeetingName:self.meetingDetailObject.stringValue
                                                        wtihMeetingDescription:@""
                                                                 withStartTime:[self startTime]
                                                                   withEndTime:[self endTime]
                                                             withMeetingRoomID:self.meetingRoomID
                                                              withCallRateType:self.rateSelectCombox.selectedItem.title
                                                           withMeetingPassword:passwordDescription
                                                                withInviteUser:self.userList
                                                             withMuteUponEntry:self.muteUponEntry
                                                               withGuestDialIn:self.guestDialIn
                                                                withTimeToJoin:self.timeToJoin
                                                                 withWaterMark:self.waterMask
                                                             withWaterMarkType:self.waterMaskType ? self.waterMaskType : @""
                                                            withRecurrenceType:self.recurrenceType 
                                                        withRecurrenceInterval:self.recurrenceInterval
                                                       withRecurrenceStartTime:[self startTime] 
                                                         withRecurrenceEndTime:[self endTime]
                                                        withRecurrenceStartDay:[self startDayTime]
                                                          withRecurrenceEndDay:[self endDayTime]
                                                     withrecurrenceDaysOfMonth:self.recurrenceDaysOfMonth
                                                      withrecurrenceDaysofWeek:self.recurrenceDaysOfWeek
                                                             completionHandler:^(NSDictionary * _Nonnull meetingInfo) {
            
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            NSError *error = nil;
            ScheduleSuccessModel *shceduleMoel = [[ScheduleSuccessModel alloc] initWithDictionary:meetingInfo error:&error];
            
            NSLog(@"recurrenceEndDay:%@", [self dateTimeString:shceduleMoel.recurrenceEndDay]);
            NSLog(@"recurrenceEndTime:%@", [self dateTimeString:shceduleMoel.recurrenceEndTime]);
            NSLog(@"recurrenceStartDay:%@", [self dateTimeString:shceduleMoel.recurrenceStartDay]);
            NSLog(@"recurrenceStartTime:%@", [self dateTimeString:shceduleMoel.recurrenceStartTime]);
            NSLog(@"schedule_start_time:%@", [self dateTimeString:shceduleMoel.schedule_start_time]);
            NSLog(@"schedule_end_time:%@", [self dateTimeString:shceduleMoel.schedule_end_time]);
            if(strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(scheduleMeetingComplete: withScheduleSuccessModel:)]) {
                [strongSelf.delegate scheduleMeetingComplete:YES withScheduleSuccessModel:shceduleMoel];
            }
        } failure:^(NSError * _Nonnull error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if(strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(scheduleMeetingComplete:withScheduleSuccessModel:)]) {
                [strongSelf.delegate scheduleMeetingComplete:NO withScheduleSuccessModel:nil];
            }
            
            if([error.localizedDescription isEqualToString:@"Request failed: unauthorized (401)"]) {
                FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_LOGOUT_NOTIFICATION", @"Logout Notification") withMessage:NSLocalizedString(@"FM_LOGIN_AGAIN_NOTIFICATION", @"Verifyication failed. Please re-login and join meeting again.") preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:self.window];
                
                FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
                    [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingMainViewShowNotification object:nil userInfo:nil];
                }];
                [alertWindow addAction:action];
            }
        }];
    }
}

#pragma mark --About Time--
- (NSString *)startTime {
    NSString *startTime =[NSString stringWithFormat:@"%@:%@",self.beginTimeTextField.stringValue, self.beginDetailTextField.stringValue];
    
    return [self utcTimeString:startTime];
}

- (NSString *)endTime {
    NSString *endTime =[NSString stringWithFormat:@"%@:%@",self.endTimeTextField.stringValue, self.endDetailTextField.stringValue];
    
    return [self utcTimeString:endTime];
}

- (NSString *)startDayTime {
    //return [self dayTimeWithString:self.beginCanlanderView.timeTextField.stringValue];self.beginTimeTextField.stringValue
   // NSString *str = [NSString stringWithFormat:@"%@:%@", self.beginCanlanderView.timeTextField.stringValue, @"00:00:00"];
    //return [self dayTimeWithString:self.beginTimeTextField.stringValue];
    NSString *str = [NSString stringWithFormat:@"%@:%@", self.beginTimeTextField.stringValue, @"00:00:00"];
    return [self dayTimeWithString:str];
}

- (NSString *)endDayTime {
    NSString *str = [NSString stringWithFormat:@"%@:%@", self.endCanlanderView.timeTextField.stringValue, @"23:59:59"];
    //return [self dayTimeWithString:self.endCanlanderView.timeTextField.stringValue];
    //NSString *str = [NSString stringWithFormat:@"%@:%@", self.endTimeTextField.stringValue, @"23:59:59"];
    return [self dayTimeWithString:str];
}

- (NSString *)dayTimeWithString:(NSString *)time {
   // yyyy-MM-dd EE:HH:mm
   // time = [NSString stringWithFormat:@"%@:%@", time, @"23:59:59"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //formatter.locale = [NSLocale autoupdatingCurrentLocale];
    NSString *currentLocaleIdentifier = [[NSLocale currentLocale] localeIdentifier];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:currentLocaleIdentifier]];

    //formatter.dateFormat = @"yyyy-MM-dd EE";
    formatter.dateFormat = @"yyyy-MM-dd EE:HH:mm:ss";

    NSDate *date = [formatter dateFromString:time];
    
    //NSDate *nextDate = [[NSDate alloc] initWithTimeInterval:24 * 60 * 60 sinceDate:date];
    UInt64 recordTime = (UInt64)([date timeIntervalSince1970] * 1000); // 客户端当前13位毫秒级时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%llu", recordTime];
    
    return timeSp;
}

- (NSString *)utcTimeString:(NSString *)time {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //formatter.locale = [NSLocale autoupdatingCurrentLocale];
    NSString *currentLocaleIdentifier = [[NSLocale currentLocale] localeIdentifier];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:currentLocaleIdentifier]];

    formatter.dateFormat = @"yyyy-MM-dd EE:HH:mm";

    NSDate *date = [formatter dateFromString:time];
    UInt64 recordTime = (UInt64)([date timeIntervalSince1970] * 1000); // 客户端当前13位毫秒级时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%llu", recordTime];
 
    return timeSp;
}

- (NSString *)dateTimeString:(NSString *)utcTimeString {
    return [self dateTimeFromUtcTimeString:utcTimeString withTimeForMatter:@"yyyy-MM-dd EE"];
}

- (NSString *)hourAndSecondTimeString:(NSString *)utcTimeString {
    return [self dateTimeFromUtcTimeString:utcTimeString withTimeForMatter:@"HH:mm"];
}

- (NSString *)dateTimeFromUtcTimeString:(NSString *)utcTimeString withTimeForMatter:(NSString *)timeFormatter {
    NSArray *preferredLanguages = [NSLocale preferredLanguages];
    NSString *currentLanguage = preferredLanguages.firstObject;
    NSLocale *currentLocale = [NSLocale localeWithLocaleIdentifier:currentLanguage];
    NSTimeInterval time = [utcTimeString doubleValue] / 1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:currentLocale];
    [dateFormatter setDateFormat:timeFormatter];
    NSString *TimeDateString = [dateFormatter stringFromDate: detailDate];
    
    return TimeDateString;
}

- (BOOL)compareTime:(NSString *)utcTimeString {
    NSDate *dateNow = [NSDate date];
    UInt64 utcDataNow = [dateNow timeIntervalSince1970] * 1000;
    UInt64 recordTime = [utcTimeString doubleValue];
    
    if(recordTime > utcDataNow) {
//        if(self.delegate && [self.delegate respondsToSelector:@selector(enableScheduleButton:)]) {
//            [self.delegate enableScheduleButton:YES];
//        }
        return YES;
    } else {
//        if(self.delegate && [self.delegate respondsToSelector:@selector(enableScheduleButton:)]) {
//            [self.delegate enableScheduleButton:NO];
//        }
        return NO;
    }
}

- (BOOL)compareStartTime:(NSString *)startUtcime withEndTime:(NSString *)endUtcTime {
    UInt64 utcStartTime = [startUtcime doubleValue];
    UInt64 utcEndTime =   [endUtcTime doubleValue];
    
    if(utcEndTime > utcStartTime) {
//        if(self.delegate && [self.delegate respondsToSelector:@selector(enableScheduleButton:)]) {
//            [self.delegate enableScheduleButton:YES];
//        }
        return YES;
    } else {
//        if(self.delegate && [self.delegate respondsToSelector:@selector(enableScheduleButton:)]) {
//            [self.delegate enableScheduleButton:NO];
//        }
        return NO;
    }
}

#pragma mark --Class Interface--
- (void)updateSelectUsers:(NSArray<NSString *> *)userList {
    [self.userList removeAllObjects];
    for(NSString *user_id in userList) {
        [self.userList addObject:user_id];
    }
    
   // if(self.userList.count > 0) {
        [self updateInviteLayoutWithCount:self.userList.count];
    //}
    for(NSString *user_id in self.userList) {
        NSLog(@"****%@****", user_id);
    }
}

- (void)updateInviteLayoutWithCount:(NSInteger)count {
    if(count > 0) {
        self.invitePeopleNumber.stringValue = [NSString stringWithFormat:@"%ld %@", count, NSLocalizedString(@"FM_PEOPLE", @"People")];
        self.invitePeopleNumber.hidden = NO;
    
        [self.inviteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.inviteTextLabel.mas_centerY);
            make.left.mas_equalTo(self.invitePeopleNumber.mas_right).offset(10);
            make.width.mas_equalTo(93);
            make.height.mas_equalTo(32);
        }];
    } else {
        self.invitePeopleNumber.hidden = YES;
        
        [self.inviteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.inviteTextLabel.mas_centerY);
            make.left.mas_equalTo(self.inviteTextLabel.mas_right).offset(10);
            make.width.mas_equalTo(93);
            make.height.mas_equalTo(32);
        }];
    }
}

- (NSInteger)weekValueFromServerValue:(NSInteger)value {
    NSInteger weekDay;
    if(value == 1) {
        weekDay = 7;
    } else if(value == 2) {
        weekDay = 1;
    } else if(value == 3) {
        weekDay = 2;
    } else if(value == 4) {
        weekDay = 3;
    } else if(value == 5) {
        weekDay = 4;
    } else if(value == 6) {
        weekDay = 5;
    } else if(value == 7) {
        weekDay = 6;
    } else {
        weekDay = 0;
    }
    
    return weekDay;
}

- (void)updateScheduleView:(ScheduleSuccessModel *)meetingInfoModel withRecurrence:(BOOL)isRecurrence {
    self.password = meetingInfoModel.meeting_password;
    self.reservationID = meetingInfoModel.reservation_id;
    self.meetingType = meetingInfoModel.meeting_type;
    if(!isRecurrence) {
        self.updateType = @"reservation";
    } else {
        self.updateType = @"recurrence";
    }
    if(meetingInfoModel.invited_users_details.count > 0) {
        for(NSDictionary *dictionary in meetingInfoModel.invited_users_details) {
            NSString *user_id = dictionary[@"user_id"];
            [self.userList addObject:user_id];
        }
    }
        
    self.meetingDetailObject.stringValue = meetingInfoModel.meeting_name;
    
    if([meetingInfoModel.mute_upon_entry isEqualToString:@"ENABLE"]) {
        [self.micphoneOnOffButton setState:NSControlStateValueOn];
        self.muteUponEntry = @"ENABLE";
    } else {
        [self.micphoneOnOffButton setState:NSControlStateValueOff];
        self.muteUponEntry = @"DISABLE";
    }
    
    if([meetingInfoModel.guest_dial_in boolValue]) {
        [self.allowGuestOnOffButton setState:NSControlStateValueOn];
        self.shareWaterMaskButton.enabled = NO;
    } else {
        [self.allowGuestOnOffButton setState:NSControlStateValueOff];
        self.shareWaterMaskButton.enabled = YES;
    }
    
    if([meetingInfoModel.watermark boolValue]) {
        [self.shareWaterMaskButton setState:NSControlStateValueOn];
        self.allowGuestOnOffButton.enabled = NO;
    } else {
        [self.shareWaterMaskButton setState:NSControlStateValueOff];
        self.allowGuestOnOffButton.enabled = YES;
    }
    
    if([meetingInfoModel.time_to_join integerValue] == 30) {
        [self.advancePopUpButton selectItemAtIndex:0];
    } else {
        [self.advancePopUpButton selectItemAtIndex:1];
    }
    
    [self.rateSelectCombox selectItemWithTitle:meetingInfoModel.call_rate_type];
    
  
    self.beginTimeTextField.stringValue = [self dateTimeString:meetingInfoModel.schedule_start_time];
    self.beginDetailTextField.stringValue = [self hourAndSecondTimeString:meetingInfoModel.schedule_start_time];
    
    NSArray *preferredLanguages = [NSLocale preferredLanguages];
    NSString *currentLanguage = preferredLanguages.firstObject;
    NSLocale *currentLocale = [NSLocale localeWithLocaleIdentifier:currentLanguage];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setLocale:currentLocale];
    [formatter setDateFormat:@"yyyy-MM-dd EE:HH:mm"];
    //[formatter setLocale:currentLocale];
    
    NSString *tempString = [NSString stringWithFormat:@"%@ %@", self.beginTimeTextField.stringValue, self.beginDetailTextField.stringValue];
    NSDate *date = [formatter dateFromString:tempString];
    self.scheduleMeetingStartTime = date;
    
    self.endTimeTextField.stringValue = [self dateTimeString:meetingInfoModel.schedule_end_time];
    self.endDetailTextField.stringValue = [self hourAndSecondTimeString:meetingInfoModel.schedule_end_time];
    
    BOOL hidden = [self compareSelectTimeWithCurrentTime:[NSString stringWithFormat:@"%@:%@",self.endTimeTextField.stringValue, self.endDetailTextField.stringValue]];
    self.reminderConferenceImageView1.hidden = hidden;
    self.reminderConferenceTextField1.hidden = hidden;
    self.reminderConferenceTextField1.stringValue = NSLocalizedString(@"FM_END_TIME_NOT_EARLY_THAN_CUEEENT_TIME", @"End time cannot be earlier than current time");
    
    [self updateInviteLayoutWithCount:meetingInfoModel.invited_users_details.count];
    
    if(meetingInfoModel.meeting_room_id != nil ) {
        self.personalConferenceNumberOnOffButton.enabled = YES;
        [self.personalConferenceNumberOnOffButton setState:NSControlStateValueOn];
        self.personalConferenceNumberOnOffSelectCombox.hidden = NO;
        self.meetingRoomID = meetingInfoModel.meeting_room_id;
        
        self.rateTextField.hidden               = YES;
        self.rateSelectCombox.hidden            = YES;
        self.allowGuestOnOffButton.hidden       = YES;
        self.shareWaterMaskButton.hidden        = YES;
        self.contentWaterTypeTextField.hidden   = YES;
        self.enablePersonalPasswordOnOffButton.hidden = YES;
        
        [self.micphoneOnOffButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(24);
            make.top.mas_equalTo(self.inviteTextLabel.mas_bottom).offset(24);
            make.width.mas_greaterThanOrEqualTo(360);
            make.height.mas_greaterThanOrEqualTo(16);
         }];
        
        [self.inviteTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(24);
            make.top.mas_equalTo(self.personalConferenceNumberOnOffButton.mas_bottom).offset(30);
            make.width.mas_greaterThanOrEqualTo(0);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
    } else {
        [self.personalConferenceNumberOnOffButton setState:NSControlStateValueOff];
        self.personalConferenceNumberOnOffSelectCombox.hidden = YES;
        self.enablePersonalPasswordOnOffButton.hidden = NO;
        
        [self.inviteTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(24);
            make.top.mas_equalTo(self.enablePersonalPasswordOnOffButton.mas_bottom).offset(30);
            make.width.mas_greaterThanOrEqualTo(0);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
        
        if(self.password == nil || [self.password isEqualToString:@""]) {
            [self.enablePersonalPasswordOnOffButton setState:NSControlStateValueOff];
        } else {
            [self.enablePersonalPasswordOnOffButton setState:NSControlStateValueOn];
        }
    }
    
    if(!isRecurrence) {
        self.recurrence = NO;
        [self.recurrenceCombox selectItemAtIndex:0];
        self.recurrenceCombox.enabled = NO;
        
    } else {
        if([meetingInfoModel.meeting_type isEqualToString:@"recurrence"]) {
            self.recurrence = YES;
            if([meetingInfoModel.recurrence_type isEqualToString:@"DAILY"]) {
                [self.recurrenceCombox selectItemAtIndex:1];
                //self.beginCanlanderView.timeTextField.stringValue = self.beginTimeTextField.stringValue;
                NSDate *date = [self dateFromTimeString:[NSString stringWithFormat:@"%@:%@",self.beginTimeTextField.stringValue, self.beginDetailTextField.stringValue]];
                NSDate *nextDate = [[NSDate alloc] initWithTimeInterval:[meetingInfoModel.recurrenceInterval integerValue] * 6 * 24 * 60 * 60 sinceDate:date];
                NSString *dateString = [self dateToString:nextDate];
                NSArray *array = [dateString componentsSeparatedByString:@":"];
                self.endCanlanderView.timeTextField.stringValue = (array[0] != nil ? array[0] :@"");
                
                [self setFrameSize:NSMakeSize(390 , 960)];
                self.recurrenceType = @"DAILY";
                self.frequencyDetailLabel.stringValue = NSLocalizedString(@"FM_MEETING_RE_FREQUENCY_DAY", @"天");
                [self reLayoutForRecurrencyDay:NO];
                [self weeklyDayHiddenOrNot:YES];
                self.monthView.hidden = YES;
                //self.endReTextLabel
                [self.endReTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(24);
                    make.top.mas_equalTo(self.frequencyLabel.mas_bottom).offset(29);
                    make.width.mas_greaterThanOrEqualTo(0);
                    make.height.mas_greaterThanOrEqualTo(0);
                }];
                
                [self.personalConferenceNumberOnOffButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(24);
                    make.top.mas_equalTo(self.endCanlanderView.mas_bottom).offset(32);
                    make.width.mas_greaterThanOrEqualTo(360);
                    make.height.mas_greaterThanOrEqualTo(16);
                }];
                
                
                [self.frequencyCombox removeAllItems];
                for(int i = 1; i <= 99; i++) {
                    [self.frequencyCombox addItemWithTitle:[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"FM_MEETING_RE_MEI", @"每"),[NSString stringWithFormat:@"%d", i]]];
                }
                
                [self.frequencyCombox selectItemAtIndex:[meetingInfoModel.recurrenceInterval integerValue] - 1];
                
            } else if([meetingInfoModel.recurrence_type isEqualToString:@"WEEKLY"]) {
                [self.recurrenceCombox selectItemAtIndex:2];
                //self.beginCanlanderView.timeTextField.stringValue = self.beginTimeTextField.stringValue;
                NSDate *date = [self dateFromTimeString:[NSString stringWithFormat:@"%@:%@",self.beginTimeTextField.stringValue, self.beginDetailTextField.stringValue]];
                NSDate *nextDate = [[NSDate alloc] initWithTimeInterval:[meetingInfoModel.recurrenceInterval integerValue]  * 7 * 24 *60 * 60 * 7 sinceDate:date];
                NSString *dateString = [self dateToString:nextDate];
                NSArray *array = [dateString componentsSeparatedByString:@":"];
                self.endCanlanderView.timeTextField.stringValue = (array[0] != nil ? array[0] :@"");
                
                [self.recurrenceDaysOfWeek removeAllObjects];
                [self.recurrenceDaysOfWeek addObjectsFromArray:meetingInfoModel.recurrenceDaysOfWeek];
                
                self.endCanlanderView.timeTextField.stringValue = (array[0] != nil ? array[0] :@"");
                [self setFrameSize:NSMakeSize(390 , 1000)];
                self.recurrenceType = @"WEEKLY";
                self.frequencyDetailLabel.stringValue = NSLocalizedString(@"FM_MEETING_RE_FREQUENCY_WEEK", @"周");
                [self weeklyDayHiddenOrNot:NO];
                [self reLayoutForRecurrencyDay:NO];
                self.monthView.hidden = YES;
                
                
                
                for(NSNumber *number in meetingInfoModel.recurrenceDaysOfWeek) {
                    NSLog(@"The number value is %ld", [number integerValue]);
                    for(WeekView *view in self.weekDayArray) {
                        if([view weekday] == [self weekValueFromServerValue:[number integerValue]]) {
                            NSLog(@"The string value is %@", view.titleTextField.stringValue);
                            [view setSelectedColor:YES];
                        }
                    }
                }
                
                /*NSDate *currentDate = [[NSDate alloc] init];
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:currentDate];
                NSInteger weekday = components.weekday;
                
                if(![self.recurrenceDaysOfWeek containsObject:@(weekday)]) {
                    [self.recurrenceDaysOfWeek addObject:@(weekday)];
                }
                weekday = [self weekValueFromServerValue:weekday];
                
                for(WeekView *view in self.weekDayArray) {
                    if([view weekday] == weekday) {
                        [view setCurrentColor:YES];
                    } else {
                        [view setCurrentColor:NO];
                    }
                }*/
                
                [self.endReTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(24);
                    make.top.mas_equalTo(self.frequencyLabel.mas_bottom).offset(68);
                    make.width.mas_greaterThanOrEqualTo(0);
                    make.height.mas_greaterThanOrEqualTo(0);
                }];
                
                [self.personalConferenceNumberOnOffButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(24);
                    make.top.mas_equalTo(self.endCanlanderView.mas_bottom).offset(32);
                    make.width.mas_greaterThanOrEqualTo(360);
                    make.height.mas_greaterThanOrEqualTo(16);
                }];
                
                [self.frequencyCombox removeAllItems];
                for(int i = 1; i <= 12; i++) {
                    [self.frequencyCombox addItemWithTitle:[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"FM_MEETING_RE_MEI", @"每"),[NSString stringWithFormat:@"%d", i]]];
                }
                
                [self.frequencyCombox selectItemAtIndex:[meetingInfoModel.recurrenceInterval integerValue] - 1];
                
            } else if([meetingInfoModel.recurrence_type isEqualToString:@"MONTHLY"]) {
                [self.recurrenceCombox selectItemAtIndex:3];
                
                [self setFrameSize:NSMakeSize(390 , 1200)];
                NSDate *date = [self dateFromTimeString:[NSString stringWithFormat:@"%@:%@",self.beginTimeTextField.stringValue, self.beginDetailTextField.stringValue]];
                
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSDateComponents *components = [calendar components:NSCalendarUnitDay | NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
                
                NSInteger month = [components month];
                NSInteger year = [components year];
                NSInteger day = [components day];
                NSInteger newMonth = month + self.recurrenceInterval * 7;
                NSInteger newYear = year + newMonth / 12;
                newMonth = newMonth % 12;
                
                if (newMonth == 0) {
                    newMonth = 12;
                    newYear = newYear - 1;
                }
                
                NSDateComponents *newStartDateComps = [[NSDateComponents alloc] init];
                [newStartDateComps setYear: newYear];
                [newStartDateComps setMonth: newMonth];
                [newStartDateComps setDay:day];
                //NSCalendar *calendar = [NSCalendar currentCalendar];
                NSDate *finalDate = [calendar dateFromComponents:newStartDateComps];
                
                NSString *dateString = [self dateToString:finalDate];
                NSArray *array = [dateString componentsSeparatedByString:@":"];
                self.endCanlanderView.timeTextField.stringValue = (array[0] != nil ? array[0] :@"");
                
                NSLog(@"The day is %ld", components.day);
                [self.monthView setMonthViewDay:components.day];
                
            
                [self.recurrenceDaysOfMonth removeAllObjects];
                [self.recurrenceDaysOfMonth addObject:@(components.day)];
                self.recurrenceType = @"MONTHLY";
                [self weeklyDayHiddenOrNot:YES];
                [self reLayoutForRecurrencyDay:NO];
                self.monthView.hidden = NO;
                self.frequencyDetailLabel.stringValue = NSLocalizedString(@"FM_MEETING_RE_FREQUENCY_MOUNTH", @"月");
                [self.frequencyCombox removeAllItems];
                
                [self.endReTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(24);
                    make.top.mas_equalTo(self.frequencyLabel.mas_bottom).offset(233);
                    make.width.mas_greaterThanOrEqualTo(0);
                    make.height.mas_greaterThanOrEqualTo(0);
                }];
                
                [self.personalConferenceNumberOnOffButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(24);
                    make.top.mas_equalTo(self.endCanlanderView.mas_bottom).offset(32);
                    make.width.mas_greaterThanOrEqualTo(360);
                    make.height.mas_greaterThanOrEqualTo(16);
                }];
                
                for(int i = 1; i <= 12; i++) {
                    [self.frequencyCombox addItemWithTitle:[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"FM_MEETING_RE_MEI", @"每"),[NSString stringWithFormat:@"%d", i]]];
                }
                
                [self.frequencyCombox selectItemAtIndex:[meetingInfoModel.recurrenceInterval integerValue] - 1];
                
                [self.monthView updateMonthView:meetingInfoModel.recurrenceDaysOfMonth];
            }
        }
    }
}

#pragma mark --MonthView--
- (void)updateDayArrayOfMonth:(NSMutableArray *)array {
    self.recurrenceDaysOfMonth = array;
}

- (void)popupTipsForNotCancelCurrentDay {
    [self showReminderView];
}

#pragma mark --WeekViewDelegate--
- (void)updateDayOfWeek:(NSInteger)day select:(BOOL)selected {
    NSLog(@"The day is %ld", day);
    if(selected) {
        [self.recurrenceDaysOfWeek addObject:[NSNumber numberWithInteger:day]];
    } else {
        if([self.recurrenceDaysOfWeek containsObject:[NSNumber numberWithInteger:day]]) {
            [self.recurrenceDaysOfWeek removeObject:[NSNumber numberWithInteger:day]];
        }
    }
    
    NSLog(@"*******************");
    for(NSNumber *number in self.recurrenceDaysOfWeek) {
        NSLog(@"%ld", [number integerValue]);
    }
    NSLog(@"*******************");
}

- (void)canNotCancelCurrentDay {
    [self showReminderView];
}

#pragma mark --FrtcTimeViewControllerDelegate--
- (void)selectTimeValue:(NSString *)timeValue withTag:(NSInteger)tag {
    [self.popover close];
    if(tag == 203) {
        self.beginDetailTextField.stringValue = timeValue;
        
        NSString *beginTimeString = [NSString stringWithFormat:@"%@:%@",self.beginTimeTextField.stringValue, self.beginDetailTextField.stringValue];
        [self updateMeetingEndTime:beginTimeString];


    } else {
        self.endDetailTextField.stringValue = timeValue;
        
        BOOL hidden = [self compareSelectTimeWithCurrentTime:[NSString stringWithFormat:@"%@:%@",self.endTimeTextField.stringValue, self.endDetailTextField.stringValue]];
        self.reminderConferenceImageView1.hidden = hidden;
        self.reminderConferenceTextField1.hidden = hidden;
        self.reminderConferenceTextField1.stringValue = NSLocalizedString(@"FM_END_TIME_NOT_EARLY_THAN_CUEEENT_TIME", @"End time cannot be earlier than current time");
        
        if(!hidden) {
            return;
        }
        
        if(![self compareStartTime:[self utcTimeString:[NSString stringWithFormat:@"%@:%@",self.beginTimeTextField.stringValue, self.beginDetailTextField.stringValue]] withEndTime:[self utcTimeString:[NSString stringWithFormat:@"%@:%@",self.endTimeTextField.stringValue, self.endDetailTextField.stringValue]]]) {
            self.reminderConferenceImageView1.hidden = NO;
            self.reminderConferenceTextField1.hidden = NO;
            self.reminderConferenceTextField1.stringValue = NSLocalizedString(@"FM_END_TIME_NOT_EARLY_THAN_START_TIME", @"End time cannot be earlier than start time");

        } else {
            self.reminderConferenceImageView1.hidden = YES;
            self.reminderConferenceTextField1.hidden = YES;
            
            self.reminderConferenceImageView.hidden = YES;
            self.reminderConferenceTextField.hidden = YES;
        }
        
        hidden = [self compareSelectTimeWithCurrentTime:[NSString stringWithFormat:@"%@:%@",self.beginTimeTextField.stringValue, self.beginDetailTextField.stringValue]];
        self.reminderConferenceTextField.stringValue = NSLocalizedString(@"FM_START_TIME_NOT_EARLY_THAN_CURRENT_TIME", @"Start time cannot be earlier than current time");
        self.reminderConferenceImageView.hidden = hidden;
        self.reminderConferenceTextField.hidden = hidden;
    }
}

#pragma mark --FrtcDatePickerDelegate--
- (void)updateTimeString:(NSString *)timeString timeDate:(nonnull NSDate *)date type:(NSInteger)datepickerTag {
    if(datepickerTag == 202) {
        self.endTimeTextField.stringValue = timeString;
        if(![timeString isEqualToString:self.beginTimeTextField.stringValue]) {
            self.endDetailTextField.stringValue = @"00:00";
        }
        return;
    }
    
    if(datepickerTag == 204) {
        self.endCanlanderView.timeTextField.stringValue = timeString;
        
        return;
    }
    
    NSLog(@"The time String is %@", timeString);
    self.beginTimeTextField.stringValue = timeString;
    
    NSString *beginTimeString = [NSString stringWithFormat:@"%@:%@",self.beginTimeTextField.stringValue, self.beginDetailTextField.stringValue];
    [self updateMeetingEndTime:beginTimeString];
}

#pragma mark --Internal Functiino--
- (void)updateEndTimeForMonth {
    NSDate *date = [self dateFromTimeString:[NSString stringWithFormat:@"%@:%@",self.beginTimeTextField.stringValue, self.beginDetailTextField.stringValue]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay | NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
    
    NSInteger month = [components month];
    NSInteger year = [components year];
    NSInteger day = [components day];
    
    NSInteger newMonth;
    if(self.recurrenceInterval * 6 > 12) {
        newMonth = month + 12;
    } else {
        newMonth = month + self.recurrenceInterval * 6;
    }
    NSInteger newYear = year + newMonth / 12;
    newMonth = newMonth % 12;
    if (newMonth == 0) {
        newMonth = 12;
        newYear = newYear - 1;
    }
    
    NSDateComponents *newStartDateComps = [[NSDateComponents alloc] init];
    [newStartDateComps setYear: newYear];
    [newStartDateComps setMonth: newMonth];
    [newStartDateComps setDay:day];
    //NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *finalDate = [calendar dateFromComponents:newStartDateComps];
    
    NSString *dateString = [self dateToString:finalDate];
    NSArray *array = [dateString componentsSeparatedByString:@":"];
    NSString *str = array[0] != nil ? array[0] :@"";
    NSLog(@"The str is %@", str);
    self.endCanlanderView.timeTextField.stringValue = str;
}

- (BOOL)compareSelectTimeWithCurrentTime:(NSString *)selectTime {
        //设置转换格式
        //NSDate转NSString
    return [self compareTime:[self utcTimeString:selectTime]];
}

- (void)updateMeetingEndTime:(NSString *)beginTime {
    NSArray *preferredLanguages = [NSLocale preferredLanguages];
    NSString *currentLanguage = preferredLanguages.firstObject;
    NSLocale *currentLocale = [NSLocale localeWithLocaleIdentifier:currentLanguage];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setLocale:currentLocale];
    [formatter setDateFormat:@"yyyy-MM-dd EE:HH:mm"];
    
    NSDate *date = [formatter dateFromString:beginTime];
    self.scheduleMeetingStartTime = date;
    
    NSDate *minimumEndTime = [[NSDate alloc] initWithTimeInterval:30 * 60 sinceDate:date];
    NSDate *maxmumEndTime  = [[NSDate alloc] initWithTimeInterval:24 * 60 * 60 sinceDate:date];
    self.scheduleMeetingAllowEndTime = maxmumEndTime;
        
    self.endMeetingTimeString = [formatter stringFromDate:minimumEndTime];
    self.sencondEndMeetingTimeString = [formatter stringFromDate:maxmumEndTime];
    
    NSArray *array = [self.endMeetingTimeString componentsSeparatedByString:@":"];

    self.endTimeTextField.stringValue = (array[0] != nil ? array[0] :@"");
    self.endDetailTextField.stringValue = [NSString stringWithFormat:@"%@:%@", array[1], array[2]];
    
    if(self.isRecurrence) {
        //self.beginCanlanderView.timeTextField.stringValue = self.beginTimeTextField.stringValue;
        NSDate *date = [self dateFromTimeString:[NSString stringWithFormat:@"%@:%@",self.beginTimeTextField.stringValue, self.beginDetailTextField.stringValue]];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *components = [calendar components:NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:date];
        NSInteger interval = 1;
        if([self.recurrenceType isEqualToString:@"DAILY"]) {
            interval = 1 * 6;
            interval = self.recurrenceInterval * 6;
            NSDate *nextDate = [[NSDate alloc] initWithTimeInterval:interval * 24 * 60 * 60 sinceDate:date];
            NSString *dateString = [self dateToString:nextDate];
            NSArray *array = [dateString componentsSeparatedByString:@":"];
            self.endCanlanderView.timeTextField.stringValue = (array[0] != nil ? array[0] :@"");
        } else if([self.recurrenceType isEqualToString:@"WEEKLY"]) {

            NSLog(@"The week day is %ld", components.weekday);
            NSLog(@"weak dya is %ld", calendar.firstWeekday);
            
            NSInteger weekday = components.weekday;
            NSInteger originalWeekday = weekday;
            if(weekday != 1) {
                weekday -= 1;
            } else {
                weekday = 7;
            }
            for(WeekView *view in self.weekDayArray) {
                if([view weekday] == weekday) {
                    [view setCurrentColor:YES];
                    if(![self.recurrenceDaysOfWeek containsObject:@(originalWeekday)]) {
                        [self.recurrenceDaysOfWeek addObject:@(originalWeekday)];
                    }
                } else {
                    [view setCurrentColor:NO];
                    NSInteger day = [view convertDayToInt:view.titleTextField.stringValue];
                    if([self.recurrenceDaysOfWeek containsObject:@(day)]) {
                        [self.recurrenceDaysOfWeek removeObject:@(day)];
                    }
                }
            }
        } else if([self.recurrenceType isEqualToString:@"MONTHLY"]) {
            [self updateEndTimeForMonth];
            if(components.day != self.monthView.day) {
                [self.recurrenceDaysOfMonth removeObject:[NSNumber numberWithInteger:self.monthView.day]];
                if(![self.recurrenceDaysOfMonth containsObject:[NSNumber numberWithInteger:components.day]]) {
                    [self.recurrenceDaysOfMonth addObject:[NSNumber numberWithInteger:components.day]];
                }
            }
            [self.monthView setMonthViewDay:components.day];
            
            NSMutableArray<NSNumber *> *array = [NSMutableArray array];
            for(NSNumber *number in self.recurrenceDaysOfMonth) {
                [array addObject:number];
            }
            [self.monthView updateMonthView:array];
        }
    }
}

#pragma mark --Button Sender--
- (void)oninviteBtnPressed:(FrtcButton *)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(showInviteView)]) {
        [self.delegate showInviteView];
    }
}

- (void)onOnlyAudioCall:(NSButton *)sender {
    if(sender.state == NSControlStateValueOn) {
        self.muteUponEntry = @"ENABLE";
    } else {
        self.muteUponEntry = @"DISABLE";
    }
}

- (void)onEnableMicphone:(NSButton *)sender {
    if(sender.state == NSControlStateValueOn) {
        self.shareWaterMaskButton.enabled = NO;
        [self.shareWaterMaskButton setState: NSControlStateValueOff];
        self.waterMask = NO;
        self.guestDialIn = YES;
        self.waterMaskType = @"";
    } else {
        self.shareWaterMaskButton.enabled = YES;
        self.guestDialIn = NO;
    }
}

- (void)onEnableCamera:(NSButton *)sender {
    if(sender.state == NSControlStateValueOn) {
        self.allowGuestOnOffButton.enabled = NO;
        [self.allowGuestOnOffButton setState: NSControlStateValueOff];
        self.guestDialIn = NO;
        self.waterMask = YES;
        self.waterMaskType = @"single";
    } else {
        self.allowGuestOnOffButton.enabled = YES;
        self.waterMask = NO;
    }
}

- (void)onEnablePersonalNumber:(NSButton *)sender {
    if(sender.state == NSControlStateValueOn) {
        self.personalConferenceNumberOnOffSelectCombox.hidden = NO;
        NSInteger index = self.personalConferenceNumberOnOffSelectCombox.indexOfSelectedItem;
        self.meetingRoomID = ((PersonalMeetingModel *)self.meetingRooms.meeting_rooms[index]).meeting_room_id;
        
        self.rateTextField.hidden               = YES;
        self.rateSelectCombox.hidden            = YES;
        self.allowGuestOnOffButton.hidden       = YES;
        self.shareWaterMaskButton.hidden        = YES;
        self.contentWaterTypeTextField.hidden   = YES;
        self.enablePersonalPasswordOnOffButton.hidden = YES;
        
        [self.micphoneOnOffButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(24);
            make.top.mas_equalTo(self.inviteTextLabel.mas_bottom).offset(24);
            make.width.mas_greaterThanOrEqualTo(360);
            make.height.mas_greaterThanOrEqualTo(16);
         }];
        
        [self.inviteTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(24);
            make.top.mas_equalTo(self.personalConferenceNumberOnOffButton.mas_bottom).offset(30);
            make.width.mas_greaterThanOrEqualTo(0);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
    } else {
        self.personalConferenceNumberOnOffSelectCombox.hidden = YES;
        self.meetingRoomID = @"";
        
        self.rateTextField.hidden               = NO;
        self.rateSelectCombox.hidden            = NO;
        self.allowGuestOnOffButton.hidden       = NO;
        self.shareWaterMaskButton.hidden        = NO;
        self.contentWaterTypeTextField.hidden   = NO;
        self.enablePersonalPasswordOnOffButton.hidden = NO;
        
        [self.micphoneOnOffButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(24);
            make.top.mas_equalTo(self.rateSelectCombox.mas_bottom).offset(24);
            make.width.mas_greaterThanOrEqualTo(360);
            make.height.mas_greaterThanOrEqualTo(16);
        }];
        
        [self.inviteTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(24);
            make.top.mas_equalTo(self.enablePersonalPasswordOnOffButton.mas_bottom).offset(30);
            make.width.mas_greaterThanOrEqualTo(0);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
    }
}

- (void)onEnablePersonalMeetingPassword:(NSButton *)sender {
    if(sender.state == NSControlStateValueOn) {
        
    } else {
        
    }
}

- (FrtcDatePicker *)datePickerFormDate:(NSDate *)date {
    FrtcDatePicker *datePicker = [[FrtcDatePicker alloc] initWithFrame:NSMakeRect(0, 0, 256, 290) withDate:date];
    datePicker.datePickerDelegate = self;
    datePicker.autoresizingMask = NSViewMinYMargin;
    [self addSubview:datePicker];
    
    return datePicker;
}

- (NSDate *)dateFromTimeString:(NSString *)timeString {
    NSArray *preferredLanguages = [NSLocale preferredLanguages];
    
    // Use the first language in the preferred languages array
    NSString *currentLanguage = preferredLanguages.firstObject;
    
    // Create an NSLocale with the current language identifier
    NSLocale *currentLocale = [NSLocale localeWithLocaleIdentifier:currentLanguage];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd EE:HH:mm"];
    [formatter setLocale:currentLocale];
    NSDate *date = [formatter dateFromString:timeString];
    
    return date;
}

- (NSString *)dateToString:(NSDate *)date {
    NSArray *preferredLanguages = [NSLocale preferredLanguages];
    
    // Use the first language in the preferred languages array
    NSString *currentLanguage = preferredLanguages.firstObject;
    
    // Create an NSLocale with the current language identifier
    NSLocale *currentLocale = [NSLocale localeWithLocaleIdentifier:currentLanguage];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd EE:HH:mm"];
    [dateFormatter setLocale:currentLocale];
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    
    return currentDateString;
}

- (NSDate *)dateFromDayString:(NSString *)timeString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd EE"];
    NSDate *date = [formatter dateFromString:timeString];
    
    return date;
}

- (NSString *)timeStringWithDateFormatter:(NSDateFormatter *)formatter {
    // 按照24小时制，不需要在前面加上前缀：上午或下午
    NSDate *theDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMinute fromDate:theDate];
    NSInteger minute = [components minute];

    // Calculate the minutes remaining until the next half-hour mark or hour
    NSInteger remainingMinutes = (15 - (minute % 15)) % 15;

    // Round up to the nearest half-hour mark or hour
    NSInteger roundedMinutes = remainingMinutes > 0 ? remainingMinutes : 15;
    NSDate *nextDate = [theDate dateByAddingTimeInterval:roundedMinutes * 60];
    

    // Reset the second component to 0
    NSDateComponents *newComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:nextDate];
    [newComponents setSecond:0];

    // Get the next half-hour mark or hour
    NSDate *finalDate = [calendar dateFromComponents:newComponents];
    NSString *dateString = [formatter stringFromDate:finalDate];
    
    return dateString;
}

#pragma mark --CalanderViewDelegate--
- (void)popupCalanderViewWithInterger:(NSInteger)tag {
    if(tag == 201) {
        NSDate *date = [self dateFromTimeString:[NSString stringWithFormat:@"%@:%@",self.beginTimeTextField.stringValue, self.beginDetailTextField.stringValue]];

        self.recurrenceStartDatePicker = [self datePickerFormDate:date];
        self.recurrenceStartDatePicker.datepickerTag = 203;
        [self addSubview:self.recurrenceStartDatePicker];
        
        [self.recurrenceStartDatePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.beginCanlanderView.mas_bottom).offset(8);
            make.left.mas_equalTo(self.beginReTextLabel.mas_right).offset(8);
            make.width.mas_equalTo(256);
            make.height.mas_equalTo(290);
        }];
    } else if(tag == 202) {
        NSDate *date = [self dateFromTimeString:[NSString stringWithFormat:@"%@:%@",self.beginTimeTextField.stringValue, self.beginDetailTextField.stringValue]];
        
        NSDate *someDate = [[NSDate alloc] initWithTimeInterval:365 * 24 * 60 * 60 sinceDate:date];
        
        date = [self dateFromDayString:self.endCanlanderView.timeTextField.stringValue];
        self.recurrenceEndDatePicker = [self datePickerFormDate:date];
        self.recurrenceEndDatePicker.datepickerTag = 204;
        
       
        [self.recurrenceEndDatePicker setDatePickerrangeFromDate:[self dateFromTimeString:[NSString stringWithFormat:@"%@:%@",self.beginTimeTextField.stringValue, self.beginDetailTextField.stringValue]] endDate:someDate];
       // [self.recurrenceEndDatePicker setDatePickerrange:date];
        [self addSubview:self.recurrenceEndDatePicker];
        
        [self.recurrenceEndDatePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.endCanlanderView.mas_bottom).offset(8);
            make.left.mas_equalTo(self.endReTextLabel.mas_right).offset(8);
            make.width.mas_equalTo(256);
            make.height.mas_equalTo(290);
        }];
    }
}

#pragma mark --HoverImageViewDelegate--
- (void)hoverImageViewClickedwithSenderTag:(NSInteger)tag {
    self.popover = [[NSPopover alloc] init];
    self.popover.behavior = NSPopoverBehaviorTransient;
    
     NSRectEdge preferredPopoverEdge = NSRectEdgeMinY;
    
    if(tag == 202) {
        if([self.endDatePicker isDescendantOf:self]) {
            return;
        } else {
            self.endDatePicker = [[FrtcDatePicker alloc] initWithFrame:NSMakeRect(24, 255, 256, 290) withDate:self.scheduleMeetingStartTime];
            self.endDatePicker.datePickerDelegate = self;
            self.endDatePicker.datepickerTag = 202;
            self.endDatePicker.autoresizingMask = NSViewMinYMargin;
            [self addSubview:self.endDatePicker];
            
            [self.endDatePicker setDatePickerrange:self.scheduleMeetingStartTime];
            //[self.endDatePicker setDatePickerrangeFromDate:self.scheduleMeetingStartTime endDate:[[NSDate alloc] initWithTimeInterval:23 * 60 * 60 sinceDate:self.scheduleMeetingStartTime]];
        }
    } else if(tag == 201) {
        if([self.datePicker isDescendantOf:self]) {
            return;
        } else {
            NSDate *date = [[NSDate alloc] init];
            self.datePicker = [[FrtcDatePicker alloc] initWithFrame:NSMakeRect(24, 170, 256, 290) withDate:date];
            self.datePicker.datePickerDelegate = self;
            self.datePicker.datepickerTag = 201;
            self.datePicker.autoresizingMask = NSViewMinYMargin;
            [self addSubview:self.datePicker];
        }
    } else if(tag == 203) {
        FrtcTimeViewController *controller = [[FrtcTimeViewController alloc] init];
        controller.delegate = self;
        controller.viewControllerTag = tag;
        controller.scheduleMeetingStartTime = self.scheduleMeetingStartTime;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [formatter setDateFormat:@"HH:mm"];
        [self timeStringWithDateFormatter:formatter];
        NSString *dateString = [self timeStringWithDateFormatter:formatter];
        controller.currentTimeString = dateString;
        
        controller.beginTimeSheet = YES;
        self.popover.contentViewController = controller;
        [self.popover showRelativeToRect:self.timerImageView.bounds ofView:self.timerImageView preferredEdge:preferredPopoverEdge];
    } else if(tag == 204) {
        FrtcTimeViewController *controller = [[FrtcTimeViewController alloc] init];
        self.popover.contentViewController = controller;
        controller.viewControllerTag = tag;
        controller.currentTimeString = self.endDetailTextField.stringValue;
        controller.scheduleMeetingStartTime = self.scheduleMeetingStartTime;
        controller.scheduleEndDayTime = self.endTimeTextField.stringValue;
        controller.shceduleMeetingAllowEndTime = self.scheduleMeetingAllowEndTime;
        controller.delegate = self;
        [self.popover showRelativeToRect:self.endTimerImageView.bounds ofView:self.endTimerImageView preferredEdge:preferredPopoverEdge];
    }
}

#pragma mark --setter--
- (void)setMeetingRooms:(MeetingRooms *)meetingRooms {
    _meetingRooms = meetingRooms;
    
    if(meetingRooms.meeting_rooms.count > 0) {
        self.personalConferenceNumberOnOffButton.enabled = YES;
        self.personalConferenceNumberOnOffSelectCombox.enabled = YES;
        for(PersonalMeetingModel *model in self.meetingRooms.meeting_rooms) {
            [[self personalConferenceNumberOnOffSelectCombox] addItemWithTitle:model.meeting_number];
        }
        self.meetingRoomID = @"";
    } else {
        self.personalConferenceNumberOnOffButton.enabled = NO;
        self.personalConferenceNumberOnOffSelectCombox.enabled = NO;
        self.meetingRoomID = @"";
    }
}

- (BOOL)compareTime {
    if(![self compareSelectTimeWithCurrentTime:[NSString stringWithFormat:@"%@:%@",self.beginTimeTextField.stringValue, self.beginDetailTextField.stringValue]]) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(showTimeReminderValue:)]) {
            [self.delegate showTimeReminderValue:NSLocalizedString(@"FM_START_TIME_NOT_EARLY_THAN_CURRENT_TIME", @"Start time cannot be earlier than current time")];
        }
        return NO;
    }

    if(![self compareSelectTimeWithCurrentTime:[NSString stringWithFormat:@"%@:%@",self.endTimeTextField.stringValue, self.endDetailTextField.stringValue]]) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(showTimeReminderValue:)]) {
            [self.delegate showTimeReminderValue:NSLocalizedString(@"FM_END_TIME_NOT_EARLY_THAN_CUEEENT_TIME", @"End time cannot be earlier than current time")];
        }
        return NO;
    }

    if(![self compareStartTime:[self utcTimeString:[NSString stringWithFormat:@"%@:%@",self.beginTimeTextField.stringValue, self.beginDetailTextField.stringValue]] withEndTime:[self utcTimeString:[NSString stringWithFormat:@"%@:%@",self.endTimeTextField.stringValue, self.endDetailTextField.stringValue]]]) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(showTimeReminderValue:)]) {
            [self.delegate showTimeReminderValue: NSLocalizedString(@"FM_END_TIME_NOT_EARLY_THAN_START_TIME", @"End time cannot be earlier than start time")];
        }
        
        return NO;

    }
        
    return YES;
}

- (void)setAuthority:(BOOL)authority {
    _authority = authority;
    
    if(self.authority) {
        [[self rateSelectCombox] addItemWithTitle:@"128K"];
        [[self rateSelectCombox] addItemWithTitle:@"512K"];
        [[self rateSelectCombox] addItemWithTitle:@"1024K"];
        [[self rateSelectCombox] addItemWithTitle:@"2048K"];
        [[self rateSelectCombox] addItemWithTitle:@"2560K"];
        [[self rateSelectCombox] addItemWithTitle:@"3072K"];
        [[self rateSelectCombox] addItemWithTitle:@"4096K"];
        [[self rateSelectCombox] addItemWithTitle:@"6144K"];
        [[self rateSelectCombox] addItemWithTitle:@"8192K"];
        [self.rateSelectCombox selectItemWithTitle:@"2048K"];
    } else {
        [[self rateSelectCombox] addItemWithTitle:@"128K"];
        [[self rateSelectCombox] addItemWithTitle:@"512K"];
        [[self rateSelectCombox] addItemWithTitle:@"1024K"];
        [[self rateSelectCombox] addItemWithTitle:@"2048K"];
        [[self rateSelectCombox] addItemWithTitle:@"2560K"];
        [[self rateSelectCombox] addItemWithTitle:@"3072K"];
        [[self rateSelectCombox] addItemWithTitle:@"4096K"];
        [self.rateSelectCombox selectItemWithTitle:@"2048K"];
    }
}

#pragma mark --popup button sender--
- (void)onRateSelChange {
    NSString *title = [self.rateSelectCombox titleOfSelectedItem];
    NSLog(@"%@", title);
}


- (void)onAdvanceSelChange {
    NSString *title = [self.advancePopUpButton titleOfSelectedItem];
    if([title isEqualToString:@"任意时间"]) {
        self.timeToJoin = -1;
    } else {
        self.timeToJoin = 30;
    }
    NSLog(@"%@", title);
}

- (void)onPersonalNumberSelChange {
    NSInteger index = [self.personalConferenceNumberOnOffSelectCombox indexOfSelectedItem];
    self.meetingRoomID = ((PersonalMeetingModel *)self.meetingRooms.meeting_rooms[index]).meeting_room_id;
}

- (void)onRecurrencyRateSelChange {
    self.recurrenceInterval = 1;
    NSString *title = [self.recurrenceCombox titleOfSelectedItem];
    if([title isEqualToString:NSLocalizedString(@"FM_MEETING_NO_RE_CRERENCE", @"不重复")]) {
        [self setFrameSize:NSMakeSize(390 , 960)];
        self.recurrence = NO;
        self.meetingType = @"reservation";
        self.recurrenceInterval = 1;
        
        //self.beginCanlanderView.timeTextField.stringValue = self.beginTimeTextField.stringValue;
        NSDate *date = [self dateFromTimeString:[NSString stringWithFormat:@"%@:%@",self.beginTimeTextField.stringValue, self.beginDetailTextField.stringValue]];
        NSDate *nextDate = [[NSDate alloc] initWithTimeInterval:self.recurrenceInterval * 7 * 24 *60 * 60 sinceDate:date];
        NSString *dateString = [self dateToString:nextDate];
        NSArray *array = [dateString componentsSeparatedByString:@":"];
        self.endCanlanderView.timeTextField.stringValue = (array[0] != nil ? array[0] :@"");
        
        [self reLayoutForRecurrencyDay:YES];
        [self weeklyDayHiddenOrNot:YES];
        self.monthView.hidden = YES;
        [self.personalConferenceNumberOnOffButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(24);
            make.top.mas_equalTo(self.recurrenceCombox.mas_bottom).offset(32);
            make.width.mas_greaterThanOrEqualTo(360);
            make.height.mas_greaterThanOrEqualTo(16);
        }];
        
    } else {
        self.recurrence = YES;
        self.meetingType = @"recurrence";
       // self.beginCanlanderView.timeTextField.stringValue = self.beginTimeTextField.stringValue;
        NSDate *date = [self dateFromTimeString:[NSString stringWithFormat:@"%@:%@",self.beginTimeTextField.stringValue, self.beginDetailTextField.stringValue]];
        NSDate *nextDate = [[NSDate alloc] initWithTimeInterval:self.recurrenceInterval * 6 * 24 * 60 * 60 sinceDate:date];
        NSString *dateString = [self dateToString:nextDate];
        NSArray *array = [dateString componentsSeparatedByString:@":"];
        self.endCanlanderView.timeTextField.stringValue = (array[0] != nil ? array[0] :@"");
        if([title isEqualToString:NSLocalizedString(@"FM_MEETING_RE_CRERENCE_DAY", @"每天")]) {
            [self setFrameSize:NSMakeSize(380 , 960)];
            self.recurrenceType = @"DAILY";
            self.frequencyDetailLabel.stringValue = NSLocalizedString(@"FM_MEETING_RE_FREQUENCY_DAY", @"天");
            [self reLayoutForRecurrencyDay:NO];
            [self weeklyDayHiddenOrNot:YES];
            self.monthView.hidden = YES;
            [self.endReTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(24);
                make.top.mas_equalTo(self.frequencyLabel.mas_bottom).offset(29);
                make.width.mas_greaterThanOrEqualTo(0);
                make.height.mas_greaterThanOrEqualTo(0);
            }];
            
            [self.personalConferenceNumberOnOffButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(24);
                make.top.mas_equalTo(self.endCanlanderView.mas_bottom).offset(32);
                make.width.mas_greaterThanOrEqualTo(360);
                make.height.mas_greaterThanOrEqualTo(16);
            }];
            
            for(int i = 1; i <= 99; i++) {
                [self.frequencyCombox addItemWithTitle:[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"FM_MEETING_RE_MEI", @"每"),[NSString stringWithFormat:@"%d", i]]];
            }
        } else if([title isEqualToString:NSLocalizedString(@"FM_MEETING_RE_CRERENCE_WEEK", @"每周")]) {
            nextDate = [[NSDate alloc] initWithTimeInterval:self.recurrenceInterval * 6 * 24 * 60 * 60 * 7 sinceDate:date];
            dateString = [self dateToString:nextDate];
            array = [dateString componentsSeparatedByString:@":"];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:date];
   
            self.endCanlanderView.timeTextField.stringValue = (array[0] != nil ? array[0] :@"");
            [self setFrameSize:NSMakeSize(380 , 1000)];
            self.recurrenceType = @"WEEKLY";
            self.frequencyDetailLabel.stringValue = NSLocalizedString(@"FM_MEETING_RE_FREQUENCY_WEEK", @"周");
            [self weeklyDayHiddenOrNot:NO];
            [self reLayoutForRecurrencyDay:NO];
            self.monthView.hidden = YES;
            
            NSInteger weekday = components.weekday;
            [self.recurrenceDaysOfWeek removeAllObjects];
            [self.recurrenceDaysOfWeek addObject:[NSNumber numberWithInteger:weekday]];
            if(weekday != 1) {
                weekday -= 1;
            } else {
                weekday = 7;
            }
            for(WeekView *view in self.weekDayArray) {
                if([view weekday] == weekday) {
                    [view setCurrentColor:YES];
                } else {
                    [view setCurrentColor:NO];
                }
            }
            
            [self.endReTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(24);
                make.top.mas_equalTo(self.frequencyLabel.mas_bottom).offset(68);
                make.width.mas_greaterThanOrEqualTo(0);
                make.height.mas_greaterThanOrEqualTo(0);
            }];
            
            [self.personalConferenceNumberOnOffButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(24);
                make.top.mas_equalTo(self.endCanlanderView.mas_bottom).offset(32);
                make.width.mas_greaterThanOrEqualTo(360);
                make.height.mas_greaterThanOrEqualTo(16);
            }];
            
            [self.frequencyCombox removeAllItems];
            for(int i = 1; i <= 12; i++) {
                [self.frequencyCombox addItemWithTitle:[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"FM_MEETING_RE_MEI", @"每"),[NSString stringWithFormat:@"%d", i]]];
            }
            
        } else if([title isEqualToString:NSLocalizedString(@"FM_MEETING_RE_CRERENCE_MOUNTH", @"每月")]) {
            [self setFrameSize:NSMakeSize(380 , 1200)];
            NSDate *date = [self dateFromTimeString:[NSString stringWithFormat:@"%@:%@",self.beginTimeTextField.stringValue, self.beginDetailTextField.stringValue]];
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:NSCalendarUnitDay | NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
            
            NSInteger month = [components month];
            NSInteger year = [components year];
            NSInteger day = [components day];
            NSInteger newMonth;
            if(self.recurrenceInterval * 6 > 12) {
                newMonth = month + 12;
            } else {
                newMonth = month + self.recurrenceInterval * 6;
            }
            NSInteger newYear = year + newMonth / 12;
            newMonth = newMonth % 12;

            if (newMonth == 0) {
                newMonth = 12;
                newYear = newYear - 1;
            }
            
            NSDateComponents *newStartDateComps = [[NSDateComponents alloc] init];
            [newStartDateComps setYear: newYear];
            [newStartDateComps setMonth: newMonth];
            [newStartDateComps setDay:day];
            //NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDate *finalDate = [calendar dateFromComponents:newStartDateComps];
            
            dateString = [self dateToString:finalDate];
            array = [dateString componentsSeparatedByString:@":"];
            self.endCanlanderView.timeTextField.stringValue = (array[0] != nil ? array[0] :@"");
            
            NSLog(@"The day is %ld", components.day);
            [self.monthView setMonthViewDay:components.day];
            
            [self.recurrenceDaysOfMonth removeAllObjects];
            [self.recurrenceDaysOfMonth addObject:@(components.day)];
            self.recurrenceType = @"MONTHLY";
            [self weeklyDayHiddenOrNot:YES];
            [self reLayoutForRecurrencyDay:NO];
            self.monthView.hidden = NO;
            self.frequencyDetailLabel.stringValue = NSLocalizedString(@"FM_MEETING_RE_FREQUENCY_MOUNTH", @"月");
            [self.frequencyCombox removeAllItems];
            
            [self.endReTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(24);
                make.top.mas_equalTo(self.frequencyLabel.mas_bottom).offset(233);
                make.width.mas_greaterThanOrEqualTo(0);
                make.height.mas_greaterThanOrEqualTo(0);
            }];
            
            [self.personalConferenceNumberOnOffButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(24);
                make.top.mas_equalTo(self.endCanlanderView.mas_bottom).offset(32);
                make.width.mas_greaterThanOrEqualTo(360);
                make.height.mas_greaterThanOrEqualTo(16);
            }];
            
            for(int i = 1; i <= 12; i++) {
                [self.frequencyCombox addItemWithTitle:[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"FM_MEETING_RE_MEI", @"每"),[NSString stringWithFormat:@"%d", i]]];
            }
        }
    }
}

- (void)onFrequencySelChange {
    NSString *title = [self.frequencyCombox titleOfSelectedItem];
    NSLog(@"The frequence title is %@", title);
    NSString *str = [title substringFromIndex:1];
    NSLog(@"The frequence title is %@, and the subindex string is %@", title, str);
    if([self isEnglish]) {
        self.recurrenceInterval = [title integerValue];
    } else {
        self.recurrenceInterval = [str integerValue];
    }
    NSLog(@"The frequence title is %@, and the subindex string is %@, and the interval is %ld", title, str, self.recurrenceInterval);
    
    NSDate *date = [self dateFromTimeString:[NSString stringWithFormat:@"%@:%@",self.beginTimeTextField.stringValue, self.beginDetailTextField.stringValue]];
    
    NSDate *nextDate = [[NSDate alloc] initWithTimeInterval:self.recurrenceInterval * 6 * 24 *60 * 60 sinceDate:date];
    NSString *dateString = [self dateToString:nextDate];
    NSArray *array = [dateString componentsSeparatedByString:@":"];
    self.endCanlanderView.timeTextField.stringValue = (array[0] != nil ? array[0] :@"");
    if([self.recurrenceCombox.selectedItem.title isEqualToString:NSLocalizedString(@"FM_MEETING_RE_CRERENCE_WEEK", @"每周")]) {
        if(self.recurrenceInterval * 7 >= 52) {
            nextDate = [[NSDate alloc] initWithTimeInterval:52 * 24 * 60 * 60 * 7 sinceDate:date];
        } else {
            nextDate = [[NSDate alloc] initWithTimeInterval:self.recurrenceInterval * 7 * 24 * 60 * 60 * 7 sinceDate:date];
        }
        dateString = [self dateToString:nextDate];
        array = [dateString componentsSeparatedByString:@":"];
        self.endCanlanderView.timeTextField.stringValue = (array[0] != nil ? array[0] :@"");
    } else if([self.recurrenceCombox.selectedItem.title isEqualToString:NSLocalizedString(@"FM_MEETING_RE_CRERENCE_MOUNTH", @"每月")]) {
        [self updateEndTimeForMonth];
    }
}

#pragma mark --Internal Function
- (BOOL)isEnglish {
    NSString * language = [FMLanguageConfig userLanguage] ? : [NSLocale preferredLanguages].firstObject;
    
    if([language hasPrefix:@"en"]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark --lazy load getter--
- (NSTextField *)meetingObject {
    if(!_meetingObject) {
        _meetingObject = [self textField];
        _meetingObject.stringValue = NSLocalizedString(@"FM_MEETING_OBJECT", @"Meeting Topic");
        [self addSubview:_meetingObject];
    }
    
    return _meetingObject;
}

- (FrtcDefaultTextField *)meetingDetailObject {
    if (!_meetingDetailObject){
        _meetingDetailObject = [[FrtcDefaultTextField alloc] initWithFrame:CGRectMake(0, 0, 332, 36)];
        _meetingDetailObject.stringValue = @"李美美 预约的会议";
        NumberLimiteFormatter *formatter = [[NumberLimiteFormatter alloc] init];
        [formatter setMaximumLength:64];
        [_meetingDetailObject setFormatter:formatter];
        _meetingDetailObject.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        [self addSubview:_meetingDetailObject];
    }
    
    return _meetingDetailObject;
}

- (NSTextField *)meetingDescriptionLabel {
    if(!_meetingDescriptionLabel) {
        _meetingDescriptionLabel = [self textField];
        _meetingDescriptionLabel.stringValue = @"会议介绍";
        [self addSubview:_meetingDescriptionLabel];
    }
    
    return _meetingDescriptionLabel;
}

- (NSTextField *)meetingDescriptionTextField {
    if (!_meetingDescriptionTextField){
        _meetingDescriptionTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 332, 36)];
        _meetingDescriptionTextField.editable = YES;
        _meetingDescriptionTextField.bordered = YES;
        _meetingDescriptionTextField.textColor = [NSColor colorWithString:@"222222" andAlpha:1.0];
        _meetingDescriptionTextField.alignment = NSTextAlignmentLeft;
        [_meetingDescriptionTextField setFocusRingType:NSFocusRingTypeNone];
        [_meetingDescriptionTextField.cell setFont:[NSFont systemFontOfSize:14]];
        _meetingDescriptionTextField.wantsLayer = YES;
        _meetingDescriptionTextField.layer.backgroundColor = [NSColor whiteColor].CGColor;
        _meetingDescriptionTextField.layer.borderColor = [NSColor colorWithString:@"999999" andAlpha:1.0].CGColor;
        _meetingDescriptionTextField.layer.borderWidth = 1.0;
        _meetingDescriptionTextField.layer.cornerRadius = 4.0f;
        _meetingDescriptionTextField.maximumNumberOfLines = 0;
        _meetingDescriptionTextField.lineBreakMode = NSLineBreakByCharWrapping;
        _meetingDescriptionTextField.placeholderString = @"输入会议介绍";
        _meetingDescriptionTextField.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        [self addSubview:_meetingDescriptionTextField];
    }
    
    return _meetingDescriptionTextField;
}

- (NSTextField *)beginTimeTextLabel {
    if(!_beginTimeTextLabel) {
        _beginTimeTextLabel = [self textField];
        _beginTimeTextLabel.stringValue = NSLocalizedString(@"FM_MEETING_START_TIME", @"Start Time");
        [self addSubview:_beginTimeTextLabel];
    }
    
    return _beginTimeTextLabel;
}

- (FrtcDefaultTextField *)beginTimeTextField {
    if (!_beginTimeTextField) {
        _beginTimeTextField = [[FrtcDefaultTextField alloc] initWithFrame:CGRectMake(0, 0, 207, 36)];
        NSDate *theDate = [NSDate date];
        self.scheduleMeetingStartTime = theDate;
        NSArray *preferredLanguages = [NSLocale preferredLanguages];
        
        // Use the first language in the preferred languages array
        NSString *currentLanguage = preferredLanguages.firstObject;
        
        // Create an NSLocale with the current language identifier
        NSLocale *currentLocale = [NSLocale localeWithLocaleIdentifier:currentLanguage];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd EE";
        [formatter setLocale:currentLocale];
        NSString *dateString = [formatter stringFromDate:theDate];
        _beginTimeTextField.stringValue = dateString;
        _beginTimeTextField.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        _beginTimeTextField.editable = NO;
        NSDate *datenow = [NSDate date];//现在时间,您可以输出来看下是什么格式

        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
        NSLog(@"dateString: %@, timeSp: %@", dateString, timeSp);
        [self addSubview:_beginTimeTextField];
    }
    
    return _beginTimeTextField;
}

- (HoverImageView *)canlanderImageView {
    if(!_canlanderImageView) {
        _canlanderImageView = [[HoverImageView alloc] initWithFrame:CGRectMake(0, 0, 15.38, 14.77)];
        _canlanderImageView.tag = 201;
        _canlanderImageView.delegate = self;
        _canlanderImageView.image = [NSImage imageNamed:@"icon-calander"];
        [self addSubview:_canlanderImageView];
    }

    return _canlanderImageView;
}

- (FrtcDefaultTextField *)beginDetailTextField {
    if (!_beginDetailTextField) {
        _beginDetailTextField = [[FrtcDefaultTextField alloc] initWithFrame:CGRectMake(0, 0, 207, 36)];
        
        // 按照24小时制，不需要在前面加上前缀：上午或下午
        NSDate *theDate = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSCalendarUnitMinute fromDate:theDate];
        NSInteger minute = [components minute];

        // Calculate the minutes remaining until the next half-hour mark or hour
        NSInteger remainingMinutes = (15 - (minute % 15)) % 15;

        // Round up to the nearest half-hour mark or hour
        NSInteger roundedMinutes = remainingMinutes > 0 ? remainingMinutes : 15;
        NSDate *nextDate = [theDate dateByAddingTimeInterval:roundedMinutes * 60];
        

        // Reset the second component to 0
        NSDateComponents *newComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:nextDate];
        [newComponents setSecond:0];

        // Get the next half-hour mark or hour
        NSDate *finalDate = [calendar dateFromComponents:newComponents];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [formatter setDateFormat:@"HH:mm"];
        NSString *dateString = [formatter stringFromDate:finalDate];
        NSLog(@"beginDetailTextField: %@", dateString);
        [_beginDetailTextField setFormatter:formatter];
        _beginDetailTextField.stringValue = dateString;
        _beginDetailTextField.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        
        IntegerFormatter *formatter1 = [[IntegerFormatter alloc] init];
        [_beginDetailTextField setFormatter:formatter1];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        [_beginDetailTextField setFormatter:dateFormatter];
        [self addSubview:_beginDetailTextField];
    }
    
    return _beginDetailTextField;
}

- (FrtcDetailTimeView *)detaiTimeView {
    if(!_detaiTimeView) {
        _detaiTimeView = [[FrtcDetailTimeView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:_detaiTimeView];
    }
    
    return _detaiTimeView;
 }

- (HoverImageView *)timerImageView {
    if(!_timerImageView) {
        _timerImageView = [[HoverImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        _timerImageView.delegate = self;
        _timerImageView.tag = 203;
        _timerImageView.image = [NSImage imageNamed:@"icon-timer"];
        [self addSubview:_timerImageView];
    }
    
    return _timerImageView;
}

- (NSTextField *)endTimeTextLabel {
    if(!_endTimeTextLabel) {
        _endTimeTextLabel = [self textField];
        _endTimeTextLabel.stringValue = NSLocalizedString(@"FM_MEETING_END_TIME", @"End time");
        [self addSubview:_endTimeTextLabel];
    }
    
    return _endTimeTextLabel;
}

- (FrtcDefaultTextField *)endTimeTextField {
    if (!_endTimeTextField) {
        _endTimeTextField = [[FrtcDefaultTextField alloc] initWithFrame:CGRectMake(0, 0, 207, 36)];
        NSString *beginTimeString = [NSString stringWithFormat:@"%@:%@",self.beginTimeTextField.stringValue, self.beginDetailTextField.stringValue];
        
        ////
        NSArray *preferredLanguages = [NSLocale preferredLanguages];
        NSString *currentLanguage = preferredLanguages.firstObject;
        NSLocale *currentLocale = [NSLocale localeWithLocaleIdentifier:currentLanguage];

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init]; 
        [formatter setLocale:currentLocale];
        [formatter setDateFormat:@"yyyy-MM-dd EE:HH:mm"];
        //[formatter setLocale:currentLocale];
        
        NSDate *date = [formatter dateFromString:beginTimeString];
        self.scheduleMeetingStartTime = date;
        NSDate *nextDate = [[NSDate alloc] initWithTimeInterval:30 * 60 sinceDate:date];
        self.scheduleMeetingAllowEndTime = [[NSDate alloc] initWithTimeInterval:24 * 60 * 60 sinceDate:date];
        NSString *dateString = [formatter stringFromDate:nextDate];
        NSArray *array = [dateString componentsSeparatedByString:@":"];
 
        _endTimeTextField.stringValue = (array[0] != nil ? array[0] :@"");
        self.endDetailTextField.stringValue = [NSString stringWithFormat:@"%@:%@", array[1], array[2]];
        
        _endTimeTextField.stringValue = (array[0] != nil ? array[0] :@"");
        _endTimeTextField.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        _endTimeTextField.editable = NO;
 
        [self addSubview:_endTimeTextField];
       
    }
    
    return _endTimeTextField;
}

- (HoverImageView *)endCanlanderImageView {
    if(!_endCanlanderImageView) {
        _endCanlanderImageView = [[HoverImageView alloc] initWithFrame:CGRectMake(0, 0, 15.38, 14.77)];
        _endCanlanderImageView.tag = 202;
        _endCanlanderImageView.delegate = self;
        _endCanlanderImageView.image = [NSImage imageNamed:@"icon-calander"];
        [self addSubview:_endCanlanderImageView];
    }
    
    return _endCanlanderImageView;
}

- (FrtcDefaultTextField *)endDetailTextField {
    if (!_endDetailTextField) {
        _endDetailTextField = [[FrtcDefaultTextField alloc] initWithFrame:CGRectMake(0, 0, 207, 36)];
        //按照24小时制，不需要在前面加上前缀：上午或下午
        NSDate *currentDate = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];

        // Get the minute component of the current date
        NSDateComponents *components = [calendar components:NSCalendarUnitMinute fromDate:currentDate];
        NSInteger minute = [components minute];

        // Calculate the minutes remaining until the next half-hour mark or hour
        NSInteger remainingMinutes = 30 - (minute % 30);

        // Add the remaining minutes to the current date
        NSDate *nextDate = [currentDate dateByAddingTimeInterval:remainingMinutes * 60];

        // Round up to the nearest half-hour mark or hour
        NSDateComponents *newComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:nextDate];
        [newComponents setSecond:0];

        NSInteger minuteComponent = [newComponents minute];
        NSInteger roundingValue = (minuteComponent >= 30) ? 60 - minuteComponent : 30 - minuteComponent;
        NSDate *finalDate = [calendar dateByAddingUnit:NSCalendarUnitMinute value:roundingValue toDate:nextDate options:0];

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        if([self isEnglish]) {
            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        } else {
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
        }
        
        formatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
        [formatter setTimeZone:timeZone];
        
        [formatter setDateFormat:@"hh:mm"];
        NSString *dateString = [formatter stringFromDate:finalDate];
        NSLog(@"endDetailTextField: %@", dateString);
        
        _endDetailTextField.stringValue = dateString;
        
        NSString *beginTimeString = [NSString stringWithFormat:@"%@:%@",self.beginTimeTextField.stringValue, self.beginDetailTextField.stringValue];
                
        [formatter setDateFormat:@"yyyy-MM-dd EE:HH:mm"];
        NSDate *date = [formatter dateFromString:beginTimeString];
        nextDate = [[NSDate alloc] initWithTimeInterval:30 * 60 sinceDate:date];
        dateString = [formatter stringFromDate:nextDate];
        
        NSArray *array = [dateString componentsSeparatedByString:@":"];
        _endDetailTextField.stringValue = [NSString stringWithFormat:@"%@:%@", array[1], array[2]];
        _endDetailTextField.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        [self addSubview:_endDetailTextField];
    }
    
    return _endDetailTextField;
}

- (HoverImageView *)endTimerImageView {
    if(!_endTimerImageView) {
        _endTimerImageView = [[HoverImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        _endTimerImageView.tag = 204;
        _endTimerImageView.delegate = self;
        _endTimerImageView.image = [NSImage imageNamed:@"icon-timer"];
        [self addSubview:_endTimerImageView];
    }
    
    return _endTimerImageView;
}

- (NSTextField *)timeZoneLabel {
    if(!_timeZoneLabel) {
        _timeZoneLabel = [self textField];
        _timeZoneLabel.stringValue = NSLocalizedString(@"FM_MEETING_TIME_ZONE", @"Time Zone");
        [self addSubview:_timeZoneLabel];
    }
    
    return _timeZoneLabel;
}

- (FrtcDefaultTextField *)timeZoneTextField {
    if (!_timeZoneTextField) {
        _timeZoneTextField = [[FrtcDefaultTextField alloc] initWithFrame:CGRectMake(0, 0, 207, 36)];
        _timeZoneTextField.placeholderString = NSLocalizedString(@"FM_CHINA_TIME", @" (GMT+08:00)China Standard Time - BeiJing");
        _timeZoneTextField.editable = NO;
        _timeZoneTextField.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        [self addSubview:_timeZoneTextField];
    }
    
    return _timeZoneTextField;
}

- (NSTextField *)recurrentlyLabel {
    if(!_recurrentlyLabel) {
        _recurrentlyLabel = [self textField];
        _recurrentlyLabel.stringValue = NSLocalizedString(@"FM_MEETING_CURRENCE_MEETING", @"周期性会议");
        [self addSubview:_recurrentlyLabel];
    }
    
    return _recurrentlyLabel;
}

- (NSTextField *)recurrenceLabel {
    if(!_recurrenceLabel) {
        _recurrenceLabel = [self textField];
        _recurrenceLabel.stringValue = NSLocalizedString(@"FM_MEETING_RE_CRERENCE", @"重复");
        [self addSubview:_recurrenceLabel];
    }
    
    return _recurrenceLabel;
}

- (FrtcPopUpButton *)recurrenceCombox {
    if (!_recurrenceCombox) {
        _recurrenceCombox = [[FrtcPopUpButton alloc] init];
        [_recurrenceCombox setFontWithString:@"222222" alpha:1 size:14 andType:SFProDisplayRegular];
        [_recurrenceCombox setTarget:self];
        [_recurrenceCombox setAction:@selector(onRecurrencyRateSelChange)];
        [_recurrenceCombox addItemWithTitle:NSLocalizedString(@"FM_MEETING_NO_RE_CRERENCE", @"不重复")];
        [_recurrenceCombox addItemWithTitle:NSLocalizedString(@"FM_MEETING_RE_CRERENCE_DAY", @"每天")];
        [_recurrenceCombox addItemWithTitle:NSLocalizedString(@"FM_MEETING_RE_CRERENCE_WEEK", @"每周")];
        [_recurrenceCombox addItemWithTitle:NSLocalizedString(@"FM_MEETING_RE_CRERENCE_MOUNTH", @"每月")];
    
        [self addSubview:_recurrenceCombox];
    }
    
    return  _recurrenceCombox;
}

- (NSTextField *)frequencyLabel {//FM_MEETING_RE_FREQUENCY = "频率";
    if(!_frequencyLabel) {
        _frequencyLabel = [self textField];
        _frequencyLabel.stringValue = NSLocalizedString(@"FM_MEETING_RE_FREQUENCY", @"频率");
        _frequencyLabel.hidden = YES;
        [self addSubview:_frequencyLabel];
    }
    
    return _frequencyLabel;
}

- (FrtcPopUpButton *)frequencyCombox {
    if (!_frequencyCombox) {
        _frequencyCombox = [[FrtcPopUpButton alloc] init];
        [_frequencyCombox setFontWithString:@"222222" alpha:1 size:14 andType:SFProDisplayRegular];
        [_frequencyCombox setTarget:self];
        [_frequencyCombox setAction:@selector(onFrequencySelChange)];
        _frequencyCombox.hidden = YES;
        [self addSubview:_frequencyCombox];
    }
    
    return  _frequencyCombox;
}

- (NSTextField *)frequencyDetailLabel {
    if(!_frequencyDetailLabel) {
        _frequencyDetailLabel = [self textField];
        _frequencyDetailLabel.stringValue = NSLocalizedString(@"FM_MEETING_RE_FREQUENCY_DAY", @"天");
        _frequencyDetailLabel.hidden = YES;
        [self addSubview:_frequencyDetailLabel];
    }
    
    return _frequencyDetailLabel;
}

- (WeekView *)weekViewSunday {
    if(!_weekViewSunday) {
        _weekViewSunday = [[WeekView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        _weekViewSunday.weekDayOfDelegate = self;
        _weekViewSunday.hidden = YES;
        _weekViewSunday.titleTextField.stringValue = NSLocalizedString(@"FM_MEETING_SUN", @"Sun");
        [self.weekDayArray addObject:_weekViewSunday];
        [self addSubview:_weekViewSunday];
    }
    
    return _weekViewSunday;
}

- (WeekView *)weekViewMonday {
    if(!_weekViewMonday) {
        _weekViewMonday = [[WeekView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        _weekViewMonday.weekDayOfDelegate = self;
        _weekViewMonday.hidden = YES;
        _weekViewMonday.titleTextField.stringValue = NSLocalizedString(@"FM_MEETING_MON", @"Mon");
        [self.weekDayArray addObject:_weekViewMonday];
        [self addSubview:_weekViewMonday];
    }
    
    return _weekViewMonday;
}

- (WeekView *)weekViewTuesday {
    if(!_weekViewTuesday) {
        _weekViewTuesday = [[WeekView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        _weekViewTuesday.hidden = YES;
        _weekViewTuesday.weekDayOfDelegate = self;
        _weekViewTuesday.titleTextField.stringValue = NSLocalizedString(@"FM_MEETING_TUE", @"Tue");
        [self.weekDayArray addObject:_weekViewTuesday];
        [self addSubview:_weekViewTuesday];
    }
    
    return _weekViewTuesday;
}

- (WeekView *)weekViewWednesday {
    if(!_weekViewWednesday) {
        _weekViewWednesday = [[WeekView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        _weekViewWednesday.hidden = YES;
        _weekViewWednesday.weekDayOfDelegate = self;
        _weekViewWednesday.titleTextField.stringValue = NSLocalizedString(@"FM_MEETING_WED", @"Wed");
        [self.weekDayArray addObject:_weekViewWednesday];
        [self addSubview:_weekViewWednesday];
    }
    
    return _weekViewWednesday;
}

- (WeekView *)weekViewThursday {
    if(!_weekViewThursday) {
        _weekViewThursday = [[WeekView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        _weekViewThursday.hidden = YES;
        _weekViewThursday.weekDayOfDelegate = self;
        _weekViewThursday.titleTextField.stringValue = NSLocalizedString(@"FM_MEETING_THU", @"Thu");
        [self.weekDayArray addObject:_weekViewThursday];
        [self addSubview:_weekViewThursday];
    }
    
    return _weekViewThursday;
}

- (WeekView *)weekViewFriday {
    if(!_weekViewFriday) {
        _weekViewFriday = [[WeekView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        _weekViewFriday.hidden = YES;
        _weekViewFriday.weekDayOfDelegate = self;
        _weekViewFriday.titleTextField.stringValue = NSLocalizedString(@"FM_MEETING_FRI", @"Fri");
        [self.weekDayArray addObject:_weekViewFriday];
        [self addSubview:_weekViewFriday];
    }
    
    return _weekViewFriday;
}

- (WeekView *)weekViewSaturday {
    if(!_weekViewSaturday) {
        _weekViewSaturday = [[WeekView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        _weekViewSaturday.hidden = YES;
        _weekViewSaturday.weekDayOfDelegate= self;
        _weekViewSaturday.titleTextField.stringValue = NSLocalizedString(@"FM_MEETING_SAT", @"Sat");
        [self.weekDayArray addObject:_weekViewSaturday];
        [self addSubview:_weekViewSaturday];
    }
    
    return _weekViewSaturday;
}

- (NSTextField *)beginReTextLabel {
    if(!_beginReTextLabel) {
        _beginReTextLabel = [self textField];
        _beginReTextLabel.stringValue = NSLocalizedString(@"FM_MEETING_RE_BEGIN", @"开始于");
        _beginReTextLabel.hidden = YES;
        [self addSubview:_beginReTextLabel];
    }
    
    return _beginReTextLabel;
}

-(CanlanderView *)beginCanlanderView {
    if(!_beginCanlanderView) {
        _beginCanlanderView = [[CanlanderView alloc] initWithFrame:CGRectMake(0, 0, 207, 36)];
        _beginCanlanderView.viewTag = 201;
        _beginCanlanderView.hidden = YES;
        _beginCanlanderView.calanlerViewDelegate = self;
        [self addSubview:_beginCanlanderView];
    }
    
    return _beginCanlanderView;;
}

- (NSTextField *)endReTextLabel {
    if(!_endReTextLabel) {
        _endReTextLabel = [self textField];
        _endReTextLabel.stringValue = NSLocalizedString(@"FM_MEETING_RE_END", @"结束于");
        _endReTextLabel.hidden = YES;
        [self addSubview:_endReTextLabel];
    }
    
    return _endReTextLabel;
}

- (CanlanderView *)endCanlanderView {
    if(!_endCanlanderView) {
        _endCanlanderView = [[CanlanderView alloc] initWithFrame:CGRectMake(0, 0, 207, 36)];
        _endCanlanderView.viewTag = 202;
        _endCanlanderView.hidden = YES;
        _endCanlanderView.calanlerViewDelegate = self;
        [self addSubview:_endCanlanderView];
    }
    
    return _endCanlanderView;;
}

- (MonthView *)monthView {
    if(!_monthView) {
        _monthView = [[MonthView alloc] initWithFrame:CGRectMake(0, 0, 248, 193)];
        _monthView.monthViewDelegate = self;
        _monthView.hidden = YES;
        [self addSubview:_monthView];
    }
    
    return _monthView;
}


- (NSButton *)personalConferenceNumberOnOffButton {
    if (!_personalConferenceNumberOnOffButton) {
        _personalConferenceNumberOnOffButton = [self checkButton:NSLocalizedString(@"FM_USE_PER_MEETING", @"Use Personal Meeting ID") aciton:@selector(onEnablePersonalNumber:)];
        if(self.meetingRooms.meeting_rooms.count > 0) {
            _personalConferenceNumberOnOffButton.enabled = YES;
        } else {
            _personalConferenceNumberOnOffButton.enabled = NO;
        }
    }
    
    return _personalConferenceNumberOnOffButton;
}

- (FrtcPopUpButton *)personalConferenceNumberOnOffSelectCombox {
    if (!_personalConferenceNumberOnOffSelectCombox) {
        _personalConferenceNumberOnOffSelectCombox = [[FrtcPopUpButton alloc] init];
        [_personalConferenceNumberOnOffSelectCombox setFontWithString:@"222222" alpha:1 size:14 andType:SFProDisplayRegular];
        [_personalConferenceNumberOnOffSelectCombox setTarget:self];
        [_personalConferenceNumberOnOffSelectCombox setAction:@selector(onPersonalNumberSelChange)];
        if(self.meetingRooms) {
            for(PersonalMeetingModel *model in self.meetingRooms.meeting_rooms) {
                [[self personalConferenceNumberOnOffSelectCombox] addItemWithTitle:model.meeting_number];
            }
        }
        _personalConferenceNumberOnOffSelectCombox.hidden = YES;
        [self addSubview:_personalConferenceNumberOnOffSelectCombox];
    }
    
    return  _personalConferenceNumberOnOffSelectCombox;
}

- (NSButton *)enablePersonalPasswordOnOffButton {
    if (!_enablePersonalPasswordOnOffButton) {
        _enablePersonalPasswordOnOffButton = [self checkButton:NSLocalizedString(@"FM_ENABLE_PER_PASSWORD", @"FM_ENABLE_PER_PASSWORD") aciton:@selector(onEnablePersonalMeetingPassword:)];
        _enablePersonalPasswordOnOffButton.state = NSControlStateValueOff;
    }
    
    return _enablePersonalPasswordOnOffButton;
}

- (NSTextField *)inviteTextLabel {
    if(!_inviteTextLabel) {
        _inviteTextLabel = [self textField];
        _inviteTextLabel.stringValue = NSLocalizedString(@"FM_MEETING_INVITED_USERS", @"Invited Participants");
        [self addSubview:_inviteTextLabel];
    }
    
    return _inviteTextLabel;
}

- (FrtcButton *)inviteButton {
    if(!_inviteButton) {
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#DEDEDE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andButtonTitle:[NSString stringWithFormat:@"+ %@", NSLocalizedString(@"FM_MEETING_ADD_USERS", @"Add")] andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#DEDEDE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andButtonTitle:[NSString stringWithFormat:@"+ %@", NSLocalizedString(@"FM_MEETING_ADD_USERS", @"Add")] andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        _inviteButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 93, 32) withNormalMode:normalMode withHoverMode:hoverMode];
        _inviteButton.target = self;
        _inviteButton.action = @selector(oninviteBtnPressed:);
        
        [self addSubview:_inviteButton];
        
        
    }
    
    return _inviteButton;;
}

- (NSTextField *)invitePeopleNumber {
    if(!_invitePeopleNumber) {
        _invitePeopleNumber = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _invitePeopleNumber.backgroundColor = [NSColor clearColor];
        _invitePeopleNumber.font = [NSFont systemFontOfSize:14 weight:NSFontWeightRegular];
        _invitePeopleNumber.alignment = NSTextAlignmentCenter;
        _invitePeopleNumber.textColor = [NSColor colorWithString:@"#999999" andAlpha:1.0];
        _invitePeopleNumber.bordered = NO;
        _invitePeopleNumber.editable = NO;
        _invitePeopleNumber.hidden = YES;
        [self addSubview:_invitePeopleNumber];
    }
    
    return _invitePeopleNumber;
}

- (NSTextField *)rateTextField {
    if(!_rateTextField) {
        _rateTextField = [self textField];
        _rateTextField.stringValue = NSLocalizedString(@"FM_CALL_RATE_USED", @"Call Rate");
        [self addSubview:_rateTextField];
    }
    
    return _rateTextField;
}

- (FrtcPopUpButton *)rateSelectCombox {
    if (!_rateSelectCombox) {
        _rateSelectCombox = [[FrtcPopUpButton alloc] init];
        [_rateSelectCombox setFontWithString:@"222222" alpha:1 size:14 andType:SFProDisplayRegular];
        [_rateSelectCombox setTarget:self];
        [_rateSelectCombox setAction:@selector(onRateSelChange)];
        [self addSubview:_rateSelectCombox];
    }
    
    return  _rateSelectCombox;
}

- (NSTextField *)advanceTextField {
    if(!_advanceTextField) {
        _advanceTextField = [self textField];
        _advanceTextField.stringValue = NSLocalizedString(@"FM_MEETING_JOIN_MEETING_BEFORE_TIME", @"Early membership time");
        [self addSubview:_advanceTextField];
    }
    
    return _advanceTextField;
}

- (FrtcPopUpButton *)advancePopUpButton {
    if (!_advancePopUpButton) {
        _advancePopUpButton = [[FrtcPopUpButton alloc] init];
        [_advancePopUpButton setFontWithString:@"222222" alpha:1 size:14 andType:SFProDisplayRegular];
        [_advancePopUpButton setTarget:self];
        [_advancePopUpButton addItemWithTitle:@"30分钟"];
        [_advancePopUpButton addItemWithTitle:@"任意时间"];
        [_advancePopUpButton setAction:@selector(onAdvanceSelChange)];
        [self addSubview:_advancePopUpButton];
    }
    
    return  _advancePopUpButton;
}

- (NSButton *)micphoneOnOffButton {
    if (!_micphoneOnOffButton) {
        _micphoneOnOffButton = [self checkButton:NSLocalizedString(@"FM_MEETING_JOIN_MUTE", @"Mute When Join") aciton:@selector(onOnlyAudioCall:)];
        self.muteUponEntry = @"DISABLE";
    }
    
    return _micphoneOnOffButton;
}

- (NSButton *) allowGuestOnOffButton {
    if (!_allowGuestOnOffButton) {
        _allowGuestOnOffButton = [self checkButton:NSLocalizedString(@"FM_MEETING_ALLOW_GUEST", @"Allow Guest In") aciton:@selector(onEnableMicphone:)];
        self.guestDialIn = YES;
        [_allowGuestOnOffButton setState:NSControlStateValueOn];
    }
    
    return _allowGuestOnOffButton;
}

- (NSButton *)shareWaterMaskButton {
    if (!_shareWaterMaskButton) {
        _shareWaterMaskButton = [self checkButton:NSLocalizedString(@"FM_MEETING_WATER_PRINT", @"Screen Sharing Watermark") aciton:@selector(onEnableCamera:)];
        _shareWaterMaskButton.enabled = NO;
    }
    
    return _shareWaterMaskButton;
}

- (NSTextField *)contentWaterTypeTextField {
    if(!_contentWaterTypeTextField) {
        _contentWaterTypeTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _contentWaterTypeTextField.backgroundColor = [NSColor clearColor];
        _contentWaterTypeTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightRegular];
        _contentWaterTypeTextField.alignment = NSTextAlignmentLeft;
        _contentWaterTypeTextField.textColor = [NSColor colorWithString:@"#999999" andAlpha:1.0];
        _contentWaterTypeTextField.bordered = NO;
        _contentWaterTypeTextField.editable = NO;
        _contentWaterTypeTextField.stringValue = NSLocalizedString(@"FM_MEETING_WATER_PRINT_SINGLE", @"Single line");
        [self addSubview:_contentWaterTypeTextField];
    }
    
    return _contentWaterTypeTextField;
}

- (FrtcBorderTextField *)reminderConferenceTextField {
    if (!_reminderConferenceTextField) {
        _reminderConferenceTextField = [[FrtcBorderTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _reminderConferenceTextField.backgroundColor = [NSColor clearColor];
        _reminderConferenceTextField.font = [NSFont systemFontOfSize:12 weight:NSFontWeightMedium];
        _reminderConferenceTextField.alignment = NSTextAlignmentLeft;
        _reminderConferenceTextField.textColor = [NSColor colorWithString:@"666666" andAlpha:1.0];
        _reminderConferenceTextField.bordered = NO;
        _reminderConferenceTextField.editable = NO;
        _reminderConferenceTextField.stringValue = NSLocalizedString(@"FM_START_TIME_NOT_EARLY_THAN_CURRENT_TIME", @"Start time cannot be earlier than current time");
        _reminderConferenceTextField.hidden = YES;
        [self addSubview:_reminderConferenceTextField];
    }
    
    return _reminderConferenceTextField;
}

- (NSImageView *)reminderConferenceImageView {
    if (!_reminderConferenceImageView) {
        _reminderConferenceImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        [_reminderConferenceImageView setImage:[NSImage imageNamed:@"icon_reminder"]];
        _reminderConferenceImageView.imageAlignment =  NSImageAlignTopLeft;
        _reminderConferenceImageView.imageScaling =  NSImageScaleAxesIndependently;
        _reminderConferenceImageView.hidden = YES;
        [self addSubview:_reminderConferenceImageView];
    }
    
    return _reminderConferenceImageView;
}

- (FrtcBorderTextField *)reminderConferenceTextField1 {
    if (!_reminderConferenceTextField1) {
        _reminderConferenceTextField1 = [[FrtcBorderTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _reminderConferenceTextField1.backgroundColor = [NSColor clearColor];
        _reminderConferenceTextField1.font = [NSFont systemFontOfSize:12 weight:NSFontWeightMedium];
        _reminderConferenceTextField1.alignment = NSTextAlignmentLeft;
        _reminderConferenceTextField1.textColor = [NSColor colorWithString:@"666666" andAlpha:1.0];
        _reminderConferenceTextField1.bordered = NO;
        _reminderConferenceTextField1.editable = NO;
        _reminderConferenceTextField1.stringValue = NSLocalizedString(@"FM_END_TIME_NOT_EARLY_THAN_START_TIME", @"End time cannot be earlier than start time");
        _reminderConferenceTextField1.hidden = YES;
        [self addSubview:_reminderConferenceTextField1];
    }
    
    return _reminderConferenceTextField1;
}

- (NSImageView *)reminderConferenceImageView1 {
    if (!_reminderConferenceImageView1) {
        _reminderConferenceImageView1 = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        [_reminderConferenceImageView1 setImage:[NSImage imageNamed:@"icon_reminder"]];
        _reminderConferenceImageView1.imageAlignment =  NSImageAlignTopLeft;
        _reminderConferenceImageView1.imageScaling =  NSImageScaleAxesIndependently;
        _reminderConferenceImageView1.hidden = YES;
        [self addSubview:_reminderConferenceImageView1];
    }
    
    return _reminderConferenceImageView1;
}
- (NSMutableArray<NSString *> *)userList {
    if(!_userList) {
        _userList = [NSMutableArray array];
    }
    
    return _userList;
}

- (NSDictionary *)userDictionary {
    if(!_userDictionary) {
        _userDictionary = [[NSDictionary alloc] init];
    }
    
    return _userDictionary;
}

- (CallResultReminderView *)reminderView {
    if(!_reminderView) {
        _reminderView = [[CallResultReminderView alloc] initWithFrame:CGRectMake(0, 0, 172, 40)];
        _reminderView.tipLabel.stringValue = @"账号或密码不正确";
        _reminderView.hidden = YES;
        
        [self addSubview:_reminderView];
    }
    
    return _reminderView;
}
#pragma mark --Internal Function--
- (NSTextField *)textField {
    NSTextField *internalTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    internalTextField.backgroundColor = [NSColor clearColor];
    internalTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightMedium];
    internalTextField.alignment = NSTextAlignmentCenter;
    internalTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
    internalTextField.bordered = NO;
    internalTextField.editable = NO;
 
    return internalTextField;
}

#pragma mark -- internal function --
- (NSButton *)checkButton:(NSString *)buttonTile aciton:(SEL)action {
    int btnWidth = 360;
    int btnHeight = 16;
    NSButton *checkButton = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, btnWidth, btnHeight)];
    [checkButton setButtonType:NSButtonTypeSwitch];
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:buttonTile];
    NSUInteger len = [attrTitle length];
    NSRange range = NSMakeRange(0, len);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    [attrTitle addAttribute:NSForegroundColorAttributeName value:[[FrtcBaseImplement baseImpleSingleton] baseColor]
                      range:range];
    [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                      range:range];
    
    [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                      range:range];
    [attrTitle fixAttributesInRange:range];
    [checkButton setAttributedTitle:attrTitle];
    attrTitle = nil;
    [checkButton setNeedsDisplay:YES];
    
    checkButton.target = self;
    checkButton.action = action;
    [self addSubview:checkButton];
    
    return checkButton;
}

@end
