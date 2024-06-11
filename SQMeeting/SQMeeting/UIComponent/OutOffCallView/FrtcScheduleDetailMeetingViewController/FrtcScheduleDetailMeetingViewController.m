#import "FrtcScheduleDetailMeetingViewController.h"
#import "FrtcButton.h"
#import "CallResultReminderView.h"
#import "FrtcAlertMainWindow.h"
#import "FrtcReminderImageButton.h"
#import "HoverImageView.h"
#import "FrtcMeetingManagement.h"
#import "FrtcMeetingScheduleInfoWindow.h"
#import "FrtcRecurrenceView.h"
#import "FrtcRecurrenceIntervalView.h"
#import "FrtcRecurrenceDetailViewController.h"
#import "FrtcScheduleDetailMeetingViewController.h"
#import "FrtcScheduleMeetingModifyViewController.h"
#import "FrtcMainWindow.h"
#import "FrtcModifyCancelTypeWindow.h"
#import "FrtcReplaceButton.h"
#import "FrtcCancelMeetingWindow.h"

#import <EventKit/EventKit.h> //for iCal


@interface FrtcScheduleDetailMeetingViewController () <FrtcReminderImageButtonDelegate, HoverImageViewDelegate, FrtcRecurrenceIntervalViewDelegate, FrtcRecurrenceDetailViewControllerDelegate, FrtcModifyCancelTypeWindowDelegate, FrtcCancelMeetingWindowDelegate>

@property (nonatomic, strong) NSTextField   *titleTextField;
@property (nonatomic, strong) NSView        *line1;
@property (nonatomic, strong) NSTextField   *beginTimeLabel;
@property (nonatomic, strong) NSTextField   *beginTimeTextField;
@property (nonatomic, strong) NSView        *line2;
@property (nonatomic, strong) NSTextField   *durationTimeLabel;
@property (nonatomic, strong) NSTextField   *durationTimeTextField;
@property (nonatomic, strong) NSView        *line3;
@property (nonatomic, strong) NSTextField   *meetingOwnerLabel;
@property (nonatomic, strong) NSTextField   *meetingOwnerTextField;
@property (nonatomic, strong) NSTextField   *meetingNumberLabel;
@property (nonatomic, strong) NSTextField   *meetingNumberTextField;
@property (nonatomic, strong) NSView        *line4;
@property (nonatomic, strong) NSTextField   *meetingPasswordLabel;
@property (nonatomic, strong) NSTextField   *meetingPasswordTextField;
@property (nonatomic, strong) NSView        *line5;
@property (nonatomic, strong) NSTextField   *meetingLeadLabel;
@property (nonatomic, strong) NSTextField   *meetingLeadTextField;
@property (nonatomic, strong) NSView        *line6;
@property (nonatomic, strong) NSView        *line7;
@property (nonatomic, strong) CallResultReminderView *reminderView;
@property (nonatomic, strong) FrtcButton      *callButton;
@property (nonatomic, strong) FrtcButton      *copyButton;
@property (nonatomic, strong) FrtcButton      *cancelButton;
@property (nonatomic, strong) FrtcButton      *deleteButton;
@property (nonatomic, strong) FrtcButton      *removeButton;
@property (nonatomic, strong) FrtcReminderImageButton *saveToCalendarButton;
@property (nonatomic, strong) EKEventStore *eventStore;

@property (nonatomic, strong) NSTimer       *reminderTipsTimer;

@property (nonatomic, strong) HoverImageView *modifyImageView;
@property (nonatomic, strong) NSTextField *modifyTextField;
@property (nonatomic, strong) FrtcRecurrenceView *recurrenceView;
@property (nonatomic, strong) FrtcRecurrenceIntervalView *recurrenceIntervalView;
@property (nonatomic, strong) FrtcMainWindow *meetingDetailWindow;
@property (nonatomic, strong) FrtcMainWindow *modifyWindow;
@property (nonatomic, strong) FrtcMainWindow *scheduleWindow;

@end

@implementation FrtcScheduleDetailMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMainViewNotification:) name:FrtcMeetingMainViewShowNotification object:nil];
    [self setupDetailMeetingUI];
    
    [self updateMeetingNumber];
}

