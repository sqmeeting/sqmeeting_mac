#import "FrtcLocalReminderWindowController.h"
#import "FrtcLocalReminderTableViewController.h"
#import "FrtcLocalReminderTitleBarView.h"
#import "FrtcInConferenceAlertWindow.h"
#import "FrtcCallInterface.h"
#import "FrtcMultiTypesButton.h"

#import <AppKit/AppKit.h>
#import <AppKit/NSWindow.h>

#import "Masonry.h"
#import "NSColor+Utils.h"
#import "NSColor+Enhancement.h"


@interface FrtcLocalReminderWindowController () <FrtcLocalReminderTableViewControllerDelegate>

@property (nonatomic, assign, readonly) BOOL isWindowLoaded;
@property (nonatomic, assign, readonly) BOOL isWindowHide;

@property (nonatomic, strong) NSImageView *horizontalLine;
@property (nonatomic, strong) FrtcMultiTypesButton    *ignoreButton;
@property (nonatomic, strong) NSView      *lineView;
@property (nonatomic, strong) NSView      *bottomView;

@property (nonatomic, strong) FrtcLocalReminderTitleBarView        *titleBarView;
@property (nonatomic, strong) FrtcLocalReminderTableViewController *localReminderTableViewController;
@property (nonatomic, strong) FrtcInConferenceAlertWindow          *inConferenceAlertWindow;

@property (nonatomic, weak) id<FrtcLocalReminderWindowControllerDelegate> reminderTableViewDelegate;

// Define the ending meeting array and ending time array as instance variables
@property (nonatomic, strong) NSMutableArray *endingMeetingArray;
@property (nonatomic, strong) NSMutableArray *endingTimeArray;

// Define the timer as an instance variable
@property (nonatomic, strong) NSTimer *endingTimer;

@end


@implementation FrtcLocalReminderWindowController

- (void)dealloc {
    NSLog(@"[%s]", __func__);
    if (nil != _reminderTableViewDelegate) {
        _reminderTableViewDelegate = nil;
    }
    if (nil != _titleBarView) {
        _titleBarView = nil;
    }
    if (nil != _inConferenceAlertWindow) {
        _inConferenceAlertWindow = nil;
    }
    if (nil != _localReminderTableViewController) {
        _localReminderTableViewController = nil;
    }
    if (nil != _scheduledModelArray) {
        [_scheduledModelArray removeAllObjects];
        _scheduledModelArray = nil;
    }
    if (nil != _willShowScheduledModelArray) {
        [_willShowScheduledModelArray removeAllObjects];
        _willShowScheduledModelArray = nil;
    }
    //for ending time.
    if (_endingTimer) {
        [_endingTimer invalidate];
        _endingTimer = nil;
    }
    if (nil != _endingMeetingArray) {
        [_endingMeetingArray removeAllObjects];
        _endingMeetingArray = nil;
    }
    if (nil != _endingTimeArray) {
        [_endingTimeArray removeAllObjects];
        _endingTimeArray = nil;
    }
}

- (instancetype)init {
    self = [super initWithWindow:nil];
    if (self) {
        _isWindowLoaded = NO;
        _isWindowHide = YES;
        _scheduledModelArray = [[NSMutableArray alloc] initWithCapacity:4];
        _willShowScheduledModelArray = [[NSMutableArray alloc] initWithCapacity:4];
        
        _endingMeetingArray = [[NSMutableArray alloc] initWithCapacity:4];
        _endingTimeArray = [[NSMutableArray alloc] initWithCapacity:4];
        [self windowDidLoad];
    }
    //NSLog(@"[%s]: window: %@", __func__, self.window);
    return self;
}

