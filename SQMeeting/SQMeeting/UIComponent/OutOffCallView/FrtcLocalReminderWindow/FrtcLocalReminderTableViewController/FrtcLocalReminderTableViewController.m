#import "FrtcLocalReminderTableViewController.h"

#import "FrtcBaseImplement.h"
#import "Masonry.h"
#import "NSColor+Utils.h"
#import "NSColor+Enhancement.h"

#import "FrtcLocalReminderTitleBarView.h"
#import "FrtcLocalReminderTableCellView.h"


@interface FrtcLocalReminderTableViewController ()

@property (nonatomic, strong) NSWindow *window;

@property (nonatomic, assign) CGFloat tableHeight;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) CGFloat windowHeight;


@end

@implementation FrtcLocalReminderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self setupWindowUILayout];
}

- (void)loadView {
    //self.view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 380, 300)];
    self.view = [[NSView alloc] init];
    self.view.layer.backgroundColor = [NSColor cyanColor].CGColor;
    
    NSRect scrollViewRect = NSMakeRect(0, 0, 380, 0);
    self.scrollView = [[NSScrollView alloc] initWithFrame:scrollViewRect];
//    self.scrollView.hasHorizontalScroller = NO;
//    self.scrollView.horizontalScrollElasticity = NSScrollElasticityNone;
    self.scrollView.contentView.backgroundColor = NSColor.whiteColor;
    self.scrollView.backgroundColor = [NSColor whiteColor];

    self.scrollView.hasVerticalScroller = YES;
    self.scrollView.scrollerStyle = NSScrollerStyleOverlay;
    self.scrollView.scrollerKnobStyle = NSScrollerKnobStyleDark;
    self.scrollView.scrollsDynamically = YES;
    self.scrollView.hasVerticalScroller = YES;
    self.scrollView.autohidesScrollers = NO;
    self.scrollView.verticalScroller.hidden = NO;
    self.scrollView.automaticallyAdjustsContentInsets = NO;
    
    self.scrollView.horizontalScrollElasticity = NSScrollElasticityNone;
    
    [self.scrollView setHasHorizontalScroller:YES];
    [self.scrollView setHasVerticalScroller:YES];
    [self.scrollView setAutohidesScrollers:YES];
    
    //[self.scrollView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    //[self.scrollView setAutoresizingMask:NSViewHeightSizable];
    
    _tableView = [[NSTableView alloc] initWithFrame:self.scrollView.bounds];
    
    [_tableView setAutoresizingMask:NSViewNotSizable];
    [[_tableView enclosingScrollView] setAutoresizingMask:NSViewNotSizable];
    
    NSTableColumn *tableColumn = [[NSTableColumn alloc] initWithIdentifier:@"reminderTableColumn"];
    tableColumn.width = 380;
    [_tableView addTableColumn:tableColumn];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.gridStyleMask = NSTableViewGridNone;
    _tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
    [_tableView setIntercellSpacing:NSZeroSize];    _tableView.allowsColumnReordering = NO;
    [_tableView setHeaderView:nil];
    //_tableView.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] whiteColor];
    _tableView.focusRingType = NSFocusRingTypeNone;
    _tableView.translatesAutoresizingMaskIntoConstraints = YES;
    
    [_tableView setAutoresizingMask:NSViewNotSizable];
    [_tableView setAllowsColumnResizing:NO];
    
    [_tableView setFrameSize:NSMakeSize(380, 200)];
    _tableView.backgroundColor = [NSColor whiteColor];
    
    self.scrollView.documentView = self.tableView;
    [self.view addSubview:self.scrollView];
    
//    NSLog(@"[%s]: tableColumn.frame: [%d, %d, %d, %d]", __func__,
//          (int)tableColumn.tableView.frame.origin.x,
//          (int)tableColumn.tableView.frame.origin.y,
//          (int)tableColumn.tableView.frame.size.width,
//          (int)tableColumn.tableView.frame.size.height);
//
//    NSLog(@"[%s]: tableColumn.bound: [%d, %d, %d, %d]", __func__,
//          (int)tableColumn.tableView.bounds.origin.x,
//          (int)tableColumn.tableView.bounds.origin.y,
//          (int)tableColumn.tableView.bounds.size.width,
//          (int)tableColumn.tableView.bounds.size.height);
    
    self.window = [self.view window];
}

- (void)setupWindowUILayout {
    int nWindowHeight = TABLE_VIEW_BAR_HIGHT_MAX;
    ///NSLog(@"[%s]: nReminderCount = self.scheduledModelArray.count: %d, nWindowHeight: %d", __func__, (int)self.scheduledModelArray.count, nWindowHeight);

    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(WINDOW_TITLE_BAR_HIGHT);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.width.mas_equalTo(380);
        make.height.mas_equalTo(nWindowHeight);
    }];
}

- (void)refreshList {
    [self adjustWindowSize];
    [self setupWindowUILayout];
    [self.tableView reloadData];
}