- (void)setupDetailMeetingUI {
    if([self.scheduleModel.meeting_type isEqualToString:@"recurrence"]) {
        if(!self.isInvite && !self.isAddMeeting) {
            [self.modifyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view.mas_top).offset(16);
                make.right.mas_equalTo(self.view.mas_right).offset(-57);
                make.width.mas_equalTo(24);
                make.height.mas_equalTo(24);
            }];
            
            [self.modifyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.modifyImageView.mas_centerY);
                make.left.mas_equalTo(self.modifyImageView.mas_right).offset(5);
                make.width.mas_greaterThanOrEqualTo(0);
                make.height.mas_greaterThanOrEqualTo(0);
            }];
            
            FrtcReplaceButton *button = [[FrtcReplaceButton alloc] initWithFrame:self.modifyTextField.frame];
            [button setBordered:NO];
            [button setTitle:@""];
            [button setTarget:self];
            button.wantsLayer = YES;
            button.layer.backgroundColor = [NSColor clearColor].CGColor;
            [self.view addSubview:button];
            [button setAction:@selector(buttonClicked:)];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.modifyImageView.mas_centerY);
                make.left.mas_equalTo(self.modifyTextField.mas_left);
                make.width.mas_equalTo(self.modifyTextField.mas_width);
                make.height.mas_equalTo(self.modifyTextField.mas_height);
            }];
        }
        
        NSFont *font             = [NSFont systemFontOfSize:13.0f];
        NSDictionary *attributes = @{ NSFontAttributeName:font };
        CGSize size              = [NSLocalizedString(@"FM_MEETING_RECURRENCE_RECURRENT_TAG", @"Recurrence") sizeWithAttributes:attributes];
        
        [self.recurrenceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).offset(50);
            make.left.mas_equalTo(self.view.mas_left).offset(24);
            make.width.mas_equalTo(size.width + 10);
            make.height.mas_equalTo(24);
        }];
        
        NSFont *font1             = [NSFont systemFontOfSize:14.0f];
        NSDictionary *attributes1 = @{ NSFontAttributeName:font1 };
        CGSize size1              = [self.recurrenceIntervalView.titleTextField.stringValue sizeWithAttributes:attributes1];

        [self.recurrenceIntervalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.recurrenceView.mas_centerY);
            make.left.mas_equalTo(self.recurrenceView.mas_right);
            make.width.mas_equalTo(size1.width + 30);
            make.height.mas_equalTo(24);
        }];
        
        FrtcReplaceButton *replaceInterviewButton = [[FrtcReplaceButton alloc] initWithFrame:self.modifyTextField.frame];
        [replaceInterviewButton setBordered:NO];
        [replaceInterviewButton setTitle:@""];
        [replaceInterviewButton setTarget:self];
        replaceInterviewButton.wantsLayer = YES;
        replaceInterviewButton.layer.backgroundColor = [NSColor clearColor].CGColor;
        [self.view addSubview:replaceInterviewButton];
        [replaceInterviewButton setAction:@selector(replaceButtonClicked:)];
        
        [replaceInterviewButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.recurrenceIntervalView.mas_centerY);
            make.left.mas_equalTo(self.view.mas_left).offset(24);
            //make.left.mas_equalTo(self.recurrenceIntervalView.mas_left);
            make.width.mas_equalTo(size.width + 30 + size1.width + 10);
            make.height.mas_equalTo(self.recurrenceIntervalView.mas_height);
        }];
        
        [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.recurrenceView.mas_bottom).offset(15);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.width.mas_greaterThanOrEqualTo(0);
            make.height.mas_greaterThanOrEqualTo(0);
         }];
    } else {
        
        [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).offset(60);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(380);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
    }
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(380);
        make.height.mas_equalTo(1);
    }];
    

    [self.durationTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line1.mas_bottom).offset(11);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.durationTimeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-24);
        make.centerY.mas_equalTo(self.durationTimeLabel.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.beginTimeLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_equalTo(380);
        make.height.mas_equalTo(1);
     }];
    
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.durationTimeLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_equalTo(332);
        make.height.mas_equalTo(1);
     }];
    
    [self.meetingNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line3.mas_bottom).offset(15);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.meetingNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-24);
        make.centerY.mas_equalTo(self.meetingNumberLabel.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.meetingNumberLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_equalTo(332);
        make.height.mas_equalTo(1);
     }];
    
    [self.meetingOwnerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line4.mas_bottom).offset(15);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.meetingOwnerTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-24);
        make.centerY.mas_equalTo(self.meetingOwnerLabel.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.line7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.meetingOwnerLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_equalTo(332);
        make.height.mas_equalTo(1);
     }];
    
    [self.meetingPasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line7.mas_bottom).offset(15);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.meetingPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-24);
        make.centerY.mas_equalTo(self.meetingPasswordLabel.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.meetingPasswordLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_equalTo(332);
        make.height.mas_equalTo(1);
     }];
    
    [self.meetingLeadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line5.mas_bottom).offset(15);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.meetingLeadTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-24);
        make.centerY.mas_equalTo(self.meetingLeadLabel.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.line6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.meetingLeadLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_equalTo(332);
        make.height.mas_equalTo(1);
     }];
    
    if(self.isOvertime) {
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.line6.mas_bottom).offset(24);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(332);
            make.height.mas_equalTo(36);
         }];
        
        return;
    }
    
    if(self.isInvite) {
        [self.callButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.line6.mas_bottom).offset(24);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(332);
            make.height.mas_equalTo(36);
         }];
        
        [self.copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.callButton.mas_bottom).offset(16);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(332);
            make.height.mas_equalTo(36);
         }];
        
        NSFont *font1             = [NSFont systemFontOfSize:14.0f];
        
        NSDictionary *attributes1 = @{ NSFontAttributeName:font1 };
        CGSize size1              = [NSLocalizedString(@"FM_MEETING_REMINDER_CALENDAR", @"Save to System Calendar") sizeWithAttributes:attributes1];
        
        [self.saveToCalendarButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.copyButton.mas_bottom).offset(16);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(size1.width + 30);
            make.height.mas_equalTo(size1.height + 10);
        }];
        
        return;
    } 
    
    [self.callButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line6.mas_bottom).offset(24);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(332);
        make.height.mas_equalTo(36);
     }];
    
    [self.copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.callButton.mas_bottom).offset(16);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(332);
        make.height.mas_equalTo(36);
     }];
    
    if(self.isAddMeeting) {
        [self.removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.copyButton.mas_bottom).offset(16);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(332);
            make.height.mas_equalTo(36);
         }];
        
        NSFont *font1             = [NSFont systemFontOfSize:14.0f];
        NSDictionary *attributes1 = @{ NSFontAttributeName:font1 };
        CGSize size1              = [NSLocalizedString(@"FM_MEETING_REMINDER_CALENDAR", @"Save to System Calendar") sizeWithAttributes:attributes1];
     
        [self.saveToCalendarButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.removeButton.mas_bottom).offset(16);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(size1.width + 30);
            make.height.mas_equalTo(size1.height + 10);
        }];
    } else {
        
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.copyButton.mas_bottom).offset(16);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(332);
            make.height.mas_equalTo(36);
        }];
        
        NSFont *font1             = [NSFont systemFontOfSize:14.0f];
        NSDictionary *attributes1 = @{ NSFontAttributeName:font1 };
        CGSize size1              = [NSLocalizedString(@"FM_MEETING_REMINDER_CALENDAR", @"Save to System Calendar") sizeWithAttributes:attributes1];
        
        [self.saveToCalendarButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.cancelButton.mas_bottom).offset(16);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(size1.width + 30);
            make.height.mas_equalTo(size1.height + 10);
        }];
    }
}

- (void)dealloc {
    NSLog(@"FrtcScheduleDetailMeetingViewController dealloc");
}

- (void)updateMeetingNumber {
    __weak __typeof(self)weakSelf = self;
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcGetScheduleMeetingGroupInformation:[[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN] withGroupID:self.scheduleModel.recurrence_gid completionHandler:^(ScheduleGroupModel * _Nonnull scheduleGroupModel) {
        NSString *str;
        if([self.scheduleModel.recurrence_type isEqualToString:@"DAILY"]) {
            if([self.scheduleModel.recurrenceInterval integerValue] == 1) {
                str = NSLocalizedString(@"FM_MEETING_RE_EVERY_DAY", @"Every Day");
            } else {
                str = [NSString stringWithFormat:NSLocalizedString(@"FM_MEETING_RE_EVERY_SOME_DAY", @"Every %@ Day"), [self.scheduleModel.recurrenceInterval stringValue]];
            }
        } else if([self.scheduleModel.recurrence_type isEqualToString:@"WEEKLY"]) {
            if([self.scheduleModel.recurrenceInterval integerValue] == 1) {
                str = NSLocalizedString(@"FM_MEETING_RE_EVERY_WEEK", @"Every Week");
            } else {
                str = [NSString stringWithFormat:NSLocalizedString(@"FM_MEETING_RE_EVERY_SOME_WEEK", @"Every %@ Week"), [self.scheduleModel.recurrenceInterval stringValue]];
            }
            
        } else if([self.scheduleModel.recurrence_type isEqualToString:@"MONTHLY"]) {
            if([self.scheduleModel.recurrenceInterval integerValue] == 1) {
                str = str = NSLocalizedString(@"FM_MEETING_RE_EVERY_MONTH", @"Every MONTH");
            } else {
                str = [NSString stringWithFormat:NSLocalizedString(@"FM_MEETING_RE_EVERY_SOME_MONTH", @"EVERY %@ Month"), [self.scheduleModel.recurrenceInterval stringValue]];
            }
        }
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
       // NSLocalizedString(@"FM_MEETING_RE_REMAINS_MEETINGS","%@, %ld remaining meetings");
        str = [NSString stringWithFormat:NSLocalizedString(@"FM_MEETING_RE_REMAINS_MEETINGS",@"%@, %ld remaining meetings"), str, scheduleGroupModel.meeting_schedules.count];
        strongSelf.recurrenceIntervalView.titleTextField.stringValue = str;
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"failure");
    }];
}

#pragma mark -- implement notification
- (void)receiveMainViewNotification:(NSNotification*)noti {
    [self.view.window close];
}