- (void)initUI {
    // Step 1: set for Window.
    NSRect windowFrame = [self getFrameOfBottomLeftOfMainScreen];
    
    self.window = [[NSWindow alloc] initWithContentRect:windowFrame
                                              styleMask:NSWindowStyleMaskTitled
                                                backing:NSBackingStoreBuffered
                                                  defer:NO];
    
    [self.window setLevel:CGWindowLevelForKey(kCGPopUpMenuWindowLevelKey)];
    [self.window makeKeyAndOrderFront:nil];
    
    [self.window setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
    [self.window setHidesOnDeactivate:NO];
    
    self.window.delegate = self;
    self.window.releasedWhenClosed = NO;

    // Step 2: Create a custom appearance with a light appearance.
    self.window.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
    self.window.titlebarAppearsTransparent  = YES;
    self.window.movableByWindowBackground = YES;
    self.window.titleVisibility = NSWindowTitleHidden;
    [self.window setStyleMask:[self.window styleMask] | NSWindowStyleMaskFullSizeContentView];
    
    CGFloat cornerRadius = 4.0;
    [self.window.contentView setWantsLayer:YES];
    [self.window.contentView.layer setCornerRadius:cornerRadius];
    [self.window.contentView.layer setMasksToBounds:YES];
    
    // Step 3: create titleBarView.
    self.titleBarView = [[FrtcLocalReminderTitleBarView alloc] initWithFrame:NSMakeRect(0, 0, 380, 32)];
    [[self.window contentView] addSubview:self.titleBarView];
    
    self.titleBarView.delegate = self;
    //[self.titleBarView setTitleString:[NSString stringWithFormat:@" "]];
    [self.titleBarView setFont:[NSFont systemFontOfSize:14]];
    [self.titleBarView getAttributeds];
    
    // Step 4: Position titleBarView at top of contentView using layout constraints.
    [self.titleBarView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[self.titleBarView.topAnchor constraintEqualToAnchor:[self.window.contentView topAnchor]] setActive:YES];
    [[self.titleBarView.leadingAnchor constraintEqualToAnchor:[self.window.contentView leadingAnchor]] setActive:YES];
    [[self.titleBarView.trailingAnchor constraintEqualToAnchor:[self.window.contentView trailingAnchor]] setActive:YES];
    [[self.titleBarView.heightAnchor constraintEqualToConstant:32] setActive:YES];
    
    // Step 5: Set background color of content view to transparent color.
    [[self.window contentView] setBackgroundColor:[NSColor whiteColor]];
    
    // Step 6: Hide default title bar text.
    [self.window setTitleVisibility:NSWindowTitleHidden];
    
    // Step 7: Create Reminder TableView.
    self.localReminderTableViewController = [[FrtcLocalReminderTableViewController alloc] initWithNibName:nil bundle:nil];
    self.localReminderTableViewController.localReminderJoinConferenceDelegate = self;
    [self.window.contentView addSubview:self.localReminderTableViewController.view];
    self.localReminderTableViewController.view.frame = self.window.contentView.bounds;
    
//    NSLog(@"[%s][showFrame]: self.window.contentView.bounds: [%d, %d, %d, %d]", __func__,
//          (int)self.window.contentView.bounds.origin.x,
//          (int)self.window.contentView.bounds.origin.y,
//          (int)self.window.contentView.bounds.size.width,
//          (int)self.window.contentView.bounds.size.height);
    
    __weak typeof(self.localReminderTableViewController) __weak_reminder_tablbViewVC = self.localReminderTableViewController;
    self.reminderTableViewDelegate = __weak_reminder_tablbViewVC;
    
    //default hide.
    [self closeReminderWindow];
}

- (NSRect)getFrameOfBottomLeftOfMainScreen {
    CGFloat windowHeight = WINDOW_TITLE_BAR_HIGHT + WINDOW_BUTTON_BAR_HIGHT;
    NSRect const kNewWindowFrame = {0, 0, 380, windowHeight};
    NSScreen *mainScreen = [NSScreen mainScreen];
    
    // Calculate the position of the new window aligned with the bottom edge of the main screen
    CGFloat const kWindowOffset = 20;
    NSRect screenFrame = [mainScreen frame];
    
    //creat a new NSWindow and show it on the mainScreen
    NSRect newWindowFrame = NSOffsetRect(kNewWindowFrame, NSMaxX(screenFrame) - kNewWindowFrame.size.width - kWindowOffset, NSMinY(screenFrame) + kWindowOffset);
    
//    NSLog(@"[%s][showFrame]: NSOffsetRect newWindowFrame: [%d, %d, %d, %d]", __func__,
//          (int)newWindowFrame.origin.x,
//          (int)newWindowFrame.origin.y,
//          (int)newWindowFrame.size.width,
//          (int)newWindowFrame.size.height);
    
    return newWindowFrame;
}

- (void)showWindow:(id)sender {
    [super showWindow:sender];
    
    //NSLog(@"[%s]: window: %@", __func__, self.window);
    // If the window has not yet been loaded, call windowDidLoad manually
    if (!_isWindowLoaded) {
        [self windowDidLoad];
        //[[self window] orderFront:nil];
    }
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    //NSLog(@"[%s]", __func__);
    _isWindowLoaded = YES;
    [_scheduledModelArray removeAllObjects];
    
    [self initUI];
    [self setupWindowUILayout];
}

- (BOOL)windowShouldClose:(NSWindow *)sender {
    //NSLog(@"[%s]", __func__);
    _isWindowLoaded = NO;
    return YES;
}


#pragma mark  -- UI views config --

- (void)setupWindowUILayout {
    //NSLog(@"[%s]", __func__);
    //int nWindowHeight = TABLE_VIEW_BAR_HIGHT_MAX;
    //NSLog(@"[%s]: nReminderCount = self.count: %d, nWindowHeight: %d", __func__, (int)self.count, nWindowHeight);

    [self.titleBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.window.contentView.mas_top).offset(0);
        make.left.mas_equalTo(self.window.contentView.mas_left).offset(0);
        make.right.mas_equalTo(self.window.contentView.mas_right).offset(0);
        make.width.mas_equalTo(380);
        make.height.mas_equalTo(WINDOW_TITLE_BAR_HIGHT);
    }];

    [self.self.localReminderTableViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.window.contentView.mas_top).offset(0);
        make.bottom.mas_equalTo(self.window.contentView.mas_bottom).offset(-32);
        make.left.mas_equalTo(self.window.contentView.mas_left).offset(0);
        make.right.mas_equalTo(self.window.contentView.mas_right).offset(0);
        make.width.mas_equalTo(380);
        //make.height.mas_equalTo(18);
    }];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.window.contentView.mas_left).offset(0);
        make.bottom.mas_equalTo(self.window.contentView.mas_bottom).offset(0);
        make.width.mas_equalTo(380);
        make.height.mas_equalTo(32);
    }];
}

