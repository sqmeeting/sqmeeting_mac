#import "FrtcRequestUnMuteListViewController.h"
#import "FrtcRequestUnMuteBackgroundView.h"
#import "FrtcRequetUnMuteTitleCell.h"
#import "FrtcRequetUnMuteTitleCell.h"
#import "FrtcRequestUnMuteDetailCell.h"
#import "FrtcMeetingManagement.h"
#import "FrtcMultiTypesButton.h"

@interface FrtcRequestUnMuteListViewController ()<NSTableViewDelegate, NSTableViewDataSource, FrtcRequestUnMuteDetailCellDelegate>

@property (nonatomic, strong) NSTextField *titleTextField;

@property (nonatomic, strong) NSView      *lineView;

@property (nonatomic, strong) NSScrollView *rosterListScrollView;

@property (nonatomic, strong) NSTableView  *rosterListTableView;

@property (nonatomic, strong) FrtcMultiTypesButton     *agreeAllUnmuteButton;

@property (nonatomic, strong) NSMutableArray *nameArray;

@property (nonatomic, strong) NSMutableArray *uuidArray;

@property (nonatomic, strong) FrtcRequestUnMuteBackgroundView *requestBackgroundView;

@end

@implementation FrtcRequestUnMuteListViewController

- (instancetype)init {
    self = [super init];
    
    if(self) {
        self.uuidArray = [NSMutableArray array];
        self.nameArray = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
    
    self.titleTextField.stringValue = NSLocalizedString(@"FM_ASK_FOR_MUTE_TITLE", @"Participant’s Requests");
    [self requestUnmuteListViewLayout];
}

#pragma mark --ParticipantsView Layout--
- (void)requestUnmuteListViewLayout {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(9);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.requestBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(41);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.width.mas_equalTo(448);
        make.height.mas_equalTo(360);
    }];
    
    [self.rosterListScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(41);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.width.mas_equalTo(448);
        make.height.mas_equalTo(360);
    }];
    
    [self.agreeAllUnmuteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-16);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(104);
        make.height.mas_equalTo(30);
    }];
}

#pragma mark -Button Senser--
- (void)onAgreeAllUnmutePressed {
    if(self.agreeAllUnmuteButton.hover == NO) {
        return;
    }
    
    __weak __typeof(self)weakSelf = self;
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcMeetingAllowUnmute:self.inCallModel.userToken meetingNumber:self.inCallModel.conferenceNumber clientIdentifier:self.uuidArray allowUnmuteSuccessful:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.uuidArray removeAllObjects];
        [strongSelf.nameArray removeAllObjects];
        strongSelf.rosterListScrollView.hidden = YES;
        strongSelf.requestBackgroundView.hidden = NO;
       // strongSelf.agreeAllUnmuteButton.enabled = NO;
        [self disableButtonColor];
        
        if(strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(agreeAll)]) {
            [strongSelf.delegate agreeAll];
        }
    } allowUnmuteFailure:^(NSError * _Nonnull error) {
        NSLog(@"Failure");
    }];
}

- (void)disableButtonColor {
    self.agreeAllUnmuteButton.layer.backgroundColor = [NSColor colorWithString:@"#026FFE" andAlpha:0.3].CGColor;
    self.agreeAllUnmuteButton.hover = NO;
}

//key: uuid, val: name
#pragma mark -NSTableViewDelegate, NSTableViewDataSource-
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.nameArray count] + 1;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
      // Retrieve to get the @"MyView" from the pool or,
      // if no version is available in the pool, load the Interface Builder versio
    if(row == 0) {
        FrtcRequetUnMuteTitleCell *cell = [tableView makeViewWithIdentifier:@"FrtcRequetUnMuteTitleCell" owner:self];
        if(cell == nil) {
            cell = [[FrtcRequetUnMuteTitleCell alloc] initWithFrame:NSMakeRect(0, 0, 448, 40)];
            cell.identifier = @"FrtcRequetUnMuteTitleCell";
            cell.rowSizeStyle = NSTableViewRowSizeStyleLarge;
        }
        
        cell.wantsLayer = YES;
        cell.layer.backgroundColor = [NSColor colorWithString:@"#F8F9FA" andAlpha:1.0].CGColor;
        
        return cell;
    } else {
        FrtcRequestUnMuteDetailCell *cell = [tableView makeViewWithIdentifier:@"FrtcRequestUnMuteDetailCell" owner:self];
        if(cell == nil) {
            cell = [[FrtcRequestUnMuteDetailCell alloc] initWithFrame:NSMakeRect(0, 0, 448, 40)];
            cell.identifier = @"FrtcRequestUnMuteDetailCell";
            cell.rowSizeStyle = NSTableViewRowSizeStyleLarge;
            NSLog(@"-----The row is %ld, and the name is %@", row, self.nameArray[row-1]);
            [cell updateCellName:self.nameArray[row - 1]];
            cell.row = row;
            cell.delegate = self;
        } else {
            [cell updateCellName:self.nameArray[row - 1]];
            cell.row = row;
        }
        
        cell.wantsLayer = YES;
        cell.layer.backgroundColor = [NSColor colorWithString:@"#F8F9FA" andAlpha:1.0].CGColor;
        
        return cell;
    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 40;
}