#pragma makr --FrtcCancelMeetingWindowDelegate--
- (void)cancelMeetingWithCancelRecurrence:(BOOL)cancelAll withReservationID:(NSString *)reservationID {
    __weak __typeof(self)weakSelf = self;
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcDeleteCurrentMeeting:[[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN] withReservationId:reservationID withCancelALL:cancelAll deleteCompletionHandler:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            if(strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(updateScheduleMeetingWhenDeleteSuccess)]) {
                [strongSelf.delegate updateScheduleMeetingWhenDeleteSuccess];
            }
            [strongSelf.view.window close];
        } deleteFailure:^(NSError * _Nonnull error) {
            if([error.localizedDescription isEqualToString:@"Request failed: unauthorized (401)"]) {
                FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_VERIFY_FAILURE", @"Verifyication failed") withMessage:NSLocalizedString(@"FM_RE_SIGN", @"Please sign in again") preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:self.view.window];

                FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
                    [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingMainViewShowNotification object:nil userInfo:nil];
                }];
                [alertWindow addAction:action];
            }
    }];
}

#pragma mark --FrtcModifyCancelTypeWindowDelegate--
- (void)modifyMeetingWithRecurrence:(BOOL)isRecurrence withReversionID:(NSString *)reversionID withRow:(NSInteger)row {
     [self.view.window close];
     if(self.delegate && [self.delegate respondsToSelector:@selector(updateScheduleMeetingWithRecurrence:withReversionID:withRow:)]) {
         [self.delegate updateScheduleMeetingWithRecurrence:isRecurrence withReversionID:reversionID withRow:row];
     }
}

#pragma mark --Button Sender--
- (void)buttonClicked:(NSButton *)sender {
    [self hoverImageViewClickedwithSenderTag:0];
}

- (void)replaceButtonClicked:(NSButton *)sender {
    [self popupScheduleRecurrencView];
}

#pragma mark --FrtcRecurrenceDetailViewControllerDelegate--
- (void)joinMeetingWithRow:(NSInteger)row {
    [self onJoinVideoMeetingPressed:self.callButton];
}

- (void)updateScheduleMeeting:(NSString *)reversionID withRecurrence:(BOOL)isRecurrence {
//    if(self.delegate && [self.delegate respondsToSelector:@selector(modifyScheduleMeeting:withRecurrence:)]) {
//        //[self.delegate modifyScheduleMeeting:reversionID withRecurrence:isRecurrence];
//    }
}

#pragma mark --FrtcRecurrenceIntervalViewDelegate
- (void)popupScheduleRecurrencView {
    if(self.delegate && [self.delegate respondsToSelector:@selector(popupRecurrenceDetailView:withInvite:)]) {
        [self.delegate popupRecurrenceDetailView:self.row withInvite:self.isInvite];
    }
    [self.view.window close];
}

#pragma mark --HoverImageDelegate
- (void)hoverImageViewClickedwithSenderTag:(NSInteger)tag {
    FrtcModifyCancelTypeWindow *modifyMeetingWindow = [[FrtcModifyCancelTypeWindow alloc] initWithSize:NSMakeSize(332, 160)];
    modifyMeetingWindow.modifyDelegate = self;
    modifyMeetingWindow.row = self.row;
    modifyMeetingWindow.reversionID = self.reversionID;
    [modifyMeetingWindow showWindowWithWindow:self.view.window];
}

#pragma mark --Button Sender--
- (void)onJoinVideoMeetingPressed:(FrtcButton *)sender {
    sender.enabled = NO;
    [self.view.window orderOut:nil];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(joinMeeting:)]) {
        [self.delegate joinMeeting:self.row];
    }
}

- (void)onDeleteMeeting:(FrtcButton *)sender {
    NSString *message;
    if([self.scheduleModel.meeting_type isEqualToString:@"recurrence"]) {
        message = NSLocalizedString(@"FM_MEETING_RE_CANCEL_ONE_MEETING", @"Are you sure you want to cancel this meeting in the meeting series?");
        
        FrtcCancelMeetingWindow *cancelRecurrenceMeetingWindow = [[FrtcCancelMeetingWindow alloc] initWithSize:NSMakeSize(320, 160)];
        cancelRecurrenceMeetingWindow.cancelMeetingDelegate = self;
        cancelRecurrenceMeetingWindow.reservationID = self.scheduleModel.reservation_id;
        [cancelRecurrenceMeetingWindow showWindowWithWindow:self.view.window];
    } else {
        message = NSLocalizedString(@"FM_CANCEL_METTING_MESSAGE", @"All participants can not join this meeting once canceled");
        
        FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_CANCEL_MEETING_ABOUT", @"Cancel Meeting") withMessage:message preferredStyle:FrtcWindowAlertStyleDefault withCurrentWindow:self.view.window];
        
        __weak __typeof(self)weakSelf = self;
        FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_CANCEL_ABOUT_YES", @"YES") style:FrtcWindowAlertActionStyleOK handler:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            [strongSelf.view.window orderOut:nil];
            
            if(strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(deleteMeetingWithReservationID:)]) {
                [strongSelf.delegate deleteMeetingWithReservationID:strongSelf.scheduleModel.reservation_id];
            }
            
        }];
        [alertWindow addAction:action withTitleColor:[NSColor colorWithString:@"#E32726" andAlpha:1.0]];
       // [alertWindow addAction:action];
        
        FrtcAlertAction *actionCancel = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_CANCEL_ABOUT", @"NO") style:FrtcWindowAlertActionStyleCancle handler:^{
        }];
        
        [alertWindow addAction:actionCancel];
    }
}

- (void)onCopyMeeting:(FrtcButton *)sender {
    __weak __typeof(self)weakSelf = self;
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcGetScheduleMeetingDetailInformation:[[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN] withReservationID:self.scheduleModel.reservation_id completionHandler:^(ScheduleSuccessModel * meetingDetailModel) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        FrtcMeetingScheduleInfoWindow *scheduledInfoWindow = [[FrtcMeetingScheduleInfoWindow alloc] initWithSize:NSMakeSize(388, 410) withSuccessfulSchedule:NO];
       
        [scheduledInfoWindow setupMeetingInfo:meetingDetailModel];
        [scheduledInfoWindow makeKeyAndOrderFront:strongSelf];
        [scheduledInfoWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
        scheduledInfoWindow.titleVisibility       = NSWindowTitleHidden;
        
        [scheduledInfoWindow showWindowWithWindow:strongSelf.view.window];
    } failure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSLog(@"%@", error);
        FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_VERIFY_FAILURE", @"Verifyication failed") withMessage:NSLocalizedString(@"FM_RE_SIGN", @"Please sign in again") preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:strongSelf.view.window];

        FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
            [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingMainViewShowNotification object:nil userInfo:nil];
        }];
        [alertWindow addAction:action];
    }];
}