- (void)updateLayout {
    //NSLog(@"[%s]", __func__);
    [self.titleBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.window.contentView.mas_top).offset(0);
        make.left.mas_equalTo(self.window.contentView.mas_left).offset(0);
        make.right.mas_equalTo(self.window.contentView.mas_right).offset(0);
        make.width.mas_equalTo(380);
        make.height.mas_equalTo(WINDOW_TITLE_BAR_HIGHT);
    }];

    [self.self.localReminderTableViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.window.contentView.mas_bottom).offset(0);
        make.bottom.mas_equalTo(self.window.contentView.mas_bottom).offset(-32);
        make.left.mas_equalTo(self.window.contentView.mas_left).offset(0);
        make.right.mas_equalTo(self.window.contentView.mas_right).offset(0);
        make.width.mas_equalTo(380);
        //make.height.mas_equalTo(18);
    }];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.window.contentView.mas_left).offset(0);
        make.bottom.mas_equalTo(self.window.contentView.mas_bottom).offset(0);
        make.width.mas_equalTo(380);
        make.height.mas_equalTo(32);
    }];
}

#pragma mark  -- UI views --

- (NSView *)lineView {
    if (!_lineView) {
        _lineView = [[NSView alloc] initWithFrame:CGRectMake(0, 43, 381, 1)];
        _lineView.wantsLayer = YES;
        _lineView.layer.backgroundColor = [NSColor colorWithString:@"DEDEDE" andAlpha:1.0].CGColor;
        [self.window.contentView addSubview:_lineView];
    }
    return _lineView;
}