#pragma mark --FrtcRequestUnMuteDetailCellDelegate--
- (void)agreeUnMuteWithRow:(NSInteger)row {
    NSInteger index = row - 1;
    NSArray *allowUnmuteArray = @[(NSString *)(self.uuidArray[index])];
    NSString *uuid = self.uuidArray[index];
    [self.uuidArray removeObjectAtIndex:index];
    [self.nameArray removeObjectAtIndex:index];
    
    __weak __typeof(self)weakSelf = self;

    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcMeetingAllowUnmute:self.inCallModel.userToken meetingNumber:self.inCallModel.conferenceNumber clientIdentifier:allowUnmuteArray allowUnmuteSuccessful:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.rosterListTableView reloadData];
        
        if(strongSelf.uuidArray.count == 0) {
            strongSelf.rosterListScrollView.hidden = YES;
            strongSelf.requestBackgroundView.hidden = NO;
            //strongSelf.agreeAllUnmuteButton.enabled = NO;
            [self disableButtonColor];
        }
        
        if(strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(agreeOneUserWithUUID:)]) {
            [strongSelf.delegate agreeOneUserWithUUID:uuid];
        }
        
    } allowUnmuteFailure:^(NSError * _Nonnull error) {
        NSLog(@"Failure");
    }];
}

#pragma mark -- Class Interface
- (void)updateDictionary:(NSMutableDictionary *)dictionary {
    [self.nameArray removeAllObjects];
    [self.uuidArray removeAllObjects];
    [self.nameArray addObjectsFromArray:[dictionary allValues]];
    [self.uuidArray addObjectsFromArray:[dictionary allKeys]];
//    [self.nameArray addObject:[dictionary allValues][0]];
//    [self.uuidArray addObject:[dictionary allKeys][0]];
    
    if(self.rosterListScrollView.hidden) {
        self.rosterListScrollView.hidden = NO;
        self.requestBackgroundView.hidden = YES;
        self.agreeAllUnmuteButton.enabled = YES;
        self.agreeAllUnmuteButton.hover = YES;
        self.agreeAllUnmuteButton.layer.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] blueColor].CGColor;
    }
    
    [self.rosterListTableView reloadData];
}

- (void)popRequestUnmuteView:(NSMutableDictionary *)dictionary {
    [self.nameArray addObjectsFromArray:[dictionary allValues]];
    [self.uuidArray addObjectsFromArray:[dictionary allKeys]];
    
    [self.rosterListTableView reloadData];
}


#pragma mark --lazy load--
- (NSTextField *)titleTextField {
    if (!_titleTextField){
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightMedium];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = @"参会者 (12)";
        [self.view addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (NSTableView *)rosterListTableView {
    if(!_rosterListTableView) {
        _rosterListTableView = [[NSTableView alloc] initWithFrame:NSMakeRect(0, 41, 448, 360)];
        NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@""];
        [_rosterListTableView addTableColumn:column];
        _rosterListTableView.delegate = self;
        _rosterListTableView.dataSource = self;
        [_rosterListTableView setAllowsTypeSelect:NO];
        _rosterListTableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
        [_rosterListTableView setHeaderView:nil];
        [_rosterListTableView setIntercellSpacing:NSMakeSize(0, 0)];
        _rosterListTableView.backgroundColor = [NSColor colorWithString:@"#F8F9FA" andAlpha:1.0];
        _rosterListTableView.focusRingType = NSFocusRingTypeNone;
        _rosterListTableView.translatesAutoresizingMaskIntoConstraints = YES;
     
        if(@available(macos 11.0, *)) {
            _rosterListTableView.style = NSTableViewStylePlain;
        }
        
        [_rosterListTableView reloadData];
    }
    
    return _rosterListTableView;
}

- (NSScrollView *)rosterListScrollView {
    if (!_rosterListScrollView) {
        _rosterListScrollView = [[NSScrollView alloc] init];
        _rosterListScrollView.contentView.documentView = self.rosterListTableView;
        _rosterListScrollView.hasVerticalScroller = YES;
        _rosterListScrollView.scrollerStyle = NSScrollerStyleOverlay;
        _rosterListScrollView.scrollerKnobStyle = NSScrollerKnobStyleDark;
        _rosterListScrollView.scrollsDynamically = YES;
        _rosterListScrollView.hasVerticalScroller = YES;
        _rosterListScrollView.autohidesScrollers = NO;
        _rosterListScrollView.verticalScroller.hidden = NO;
        _rosterListScrollView.automaticallyAdjustsContentInsets = NO;
        [self.view addSubview:_rosterListScrollView];
    }

    return _rosterListScrollView;
}


- (FrtcRequestUnMuteBackgroundView *)requestBackgroundView {
    if(!_requestBackgroundView) {
        _requestBackgroundView = [[FrtcRequestUnMuteBackgroundView alloc] initWithFrame:NSMakeRect(0, 0, 448, 360)];
        _requestBackgroundView.hidden = YES;
        [self.view addSubview:_requestBackgroundView];
    }
    
    return _requestBackgroundView;
}

- (FrtcMultiTypesButton *)agreeAllUnmuteButton {
    if (!_agreeAllUnmuteButton) {//FM_ALLOW_UN_MUTE_ALL = "Agree All";
        _agreeAllUnmuteButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 158, 36) withTitle:NSLocalizedString(@"FM_ALLOW_UN_MUTE_ALL", @"Agree All")];
        _agreeAllUnmuteButton.target = self;
        _agreeAllUnmuteButton.layer.cornerRadius = 4.0;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_ALLOW_UN_MUTE_ALL", @"Agree All")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[[FrtcBaseImplement baseImpleSingleton] whiteColor]
                          range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [_agreeAllUnmuteButton setAttributedTitle:attrTitle];
        _agreeAllUnmuteButton.action = @selector(onAgreeAllUnmutePressed);
        [self.view addSubview:_agreeAllUnmuteButton];
    }
    
    return _agreeAllUnmuteButton;
}

@end
