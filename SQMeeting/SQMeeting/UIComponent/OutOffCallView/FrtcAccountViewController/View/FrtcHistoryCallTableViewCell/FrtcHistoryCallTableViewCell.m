#import "FrtcHistoryCallTableViewCell.h"
#import "FrtcDefaultTextField.h"
#import "FrtcBackGroundView.h"

@interface FrtcHistoryCallTableViewCell ()

@property (nonatomic, strong) FrtcBackGroundView    *backgroundView;
@property (nonatomic, strong) FrtcMultiTypesButton              *removeMeetingButton;
@property (nonatomic, strong) NSView                *lineView;

@end

@implementation FrtcHistoryCallTableViewCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)init {
    if(self = [super init]) {
        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited;
        
        NSRect rect = NSMakeRect(0, 0, 356, 80);
        NSTrackingArea *focusTrackingArea = [[NSTrackingArea alloc] initWithRect:rect
                                                                         options:focusTrackingAreaOptions owner:self userInfo:nil];
        [self addTrackingArea:focusTrackingArea];
        
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor whiteColor].CGColor;
        [self configHistoryCallCellLayout];
    }
    return self;
}

#pragma mark  -- mouse evetn--
- (void)mouseEntered:(NSEvent *)event {
    [[NSCursor pointingHandCursor] set];
    //_mouseIn = YES;
}

- (void)mouseExited:(NSEvent *)event {
    [[NSCursor arrowCursor] set];
   // _mouseIn = NO;
}

- (void)configHistoryCallCellLayout {
    [self.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(356);
        make.height.mas_equalTo(80);
    }];
    
    [self.numberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backgroundView.mas_left).offset(12);
        make.top.mas_equalTo(self.backgroundView.mas_top).offset(6);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.numberTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.numberLabel.mas_right).offset(-2);
        make.top.mas_equalTo(self.backgroundView.mas_top).offset(6);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.meetingNameTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backgroundView.mas_left).offset(12);
        make.top.mas_equalTo(self.numberTextField.mas_bottom).offset(8);
        make.width.mas_equalTo(270);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.timeTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backgroundView.mas_left).offset(12);
        make.top.mas_equalTo(self.meetingNameTextField.mas_bottom).offset(8);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.joinMeetingButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.backgroundView.mas_right).offset(-12);
        make.top.mas_equalTo(self.backgroundView.mas_top).offset(14);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(22);
    }];
    
    [self.removeMeetingButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.backgroundView.mas_right).offset(-12);
        make.top.mas_equalTo(self.joinMeetingButton.mas_bottom).offset(8);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(22);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(88);
        make.width.mas_equalTo(332);
        make.height.mas_equalTo(1);
    }];
}
#pragma mark --Button Sender--
- (void)onRemovePressed:(FrtcMultiTypesButton *)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(removeCallHistoryAtRow:)]) {
        [self.delegate removeCallHistoryAtRow:self.row];
    }
}

- (void)onJoinVideoMeetingPressed:(FrtcMultiTypesButton *)sender {
    sender.enabled = NO;
    if(self.delegate && [self.delegate respondsToSelector:@selector(joinMeetingAtRow:)]) {
        [self.delegate joinMeetingAtRow:self.row];
    }
}

#pragma mark --Lazy getter--
- (FrtcBackGroundView *)backgroundView {
    if(!_backgroundView) {
        _backgroundView = [[FrtcBackGroundView alloc] initWithFrame:NSMakeRect(0, 0, 356, 80)];
        _backgroundView.wantsLayer = YES;
        _backgroundView.layer.masksToBounds = YES;
        _backgroundView.layer.cornerRadius = 8.0;
        [self addSubview:_backgroundView];
    }
    
    return _backgroundView;;
}

- (NSTextField *)numberLabel {
    if (!_numberLabel){
        _numberLabel = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _numberLabel.backgroundColor = [NSColor clearColor];
        _numberLabel.font = [NSFont systemFontOfSize:12 weight:NSFontWeightMedium];
        _numberLabel.alignment = NSTextAlignmentLeft;
        _numberLabel.textColor = [NSColor colorWithString:@"#999999" andAlpha:1.0];
        _numberLabel.editable = NO;
        _numberLabel.bordered = NO;
        _numberLabel.wantsLayer = NO;
        _numberLabel.stringValue = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"FM_MEETING_NUMBER", @"Meeting ID")];;
        [self.backgroundView addSubview:_numberLabel];
    }
    
    return _numberLabel;
}