- (NSView *)bottomView {
    if (!_bottomView) {
        NSRect frame = self.window.contentView.frame;
        frame.origin.y = frame.size.height;
        frame.size = CGSizeMake(380, 32);
        _bottomView = [[NSView alloc] initWithFrame:frame];
        _bottomView.wantsLayer = YES;
        _bottomView.layer.backgroundColor = [NSColor colorWithString:@"FFFFFF" andAlpha:1.0].CGColor;
        //_bottomView.layer.backgroundColor = [NSColor cyanColor].CGColor;
        [self.window.contentView addSubview:_bottomView];
        
        [self horizontalLine];
        [self ignoreButton];
    }
    return _bottomView;
}

- (NSImageView *)horizontalLine {
    if (!_horizontalLine) {
        _horizontalLine = [[NSImageView alloc] initWithFrame:CGRectMake(0, 31, 380, 1)];
        [_horizontalLine setImage:[NSImage imageNamed:@"gray_line_content_select"]];
        _horizontalLine.imageAlignment =  NSImageAlignTopLeft;
        _horizontalLine.imageScaling =  NSImageScaleAxesIndependently;
        [_bottomView addSubview:_horizontalLine];
    }
    return _horizontalLine;
}

- (FrtcMultiTypesButton *)ignoreButton {
    if (!_ignoreButton) {
        NSRect frame = self.window.contentView.frame;
        frame.origin.x = frame.size.width - 64 - 13;
        frame.origin.y = 6;
        frame.size = CGSizeMake(64, 18);
        _ignoreButton = [[FrtcMultiTypesButton alloc] initTenWithFrame:frame
                                                 withTitle:NSLocalizedString(@"FM_MEETING_REMINDER_IGNORE", @"Ignore")
                                              withFontSize:12
                                            withTitleColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0]
                                          withCornerRadius:4
                                       withBackgroundColor:[NSColor colorWithString:@"#F0F0F5" andAlpha:1.0]
                                                withBorder:NO
                                           withBorderColor:[NSColor colorWithString:@"#F0F0F5" andAlpha:1.0]
                                           withBorderWidth:0];
        
        _ignoreButton.target = self;
        _ignoreButton.action = @selector(cancelBtnClicked:);
        [_bottomView addSubview:_ignoreButton];
    }
    return _ignoreButton;
}

- (void)cancelBtnClicked:(id)sender {
    //NSLog(@"[%s]", __func__);
    [self closeReminderWindow];
    
    //Ignore all reminders, which have been shown; Next time popup reminder window, those will not show agin.
    [self ignoreAllReminderMeeting];
}

- (void)closeButtonOnTitleBarClicked:(id)sender {
    //NSLog(@"[%s]", __func__);
    [self closeReminderWindow];
    
    //Ignore all reminders, which have been shown; Next time popup reminder window, those will not show agin.
    [self ignoreAllReminderMeeting];
}

- (void)closeReminderWindow {
    //NSLog(@"[%s]", __func__);
    [[self window] close];
    _isWindowHide = YES;
}

- (void)showReminderWindow {
    //NSLog(@"[%s]", __func__);
    _isWindowHide = NO;
    NSRect windowFrame = [self getFrameOfBottomLeftOfMainScreen];
    [self.window setFrame:windowFrame display:YES];
    [self.window makeKeyAndOrderFront:nil];
}

