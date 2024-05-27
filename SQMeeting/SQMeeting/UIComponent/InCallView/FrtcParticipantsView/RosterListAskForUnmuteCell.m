#import "RosterListAskForUnmuteCell.h"

@interface RosterListAskForUnmuteCell() <HoverImageViewDelegate>

@end

@implementation RosterListAskForUnmuteCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)init {
    if(self = [super init]) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor colorWithString:@"#E1EDFF" andAlpha:1.0].CGColor;
        [self configCellLayout];
        
        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited;
        
        NSRect rect = NSMakeRect(0, 0, 388, 40);
        NSTrackingArea *focusTrackingArea = [[NSTrackingArea alloc] initWithRect:rect
                                                                         options:focusTrackingAreaOptions owner:self userInfo:nil];
        [self addTrackingArea:focusTrackingArea];
    }
    return self;
}

#pragma mark --RosterListLayout--
- (void)configCellLayout {
    [self.spliteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top);
        make.width.mas_equalTo(341);
        make.height.mas_equalTo(1);
    }];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(24);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.participantName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(52);
        make.width.mas_equalTo(250);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.viewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-24);
        make.centerY.mas_equalTo(self.participantName.mas_centerY);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(24);
    }];
    
    [self.showNewComingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.viewButton.mas_right).offset(-4);
        make.bottom.mas_equalTo(self.viewButton.mas_top).offset(4);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(8);
    }];
}

#pragma mark -- Button Sender --
- (void)onViewBtnPressed {
    self.showNewComingView.hidden = YES;
    if(self.delegate && [self.delegate respondsToSelector:@selector(viewAllAskForMuteList)]) {
        [self.delegate viewAllAskForMuteList];
    }
}

#pragma mark -- lazy load--
- (NSImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[HoverImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _headerImageView.delegate = self;
        _headerImageView.image = [NSImage imageNamed:@"icon_mute_lock"];
        [self addSubview:_headerImageView];
    }
        
    return _headerImageView;
}

- (NSTextField *)participantName {
    if (!_participantName) {
        _participantName = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _participantName.backgroundColor = [NSColor clearColor];
        _participantName.font = [NSFont systemFontOfSize:14 weight:NSFontWeightRegular];
        _participantName.alignment = NSTextAlignmentLeft;
        _participantName.lineBreakMode = NSLineBreakByTruncatingTail;
        _participantName.textColor = [NSColor colorWithString:@"#0465E6" andAlpha:1.0];
        _participantName.bordered = NO;
        _participantName.editable = NO;
        _participantName.stringValue = @"limeimei12美美李 正在申请解除静音";
        [self addSubview:_participantName];
    }
    
    return _participantName;;
}

- (FrtcMultiTypesButton *)viewButton {
    if (!_viewButton) {
        _viewButton = [[FrtcMultiTypesButton alloc] initThirdWithFrame:CGRectMake(0, 0, 0, 0) withTitle:NSLocalizedString(@"FM_VIEW_ASK_FRO_UN_MUTE_LIST", @"View")];
        _viewButton.target = self;
        _viewButton.action = @selector(onViewBtnPressed);
        
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_VIEW_ASK_FRO_UN_MUTE_LIST", @"View")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"026FFE" andAlpha:1.0] range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:12] range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
        [attrTitle fixAttributesInRange:range];
        [_viewButton setAttributedTitle:attrTitle];
        _viewButton.layer.cornerRadius = 4.0f;
        _viewButton.layer.borderWidth = 1.0;
        _viewButton.layer.masksToBounds = YES;
        _viewButton.layer.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] whiteColor].CGColor;
        _viewButton.layer.borderColor = [NSColor colorWithString:@"026FFE" andAlpha:1.0].CGColor;
        [self addSubview:_viewButton];
    }
    
    return _viewButton;
}

- (NSImageView *)showNewComingView {
    if (!_showNewComingView) {
        _showNewComingView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        _showNewComingView.wantsLayer = YES;
        _showNewComingView.layer.cornerRadius = 4.0;
        _showNewComingView.layer.masksToBounds = YES;
        _showNewComingView.layer.backgroundColor = [NSColor colorWithString:@"#FA5150" andAlpha:1.0].CGColor;
        [self addSubview:_showNewComingView];
    }
        
    return _showNewComingView;
}

@end
