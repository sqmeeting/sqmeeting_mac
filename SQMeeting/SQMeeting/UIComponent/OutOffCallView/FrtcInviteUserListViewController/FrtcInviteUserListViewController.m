#import "FrtcInviteUserListViewController.h"
#import "FrtcInviteUserListViewCell.h"
#import "FrtcButton.h"
#import "LoginTextField.h"
#import "FrtcInviteUserListViewCell.h"
#import "FrtcMeetingManagement.h"
#import "FrtcDeleteUserListViewCell.h"
#import "FrtcMeetingManagement.h"
#import "FrtcAlertMainWindow.h"

@interface FrtcInviteUserListViewController () <NSTableViewDelegate, NSTableViewDataSource, FrtcInviteUserListViewCellDelegate, NSTextFieldDelegate, FrtcDeleteUserListViewCellDelegate>

@property (nonatomic, strong) NSTextField    *titleTextField;
@property (nonatomic, strong) NSView         *line1;
@property (nonatomic, strong) FrtcButton     *inviteUserButton;
@property (nonatomic, strong) FrtcButton     *hadInvitedUserButton;
@property (nonatomic, strong) LoginTextField *searchTextField;
@property (nonatomic, strong) NSScrollView   *backGoundView;
@property (nonatomic, strong) NSTableView    *userListTableView;
@property (nonatomic, strong) FrtcButton     *cancelButton;
@property (nonatomic, strong) FrtcButton     *completeButton;
@property (nonatomic, strong) UserModel      *userInfoModel;
@property (nonatomic, strong) NSMutableArray<UserModel *> *tempUserModelArray;
@property (nonatomic, strong) NSMutableArray<UserModel *> *selectedUserModelArray;
@property (nonatomic, strong) NSProgressIndicator *userListProgress;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *userList;
@property (nonatomic, strong) NSArray<NSString *> *selectUserList;

@property (nonatomic, assign) NSInteger selectedUserNumber;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation FrtcInviteUserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.selectedUserNumber = 0;
    self.disPlayTag = FrtcUserListWillDisplayTag;
    [self setupInviteUILayout];
    [self addNotification];
}

- (void)dealloc {
    NSLog(@"---------FrtcInviteUserListViewController dealloc--------------");
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(boundsDidChangeNotification:)
                                                 name:NSViewBoundsDidChangeNotification
                                               object:[self.backGoundView contentView]];
}

#pragma mark --layout--
- (void)setupInviteUILayout {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(8);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(12);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(380);
        make.height.mas_equalTo(1);
     }];
    
    [self.inviteUserButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line1.mas_bottom).offset(13);
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.width.mas_equalTo(154);
        make.height.mas_equalTo(32);
    }];
    
    [self.hadInvitedUserButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line1.mas_bottom).offset(13);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.width.mas_equalTo(154);
        make.height.mas_equalTo(32);
    }];
    
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.inviteUserButton.mas_bottom).offset(12);
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.width.mas_equalTo(308);
        make.height.mas_equalTo(32);
    }];
    
    [self.backGoundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchTextField.mas_bottom).offset(2);
        make.left.mas_equalTo(self.view.mas_left);
        make.width.mas_equalTo(380);
        make.height.mas_equalTo(336);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(471);
        make.left.mas_equalTo(74);
        make.width.mas_equalTo(88);
        make.height.mas_equalTo(32);
    }];
    
    [self.completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(471);
        make.right.mas_equalTo(-66);
        make.width.mas_equalTo(87.79);
        make.height.mas_equalTo(32);
    }];
    
    [self.userListProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backGoundView.mas_bottom).offset(5);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
}

#pragma mark --Update UserList--
- (void)updateSelectUserInfo:(NSArray *)userList {
    for(NSDictionary *dictionary in userList) {
        UserModel *model = [[UserModel alloc] init];
        model.username = dictionary[@"username"];
        model.user_id  = dictionary[@"user_id"];
        model.real_name = dictionary[@"real_name"];
        [self.tempUserModelArray addObject:model];
        [self.selectedUserModelArray addObject:model];
        self.selectUserList = [self.selectUserList arrayByAddingObject:dictionary[@"username"]];
    }
    
    if(userList.count > 0) {
        [self updateCompleteButtonStyleUsingSelectedUserNumber:self.tempUserModelArray.count];
    }
}