//Ignore all reminders, which have been shown; Next time popup reminder window, those will not show agin.
- (void)ignoreAllReminderMeeting {
    //will not show those schedule meeting reminder again.
    for (ReminderScheduleModel *schedule in self.scheduledModelArray) {
        if (FRTCSDK_REMINDER_STATE_IS_SHOWING == schedule.meeting_reminder_state) {
            //NSLog(@"[%s][%d]: %@: change reminder state: frmo IS_SHOWING  to IS_IGNORE", __func__, __LINE__, schedule.owner_name);
            //for local remider state: will not be show again.
            schedule.meeting_reminder_state = FRTCSDK_REMINDER_STATE_IS_IGNORE;
        }
    }
}


#pragma mark -- FrtcLocalReminderManagementDelegate --

- (void)addReminderMeeting:(NSMutableArray *)meetings {
    //NSLog(@"[%s][%d]: ", __func__, __LINE__);

    for (ScheduleModel *meeting in meetings) {
        //NSLog(@"[%s][%d]: add to reminder window to show, meeting_meeting_number: %@", __func__, __LINE__, meeting.meeting_number);
        
        BOOL isInReminderList = NO;
        for (ReminderScheduleModel *schedule in self.scheduledModelArray) {
            
            if ([schedule.meeting_number isEqual:meeting.meeting_number]) {
                //NSLog(@"[%s][%d]: update, meeting_meeting_number: %@", __func__, __LINE__, meeting_meeting_number);
                isInReminderList = YES;
                
                schedule.meeting_name = meeting.meeting_name;
                schedule.meeting_number = meeting.meeting_number;
                schedule.meeting_password = meeting.meeting_password;
                schedule.meeting_type = meeting.meeting_type;
                schedule.owner_id = meeting.owner_id;
                schedule.owner_name = meeting.owner_name;
                schedule.recurrence_gid = meeting.recurrence_gid;
                schedule.recurrence_type = meeting.recurrence_type;
                schedule.reservation_id = meeting.reservation_id;
                schedule.schedule_end_time = meeting.schedule_end_time;
                schedule.schedule_start_time = meeting.schedule_start_time;
                schedule.meeting_url = meeting.meeting_url;
            }
        }
        
        if (NO == isInReminderList) {
            //NSLog(@"[%s][%d]: add new, meeting_meeting_number: %@", __func__, __LINE__, meeting_meeting_number);
            
            ReminderScheduleModel *newSchedule = [[ReminderScheduleModel alloc] init];
            newSchedule.meeting_name = meeting.meeting_name;
            newSchedule.meeting_number = meeting.meeting_number;
            newSchedule.meeting_password = meeting.meeting_password;
            newSchedule.meeting_type = meeting.meeting_type;
            newSchedule.owner_id = meeting.owner_id;
            newSchedule.owner_name = meeting.owner_name;
            newSchedule.recurrence_gid = meeting.recurrence_gid;
            newSchedule.recurrence_type = meeting.recurrence_type;
            newSchedule.reservation_id = meeting.reservation_id;
            newSchedule.schedule_end_time = meeting.schedule_end_time;
            newSchedule.schedule_start_time = meeting.schedule_start_time;
            newSchedule.meeting_url = meeting.meeting_url;

            //for local remider state: will be show.
            newSchedule.meeting_reminder_state = FRTCSDK_REMINDER_STATE_IS_SHOWING;
            //FRTCSDK_REMINDER_STATE_IDLE -> FRTCSDK_REMINDER_STATE_IS_SHOWING
            
            [self.scheduledModelArray addObject:newSchedule];
        }
    }
    
    if (nil != self.scheduledModelArray && 0 < self.scheduledModelArray.count) {
        //only show data with meeting_reminder_state: FRTCSDK_REMINDER_STATE_IS_SHOWING
        [self getScheduleModelToShowing];
    }
    
    [self refreshUI];
}

//clear and prepare data for refresh UI list.