- (void)adjustWindowSize {
    int reminderCount = (int)self.scheduledModelArray.count;
    _tableHeight = REMINDER_CELL_HIGHT * reminderCount;
    _viewHeight = _tableHeight + WINDOW_TITLE_BAR_HIGHT + WINDOW_BUTTON_BAR_HIGHT + 12;
    
    if (reminderCount <= 0) {
        // no reminder data, so close window.
        //NSLog(@"[%s]: self.scheduledModelArray.count: %d, no reminder data, so close window.", __func__, reminderCount);
        _windowHeight = _tableHeight + WINDOW_TITLE_BAR_HIGHT + WINDOW_BUTTON_BAR_HIGHT;
    } else if (reminderCount <= 4) {
        _windowHeight = _tableHeight + WINDOW_TITLE_BAR_HIGHT + WINDOW_BUTTON_BAR_HIGHT;
    } else {
        _windowHeight = REMINDER_CELL_HIGHT * 4 + WINDOW_TITLE_BAR_HIGHT + WINDOW_BUTTON_BAR_HIGHT;
    }
    
    //NSLog(@"[%s]: self.scheduledModelArray.count: %d, _tableHeight: %d, _windowHeight: %d", __func__, reminderCount, (int)_tableHeight, (int)_windowHeight);

    // adjust the window height.
    NSRect screenFrame = [self.view.window frame];
    NSRect newWindowFrame = screenFrame;
    newWindowFrame.size.height = _windowHeight;
    
    [self.view.window setFrame:newWindowFrame display:YES animate:YES];

    [self.view setFrame:CGRectMake(0, 0, 380, _windowHeight)];
    //[self.scrollView setFrame:CGRectMake(0, 0, self.view.frame.size.width, _tableHeight)];
    [self.tableView setFrame:CGRectMake(0, 0, 380, _tableHeight)];
}

- (void)configureCell:(FrtcLocalReminderTableCellView *)cell WithData:(NSInteger)row {
    ReminderScheduleModel *scheduleModel = self.scheduledModelArray[row];
    
    NSString *startTimeString = [[FrtcBaseImplement baseImpleSingleton] getDateTimeFromDateString:scheduleModel.schedule_start_time];
    NSString *endTimeString   = [[FrtcBaseImplement baseImpleSingleton] getTimeFromDateString:scheduleModel.schedule_end_time];
    //NSLog(@"startTimeString: %@ ~ endTimeString: %@", startTimeString, endTimeString);
    
    NSString *meetingName = scheduleModel.meeting_name ? scheduleModel.meeting_name : @"";
    NSString *meetingNumber = scheduleModel.meeting_number ? scheduleModel.meeting_number : @"";
    NSString *meetingNameAndNumber = [NSString stringWithFormat:@"%@ %@", meetingName, meetingNumber];
    cell.meetingNameTextField.stringValue     = meetingNameAndNumber ? meetingNameAndNumber : @"";
    
    NSString *ownerName = scheduleModel.owner_name ? scheduleModel.owner_name : @"";
    NSString *ownerTitle = NSLocalizedString(@"FM_MEETING_REMINDER_MEETINGOWNER", @"Meeting owner");
    NSString *timeAndOwnerTextField = [NSString stringWithFormat:@"%@-%@ %@: %@", startTimeString, endTimeString, ownerTitle, ownerName];
    cell.timeAndOwnerTextField.stringValue     = timeAndOwnerTextField ? timeAndOwnerTextField : @"";

    cell.row = row;
    
    [cell updateLayout];
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    //NSLog(@"[%s]: self.scheduledModelArray.count: %d", __func__, (int)self.scheduledModelArray.count);
    //return self.data.count;
    return self.scheduledModelArray.count;
}

- (NSTableCellView *)AccoutTableViewCellWithTableView:(NSTableView *)tableView
                                     withTableViewRow:(NSInteger)row {
    
    //NSLog(@"[%s]: row: %d", __func__, (int)row);
    FrtcLocalReminderTableCellView *cell = [tableView makeViewWithIdentifier:@"FrtcLocalReminderTableCellView" owner:self];
    if (cell == nil) {
        //NSLog(@"[%s]: FrtcLocalReminderTableCellView alloc: row: %d", __func__, (int)row);
        cell = [[FrtcLocalReminderTableCellView alloc] init];
        __weak __typeof(self)weakSelf = self;
        cell.delegate = weakSelf;
        cell.identifier = @"FrtcLocalReminderTableCellView";
    }
    
    cell.row = row;
    cell.meetingNameTextField.stringValue = @"goodmao Meeting";
    
//    if (row % 2 == 0) {
//        cellView.layer.backgroundColor = [NSColor colorWithString:@"#F6F6F6" andAlpha:1.0].CGColor;
//    } else {
//        cellView.layer.backgroundColor = [NSColor colorWithString:@"#FBFBFB" andAlpha:1.0].CGColor;
//    }
        
    [self configureCell:cell WithData:row];
    return cell;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return [self AccoutTableViewCellWithTableView:tableView withTableViewRow:row];
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return REMINDER_CELL_HIGHT; //60;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row  {
    return NO;
}

- (void)setScheduledModelArray:(NSMutableArray<ReminderScheduleModel *> *)scheduledModelArray {
    _scheduledModelArray = scheduledModelArray;

    [self.tableView reloadData];
    [self refreshList];
}

- (void)joinMeetingAtRow:(NSInteger)row {
    //NSLog(@"[%s]: scheduledModelArray: %d", __func__, (int)row);

    if ([self.localReminderJoinConferenceDelegate respondsToSelector:@selector(joinTheConferenceWithScheduleModel:)]) {
        ScheduleModel *scheduleModel = self.scheduledModelArray[row];
        [self.localReminderJoinConferenceDelegate joinTheConferenceWithScheduleModel:scheduleModel];
    } else {
        NSLog(@"[%s]: delegate not respond with setScheduledModelArray:", __func__);
    }
}

@end
