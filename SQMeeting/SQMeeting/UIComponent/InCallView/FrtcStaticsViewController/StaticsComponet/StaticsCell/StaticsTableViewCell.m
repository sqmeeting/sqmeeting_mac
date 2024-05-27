#import "StaticsTableViewCell.h"
#import "Masonry.h"
#import "FrtcUserDefault.h"

@implementation StaticsTableViewCell

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

- (void)updateCellInfomation:(MediaDetailModel *)model {
    _participantLabel.stringValue = model.participantName;
    NSString *channelName = @"Audio";
    //NSString *channelName = model.pipeName;
    if([model.mediaType isEqualToString:@"apr"]) {
        channelName = @"Audio";
    } else if([model.mediaType isEqualToString:@"aps"]) {
        channelName = @"Audio↑";
    } else if([model.mediaType isEqualToString:@"vps"]) {
        channelName = @"Video↑";
    } else if([model.mediaType isEqualToString:@"vpr"]) {
        channelName = @"Video";
    } else if([model.mediaType isEqualToString:@"vcs"]) {
        channelName = @"Content↑";
    } else if([model.mediaType isEqualToString:@"vcr"]) {
        channelName = @"Content";
    }
    
    _channelLabel.stringValue = channelName;
    _protocolLabel.stringValue = @"123";//model.codec;
    _formatLabel.stringValue = model.resolution;
    if([model.mediaType containsString:@"r"]) {
        _rateLabel.stringValue = @"N/A";
    } else {
        _rateLabel.stringValue = [NSString stringWithFormat:@"%ld",(long)[model.rtpLogicBitRate integerValue]];
    }
 
    _rateUsedLabel.stringValue = [NSString stringWithFormat:@"%ld",(long)[model.rtpActualBitRate integerValue]];
    _packetLostLable.stringValue = [NSString stringWithFormat:@"%ld",(long)[model.frameRate integerValue]];
    if([model.mediaType containsString:@"apr"]) {
        _jitterLabel.stringValue =[NSString stringWithFormat:@"%ld(%ld%%)%ld(%ld%%)",(long)[model.packageLoss integerValue], (long)[model.packageLossRate integerValue], (long)[model.logicPacketLoss integerValue], (long)[model.logicPacketLossRate integerValue]];
    } else {
        _jitterLabel.stringValue =[NSString stringWithFormat:@"%ld(%ld%%)",(long)[model.packageLoss integerValue], (long)[model.packageLossRate integerValue]];
    }
    _errorConcealmentLable.stringValue = [NSString stringWithFormat:@"%ld",(long)[model.jitter integerValue]];
}

- (void)configStaticTagTypeCell {
    [self.participantLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(24);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(38);
    }];
    
    [self.channelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(227);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(38);
    }];
    
    [self.formatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(307);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(38);
    }];
    
    [self.rateUsedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(411);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(38);
    }];
    
    [self.packetLostLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(502);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(38);
    }];
    
    [self.jitterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset([self distance]);
        make.width.mas_equalTo(115);
        make.height.mas_equalTo(38);
      }];
    
    [self.errorConcealmentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(690);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(38);
    }];
}

- (CGFloat)distance {
    NSString * language = [FMLanguageConfig userLanguage] ? : [NSLocale preferredLanguages].firstObject;
    
    if([language hasPrefix:@"en"]) {
        return 595.0;
    } else {
        return 575.0;
    }
}

- (StaticsTextField *)textField1 {
    StaticsTextField *testField = [[StaticsTextField alloc] init];
    testField.font = [NSFont fontWithName:@"Helvetica" size:14.0];
    testField.backgroundColor = [NSColor clearColor];
    testField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
    testField.editable = NO;
    testField.bordered = NO;
    
    testField.alignment = NSTextAlignmentLeft;
    
    return testField;
}

- (StaticsTextField *)participantLabel {
    if(!_participantLabel) {
        _participantLabel = [self textField1];
        _participantLabel.stringValue = @"remote";
        [self addSubview:_participantLabel];
    }
    return _participantLabel;
}

- (StaticsTextField *)channelLabel {
    if(!_channelLabel) {
        _channelLabel = [self textField1];
        _channelLabel.stringValue = @"-";
        [self addSubview:_channelLabel];
    }
    return _channelLabel;
}

- (StaticsTextField *)protocolLabel {
    if(!_protocolLabel) {
        _protocolLabel = [self textField1];;
        _protocolLabel.stringValue = @"-";
        [self addSubview:_protocolLabel];
    }
    return _protocolLabel;
}

- (StaticsTextField *)formatLabel {
    if(!_formatLabel) {
        _formatLabel = [self textField1];
        _formatLabel.stringValue = @"—";
        [self addSubview:_formatLabel];
    }
    return _formatLabel;
}

- (StaticsTextField *)rateLabel {
    if(!_rateLabel) {
        _rateLabel = [self textField1];
        _rateLabel.stringValue = @"64";
        [self addSubview:_rateLabel];
    }
    return _rateLabel;
}

- (StaticsTextField *)rateUsedLabel {
    if(!_rateUsedLabel) {
        _rateUsedLabel = [self textField1];
        _rateUsedLabel.stringValue = @"60";
        [self addSubview:_rateUsedLabel];
    }
    return _rateUsedLabel;
}

- (StaticsTextField *)packetLostLable {
    if(!_packetLostLable) {
        _packetLostLable = [self textField1];
        _packetLostLable.stringValue = @"0(0%)";
        [self addSubview:_packetLostLable];
    }
    return _packetLostLable;
}

- (StaticsTextField *)jitterLabel {
    if(!_jitterLabel) {
        _jitterLabel = [self textField1];
        _jitterLabel.stringValue = @"0";
        [self addSubview:_jitterLabel];
    }
    return _jitterLabel;
}

- (StaticsTextField *)errorConcealmentLable {
    if(!_errorConcealmentLable) {
        _errorConcealmentLable = [self textField1];
        _errorConcealmentLable.stringValue = @"-";
        [self addSubview:_errorConcealmentLable];
    }
    return _errorConcealmentLable;
}

- (StaticsTextField *)encryptedLabel {
    if(!_encryptedLabel) {
        _encryptedLabel = [self textField1];
        _encryptedLabel.stringValue = DISABLE;
        [self addSubview:_encryptedLabel];
    }
    return _encryptedLabel;
}

@end