- (void)onRemoveMeeting:(FrtcButton *)sender {
    FrtcAlertMainWindow *alertWindow;
    if([self.scheduleModel.meeting_type isEqualToString:@"recurrence"]) {
        alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_REMOVE_MEETING_RECURRENT_FROM_LIST", @"Remove the recurring meeting？") withMessage:NSLocalizedString(@"FM_REMOVE_MEETING_RECURRENT_FROM_LIST_DETAIL", @"You will remove this recurring meeting from the meeting list") preferredStyle:FrtcWindowAlertStyleDefault withCurrentWindow:self.view.window withWindowSize: NSMakeSize(286, 128)];
    } else {
        alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_REMOVE_MEETING_FROMLIST", @"Remove Meeting") withMessage:NSLocalizedString(@"FM_REMOVE_MEETING_NORMAL_FROM_LIST_DETAIL", @"You will remove this recurring meeting from the meeting list") preferredStyle:FrtcWindowAlertStyleDefault withCurrentWindow:self.view.window withWindowSize: NSMakeSize(286, 128)];
    }
    
    __weak __typeof(self)weakSelf = self;
    FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_REMOVE_MEETING_FROMLIST", @"Remove Meeting") style:FrtcWindowAlertActionStyleOK handler:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSString *meetingIdentifier;
        
        if([strongSelf.scheduleModel.meeting_type isEqualToString:@"recurrence"]) {
            meetingIdentifier = strongSelf.scheduleModel.groupInfoKey;
        } else {
            meetingIdentifier = strongSelf.scheduleModel.meetingInfoKey;
        }
        
        [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcRemoveMeetingListFromUrl:[[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN] meetingIdentifier:meetingIdentifier completionHandler:^(NSDictionary * _Nonnull meetingInfo) {
                NSLog(@"Success");
            
                if(strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(removeMeetingSuccess)]) {
                    [strongSelf.delegate removeMeetingSuccess];
                }
                [strongSelf.view.window close];
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"failure");
        }];
 
    }];
    
    [alertWindow addAction:action withTitleColor:[NSColor colorWithString:@"#E32726" andAlpha:1.0]];
    
    FrtcAlertAction *actionCancel = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_CANCEL_ABOUT", @"Not Now") style:FrtcWindowAlertActionStyleCancle handler:^{
    }];
    
    [alertWindow addAction:actionCancel];
}