- (NSTextField *)numberTextField {
    if (!_numberTextField){
        _numberTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _numberTextField.backgroundColor = [NSColor clearColor];
        _numberTextField.font = [NSFont systemFontOfSize:12 weight:NSFontWeightMedium];
        _numberTextField.alignment = NSTextAlignmentLeft;
        _numberTextField.textColor = [NSColor colorWithString:@"#999999" andAlpha:1.0];
        _numberTextField.editable = NO;
        _numberTextField.bordered = NO;
        _numberTextField.wantsLayer = NO;
        [self.backgroundView addSubview:_numberTextField];
    }
    
    return _numberTextField;
}

- (NSTextField *)meetingNameTextField {
    if (!_meetingNameTextField){
        _meetingNameTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _meetingNameTextField.backgroundColor = [NSColor clearColor];
        _meetingNameTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightSemibold];
        _meetingNameTextField.alignment = NSTextAlignmentLeft;
        _meetingNameTextField.textColor = [NSColor colorWithString:@"#444444" andAlpha:1.0];
        _meetingNameTextField.maximumNumberOfLines = 1;
        _meetingNameTextField.lineBreakMode = NSLineBreakByTruncatingTail;
        _meetingNameTextField.editable = NO;
        _meetingNameTextField.bordered = NO;
        _meetingNameTextField.wantsLayer = NO;
        _meetingNameTextField.stringValue = @"会议名称 frtcmeeting";
        [self.backgroundView addSubview:_meetingNameTextField];
    }
    
    return _meetingNameTextField;
}

- (NSTextField *)timeTextField {
    if (!_timeTextField){
        _timeTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _timeTextField.backgroundColor = [NSColor clearColor];
        _timeTextField.font = [NSFont systemFontOfSize:12 weight:NSFontWeightRegular];
        _timeTextField.alignment = NSTextAlignmentLeft;
        _timeTextField.textColor = [NSColor colorWithString:@"#999999" andAlpha:1.0];
        _timeTextField.editable = NO;
        _timeTextField.bordered = NO;
        _timeTextField.wantsLayer = NO;
        [self.backgroundView addSubview:_timeTextField];
    }
    
    return _timeTextField;
}

- (FrtcMultiTypesButton *)joinMeetingButton {
    if (!_joinMeetingButton){
        _joinMeetingButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 48, 22) withTitle:NSLocalizedString(@"FM_JOIN", @"Join")];
        _joinMeetingButton.target = self;
        _joinMeetingButton.layer.cornerRadius = 4.0;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_JOIN", @"Join")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[[FrtcBaseImplement baseImpleSingleton] whiteColor]
                          range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:12]
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [_joinMeetingButton setAttributedTitle:attrTitle];
        _joinMeetingButton.action = @selector(onJoinVideoMeetingPressed:);
        [self.backgroundView addSubview:_joinMeetingButton];
    }
    
    return _joinMeetingButton;
}

- (FrtcMultiTypesButton*)removeMeetingButton {
    if (!_removeMeetingButton){
        _removeMeetingButton = [[FrtcMultiTypesButton alloc] initForthWithFrame:CGRectMake(0, 0, 48, 22) withTitle:NSLocalizedString(@"FM_REMOVE", @"Remove")];
        _removeMeetingButton.target = self;
        _removeMeetingButton.layer.cornerRadius = 4.0;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_REMOVE", @"Remove")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#666666" andAlpha:1.0]
                          range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:12]
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [_removeMeetingButton setAttributedTitle:attrTitle];
        //_removeMeetingButton.layer.backgroundColor = [NSColor colorWithString:@"#F8F9FA" andAlpha:1.0].CGColor;
        //_removeMeetingButton.bordered = YES;
        _removeMeetingButton.action = @selector(onRemovePressed:);
        _removeMeetingButton.layer.borderColor = [NSColor colorWithString:@"#CCCCCC" andAlpha:1.0].CGColor;
        [self.backgroundView addSubview:_removeMeetingButton];
    }
    return _removeMeetingButton;
}

- (NSView *)lineView {
    if(!_lineView) {
        _lineView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 332, 1)];
        _lineView.wantsLayer = YES;
        _lineView.layer.backgroundColor = [NSColor colorWithString:@"#EEEFF0" andAlpha:1.0].CGColor;
        [self addSubview:_lineView];
    }
    
    return _lineView;
}

@end