- (BOOL)contaninUser:(NSString *)user {
    for(UserModel * modle in self.tempUserModelArray) {
        if([modle.username isEqualToString:user]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark --Notification--
- (void)boundsDidChangeNotification:(NSNotification *)notification {
    NSClipView *clipView = self.backGoundView.contentView;
    
    if(clipView.bounds.origin.y == 0) {
        NSLog(@"Scrollview go to the bottom");
    } else if(clipView.bounds.origin.y + clipView.bounds.size.height == self.backGoundView.documentView.bounds.size.height) {
        NSLog(@"Scrollview go to the top");
        if(self.currentPage < self.totalPages) {
            [self.backGoundView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.searchTextField.mas_bottom).offset(2);
                make.left.mas_equalTo(self.view.mas_left);
                make.width.mas_equalTo(360);
                make.height.mas_equalTo(336);
            }];
            self.userListProgress.hidden = NO;
        
            [self.userListProgress mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.backGoundView.mas_bottom).offset(5);
                make.centerX.mas_equalTo(self.view.mas_centerX);
                make.width.mas_equalTo(16);
                make.height.mas_equalTo(16);
            }];
            [self.userListProgress startAnimation:self];
            
            NSInteger pageNumber = self.currentPage + 1;
            NSString *userToken = [[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN];
            
            __weak typeof(self) weakSelf = self;
            [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcGetAllUserList:userToken withPage:pageNumber withFilter:@""  completionHandler:^(UserListModel * _Nonnull allUserListModel) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                
                strongSelf.allUserListModel.users = [strongSelf.allUserListModel.users arrayByAddingObjectsFromArray:allUserListModel.users];
           
                strongSelf.currentPage += 1;
                [strongSelf.userListProgress stopAnimation:strongSelf];
                strongSelf.userListProgress.hidden = YES;
                [strongSelf.userListTableView reloadData];
            } failure:^(NSError * _Nonnull error) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf.userListProgress stopAnimation:self];
                strongSelf.userListProgress.hidden = YES;
                
                if([error.localizedDescription isEqualToString:@"Request failed: unauthorized (401)"]) {
                    FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_VERIFY_FAILURE", @"Verifyication failed") withMessage:NSLocalizedString(@"FM_RE_SIGN", @"Please sign in again") preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:self.view.window];

                    FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
                        [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingMainViewShowNotification object:nil userInfo:nil];
                    }];
                    [alertWindow addAction:action];
                }
            }];
        }
    } else {
       
    }
}

#pragma mark --FrtcDeleteUserListViewCellDelegate--
- (void)deleteUserWithCellRow:(NSInteger)row {
    //[self.selectedUserModelArray removeObjectAtIndex:row];
    [self.tempUserModelArray removeObjectAtIndex:row];
    [self.userListTableView reloadData];
    
    [self updateCompleteButtonStyleUsingSelectedUserNumber:self.tempUserModelArray.count];
}

#pragma mark --Button Sender--
- (void)onCompleteBtnPressed:(FrtcButton *)sender {
    if(self.selectedUserNumber > 100) {
        FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:@"人数上限" withMessage:@"邀请人数目前限制100人。" preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:self.view.window];

        FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
            
        }];
        [alertWindow addAction:action];
        
        return;
    }
    [self.selectedUserModelArray removeAllObjects];
    [self.userList removeAllObjects];
    for(UserModel * userModel in self.tempUserModelArray) {
        [self.selectedUserModelArray addObject:userModel];
        [self.userList addObject:@{@"user_id": userModel.user_id, @"username":userModel.username}];
        //self.userList = [self.userList arrayByAddingObject:@{@"user_id": userModel.user_id, @"username":userModel.username}];
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(selectUsers:)]) {
        [self.delegate selectUsers:self.userList];
    }
    
    [self.view.window orderOut:nil];
    NSLog(@"%@", self.selectedUserModelArray);
}