#pragma mark --Class Interface
- (void)showReminderView:(NSString *)reminderValue {
    NSFont *font             = [NSFont systemFontOfSize:14.0f];
    NSDictionary *attributes = @{ NSFontAttributeName:font };
    CGSize size              = [reminderValue sizeWithAttributes:attributes];
    
    [self.reminderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.width.mas_equalTo(size.width + 28);
        make.height.mas_equalTo(size.height + 20);
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

#pragma mark --Internal Funtion--
- (NSString *)timeDurationWithStartTime:(NSString *)startTime withEndTime:(NSString *)endTime {
    NSTimeInterval startTimeInterval = [startTime doubleValue] / 1000;
    NSTimeInterval endTimeInterval = [endTime doubleValue] / 1000;
    
    NSTimeInterval durationTimeInterval = endTimeInterval - startTimeInterval;
     
    return [self timeWithMessageString:durationTimeInterval];
}

- (NSString *)timeWithMessageString:(NSTimeInterval)timeInter {
    
    int month = timeInter / (3600 * 24 * 30);
    int day = timeInter / (3600 * 24);
    int hour = timeInter / 3600;
    int minute = timeInter / 60;
    
    int day_process = day - month * 30;
    int hour_process = hour - day *24;
    int minute_process = minute - hour *60;
    int miao_process = timeInter - minute*60;
    
    NSString *timedate = nil;
    if (day == 0) {
        timedate = [NSString stringWithFormat:@"%d%@%d%@",hour_process,NSLocalizedString(@"FM_HOUR", @"hour"),minute_process, NSLocalizedString(@"FM_MINUTE", @"minute")];
        if (hour == 0) {
           timedate = [NSString stringWithFormat:@"%d%@",minute_process, NSLocalizedString(@"FM_MINUTE", @"minute")];
//            if (hour == 0) {
//                timedate = [NSString stringWithFormat:@"%d秒",miao_process];
//            }
        }
    } else {
        timedate = [NSString stringWithFormat:@"%d天%d%@%d%@%d%@",day_process,hour_process,NSLocalizedString(@"FM_HOUR", @"hour"),minute_process,NSLocalizedString(@"FM_MINUTE", @"minute"),miao_process, NSLocalizedString(@"FM_SECOND", @"second")];
    }
    
    return timedate;
}

#pragma mark --getter load--
- (NSTextField *)titleTextField {
    if (!_titleTextField) {
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        //_titleTextField.accessibilityClearButton;
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:24 weight:NSFontWeightSemibold];
        //_titleTextField.font = [[NSFontManager sharedFontManager] fontWithFamily:@"PingFangSC-Regular" traits:NSBoldFontMask weight:NSFontWeightMedium size:18];
        _titleTextField.maximumNumberOfLines = 1;
        _titleTextField.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = self.scheduleModel.meeting_name;
        [self.view addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (NSView *)line1 {
    if(!_line1) {
        _line1 = [self line];
        [self.view addSubview:_line1];
    }
    
    return _line1;
}

- (NSTextField *)beginTimeLabel {
    if (!_beginTimeLabel) {
        _beginTimeLabel = [self interalLabel];
        _beginTimeLabel.stringValue = @"会议介绍";
        [self.view addSubview:_beginTimeLabel];
    }
    
    return _beginTimeLabel;
}

- (NSTextField *)beginTimeTextField {
    if (!_beginTimeTextField) {
        _beginTimeTextField = [self internalTextField];
        _beginTimeTextField.stringValue = self.scheduleModel.meeting_name;
        [self.view addSubview:_beginTimeTextField];
    }
    
    return _beginTimeTextField;
}

- (NSView *)line2 {
    if(!_line2) {
        _line2 = [self line];
        [self.view addSubview:_line2];
    }
    
    return _line2;
}

- (NSTextField *)durationTimeLabel {
    if(!_durationTimeLabel) {
        _durationTimeLabel = [self interalLabel];
        _durationTimeLabel.stringValue = NSLocalizedString(@"FM_MEETING_START_TIME", @"Start Time");
        [self.view addSubview:_durationTimeLabel];
    }
    
    return _durationTimeLabel;
}

- (NSTextField *)durationTimeTextField {
    if(!_durationTimeTextField) {
        _durationTimeTextField = [self internalTextField];
        _durationTimeTextField.stringValue = [[FrtcBaseImplement baseImpleSingleton] dateStringWithTimeString:self.scheduleModel.schedule_start_time];
        [self.view addSubview:_durationTimeTextField];
    }
    
    return _durationTimeTextField;
}

- (NSView *)line3 {
    if(!_line3) {
        _line3 = [self line];
        [self.view addSubview:_line3];
    }
    
    return _line3;
}

- (NSTextField *)meetingOwnerLabel {
    if(!_meetingOwnerLabel) {
        _meetingOwnerLabel = [self interalLabel];
        _meetingOwnerLabel.stringValue = NSLocalizedString(@"FM_MEETING_REMINDER_MEETINGOWNER", @"Meeting owner");
        [self.view addSubview:_meetingOwnerLabel];
    }
    
    return _meetingOwnerLabel;
}

- (NSTextField *)meetingOwnerTextField {
    if(!_meetingOwnerTextField) {
        _meetingOwnerTextField = [self internalTextField];
        _meetingOwnerTextField.stringValue = self.scheduleModel.owner_name;
        [self.view addSubview:_meetingOwnerTextField];
    }
    
    return _meetingOwnerTextField;
}

- (NSTextField *)meetingNumberLabel {
    if(!_meetingNumberLabel) {
        _meetingNumberLabel = [self interalLabel];
        _meetingNumberLabel.stringValue = NSLocalizedString(@"FM_MEETING_DURATION", @"Duration");
        [self.view addSubview:_meetingNumberLabel];
    }
    
    return _meetingNumberLabel;
}

- (NSTextField *)meetingNumberTextField {
    if(!_meetingNumberTextField) {
        _meetingNumberTextField = [self internalTextField];
        _meetingNumberTextField.stringValue = [[FrtcBaseImplement baseImpleSingleton] dateStringWithTimeString:self.scheduleModel.schedule_end_time];
        _meetingNumberTextField.stringValue = [self timeDurationWithStartTime:self.scheduleModel.schedule_start_time withEndTime:self.scheduleModel.schedule_end_time];
        [self.view addSubview:_meetingNumberTextField];
    }
    
    return _meetingNumberTextField;
}

- (NSView *)line4 {
    if(!_line4) {
        _line4 = [self line];
        [self.view addSubview:_line4];
    }
    
    return _line4;
}

- (NSTextField *)meetingPasswordLabel {
    if(!_meetingPasswordLabel) {
        _meetingPasswordLabel = [self interalLabel];
        _meetingPasswordLabel.stringValue =NSLocalizedString(@"FM_MEETING_NUMBER", @"Meeting ID");
        [self.view addSubview:_meetingPasswordLabel];
    }
    
    return _meetingPasswordLabel;
}

- (NSTextField *)meetingPasswordTextField {
    if(!_meetingPasswordTextField) {
        _meetingPasswordTextField = [self internalTextField];
        _meetingPasswordTextField.stringValue = self.scheduleModel.meeting_number;
        [self.view addSubview:_meetingPasswordTextField];
    }
    
    return _meetingPasswordTextField;
}

- (NSView *)line5 {
    if(!_line5) {
        _line5 = [self line];
        [self.view addSubview:_line5];
    }
    
    return _line5;
}

- (NSTextField *)meetingLeadLabel {
    if(!_meetingLeadLabel) {
        _meetingLeadLabel = [self interalLabel];
        _meetingLeadLabel.stringValue = NSLocalizedString(@"FM_PASSCODE", @"Password");
        [self.view addSubview:_meetingLeadLabel];
    }
    
    return _meetingLeadLabel;
}

- (NSTextField *)meetingLeadTextField {
    if(!_meetingLeadTextField) {
        _meetingLeadTextField = [self internalTextField];
        _meetingLeadTextField.stringValue = self.scheduleModel.meeting_password ? self.scheduleModel.meeting_password : @"";
        [self.view addSubview:_meetingLeadTextField];
    }
    
    return _meetingLeadTextField;
}

- (NSView *)line6 {
    if(!_line6) {
        _line6 = [self line];
        [self.view addSubview:_line6];
    }
    
    return _line6;
}

- (NSView *)line7 {
    if(!_line7) {
        _line7 = [self line];
        [self.view addSubview:_line7];
    }
    
    return _line7;
}

- (FrtcRecurrenceView *)recurrenceView {
    if(!_recurrenceView) {
        _recurrenceView = [[FrtcRecurrenceView alloc] initWithFrame:NSMakeRect(0, 0, 36, 24)];
        _recurrenceView.titleTextField.font = [NSFont systemFontOfSize:13 weight:NSFontWeightMedium];
        [self.view addSubview:_recurrenceView];
    }
    
    return _recurrenceView;
}

- (FrtcRecurrenceIntervalView *)recurrenceIntervalView {
    if(!_recurrenceIntervalView) {
        _recurrenceIntervalView = [[FrtcRecurrenceIntervalView alloc] initWithFrame:NSMakeRect(0, 0, 36, 24)];
        _recurrenceIntervalView.titleTextField.font = [NSFont systemFontOfSize:13 weight:NSFontWeightMedium];
        _recurrenceIntervalView.internalViewDelegate = self;
        NSString *str;
        if([self.scheduleModel.recurrence_type isEqualToString:@"DAILY"]) {
            if([self.scheduleModel.recurrenceInterval integerValue] == 1) {
                str = NSLocalizedString(@"FM_MEETING_RE_EVERY_DAY", @"Every Day");
            } else {
                str = [NSString stringWithFormat:NSLocalizedString(@"FM_MEETING_RE_EVERY_SOME_DAY", @"Every %@ Day"), [self.scheduleModel.recurrenceInterval stringValue]];
            }
        } else if([self.scheduleModel.recurrence_type isEqualToString:@"WEEKLY"]) {
            if([self.scheduleModel.recurrenceInterval integerValue] == 1) {
                str = NSLocalizedString(@"FM_MEETING_RE_EVERY_WEEK", @"Every Week");
            } else {
                str = [NSString stringWithFormat:NSLocalizedString(@"FM_MEETING_RE_EVERY_SOME_WEEK", @"Every %@ Week"), [self.scheduleModel.recurrenceInterval stringValue]];
            }
            
        } else if([self.scheduleModel.recurrence_type isEqualToString:@"MONTHLY"]) {
            if([self.scheduleModel.recurrenceInterval integerValue] == 1) {
                str = NSLocalizedString(@"FM_MEETING_RE_EVERY_MONTH", @"Every MONTH");
            } else {
                str = [NSString stringWithFormat:NSLocalizedString(@"FM_MEETING_RE_EVERY_SOME_MONTH", @"EVERY %@ Month"), [self.scheduleModel.recurrenceInterval stringValue]];
            }
        }
        
        str = [NSString stringWithFormat:NSLocalizedString(@"FM_MEETING_RE_REMAINS_MEETINGS",@"%ld remaining meetings"), str, self.remainMeetings];
        _recurrenceIntervalView.titleTextField.stringValue = str;
        [self.view addSubview:_recurrenceIntervalView];
    }
    
    return _recurrenceIntervalView;
}

- (FrtcButton *)callButton {
    if (!_callButton){
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_MEETING_JOIN", @"Join") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_MEETING_JOIN", @"Join") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        _callButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 332, 36) withNormalMode:normalMode withHoverMode:hoverMode];
        _callButton.target = self;
        _callButton.action = @selector(onJoinVideoMeetingPressed:);
        [self.view addSubview:_callButton];
    }
    
    return _callButton;
}

- (FrtcButton*)copyButton {
    if (!_copyButton){
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#CCCCCC" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_COPY_INVITE", @"Copy Invitation") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#CCCCCC" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_COPY_INVITE", @"Copy Invitation") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        _copyButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 332, 36) withNormalMode:normalMode withHoverMode:hoverMode];
        _copyButton.target = self;
        _copyButton.action = @selector(onCopyMeeting:);
        [self.view addSubview:_copyButton];
    }
    return _copyButton;
}

- (FrtcButton*)cancelButton {
    if (!_cancelButton){
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#E32726" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#CCCCCC" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_CANCEL_MEETING", @"Cancel") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#E32726" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#CCCCCC" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_CANCEL_MEETING", @"Cancel") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        _cancelButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 332, 36) withNormalMode:normalMode withHoverMode:hoverMode];
        _cancelButton.target = self;
        _cancelButton.action = @selector(onDeleteMeeting:);
        [self.view addSubview:_cancelButton];
    }
    return _cancelButton;
}

- (FrtcButton*)deleteButton {
    if (!_deleteButton){
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#E32726" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#CCCCCC" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_DELETE_MEETING", @"Delete Meeting") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#E32726" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#CCCCCC" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_DELETE_MEETING", @"Delete Meeting") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        _deleteButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 332, 36) withNormalMode:normalMode withHoverMode:hoverMode];
        //_callButton.target = self;
        //_callButton.action = @selector(onLeaveMeeting:);
        [self.view addSubview:_deleteButton];
    }
    return _deleteButton;
}

- (FrtcButton*)removeButton {
    if (!_removeButton){
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#E32726" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#CCCCCC" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_REMOVE_MEETING_FROMLIST", @"Remove Meeting") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#E32726" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#CCCCCC" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_REMOVE_MEETING_FROMLIST", @"Remove Meeting") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        _removeButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 332, 36) withNormalMode:normalMode withHoverMode:hoverMode];
        _removeButton.target = self;
        _removeButton.action = @selector(onRemoveMeeting:);
        [self.view addSubview:_removeButton];
    }
    return _removeButton;
}

- (FrtcReminderImageButton *)saveToCalendarButton {
    if(!_saveToCalendarButton) {
        _saveToCalendarButton = [[FrtcReminderImageButton alloc] initWithFrame:NSMakeRect(0, 0, 84, 24)];
        _saveToCalendarButton.title.stringValue = NSLocalizedString(@"FM_MEETING_REMINDER_CALENDAR", @"Save to System Calendar");
        //_saveToCalendarButton.title.stringValue = @"Your Text okYour Text ok";
        //_saveToCalendarButton.title.stringValue = @"Your Text";
        _saveToCalendarButton.buttonType = ReminderImageButtonInfo;
        _saveToCalendarButton.reminderImageButtonDelegate = self;
        [_saveToCalendarButton.imageView setImage:[NSImage imageNamed:@"local_reminder_calander_add_btn"]];
        [self.view addSubview:_saveToCalendarButton];
    }
    
    return _saveToCalendarButton;
}

- (CallResultReminderView *)reminderView {
    if(!_reminderView) {
        _reminderView = [[CallResultReminderView alloc] initWithFrame:CGRectMake(0, 0, 172, 40)];
        _reminderView.tipLabel.stringValue = @"账号或密码不正确";
        _reminderView.hidden = YES;
        
        [self.view addSubview:_reminderView];
    }
    
    return _reminderView;
}

- (HoverImageView *)modifyImageView {
    if(!_modifyImageView) {
        _modifyImageView = [[HoverImageView alloc] initWithFrame:CGRectMake(0, 0, 17, 16)];
        _modifyImageView.delegate = self;
        _modifyImageView.image = [NSImage imageNamed:@"icon_recurrence_modify"];
        [self.view addSubview:_modifyImageView];
    }
    
    return _modifyImageView;
}

- (NSTextField *)modifyTextField {
    if(!_modifyTextField) {
        _modifyTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _modifyTextField.bordered = NO;
        _modifyTextField.drawsBackground = NO;
        _modifyTextField.backgroundColor = [NSColor clearColor];
        //_modifyTextField.layer.backgroundColor = [NSColor colorWithString:@"FFFFFF" andAlpha:1.0].CGColor;
        _modifyTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightMedium];
        _modifyTextField.textColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0];
        _modifyTextField.alignment = NSTextAlignmentLeft;
        _modifyTextField.editable = NO;
        _modifyTextField.stringValue = NSLocalizedString(@"FM_MEETING_RE_MODIFY_DETAIL", @"Modify");
        [self.view addSubview:_modifyTextField];
    }
    
    return _modifyTextField;
}