- (void)getScheduleModelToShowing {
    if (nil != _willShowScheduledModelArray || 0 < _willShowScheduledModelArray.count) {
        [_willShowScheduledModelArray removeAllObjects];
    }
    
    for (ReminderScheduleModel *schedule in self.scheduledModelArray) {
        if (FRTCSDK_REMINDER_STATE_IS_SHOWING == schedule.meeting_reminder_state) {
            //NSLog(@"[%s][%d]: %@: change reminder state: frmo IS_SHOWING  to IS_IGNORE", __func__, __LINE__, schedule.owner_name);
            
            ReminderScheduleModel *newSchedule = [[ReminderScheduleModel alloc] init];
            newSchedule.meeting_name = schedule.meeting_name;
            newSchedule.meeting_number = schedule.meeting_number;
            newSchedule.meeting_password = schedule.meeting_password;
            newSchedule.meeting_type = schedule.meeting_type;
            newSchedule.owner_id = schedule.owner_id;
            newSchedule.owner_name = schedule.owner_name;
            newSchedule.recurrence_gid = schedule.recurrence_gid;
            newSchedule.recurrence_type = schedule.recurrence_type;
            newSchedule.reservation_id = schedule.reservation_id;
            newSchedule.schedule_end_time = schedule.schedule_end_time;
            newSchedule.schedule_start_time = schedule.schedule_start_time;
            newSchedule.meeting_url = schedule.meeting_url;
            
            //for local remider state: will be show.
            newSchedule.meeting_reminder_state = FRTCSDK_REMINDER_STATE_IS_SHOWING;
            //FRTCSDK_REMINDER_STATE_IDLE -> FRTCSDK_REMINDER_STATE_IS_SHOWING
            
            [self.willShowScheduledModelArray addObject:newSchedule];
        }
    }
    
    //for ending time.
    if (nil != _endingMeetingArray || 0 < _endingMeetingArray.count) {
        //clear for data to refresh UI list.
        [_endingMeetingArray removeAllObjects];
    }
    _endingMeetingArray = [NSMutableArray arrayWithArray:_willShowScheduledModelArray];
    
    [self updateEndingTimeArray];
}

- (void)refreshUI {
    //NSLog(@"[%s][%d]: refresh UI with: _willShowScheduledModelArray.count: %d", __func__, __LINE__, (int)_willShowScheduledModelArray.count);
    int reminderCount = (int)_willShowScheduledModelArray.count;
    
//    int reminderCount = 0;
//    for (ReminderScheduleModel *meeting in self.willShowScheduledModelArray) {
//        NSDate *endTime = [[FrtcBaseImplement baseImpleSingleton] getDateFromSting: meeting.schedule_end_time];
//        if (FRTCSDK_REMINDER_STATE_IS_SHOWING == meeting.meeting_reminder_state) {
//            ++reminderCount;
//        }
//    }
    
    if (reminderCount <= 0 && _isWindowHide == NO) {
        [self closeReminderWindow];
        return;
    } else if (reminderCount > 0 && _isWindowHide == YES) {
        [self showReminderWindow];
    }
    
    // Set up the date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    if ([self.reminderTableViewDelegate respondsToSelector:@selector(setScheduledModelArray:)]) {
        //NSLog(@"[%s]: setScheduledModelArray:", __func__);
        [self.reminderTableViewDelegate setScheduledModelArray: _willShowScheduledModelArray];
    } else {
        //NSLog(@"[%s]: delegate not respond with setScheduledModelArray:", __func__);
    }
    
    [self.titleBarView setTitleString:[NSString stringWithFormat:@"%d %@", (int)_willShowScheduledModelArray.count, NSLocalizedString(@"FM_MEETING_REMINDER_MEETINGALERTNUMBER", @"Meeting Reminder")]];
}

