#import "FrtcPersonView.h"
#import "FrtcPersonalTabCell.h"

@interface FrtcPersonView () <FrtcPersonalTabCellDelegate>

@property (nonatomic, strong) FrtcPersonalTabCell *nameTabCell;

@property (nonatomic, strong) FrtcPersonalTabCell *recordingTabCell;

@property (nonatomic, strong) FrtcPersonalTabCell *accountTabCell;

@property (nonatomic, strong) FrtcPersonalTabCell *passwordTabCell;

@property (nonatomic, strong) FrtcPersonalTabCell *logoutTabCell;

@end

@implementation FrtcPersonView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        [self setupUI];
    }
    
    return self;
}

- (void)setModel:(LoginModel *)model {
    _model = model;
    _nameTabCell.titleView.stringValue = self.model.realName ? self.model.realName : [NSString stringWithFormat:@"%@%@",self.model.lastname, self.model.firstname];
    _accountTabCell.detailTextField.stringValue = self.model.username;
}

#pragma mark -- setup UI
- (void)setupUI {
    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor colorWithString:@"ffffff" andAlpha:1].CGColor;
    [self setupPersonalViewCellLayout];
}

- (void)setupPersonalViewCellLayout {
    [self.nameTabCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(23);
        make.size.mas_equalTo(NSMakeSize(258, 32));
    }];
    
    [self.accountTabCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.nameTabCell.mas_bottom).offset(12);
        make.size.mas_equalTo(NSMakeSize(258, 32));
    }];
    
    [self.recordingTabCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.accountTabCell.mas_bottom).offset(12);
        make.size.mas_equalTo(NSMakeSize(258, 32));
    }];
    
    [self.passwordTabCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.recordingTabCell.mas_bottom).offset(12);
        make.size.mas_equalTo(NSMakeSize(258, 32));
    }];
    
    [self.logoutTabCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.passwordTabCell.mas_bottom).offset(12);
        make.size.mas_equalTo(NSMakeSize(258, 32));
    }];
}

#pragma mark -- FrtcPersonalTabCellDelegate --
- (void)popupWindow {
    if(self.delegate && [self.delegate respondsToSelector:@selector(frtcPopupModifyNameWindow)]) {
        [self.delegate frtcPopupModifyNameWindow];
    }
}

#pragma mark -- FrtcPersonalTabCell Sender --
- (void)logout:(FrtcPersonalTabCell *)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(frtcPersonalLogout)]) {
        [self.delegate frtcPersonalLogout];
    }
}

- (void)updatePassword:(FrtcPersonalTabCell *)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(frtcPersonalupdatePassword)]) {
        [self.delegate frtcPersonalupdatePassword];
    }
}

- (void)onMyRecordings:(FrtcPersonalTabCell *)sender {
    NSString *url = [[FrtcUserDefault defaultSingleton] objectForKey:STORAGE_SERVER_ADDRESS];
    NSString *urlString = [NSString stringWithFormat:@"https://%@", url];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:urlString]];
}

#pragma mark -- getter lazy --
- (FrtcPersonalTabCell *)nameTabCell {
    if(!_nameTabCell) {
        FrtcPersonalModel *model = [FrtcPersonalModel modelWithSelectedImageName:@"icon-account" andDisSelectedImageName:@"icon-account" andTitle:NSLocalizedString(@"FM_NORMAL_SETTING", @"General Settings")];
        _nameTabCell = [[FrtcPersonalTabCell alloc] initWithPersonalControlModel:model];
        _nameTabCell.delegate = self;
        _nameTabCell.personalTag = PersonalNameTag;
        _nameTabCell.imageView.image = [NSImage imageNamed:@"icon-account"];
        _nameTabCell.editImageView.image = [NSImage imageNamed:@"icon-name-edit"];
        _nameTabCell.titleView.textColor = [NSColor colorWithString:@"333333" andAlpha:1.0];
        //_nameTabCell.titleView.stringValue = self.model.username;
        [self addSubview:_nameTabCell];
    }
    
    return _nameTabCell;
}