#pragma mark --Internal Function--
- (NSTextField *)interalLabel {
    NSTextField *internalLabel = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    internalLabel = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    internalLabel.bordered = NO;
    internalLabel.drawsBackground = NO;
    internalLabel.backgroundColor = [NSColor clearColor];
    internalLabel.layer.backgroundColor = [NSColor colorWithString:@"FFFFFF" andAlpha:1.0].CGColor;
    internalLabel.font = [NSFont systemFontOfSize:14 weight:NSFontWeightRegular];
    internalLabel.textColor = [NSColor colorWithString:@"#666666" andAlpha:1.0];
    internalLabel.alignment = NSTextAlignmentLeft;
    internalLabel.editable = NO;
    
    return internalLabel;
}

- (NSTextField *)internalTextField {
    NSTextField *internalTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    //_titleTextField.accessibilityClearButton;
    internalTextField.backgroundColor = [NSColor clearColor];
    internalTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightRegular];
    //_titleTextField.font = [[NSFontManager sharedFontManager] fontWithFamily:@"PingFangSC-Regular" traits:NSBoldFontMask weight:NSFontWeightMedium size:18];
    internalTextField.alignment = NSTextAlignmentCenter;
    internalTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
    internalTextField.bordered = NO;
    internalTextField.editable = NO;
    
    return internalTextField;
}

- (NSView *)line {
    NSView *line1 = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
    line1.wantsLayer = YES;
    line1.layer.backgroundColor = [NSColor colorWithString:@"#EEEFF0" andAlpha:1.0].CGColor;
    
    return line1;
}


#pragma mark --Local Reminder Function--

- (void)reminderImageButtonClicked:(ReminderImageButtonType)type {
    NSLog(@"[%s]: _saveToCalendarButton delegate event handler...", __func__);
    [self addToCalendar];
}