- (void)oninviteBtnPressed:(FrtcButton *)sender {
    if(sender.tag == 201) {
        if(self.disPlayTag == FrtcUserListWillDisplayTag) {
            NSLog(@"Do nothing");
        } else {
            [self.inviteUserButton updateButtonWithButtonMode:[self skyBackgroundColorModewithTitle:NSLocalizedString(@"FM_INVITE_USERS", @"Invite")]];
            [self.hadInvitedUserButton updateButtonWithButtonMode:[self garyBackgroundColorModeWithTile:NSLocalizedString(@"FM_USER_INVITED", @"Invited")]];
            self.disPlayTag = FrtcUserListWillDisplayTag;
            [self.userListTableView reloadData];
        }
    } else if(sender.tag == 202) {
        if(self.disPlayTag == FrtcUserListHadDisplayTag) {
            NSLog(@"Do nothing");
        } else {
            [self.inviteUserButton updateButtonWithButtonMode:[self garyBackgroundColorModeWithTile:NSLocalizedString(@"FM_INVITE_USERS", @"Invite")]];
            [self.hadInvitedUserButton updateButtonWithButtonMode:[self skyBackgroundColorModewithTitle:NSLocalizedString(@"FM_USER_INVITED", @"Invited")]];
            self.disPlayTag = FrtcUserListHadDisplayTag;
            [self.userListTableView reloadData];
        }
    }
}

- (void)onCancelBtnPressed:(FrtcButton *)sender {
    [self.view.window orderOut:nil];
}

#pragma mark --FrtcInviteUserListViewCellDelegate--
- (void)selectedUser:(BOOL)selected withCellRow:(NSInteger)row {
    if(selected) {
        self.selectedUserNumber++;
        [self.tempUserModelArray addObject:((UserModel *)(self.allUserListModel.users[row]))];
        NSLog(@"The self.tempUserModelArray is %ld", self.tempUserModelArray.count);
    } else {
        self.selectedUserNumber--;
        for(UserModel *model in self.tempUserModelArray) {
            if([model.username isEqualToString:((UserModel *)(self.allUserListModel.users[row])).username]) {
                [self.tempUserModelArray removeObject:model];
                break;
            }
        }
    }
    
    [self updateCompleteButtonStyleUsingSelectedUserNumber:self.tempUserModelArray.count];
}

#pragma mark --<NSTableViewDelegate, NSTableViewDataSource>--
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if(self.disPlayTag == FrtcUserListWillDisplayTag) {
        return self.allUserListModel.users.count;
    } else {
        return self.tempUserModelArray.count;
    }
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *cell;
    if(self.disPlayTag == FrtcUserListWillDisplayTag) {
        cell = [tableView makeViewWithIdentifier:@"FrtcInviteUserListViewCell" owner:self];
        if(cell == nil) {
            cell = [[FrtcInviteUserListViewCell alloc] init];
        }
        ((FrtcInviteUserListViewCell *)cell).userNameTextField.stringValue = ((UserModel *)(self.allUserListModel.users[row])).username;
        ((FrtcInviteUserListViewCell *)cell).delegate = self;
        ((FrtcInviteUserListViewCell *)cell).identifier = @"FrtcScheduleMeetingTableViewCell";
        ((FrtcInviteUserListViewCell *)cell).row = row;
        
        NSString *userName = ((UserModel *)(self.allUserListModel.users[row])).username;
        if(/*[self.selectUserList containsObject:userName] || */[self contaninUser:userName]) {
            [((FrtcInviteUserListViewCell *)cell) haveSelected];
        } else {
            [((FrtcInviteUserListViewCell *)cell) haveUnSelected];
        }
        
    } else if(self.disPlayTag == FrtcUserListHadDisplayTag) {
        cell = [tableView makeViewWithIdentifier:@"FrtcDeleteUserListViewCell" owner:self];
        if(cell == nil) {
            cell = [[FrtcDeleteUserListViewCell alloc] init];
        }
    
       ((FrtcDeleteUserListViewCell *)cell).userNameTextField.stringValue = self.tempUserModelArray[row].username;
        ((FrtcDeleteUserListViewCell *)cell).delegate = self;
        ((FrtcDeleteUserListViewCell *)cell).identifier = @"FrtcScheduleMeetingTableViewCell";
        ((FrtcDeleteUserListViewCell *)cell).row = row;
    }

        
    return cell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 40;
}

