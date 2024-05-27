#import "FrtcRequetUnMuteTitleCell.h"
#import "StaticsTextField.h"

@interface FrtcRequetUnMuteTitleCell ()

@property (nonatomic, strong) StaticsTextField *participantLabel;

@property (nonatomic, strong) StaticsTextField *requestLabel;

@property (nonatomic, strong) StaticsTextField *actionLabel;

@property (nonatomic, strong) NSView *lineView;

@end

@implementation FrtcRequetUnMuteTitleCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)init {
    if(self = [super init]) {
        [self configStaticTagTypeCell];
        self.wantsLayer = YES;
    }
    
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if(self = [super initWithFrame:frameRect]) {
        [self configStaticTagTypeCell];
        self.wantsLayer = YES;
    }
    
    return self;
}

- (void)configStaticTagTypeCell {
    [self.participantLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(16);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    
    [self.requestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(280);
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(20);
    }];
    
    [self.actionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(384);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(20);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(self.mas_left);
        make.width.mas_equalTo(448);
        make.height.mas_equalTo(1);
    }];
}

- (StaticsTextField *)textField1 {
    StaticsTextField *testField = [[StaticsTextField alloc] init];
    testField.font = [NSFont systemFontOfSize:13 weight:NSFontWeightMedium];
    testField.backgroundColor = [NSColor clearColor];
    testField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
    testField.editable = NO;
    testField.bordered = NO;
    
    testField.alignment = NSTextAlignmentLeft;
        
    return testField;
}

- (StaticsTextField *)participantLabel {
    if(!_participantLabel) {
        _participantLabel = [self textField1];
        _participantLabel.stringValue = NSLocalizedString(@"FM_ASK_FOR_UN_MUTE_ROSTER", @"Participants");
        [self addSubview:_participantLabel];
    }
    
    return _participantLabel;
}

- (StaticsTextField *)requestLabel {
    if(!_requestLabel) {
        _requestLabel = [self textField1];
        _requestLabel.stringValue = NSLocalizedString(@"FM_ASK_FOR_UN_MUTE_ASK_STATUS", @"Requests");
        [self addSubview:_requestLabel];
    }
    
    return _requestLabel;
}

- (StaticsTextField *)actionLabel {
    if(!_actionLabel) {
        _actionLabel = [self textField1];
        _actionLabel.stringValue = NSLocalizedString(@"FM_ASK_FOR_UN_MUTE_ASK_ACTION", @"Action");
        [self addSubview:_actionLabel];
    }
    
    return _actionLabel;
}



- (NSView *)lineView {
    if(!_lineView) {
        _lineView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 1, 448)];
        _lineView.wantsLayer = YES;
        _lineView.layer.backgroundColor = [NSColor colorWithString:@"#D7DADD" andAlpha:1].CGColor;
        [self addSubview:_lineView];
    }
    
    return _lineView;
}


@end