- (void)addToCalendar {
    // Create an event store object
    EKEventStore *eventStore = [[EKEventStore alloc] init];

    // Request access to the user's calendar
   /* [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (granted) {
            // Create a new calendar event object
            EKEvent *event = [EKEvent eventWithEventStore:eventStore];

            // Set the event title and message
            ScheduleModel *model = self.scheduleModel;
            event.title = [NSString stringWithFormat:@"%@", model.meeting_name];;

            event.location = model.meeting_url;
            event.notes = [self generateScheduleMeetingInfoString];
            
            // Set the event start and end time
            NSDate *startDate = [[FrtcBaseImplement baseImpleSingleton] DateConvertFromDateAndTimeString:model.schedule_start_time];
            NSDate *endDate = [[FrtcBaseImplement baseImpleSingleton] DateConvertFromDateAndTimeString:model.schedule_end_time];
            event.startDate = startDate;
            event.endDate = endDate;
            
            //set alert message "Alert 5 minutes before start"
            [event addAlarm:[EKAlarm alarmWithRelativeOffset:-5.0f * 60.0f]];
            
            
            // Save the event to the user's calendar
            [event setCalendar:[eventStore defaultCalendarForNewEvents]];
            NSError *saveError = nil;
            [eventStore saveEvent:event span:EKSpanThisEvent error:&saveError];

            if (nil == saveError) {
                NSLog(@"[%s][iCal]: Success saving event: %@", __func__, saveError);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showReminderView:NSLocalizedString(@"FM_MEETING_REMINDER_CALENDAR_ADDOK", @"Saved successfully")];
                });
                
                // Launch Calendar app to show the event
                //NSURL *eventURL = [NSURL URLWithString:event.eventIdentifier];
                //[[NSWorkspace sharedWorkspace] openURL:eventURL];
                
                // Launch Calendar app
                // Launch Calendar app and display the event
//                NSString *eventIdentifier = event.eventIdentifier;
//                NSString *scriptSource = [NSString stringWithFormat:@"tell application \"Calendar\"\nactivate\ndo shell script \"open x-apple-calendar://?eventId=%@\"\nend tell", eventIdentifier];
//                NSAppleScript *script = [[NSAppleScript alloc] initWithSource:scriptSource];
//                NSDictionary *errorInfo = nil;
//                if (![script executeAndReturnError:&errorInfo]) {
//                    NSLog(@"Error executing AppleScript: %@", errorInfo);
//                }
                
            } else {
                NSLog(@"[%s][iCal]: Error saving event: %@", __func__, saveError);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showReminderView:NSLocalizedString(@"FM_MEETING_REMINDER_CALENDAR_ADD_FAILED", @"Save failed")];
                });
            }
        } else {
            NSLog(@"[%s][iCal]: Error: Access denied: %@", __func__, error);

            dispatch_async(dispatch_get_main_queue(), ^{
                // If permission is not granted, display an alert message
                NSAlert *alert = [[NSAlert alloc] init];
                alert.messageText = @"Calendar access required";
                alert.informativeText = @"Your app needs access to your calendar to save events. Please grant permission in System Preferences > Security & Privacy > Privacy.";
                [alert addButtonWithTitle:@"OK"];
                [alert addButtonWithTitle:@"Open Security & Privacy"];
                NSModalResponse response = [alert runModal];
                if (response == NSAlertSecondButtonReturn) {
                    NSURL *securityURL = [NSURL URLWithString:@"x-apple.systempreferences:com.apple.preference.security?Privacy_Calendars"];
                    [[NSWorkspace sharedWorkspace] openURL:securityURL];
                }
            });
            
        }
    }];*/
    
    if (@available(macOS 14.0, *)) {
#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 140000
        [eventStore requestFullAccessToRemindersWithCompletion:^(BOOL granted, NSError *error) {
            if (granted) {
                // Create a new calendar event object
                EKEvent *event = [EKEvent eventWithEventStore:eventStore];
                
                // Set the event title and message
                ScheduleModel *model = self.scheduleModel;
                event.title = [NSString stringWithFormat:@"%@", model.meeting_name];;
                
                event.location = model.meeting_url;
                event.notes = [self generateScheduleMeetingInfoString];
                
                // Set the event start and end time
                NSDate *startDate = [[FrtcBaseImplement baseImpleSingleton] DateConvertFromDateAndTimeString:model.schedule_start_time];
                NSDate *endDate = [[FrtcBaseImplement baseImpleSingleton] DateConvertFromDateAndTimeString:model.schedule_end_time];
                event.startDate = startDate;
                event.endDate = endDate;
                
                //set alert message "Alert 5 minutes before start"
                [event addAlarm:[EKAlarm alarmWithRelativeOffset:-5.0f * 60.0f]];
                
                
                // Save the event to the user's calendar
                [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                NSError *saveError = nil;
                [eventStore saveEvent:event span:EKSpanThisEvent error:&saveError];
                
                if (nil == saveError) {
                    NSLog(@"[%s][iCal]: Success saving event: %@", __func__, saveError);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showReminderView:NSLocalizedString(@"FM_MEETING_REMINDER_CALENDAR_ADDOK", @"Saved successfully")];
                    });
                    
                    // Launch Calendar app to show the event
                    //NSURL *eventURL = [NSURL URLWithString:event.eventIdentifier];
                    //[[NSWorkspace sharedWorkspace] openURL:eventURL];
                    
                    // Launch Calendar app
                    // Launch Calendar app and display the event
                    //                NSString *eventIdentifier = event.eventIdentifier;
                    //                NSString *scriptSource = [NSString stringWithFormat:@"tell application \"Calendar\"\nactivate\ndo shell script \"open x-apple-calendar://?eventId=%@\"\nend tell", eventIdentifier];
                    //                NSAppleScript *script = [[NSAppleScript alloc] initWithSource:scriptSource];
                    //                NSDictionary *errorInfo = nil;
                    //                if (![script executeAndReturnError:&errorInfo]) {
                    //                    NSLog(@"Error executing AppleScript: %@", errorInfo);
                    //                }
                    
                } else {
                    NSLog(@"[%s][iCal]: Error saving event: %@", __func__, saveError);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showReminderView:NSLocalizedString(@"FM_MEETING_REMINDER_CALENDAR_ADD_FAILED", @"Save failed")];
                    });
                }
            } else {
                NSLog(@"[%s][iCal]: Error: Access denied: %@", __func__, error);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // If permission is not granted, display an alert message
                    NSAlert *alert = [[NSAlert alloc] init];
                    alert.messageText = @"Calendar access required";
                    alert.informativeText = @"Your app needs access to your calendar to save events. Please grant permission in System Preferences > Security & Privacy > Privacy.";
                    [alert addButtonWithTitle:@"OK"];
                    [alert addButtonWithTitle:@"Open Security & Privacy"];
                    NSModalResponse response = [alert runModal];
                    if (response == NSAlertSecondButtonReturn) {
                        NSURL *securityURL = [NSURL URLWithString:@"x-apple.systempreferences:com.apple.preference.security?Privacy_Calendars"];
                        [[NSWorkspace sharedWorkspace] openURL:securityURL];
                    }
                });
                
            }
        }];