- (FrtcPersonalTabCell *)accountTabCell {
    if(!_accountTabCell) {
        FrtcPersonalModel *model = [FrtcPersonalModel modelWithSelectedImageName:@"icon_email" andDisSelectedImageName:@"icon_email" andTitle:NSLocalizedString(@"FM_ACCOUNT", @"Account")];
        _accountTabCell = [[FrtcPersonalTabCell alloc] initWithPersonalControlModel:model];
        _accountTabCell.personalTag = PersonalAccountTag;
        //_accountTabCell.delegate = self;
        _accountTabCell.imageView.image = [NSImage imageNamed:@"icon_email"];
        _accountTabCell.editImageView.hidden = YES;
        _accountTabCell.titleView.stringValue = NSLocalizedString(@"FM_ACCOUNT", @"Account");
        _accountTabCell.titleView.textColor = [NSColor colorWithString:@"#B6B6B6" andAlpha:1.0];
        _accountTabCell.detailTextField.hidden = NO;
       // _accountTabCell.detailTextField.stringValue = self.model.email;
        [self addSubview:_accountTabCell];
    }
    
    return _accountTabCell;
}

- (FrtcPersonalTabCell *)recordingTabCell {
    if(!_recordingTabCell) {
        FrtcPersonalModel *model = [FrtcPersonalModel modelWithSelectedImageName:@"icon_recording_selected" andDisSelectedImageName:@"icon_recording_un_selected" andTitle:NSLocalizedString(@"FM_ACCOUNT", @"Account")];
        _recordingTabCell = [[FrtcPersonalTabCell alloc] initWithPersonalControlModel:model];
        _recordingTabCell.personalTag = PersonalRecordingTag;
        _recordingTabCell.target = self;
        _recordingTabCell.action = @selector(onMyRecordings:);
        _recordingTabCell.imageView.image = [NSImage imageNamed:@"icon_recording_un_selected"];
        _recordingTabCell.editImageView.hidden = YES;
        _recordingTabCell.titleView.stringValue = NSLocalizedString(@"FM_VIDEO_MY_RECORDING", @"My Recordings");
        _recordingTabCell.titleView.textColor = [NSColor colorWithString:@"#B6B6B6" andAlpha:1.0];
        _recordingTabCell.detailTextField.hidden = NO;
       // _accountTabCell.detailTextField.stringValue = self.model.email;
        [self addSubview:_recordingTabCell];
    }
    
    return _recordingTabCell;
}

- (FrtcPersonalTabCell *)passwordTabCell {
    if(!_passwordTabCell) {
        FrtcPersonalModel *model = [FrtcPersonalModel modelWithSelectedImageName:@"icon-select-password" andDisSelectedImageName:@"icon-unselect" andTitle:NSLocalizedString(@"FM_ABOUT_US", @"About Us")];
        _passwordTabCell = [[FrtcPersonalTabCell alloc] initWithPersonalControlModel:model];
        _passwordTabCell.personalTag = PersonalPasswordTag;
        _passwordTabCell.imageView.image = [NSImage imageNamed:@"icon-unselect"];
        _passwordTabCell.titleView.stringValue = NSLocalizedString(@"FM_MODIFY_PASSWORD", @"Update password");
        _passwordTabCell.titleView.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _passwordTabCell.editImageView.hidden = YES;
        _passwordTabCell.target = self;
        _passwordTabCell.action = @selector(updatePassword:);
        [self addSubview:_passwordTabCell];
    }
    
    return _passwordTabCell;
}

- (FrtcPersonalTabCell *)logoutTabCell {
    if(!_logoutTabCell) {
        FrtcPersonalModel *model = [FrtcPersonalModel modelWithSelectedImageName:@"icon-logout" andDisSelectedImageName:@"icon-un-logout" andTitle:NSLocalizedString(@"FM_ABOUT_US", @"About Us")];
        _logoutTabCell = [[FrtcPersonalTabCell alloc] initWithPersonalControlModel:model];
        _logoutTabCell.personalTag = PersonalLogoutTag;
        _logoutTabCell.imageView.image = [NSImage imageNamed:@"icon-un-logout"];
        _logoutTabCell.titleView.stringValue = NSLocalizedString(@"FM_SIGN_OUT", @"Sign Out");
        _logoutTabCell.titleView.textColor = [NSColor colorWithString:@"333333" andAlpha:1.0];
        _logoutTabCell.editImageView.hidden = YES;
        _logoutTabCell.target = self;
        _logoutTabCell.action = @selector(logout:);
        [self addSubview:_logoutTabCell];
    }
    
    return _logoutTabCell;
}



@end
