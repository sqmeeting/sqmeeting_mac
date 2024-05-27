//
//  FrtcStaticsViewController.m
//  FrtcMeeting
//
//  Created by yafei on 2022/1/22.
//  Copyright © 2022 Frtc Team. All rights reserved.
//

#import "FrtcStaticsViewController.h"

@interface FrtcStaticsViewController ()

@end

@implementation FrtcStaticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self setupStaticsViewLayout];
}

- (void)setupStaticsViewLayout {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).mas_equalTo(10);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top).offset(42);
        make.width.mas_equalTo(759);
        make.height.mas_equalTo(1);
    }];
    
    [self.conferenceNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(177);
        make.top.mas_equalTo(self.line1.mas_top).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.mediaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(227);
        make.top.mas_equalTo(self.line1.mas_top).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.formatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(307);
        make.top.mas_equalTo(self.line1.mas_top).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.actualRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(411);
        make.top.mas_equalTo(self.line1.mas_top).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.frameRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(502);
        make.top.mas_equalTo(self.line1.mas_top).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.packetLossLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(575);
        make.top.mas_equalTo(self.line1.mas_top).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.jitterBufferLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(678);
        make.top.mas_equalTo(self.line1.mas_top).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

#pragma mark --Lazy Load--
- (NSTextField *)titleTextField {
    if (!_titleTextField) {
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:16 weight:NSFontWeightMedium];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = @"会议号";
        
        [self.view addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (NSView *)line1 {
    if(!_line1) {
        _line1 = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 759, 1)];
        _line1.wantsLayer = YES;
        _line1.layer.backgroundColor = [NSColor colorWithString:@"#D7DADD" andAlpha:1.0].CGColor;
        
        [self.view addSubview:_line1];
    }
    
    return _line1;
}

- (NSTextField *)conferenceNumberLabel {
    if (!_conferenceNumberLabel) {
        _conferenceNumberLabel = [self firstSectionTextField];
        _conferenceNumberLabel.stringValue = @"会议号";
        
        [self.view addSubview:_conferenceNumberLabel];
    }
    
    return _conferenceNumberLabel;
}

- (NSTextField *)conferenceNumberTextField {
    if (!_conferenceNumberTextField) {
        _conferenceNumberTextField = [self firstSectionBlueTextField];
        
        [self.view addSubview:_conferenceNumberTextField];
    }
    
    return _conferenceNumberTextField;
}

- (NSTextField *)callRateLabel {
    if (!_callRateLabel) {
        _callRateLabel = [self firstSectionTextField];
        _callRateLabel.stringValue = @"呼叫速率";
        
        [self.view addSubview:_callRateLabel];
    }
    
    return _callRateLabel;
}

- (NSTextField *)callRateTextField {
    if (!_callRateTextField) {
        _callRateTextField = [self firstSectionBlueTextField];
        
        [self.view addSubview:_callRateTextField];
    }
    
    return _callRateTextField;
}

- (NSView *)line2 {
    if(!_line2) {
        _line2 = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 759, 1)];
        _line2.wantsLayer = YES;
        _line2.layer.backgroundColor = [NSColor colorWithString:@"#D7DADD" andAlpha:1.0].CGColor;
        
        [self.view addSubview:_line2];
    }
    
    return _line2;
}

- (NSTextField *)participantLabel {
    if(!_participantLabel) {
        _participantLabel = [self secondSectionTextField];
        _participantLabel.stringValue = @"参会者";
        [self.view addSubview:_participantLabel];
    }
    
    return _participantLabel;
}

- (NSTextField *)mediaLabel {
    if(!_mediaLabel) {
        _mediaLabel = [self secondSectionTextField];
        _mediaLabel.stringValue = @"媒体";
        [self.view addSubview:_mediaLabel];
    }
    
    return _mediaLabel;
}

- (NSTextField *)formatLabel {
    if(!_formatLabel) {
        _formatLabel = [self secondSectionTextField];
        _formatLabel.stringValue = @"格式";
        [self.view addSubview:_formatLabel];
    }
    
    return _formatLabel;
}

- (NSTextField *)actualRateLabel {
    if(!_actualRateLabel) {
        _actualRateLabel = [self secondSectionTextField];
        _actualRateLabel.stringValue = @"实际速率";
        [self.view addSubview:_actualRateLabel];
    }
    
    return _actualRateLabel;
}

- (NSTextField *)frameRateLabel {
    if(!_frameRateLabel) {
        _frameRateLabel = [self secondSectionTextField];
        _frameRateLabel.stringValue = @"帧率";
        [self.view addSubview:_frameRateLabel];
    }
    
    return _frameRateLabel;
}

- (NSTextField *)packetLossLabel {
    if(!_packetLossLabel) {
        _packetLossLabel = [self secondSectionTextField];
        _packetLossLabel.stringValue = @"丢包";
        [self.view addSubview:_packetLossLabel];
    }
    
    return _packetLossLabel;
}

- (NSTextField *)jitterBufferLabel {
    if(!_jitterBufferLabel) {
        _jitterBufferLabel = [self secondSectionTextField];
        _jitterBufferLabel.stringValue = @"抖动";
        [self.view addSubview:_jitterBufferLabel];
    }
    
    return _jitterBufferLabel;
}

#pragma mark --Internal Function--
- (NSTextField *)firstSectionTextField {
    NSTextField *firstBlackTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    firstBlackTextField.backgroundColor = [NSColor clearColor];
    firstBlackTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightMedium];
    firstBlackTextField.alignment = NSTextAlignmentCenter;
    firstBlackTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
    firstBlackTextField.bordered = NO;
    firstBlackTextField.editable = NO;
    
    return firstBlackTextField;
}

- (NSTextField *)firstSectionBlueTextField {
    NSTextField *firstBlueTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    firstBlueTextField.backgroundColor = [NSColor clearColor];
    firstBlueTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightRegular];
    firstBlueTextField.alignment = NSTextAlignmentLeft;
    firstBlueTextField.textColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0];
    firstBlueTextField.bordered = NO;
    firstBlueTextField.editable = NO;
    
    return firstBlueTextField;
}

- (NSTextField *)secondSectionTextField {
    NSTextField *secondTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    secondTextField.backgroundColor = [NSColor clearColor];
    secondTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightMedium];
    secondTextField.alignment = NSTextAlignmentLeft;
    secondTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
    secondTextField.bordered = NO;
    secondTextField.editable = NO;
    
    return secondTextField;
}


@end