//- (void)removeReminderMeetingWithMeetingNumber:(NSString *)meetingNumber {
//    NSLog(@"[%s][%d]: remove, meeting with meeting.meeting_number: %@", __func__, __LINE__, meetingNumber);
//
//    if (nil == meetingNumber || [meetingNumber isEqual:@""]) {
//        return;
//    }
//
//    BOOL isInReminderList = NO;
//    for (ScheduleModel *schedule in self.scheduledModelArray) {
//        if ([schedule.meeting_number isEqual:meetingNumber]) {
//            NSLog(@"[%s][%d]: update, meeting.meeting_number: %@", __func__, __LINE__, schedule.meeting_number);
//            isInReminderList = YES;
//
//            [self.scheduledModelArray removeObject:schedule];
//        }
//    }
//
//    [self refreshUI];
//}

#pragma mark -- FrtcLocalReminderManagementJoinMeetingDelegate --

- (void)joinTheConferenceWithScheduleModel:(ScheduleModel *)scheduleModel {
    BOOL isInConference = [[FrtcCallInterface singletonFrtcCall] isInConference];
    //NSLog(@"[%s]: current: isInConference: %@", __func__, isInConference?@"YES":@"NO");

    if (isInConference) {
        //NSLog(@"[%s]: current is in call: isInConference: %@", __func__, isInConference?@"YES":@"NO");
        [self showAlertWindow];
        return;
    } else {
        FrtcLocalReminderManagement *reminderManagement = [FrtcLocalReminderManagement sharedInstance];
        if ([reminderManagement.reminderWindowJoinMeetingDelegate respondsToSelector:@selector(joinTheConferenceWithScheduleModel:)]) {
            [reminderManagement.reminderWindowJoinMeetingDelegate joinTheConferenceWithScheduleModel:scheduleModel];
        } else {
            NSLog(@"[%s]: delegate not respond with joinTheConferenceWithScheduleModel:", __func__);
        }
        
        //[Note]: join conference, still show local reminder;
        // only close reminder window, when all schedule reminders are end, reminder window is ignored or closed by user.
        //[self closeReminderWindow];
        
        //update list.
        
        for (ReminderScheduleModel *schedule in self.scheduledModelArray) {
            if ([schedule.meeting_number isEqual:scheduleModel.meeting_number]) {
                //NSLog(@"[%s][%d]: %@: change reminder state: frmo IS_SHOWING  to IS_JOINED", __func__, __LINE__, schedule.owner_name);
                //for local remider state: will not be show again.
                schedule.meeting_reminder_state = FRTCSDK_REMINDER_STATE_IS_JOINED;
            }
        }
        
        if (nil != self.scheduledModelArray && 0 < self.scheduledModelArray.count) {
            //only show data with meeting_reminder_state: FRTCSDK_REMINDER_STATE_IS_SHOWING
            [self getScheduleModelToShowing];
        }
        
        [self refreshUI];
    }
}


#pragma mark -- FrtcInConferenceAlertWindowDelegate --

- (void)okButtonClickedOnAlertWindow {
    if (nil != _inConferenceAlertWindow) {
        _inConferenceAlertWindow = nil;
    }
}

- (void)showAlertWindow {
    NSSize windowSize = CGSizeMake(284, 148);
    
    if (nil == _inConferenceAlertWindow) {
        _inConferenceAlertWindow = [[FrtcInConferenceAlertWindow alloc] initWithSize:windowSize];
        [_inConferenceAlertWindow setTitleVisibility:NSWindowTitleHidden];
        [_inConferenceAlertWindow setOkButtonDelegate:self];
    }
    
    [_inConferenceAlertWindow showWindowWithWindow:self.window];
    [_inConferenceAlertWindow setLevel:NSPopUpMenuWindowLevel];
    
//    [_inConferenceAlertWindow makeKeyAndOrderFront:self];
//    [_inConferenceAlertWindow center];
}

