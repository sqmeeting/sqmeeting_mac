#import "AccountView.h"


@interface AccountView()<FrtcPersonalTabCellDelegate>

@end

@implementation AccountView

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

#pragma mark -- setup UI
- (void)setupUI {
    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor colorWithString:@"ffffff" andAlpha:1].CGColor;
    [self setupPersonalViewCellLayout];
}

- (void)setupPersonalViewCellLayout {
    [self.nameTabCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(16);
        make.size.mas_equalTo(NSMakeSize(422, 40));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(33);
        make.top.mas_equalTo(self.nameTabCell.mas_bottom);
        make.size.mas_equalTo(NSMakeSize(389, 1));
    }];
    
    [self.accountTabCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.line.mas_bottom);
        make.size.mas_equalTo(NSMakeSize(422, 40));
    }];
    
    [self.passwordTabCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.accountTabCell.mas_bottom).offset(8);
        make.size.mas_equalTo(NSMakeSize(422, 40));
    }];
    
    [self.logoutTabCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.passwordTabCell.mas_bottom).offset(8);
        make.size.mas_equalTo(NSMakeSize(422, 40));
    }];
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

#pragma mark -- getter lazy --
- (FrtcPersonalTabCell *)nameTabCell {
    if(!_nameTabCell) {
        FrtcPersonalModel *model = [FrtcPersonalModel modelWithSelectedImageName:@"icon_name" andDisSelectedImageName:@"icon_name" andTitle:NSLocalizedString(@"FM_MEETING_NAME", @"Name")];
        _nameTabCell = [[FrtcPersonalTabCell alloc] initWithPersonalControlModel:model];
        //_nameTabCell.delegate = self;
        _nameTabCell.personalTag = PersonalNameTag;
        _nameTabCell.imageView.image = [NSImage imageNamed:@"icon_name"];
        _nameTabCell.editImageView.image = [NSImage imageNamed:@"icon-name-edit"];
        _nameTabCell.titleView.stringValue = NSLocalizedString(@"FM_MEETING_NAME", @"Name");
        _nameTabCell.titleView.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
        _nameTabCell.editImageView.hidden = YES;
        //_nameTabCell.titleView.textColor = [NSColor colorWithString:@"333333" andAlpha:1.0];
        _nameTabCell.detailTextField.hidden = NO;
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
        _accountTabCell.titleView.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
        _accountTabCell.detailTextField.hidden = NO;
       // _accountTabCell.detailTextField.stringValue = self.model.email;
        [self addSubview:_accountTabCell];
    }
    
    return _accountTabCell;
}


- (FrtcPersonalTabCell *)passwordTabCell {
    if(!_passwordTabCell) {
        FrtcPersonalModel *model = [FrtcPersonalModel modelWithSelectedImageName:@"icon_password" andDisSelectedImageName:@"icon_unselect_password" andTitle:NSLocalizedString(@"FM_MODIFY_PASSWORD", @"Update password")];
        _passwordTabCell = [[FrtcPersonalTabCell alloc] initWithPersonalControlModel:model];
        _passwordTabCell.personalTag = PersonalPasswordTag;
        _passwordTabCell.imageView.image = [NSImage imageNamed:@"icon_unselect_password"];
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

- (NSView *)line {
    if(!_line) {
        _line = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
        _line.wantsLayer = YES;
        _line.layer.backgroundColor = [NSColor colorWithString:@"#F0F0F5" andAlpha:1.0].CGColor;
        [self addSubview:_line];
    }
    
    return _line;
}

@end
