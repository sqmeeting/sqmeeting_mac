#import "FrtcInviteUserListViewCell.h"

@interface FrtcInviteUserListViewCell () <HoverImageViewDelegate>

@property (nonatomic, assign, getter=isSelected) BOOL selected;

@end

@implementation FrtcInviteUserListViewCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)init {
    if(self = [super init]) {
        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited;
        
        NSRect rect = NSMakeRect(0, 0, 308, 40);
        NSTrackingArea *focusTrackingArea = [[NSTrackingArea alloc] initWithRect:rect
                                                                         options:focusTrackingAreaOptions owner:self userInfo:nil];
        [self addTrackingArea:focusTrackingArea];
        
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor whiteColor].CGColor;
        self.selected = NO;
        [self configUserListCellLayout];
    }
    
    return self;
}

- (void)configUserListCellLayout {
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectImageView.mas_right).offset(12);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(22);
    }];
    
    [self.userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerImageView.mas_right).offset(13);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)updateBKColor:(BOOL)flag {
    if (flag) {
        self.layer.backgroundColor = [NSColor colorWithString:@"#F8F9FA" andAlpha:1.0].CGColor;
        self.userNameTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
    } else {
        self.layer.backgroundColor = [NSColor whiteColor].CGColor;
        self.userNameTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
    }
}

#pragma mark --HoverImageViewDelegate
- (void)hoverImageViewClickedwithSenderTag:(NSInteger)tag {
    if(self.isSelected) {
        self.selectImageView.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
        self.selected = NO;
    } else {
        self.selectImageView.layer.backgroundColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0].CGColor;
        self.selected = YES;
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(selectedUser:withCellRow:)]) {
        [self.delegate selectedUser:self.selected withCellRow:self.row];
    }
}

- (void)haveSelected {
    self.selectImageView.layer.backgroundColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0].CGColor;
    self.selected = YES;
}

- (void)haveUnSelected {
    self.selectImageView.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
    self.selected = NO;
}

#pragma mark  -- mouse evetn--
- (void)mouseEntered:(NSEvent *)event {
    [[NSCursor pointingHandCursor] set];
    [self updateBKColor:YES];
}

- (void)mouseExited:(NSEvent *)event {
    [[NSCursor arrowCursor] set];
    [self updateBKColor:NO];
}

- (HoverImageView *)selectImageView {
    if(!_selectImageView) {
        _selectImageView = [[HoverImageView alloc] initWithFrame:CGRectMake(0, 0, 15.38, 14.77)];
        _selectImageView.delegate = self;
        _selectImageView.image = [NSImage imageNamed:@"icon-invite-select"];
        [_selectImageView setWantsLayer:YES];
        _selectImageView.layer.borderWidth = 1.0;
        _selectImageView.layer.cornerRadius = 8.0;
        _selectImageView.layer.masksToBounds = YES;
        CGColorRef color = CGColorRetain([NSColor colorWithString:@"#CCCCCC" andAlpha:1.0].CGColor);
        [_selectImageView.layer setBorderColor:color];
        [self addSubview:_selectImageView];
    }
    
    return _selectImageView;
}

- (NSImageView *)headerImageView {
    if(!_headerImageView) {
        _headerImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        _headerImageView.image = [NSImage imageNamed:@"icon-invite-user-header"];
        [self addSubview:_headerImageView];
    }
    
    return _headerImageView;;
}

- (NSTextField *)userNameTextField {
    if(!_userNameTextField) {
        _userNameTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _userNameTextField.backgroundColor = [NSColor clearColor];
        _userNameTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightRegular];
        _userNameTextField.alignment = NSTextAlignmentCenter;
        _userNameTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _userNameTextField.bordered = NO;
        _userNameTextField.editable = NO;
        _userNameTextField.stringValue = @"admin";
        [self addSubview:_userNameTextField];
    }
    
    return _userNameTextField;
}

@end