- (void)showOrHideMeetingReminderWindow:(BOOL)enable {
    //NSLog(@"[%s][Receive reminder]: user select: enable: %@", __func__, enable?@"YES":@"NO");
    if (NO == _isWindowHide && NO == enable) {
        [self closeReminderWindow];
    } else if (YES == _isWindowHide && YES == enable) {
        //do nothing, wait get shcdule data, then will show window if it has reminder data to show.
    }
}

#pragma mark -- FrtcInConferenceAlertWindowDelegate --

// Update the ending time array with the end times of all the meetings
- (void)updateEndingTimeArray {
    [self.endingTimeArray removeAllObjects];
    
    for (ReminderScheduleModel *meeting in self.endingMeetingArray) {
        //[self.endingTimeArray addObject:meeting.schedule_end_time];
        NSDate *endTime = [[FrtcBaseImplement baseImpleSingleton] getDateFromSting: meeting.schedule_end_time];
        [self.endingTimeArray addObject:endTime];
    }
    
    // Sort the ending time array in ascending order
    [self.endingTimeArray sortUsingSelector:@selector(compare:)];
    
    // Start the ending timer with the next ending time
    [self startEndingTimer];
}

// Start the ending timer with the next ending time
- (void)startEndingTimer {
    // Stop the timer if it's already running
    [self.endingTimer invalidate];
    
    // Get the next ending time from the ending time array
    NSDate *nextEndingTime = [self.endingTimeArray firstObject];
    if (!nextEndingTime) {
        return;
    }
    
    // Calculate the time interval until the next ending time
    NSTimeInterval timeInterval = [nextEndingTime timeIntervalSinceNow];
    //NSLog(@"[%s][%d]: timeInterval: %d", __func__, __LINE__, (int)timeInterval);

    //timeInterval = [[FrtcBaseImplement baseImpleSingleton] getTimeIntervalSinceNowToDate: nextEndingTime];
    //NSLog(@"[%s][%d]: timeInterval: %d", __func__, __LINE__, (int)timeInterval);
    
    // Start the timer
    NSDictionary *userInfo = @{FMeetingLocalReminderWindowEndTimeKey: nextEndingTime};
    self.endingTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                        target:self
                                                      selector:@selector(timerFired:)
                                                      userInfo:userInfo
                                                       repeats:NO];
}

// The timer fired, remove the ending meetings and start the timer again
- (void)timerFired:(NSTimer *)timer {
    NSDate *currentEndTime = [timer.userInfo objectForKey:FMeetingLocalReminderWindowEndTimeKey];
    
    NSDictionary *userInfo = timer.userInfo;
    NSDate *nextEndingTime = userInfo[FMeetingLocalReminderWindowEndTimeKey];
    NSLog(@"Next ending time: %@", nextEndingTime);
    
    // Remove all the meetings that have ended
    NSMutableArray *meetingsToRemove = [NSMutableArray array];
    for (ReminderScheduleModel *meeting in self.endingMeetingArray) {
        NSDate *endTime = [[FrtcBaseImplement baseImpleSingleton] getDateFromSting: meeting.schedule_end_time];
        
        //whether the currentEndTime is earlier (smaller) than the endTime.
        if ([endTime compare:currentEndTime] == NSOrderedAscending || [endTime isEqualToDate:currentEndTime]) {
            [meetingsToRemove addObject:meeting];
        }
    }
    
    [self.endingMeetingArray removeObjectsInArray:meetingsToRemove];
    [self.willShowScheduledModelArray removeObjectsInArray:meetingsToRemove];

    for (ReminderScheduleModel *meeting in self.scheduledModelArray) {
        NSDate *endTime = [[FrtcBaseImplement baseImpleSingleton] getDateFromSting: meeting.schedule_end_time];
        if ([endTime compare:currentEndTime] == NSOrderedAscending || [endTime isEqualToDate:currentEndTime]) {
            meeting.meeting_reminder_state = FRTCSDK_REMINDER_STATE_IS_END;
        }
    }

    [self refreshUI];

    // Update the ending time array and start the timer again
    [self updateEndingTimeArray];
}

@end