#pragma mark -- NSTextField delegate --
- (void)controlTextDidChange:(NSNotification *)obj {
    NSString *userToken = [[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN];
    __weak typeof(self) weakSelf = self;
    
    if (self.searchTextField.stringValue.length == 0){
        [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcGetAllUserList:userToken withPage:1 withFilter:@""  completionHandler:^(UserListModel * _Nonnull allUserListModel) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            strongSelf.allUserListModel = allUserListModel;
            [strongSelf.userListTableView reloadData];
        } failure:^(NSError * _Nonnull error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.userListProgress stopAnimation:self];
            strongSelf.userListProgress.hidden = YES;
        }];
        
        return;
    }

    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcGetAllUserList:userToken withPage:1 withFilter:self.searchTextField.stringValue completionHandler:^(UserListModel * _Nonnull allUserListModel) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.allUserListModel = allUserListModel;
        [strongSelf.userListTableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark --setter--
- (void)setAllUserListModel:(UserListModel *)allUserListModel {
    _allUserListModel = allUserListModel;
    self.totalPages = [allUserListModel.total_page_num integerValue];
    self.currentPage = 1;
    [self.userListTableView reloadData];
}

#pragma mark --getter load--
- (NSTextField *)titleTextField {
    if (!_titleTextField) {
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightMedium];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = NSLocalizedString(@"FM_MEETING_ADD_INVITED_USERS", @"Add invited Users");
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

- (FrtcButton *)inviteUserButton {
    if(!_inviteUserButton) {
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_INVITE_USERS", @"Invite") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_INVITE_USERS", @"Invite") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        _inviteUserButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 93, 32) withNormalMode:normalMode withHoverMode:hoverMode];
        _inviteUserButton.layer.cornerRadius     = 1.0;
        _inviteUserButton.tag = 201;
        _inviteUserButton.hoverd = NO;
        _inviteUserButton.target = self;
        _inviteUserButton.action = @selector(oninviteBtnPressed:);
        
        [self.view addSubview:_inviteUserButton];
    }
    
    return _inviteUserButton;;
}

- (FrtcButton *)hadInvitedUserButton {
    if(!_hadInvitedUserButton) {
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#222222" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#F0F0F5" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#F0F0F5" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_USER_INVITED", @"Invited") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#222222" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#F0F0F5" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#F0F0F5" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_USER_INVITED", @"Invited") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        _hadInvitedUserButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 93, 32) withNormalMode:normalMode withHoverMode:hoverMode];
        _hadInvitedUserButton.layer.cornerRadius     = 1.0;
        _hadInvitedUserButton.tag    = 202;
        _hadInvitedUserButton.hoverd = NO;
        _hadInvitedUserButton.target = self;
        _hadInvitedUserButton.action = @selector(oninviteBtnPressed:);
        
        [self.view addSubview:_hadInvitedUserButton];
    }
    
    return _hadInvitedUserButton;;
}

- (LoginTextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[LoginTextField alloc] initWithFrame:CGRectMake(0, 0, 308, 32)];
        _searchTextField.placeholderString = NSLocalizedString(@"FM_USER_SEARCH", @"Searching");
        _searchTextField.delegate = self;
        [_searchTextField.imageView setImage:[NSImage imageNamed:@"icon-invite-search"]];
        [self.view addSubview:_searchTextField];
    }
    
    return _searchTextField;
}

- (NSScrollView *) backGoundView {
    if (!_backGoundView) {
        _backGoundView = [[NSScrollView alloc] init];
        _backGoundView.documentView = self.userListTableView;
        [[_backGoundView contentView] setPostsBoundsChangedNotifications:YES];
        _backGoundView.hasVerticalScroller = YES;
        _backGoundView.hasHorizontalScroller = NO;
        _backGoundView.scrollerStyle = NSScrollerStyleOverlay;
        _backGoundView.scrollerKnobStyle = NSScrollerKnobStyleDark;
        _backGoundView.scrollsDynamically = YES;
        _backGoundView.autohidesScrollers = NO;
        _backGoundView.verticalScroller.hidden = NO;
        _backGoundView.horizontalScroller.hidden = YES;
        _backGoundView.automaticallyAdjustsContentInsets = NO;
        _backGoundView.backgroundColor = [NSColor whiteColor];
        [self.view addSubview:_backGoundView];
    }

    return _backGoundView;
}

- (NSTableView *)userListTableView {
    if(!_userListTableView) {
        _userListTableView = [[NSTableView alloc] initWithFrame:NSMakeRect(15, 0, 308, 336)];
        NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@""];
        column.maxWidth = 308;
        [_userListTableView addTableColumn:column];
        
        _userListTableView.delegate = self;
        _userListTableView.dataSource = self;
        _userListTableView.gridStyleMask = NSTableViewGridNone;
        _userListTableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
        [_userListTableView setIntercellSpacing:NSMakeSize(0, 3)];
        _userListTableView.allowsColumnReordering = NO;
        [_userListTableView setHeaderView:nil];
        _userListTableView.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] whiteColor];
        _userListTableView.focusRingType = NSFocusRingTypeNone;
        _userListTableView.translatesAutoresizingMaskIntoConstraints = YES;
        [_userListTableView reloadData];
    }
    
    return _userListTableView;
}