#endif
    } else {
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
             if (granted) {
                 // Create a new calendar event object
                 EKEvent *event = [EKEvent eventWithEventStore:eventStore];

                 // Set the event title and message
                 ScheduleModel *model = self.scheduleModel;
                 event.title = [NSString stringWithFormat:@"%@", model.meeting_name];;

                 event.location = model.meeting_url;
                 event.notes = [self generateScheduleMeetingInfoString];
                 
                 // Set the event start and end time
                 NSDate *startDate = [[FrtcBaseImplement baseImpleSingleton] DateConvertFromDateAndTimeString:model.schedule_start_time];
                 NSDate *endDate = [[FrtcBaseImplement baseImpleSingleton] DateConvertFromDateAndTimeString:model.schedule_end_time];
                 event.startDate = startDate;
                 event.endDate = endDate;
                 
                 //set alert message "Alert 5 minutes before start"
                 [event addAlarm:[EKAlarm alarmWithRelativeOffset:-5.0f * 60.0f]];
                 
                 
                 // Save the event to the user's calendar
                 [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                 NSError *saveError = nil;
                 [eventStore saveEvent:event span:EKSpanThisEvent error:&saveError];

                 if (nil == saveError) {
                     NSLog(@"[%s][iCal]: Success saving event: %@", __func__, saveError);
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self showReminderView:NSLocalizedString(@"FM_MEETING_REMINDER_CALENDAR_ADDOK", @"Saved successfully")];
                     });
                     
                     // Launch Calendar app to show the event
                     //NSURL *eventURL = [NSURL URLWithString:event.eventIdentifier];
                     //[[NSWorkspace sharedWorkspace] openURL:eventURL];
                     
                     // Launch Calendar app
                     // Launch Calendar app and display the event
     //                NSString *eventIdentifier = event.eventIdentifier;
     //                NSString *scriptSource = [NSString stringWithFormat:@"tell application \"Calendar\"\nactivate\ndo shell script \"open x-apple-calendar://?eventId=%@\"\nend tell", eventIdentifier];
     //                NSAppleScript *script = [[NSAppleScript alloc] initWithSource:scriptSource];
     //                NSDictionary *errorInfo = nil;
     //                if (![script executeAndReturnError:&errorInfo]) {
     //                    NSLog(@"Error executing AppleScript: %@", errorInfo);
     //                }
                     
                 } else {
                     NSLog(@"[%s][iCal]: Error saving event: %@", __func__, saveError);
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self showReminderView:NSLocalizedString(@"FM_MEETING_REMINDER_CALENDAR_ADD_FAILED", @"Save failed")];
                     });
                 }
             } else {
                 NSLog(@"[%s][iCal]: Error: Access denied: %@", __func__, error);

                 dispatch_async(dispatch_get_main_queue(), ^{
                     // If permission is not granted, display an alert message
                     NSAlert *alert = [[NSAlert alloc] init];
                     alert.messageText = @"Calendar access required";
                     alert.informativeText = @"Your app needs access to your calendar to save events. Please grant permission in System Preferences > Security & Privacy > Privacy.";
                     [alert addButtonWithTitle:@"OK"];
                     [alert addButtonWithTitle:@"Open Security & Privacy"];
                     NSModalResponse response = [alert runModal];
                     if (response == NSAlertSecondButtonReturn) {
                         NSURL *securityURL = [NSURL URLWithString:@"x-apple.systempreferences:com.apple.preference.security?Privacy_Calendars"];
                         [[NSWorkspace sharedWorkspace] openURL:securityURL];
                     }
                 });
                 
             }
         }];
    }
}

- (NSString *)generateScheduleMeetingInfoString {
    ScheduleModel *model = self.scheduleModel;
    
    NSString *title = [NSString stringWithFormat:@"%@ %@", self.name, NSLocalizedString(@"FM_INVITE_PEOPLE", @"Invite you to the meeting")];
    NSString *meetingObject = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"FM_MEETING_OBJECT", @"Meeting Topic"), model.meeting_name];
    NSString *meetingStartTime = [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"FM_MEETING_START_TIME", @"Start Time"),[[FrtcBaseImplement baseImpleSingleton] dateStringWithTimeString:model.schedule_start_time]];
    NSString *meetingEndTime = [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"FM_MEETING_END_TIME", @"End Time"),[[FrtcBaseImplement baseImpleSingleton] dateStringWithTimeString:model.schedule_end_time]];
    NSString *meetingNumber = [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"FM_MEETING_NUMBER", @"Meeting ID"),model.meeting_number];
    NSString *meetingPassword = [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"FM_PASSCODE", @"Password"),model.meeting_password ? model.meeting_password :@""];
    NSString *endTitle = NSLocalizedString(@"FM_MEETING_INFO_MESSAGE", @"Open the SQ Meeting CE  client and enter the Meeting ID to join the meeting");
    NSString *endTitle1 = NSLocalizedString(@"FM_MEETING_INFO_MESSAGE_AND_PASSWORD", @"Open the SQ Meeting CE  client and enter the Meeting ID and Password to join the meeting");
        
    NSString *pastString;
    
    if ([model.meeting_url isEqualToString:@""] || model.meeting_url == nil) {
        if ([[[FrtcBaseImplement baseImpleSingleton] dateStringWithTimeString:model.schedule_end_time] isEqualToString:@"1970-01-01 08:00"] && [[[FrtcBaseImplement baseImpleSingleton] dateStringWithTimeString:model.schedule_start_time] isEqualToString:@"1970-01-01 08:00"]) {
            if (![model.meeting_password isEqualToString:@""] && model.meeting_password != nil) {
                pastString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n\n%@",
                              title,
                              meetingObject,
                              meetingNumber,
                              meetingPassword,
                              endTitle1];
            } else {
                pastString = [NSString stringWithFormat:@"%@\n%@\n%@\n\n%@",
                              title,
                              meetingObject,
                              meetingNumber,
                              endTitle];
            }
        } else {
            if (![model.meeting_password isEqualToString:@""] && model.meeting_password != nil) {
                pastString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n\n%@",
                              title,
                              meetingObject,
                              meetingStartTime,
                              meetingEndTime,
                              meetingNumber,
                              meetingPassword,
                              endTitle1];
            } else {
                pastString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n\n%@",
                              title,
                              meetingObject,
                              meetingStartTime,
                              meetingEndTime,
                              meetingNumber,
                              endTitle];
            }
        }
    } else if ([[[FrtcBaseImplement baseImpleSingleton] dateStringWithTimeString:model.schedule_end_time] isEqualToString:@"1970-01-01 08:00"] && [[[FrtcBaseImplement baseImpleSingleton] dateStringWithTimeString:model.schedule_start_time] isEqualToString:@"1970-01-01 08:00"]) {
        if ([model.meeting_url isEqualToString:@""] || model.meeting_url == nil) {
            if (![model.meeting_password isEqualToString:@""] && model.meeting_password != nil) {
                pastString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n\n%@",
                              title,
                              meetingObject,
                              meetingNumber,
                              meetingPassword,
                              endTitle1];
            } else {
                pastString = [NSString stringWithFormat:@"%@\n%@\n%@\n\n%@",
                              title,
                              meetingObject,
                              meetingNumber,
                              endTitle];
            }
        } else {
            if (![model.meeting_password isEqualToString:@""] && model.meeting_password != nil) {
                pastString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n\n%@\n%@\n%@",
                              title,
                              meetingObject,
                              meetingNumber,
                              meetingPassword,
                              endTitle1,
                              NSLocalizedString(@"FM_URL_JOIN_CALL", @"Or click the following URL to join meeting:"),
                              model.meeting_url];
            } else {
                pastString = [NSString stringWithFormat:@"%@\n%@\n%@\n\n%@\n%@\n%@",
                              title,
                              meetingObject,
                              meetingNumber,
                              endTitle,
                              NSLocalizedString(@"FM_URL_JOIN_CALL", @"Or click the following URL to join meeting:"),
                              model.meeting_url];
            }
        }
    } else {
        if (![model.meeting_password isEqualToString:@""] && model.meeting_password != nil) {
            pastString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n\n%@\n%@\n%@",
                          title,
                          meetingObject,
                          meetingStartTime,
                          meetingEndTime,
                          meetingNumber,
                          meetingPassword,
                          endTitle1,
                          NSLocalizedString(@"FM_URL_JOIN_CALL", @"Or click the following URL to join meeting:"),
                          model.meeting_url];
        } else {
            pastString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n\n%@\n%@\n%@",
                          title,
                          meetingObject,
                          meetingStartTime,
                          meetingEndTime,
                          meetingNumber,
                          endTitle,
                          NSLocalizedString(@"FM_URL_JOIN_CALL", @"Or click the following URL to join meeting:"),
                          model.meeting_url];
        }
    }
    
    return pastString;
}

@end