- (FrtcButton *)cancelButton {
    if(!_cancelButton) {
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#222222" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#F0F0F5" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#F0F0F5" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_CANCEL", @"Cancel") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#222222" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#F0F0F5" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#F0F0F5" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_CANCEL", @"Cancel") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        _cancelButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 87.79, 32) withNormalMode:normalMode withHoverMode:hoverMode];
        _cancelButton.hoverd = NO;
        _cancelButton.target = self;
        _cancelButton.action = @selector(onCancelBtnPressed:);
        
        [self.view addSubview:_cancelButton];
    }
    
    return _cancelButton;;
}

- (FrtcButton *)completeButton {
    if(!_completeButton) {
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#D7DADD" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#D7DADD" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_DONE", @" Done") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];;
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#D7DADD" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#D7DADD" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_DONE", @" Done") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        _completeButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 87.79, 32) withNormalMode:normalMode withHoverMode:hoverMode];
        _completeButton.enabled = NO;
        _completeButton.hoverd = NO;
        _completeButton.target = self;
        _completeButton.action = @selector(onCompleteBtnPressed:);
        
        [self.view addSubview:_completeButton];
    }
    
    return _completeButton;;
}

- (NSMutableArray <UserModel *> *)tempUserModelArray {
    if(!_tempUserModelArray) {
        _tempUserModelArray = [NSMutableArray array];
    }
    
    return _tempUserModelArray;
}

- (NSMutableArray <UserModel *> *)selectedUserModelArray {
    if(!_selectedUserModelArray) {
        _selectedUserModelArray = [NSMutableArray array];
    }
    
    return _selectedUserModelArray;
}

- (NSMutableArray<NSDictionary *> *)userList {
    if(!_userList) {
        _userList = [NSMutableArray array];
    }
    
    return _userList;
}

- (NSArray<NSString *> *)selectUserList {
    if(!_selectUserList) {
        _selectUserList = [[NSArray alloc] init];
    }
    
    return _selectUserList;
}

- (NSProgressIndicator *)userListProgress {
    if (!_userListProgress) {
        _userListProgress = [[NSProgressIndicator alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        _userListProgress.style = NSProgressIndicatorStyleSpinning;
        _userListProgress.hidden = YES;
        [self.view addSubview:_userListProgress];
    }
    
    return _userListProgress;
}

- (FrtcButtonMode *)skyBackgroundColorModewithTitle:(NSString *)title {
    FrtcButtonMode *skyBackgroundColorMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andButtonTitle:title andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
    
    return skyBackgroundColorMode;
}

- (FrtcButtonMode *)garyBackgroundColorModeWithTile:(NSString *)title {
    FrtcButtonMode *grayBackgroundColorMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#222222" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#F0F0F5" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#F0F0F5" andAlpha:1.0] andButtonTitle:title andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
    
    return grayBackgroundColorMode;
}

#pragma mark --Internal Function--

- (NSView *)line {
    NSView *line1 = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
    line1.wantsLayer = YES;
    line1.layer.backgroundColor = [NSColor colorWithString:@"#F0F0F5" andAlpha:1.0].CGColor;
    
    return line1;
}

- (void)updateCompleteButtonStyleUsingSelectedUserNumber:(NSInteger)selectedUserNumber {
    NSString *buttonTile;
    if(selectedUserNumber > 0) {
        buttonTile = [NSString stringWithFormat:@"%@ （%ld）",NSLocalizedString(@"FM_DONE", @" Done"), selectedUserNumber];
    } else {
        buttonTile = [NSString stringWithFormat:NSLocalizedString(@"FM_DONE", @" Done")];
    }
        self.completeButton.enabled = YES;
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andButtonTitle:buttonTile andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];;
        
        [self.completeButton updateButtonWithButtonMode:normalMode];
//    } else {
//        self.completeButton.enabled = NO;
//        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#D7DADD" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#D7DADD" andAlpha:1.0] andButtonTitle:@"完成" andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
//        [self.completeButton updateButtonWithButtonMode:hoverMode];
//    }
}

@end
