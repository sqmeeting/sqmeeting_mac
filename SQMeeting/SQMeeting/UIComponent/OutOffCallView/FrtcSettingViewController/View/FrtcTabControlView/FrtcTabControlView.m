#import "FrtcTabControlView.h"
#import "FrtcTabCell.h"
#import "NSColor+Enhancement.h"
#import "FrtcTabControlModel.h"

@interface FrtcTabControlView () <FrtcTabCellDelegate> {
    FrtcTabCell *_selectedCell;
}

@property (nonatomic, strong) FrtcTabCell *settingNormalTabCell;

@property (nonatomic, strong) FrtcTabCell *settingMediaCell;

@property (nonatomic, strong) FrtcTabCell *settingVideoCell;

@property (nonatomic, strong) FrtcTabCell *settingAboutCell;

@property (nonatomic, strong) FrtcTabCell *liveFeatureCell;

@property (nonatomic, strong) FrtcTabCell *recordingCell;

@property (nonatomic, strong) FrtcTabCell *accountCell;

@property (nonatomic, strong) FrtcTabCell *diagnosisCell;

@end

@implementation FrtcTabControlView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)init {
    self = [super init];
    
    if(self) {
        [self setupUI];
    }
    
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        [self setupUI];
    }
    
    return self;
}

- (BOOL)isFlipped {
    return YES;
}

- (instancetype)initWithFrame:(NSRect)frameRect withLoginStatus:(BOOL)loginStatus withSettingType:(FrtcSettingType)type {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        self.login       = loginStatus;
        self.settingType = type;
        [self setupUI];
    }
    
    return self;
}

#pragma mark -- Class Interface--
- (void)updateLayout:(BOOL)enableLabFeature {
    if(enableLabFeature) {
        self.recordingCell.hidden = NO;
        [self.recordingCell mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.top.mas_equalTo(self.settingMediaCell.mas_bottom).offset(12);
            make.size.mas_equalTo(NSMakeSize(153, 32));
        }];
        
        [self.liveFeatureCell mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.top.mas_equalTo(self.recordingCell.mas_bottom).offset(12);
            make.size.mas_equalTo(NSMakeSize(153, 32));
        }];
    } else {
        self.recordingCell.hidden = YES;
        [self.liveFeatureCell mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.top.mas_equalTo(self.settingMediaCell.mas_bottom).offset(12);
            make.size.mas_equalTo(NSMakeSize(153, 32));
        }];
    }
}

#pragma mark -- setup UI
- (void)setupUI {
    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor colorWithString:@"ffffff" andAlpha:1].CGColor;
    [self setupTabCellLayout];
}

- (void)setupTabCellLayout {
    if(self.settingType == SettingTypeGuest) {
        [self layoutForGuest];
    } else if(self.settingType == SettingTypeLogin) {
        [self layoutForLoginUser];
    } else if(self.settingType == SettingTypeGuestCall) {
        [self layoutForGuestCall];
        [self.settingVideoCell selected];
       // [self.settingNormalTabCell disSelected];
        _selectedCell = self.settingVideoCell;
        
        
    } else if(self.settingType == SettingTypeLoginCall) {
        [self layoutForLoginUserCall];
        [self.settingVideoCell selected];
        //[self.settingNormalTabCell disSelected];
        _selectedCell = self.settingVideoCell;
    }
}

- (void)layoutForGuest {
    [self.settingNormalTabCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(NSMakeSize(153, 32));
    }];
    
    [self.settingVideoCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.settingNormalTabCell.mas_bottom).offset(12);
        make.size.mas_equalTo(NSMakeSize(153, 32));
    }];
    
    [self.settingMediaCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.settingVideoCell.mas_bottom).offset(12);
        make.size.mas_equalTo(NSMakeSize(153, 32));
    }];
    
    [self.diagnosisCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.settingMediaCell.mas_bottom).offset(12);
        make.size.mas_equalTo(NSMakeSize(153, 32));
    }];
    
    [self.settingAboutCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.diagnosisCell.mas_bottom).offset(12);
        make.size.mas_equalTo(NSMakeSize(153, 32));
    }];
}

- (void)layoutForGuestCall {
    [self.settingVideoCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(NSMakeSize(153, 32));
    }];
    
    [self.settingMediaCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.settingVideoCell.mas_bottom).offset(12);
        make.size.mas_equalTo(NSMakeSize(153, 32));
    }];
    
    [self.settingAboutCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.settingMediaCell.mas_bottom).offset(12);
        make.size.mas_equalTo(NSMakeSize(153, 32));
    }];
}

- (void)layoutForLoginUser {
    [self.settingNormalTabCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(NSMakeSize(153, 32));
    }];
    
    [self.settingVideoCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.settingNormalTabCell.mas_bottom).offset(12);
        make.size.mas_equalTo(NSMakeSize(153, 32));
    }];
    
    [self.settingMediaCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.settingVideoCell.mas_bottom).offset(12);
        make.size.mas_equalTo(NSMakeSize(153, 32));
    }];
    
    [self.recordingCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.settingMediaCell.mas_bottom).offset(12);
        make.size.mas_equalTo(NSMakeSize(153, 32));
    }];
    
    [self.accountCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.recordingCell.mas_bottom).offset(12);
        make.size.mas_equalTo(NSMakeSize(153, 32));
    }];
    
    [self.diagnosisCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.accountCell.mas_bottom).offset(12);
        make.size.mas_equalTo(NSMakeSize(153, 32));
    }];
    
    [self.settingAboutCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.diagnosisCell.mas_bottom).offset(12);
        make.size.mas_equalTo(NSMakeSize(153, 32));
    }];
}

- (void)layoutForLoginUserCall {
    [self.settingVideoCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(NSMakeSize(153, 32));
    }];
    
    [self.settingMediaCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.settingVideoCell.mas_bottom).offset(12);
        make.size.mas_equalTo(NSMakeSize(153, 32));
    }];
    
    [self.recordingCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.settingMediaCell.mas_bottom).offset(12);
        make.size.mas_equalTo(NSMakeSize(153, 32));
    }];
    
    [self.settingAboutCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.recordingCell.mas_bottom).offset(12);
        make.size.mas_equalTo(NSMakeSize(153, 32));
    }];
}

#pragma mark -- tabCell delegate
- (void)didSelectedCell:(FrtcTabCell *)cell {
    if(cell.tag == SettingNormalTag) {
        if(cell.tag != _selectedCell.tag) {
            if(_selectedCell.tag  == SettingVideoTag) {
                
            } else if(_selectedCell.tag == SettingMediaTag) {
                
            } else if(_selectedCell.tag == SettingAboutTag) {
                
            } else if(_selectedCell.tag == SettingLabTag) {
                
            } else if(_selectedCell.tag == SettingRecordingTag) {
                
            } else if(_selectedCell.tag == SettingAccountTag) {
                
            } else if(_selectedCell.tag == SettingDiagnosis) {
                
            }
        }
    } else if(cell.tag == SettingVideoTag) {
        if(cell.tag != _selectedCell.tag) {
            if(_selectedCell.tag == SettingNormalTag) {
                
            } else if(_selectedCell.tag == SettingMediaTag) {
                
            } else if(_selectedCell.tag == SettingAboutTag) {
               
            } else if(_selectedCell.tag == SettingLabTag) {
                
            } else if(_selectedCell.tag == SettingRecordingTag) {
                
            } else if(_selectedCell.tag == SettingAccountTag) {
                
            } else if(_selectedCell.tag == SettingDiagnosis) {
                
            }
        }
    } else if(cell.tag == SettingMediaTag) {
        if(cell.tag != _selectedCell.tag) {
            if(_selectedCell.tag == SettingNormalTag) {
                
            } else if(_selectedCell.tag == SettingVideoTag) {
                
            } else if(_selectedCell.tag == SettingAboutTag) {
               
            } else if(_selectedCell.tag == SettingLabTag) {
                
            } else if(_selectedCell.tag == SettingRecordingTag) {
                
            } else if(_selectedCell.tag == SettingAccountTag) {
                
            } else if(_selectedCell.tag == SettingDiagnosis) {
                
            }
        }
    } else if(cell.tag == SettingAboutTag) {
        if(cell.tag != _selectedCell.tag) {
            
        }
        
        if(_selectedCell.tag == SettingNormalTag) {
            
        } else if(_selectedCell.tag == SettingVideoTag) {
            
        } else if(_selectedCell.tag == SettingMediaTag){
            
        } else if(_selectedCell.tag == SettingLabTag) {
            
        } else if(_selectedCell.tag == SettingRecordingTag) {
            
        } else if(_selectedCell.tag == SettingAccountTag) {
            
        } else if(_selectedCell.tag == SettingDiagnosis) {
            
        }
    } else if(cell.tag == SettingLabTag) {
        if(cell.tag != _selectedCell.tag) {
            
        }
        
        if(_selectedCell.tag == SettingNormalTag) {
            
        } else if(_selectedCell.tag == SettingVideoTag) {
            
        } else if(_selectedCell.tag == SettingMediaTag){
            
        } else if(_selectedCell.tag == SettingAboutTag) {
            
        } else if(_selectedCell.tag == SettingRecordingTag) {
            
        } else if(_selectedCell.tag == SettingAccountTag) {
            
        } else if(_selectedCell.tag == SettingDiagnosis) {
            
        }
    } else if(cell.tag == SettingRecordingTag) {
        if(cell.tag != _selectedCell.tag) {
            
        }
        
        if(_selectedCell.tag == SettingNormalTag) {
            
        } else if(_selectedCell.tag == SettingVideoTag) {
            
        } else if(_selectedCell.tag == SettingMediaTag){
            
        } else if(_selectedCell.tag == SettingAboutTag) {
            
        } else if(_selectedCell.tag == SettingLabTag) {
            
        } else if(_selectedCell.tag == SettingAccountTag) {
            
        } else if(_selectedCell.tag == SettingDiagnosis) {
            
        }
    } else if(cell.tag == SettingAccountTag) {
        if(cell.tag != _selectedCell.tag) {
            
        }
        
        if(_selectedCell.tag == SettingNormalTag) {
            
        } else if(_selectedCell.tag == SettingVideoTag) {
            
        } else if(_selectedCell.tag == SettingMediaTag){
            
        } else if(_selectedCell.tag == SettingAboutTag) {
            
        } else if(_selectedCell.tag == SettingLabTag) {
            
        } else if(_selectedCell.tag == SettingRecordingTag) {
            
        } else if(_selectedCell.tag == SettingDiagnosis) {
            
        }
    }  else if(cell.tag == SettingDiagnosis) {
        if(cell.tag != _selectedCell.tag) {
            
        }
        
        if(_selectedCell.tag == SettingNormalTag) {
            
        } else if(_selectedCell.tag == SettingVideoTag) {
            
        } else if(_selectedCell.tag == SettingMediaTag){
            
        } else if(_selectedCell.tag == SettingAboutTag) {
            
        } else if(_selectedCell.tag == SettingLabTag) {
            
        } else if(_selectedCell.tag == SettingRecordingTag) {
            
        } else if(_selectedCell.tag == SettingAccountTag) {
            
        }
    }
    
    
    if (_selectedCell == cell) {
        return;
    }
    
    [_selectedCell disSelected];
    _selectedCell = cell;
    [_selectedCell selected];

    if([self.tabControlDelegate respondsToSelector:@selector(didSelectedIndex:)]) {
        [self.tabControlDelegate didSelectedIndex:cell.tag];
    }
}

#pragma mark -- getter lazy --
- (FrtcTabCell *)settingNormalTabCell {
    if(!_settingNormalTabCell) {
        FrtcTabControlModel *model = [FrtcTabControlModel modelWithSelectedImageName:@"icon_setting_on" andDisSelectedImageName:@"icon_setting_off" andTitle:NSLocalizedString(@"FM_NORMAL_SETTING", @"General Settings")];
        _settingNormalTabCell = [[FrtcTabCell alloc] initWithTabControlModel:model];
        _settingNormalTabCell.tag = SettingNormalTag;
        _settingNormalTabCell.imageView.image = [NSImage imageNamed:@"icon_setting_on"];
        _settingNormalTabCell.titleView.stringValue = NSLocalizedString(@"FM_NORMAL_SETTING", @"General Settings");
        _settingNormalTabCell.delegate = self;
        [_settingNormalTabCell selected];
        _selectedCell = _settingNormalTabCell;
        
        [self addSubview:_settingNormalTabCell];
    }
    
    return _settingNormalTabCell;
}

- (FrtcTabCell *)settingMediaCell {
    if(!_settingMediaCell) {
        FrtcTabControlModel *model = [FrtcTabControlModel modelWithSelectedImageName:@"icon_audio_hover" andDisSelectedImageName:@"icon_audio_no_hover" andTitle:NSLocalizedString(@"FM_AUDIO", @"Audio")];
        _settingMediaCell = [[FrtcTabCell alloc] initWithTabControlModel:model];
        _settingMediaCell.tag = SettingMediaTag;
        _settingMediaCell.delegate = self;
        _settingMediaCell.imageView.image = [NSImage imageNamed:@"icon_audio_no_hover"];
        _settingMediaCell.titleView.stringValue = NSLocalizedString(@"FM_AUDIO", @"Audio");
        [self addSubview:_settingMediaCell];
    }
    
    return _settingMediaCell;
}

- (FrtcTabCell *)settingVideoCell {
    if(!_settingVideoCell) {
        FrtcTabControlModel *model = [FrtcTabControlModel modelWithSelectedImageName:@"icon_video_hover" andDisSelectedImageName:@"icon_video_no_hover" andTitle:NSLocalizedString(@"FM_VIDEO", @"Video")];
        _settingVideoCell = [[FrtcTabCell alloc] initWithTabControlModel:model];
        _settingVideoCell.tag = SettingVideoTag;
        _settingVideoCell.delegate = self;
        _settingVideoCell.imageView.image = [NSImage imageNamed:@"icon_video_no_hover"];
        _settingVideoCell.titleView.stringValue = NSLocalizedString(@"FM_VIDEO", @"Video");
        [self addSubview:_settingVideoCell];
    }
    
    return _settingVideoCell;
}

- (FrtcTabCell *)settingAboutCell {
    if(!_settingAboutCell) {
        FrtcTabControlModel *model = [FrtcTabControlModel modelWithSelectedImageName:@"icon_about_on" andDisSelectedImageName:@"icon_about_off" andTitle:NSLocalizedString(@"FM_ABOUT_US", @"About")];
        _settingAboutCell = [[FrtcTabCell alloc] initWithTabControlModel:model];
        _settingAboutCell.tag = SettingAboutTag;
        _settingAboutCell.delegate = self;
        _settingAboutCell.imageView.image = [NSImage imageNamed:@"icon_about_off"];
        _settingAboutCell.titleView.stringValue = NSLocalizedString(@"FM_ABOUT_US", @"About Us");
        [self addSubview:_settingAboutCell];
    }
    
    return _settingAboutCell;
}

- (FrtcTabCell *)liveFeatureCell {
    if(!_liveFeatureCell) {
        FrtcTabControlModel *model = [FrtcTabControlModel modelWithSelectedImageName:@"icon_lab_feature_on" andDisSelectedImageName:@"icon_lab_feature_off" andTitle:NSLocalizedString(@"FM_ABOUT_US", @"About")];
        _liveFeatureCell = [[FrtcTabCell alloc] initWithTabControlModel:model];
        _liveFeatureCell.tag = SettingLabTag;
        _liveFeatureCell.delegate = self;
        _liveFeatureCell.imageView.image = [NSImage imageNamed:@"icon_lab_feature_off"];
        _liveFeatureCell.titleView.stringValue = NSLocalizedString(@"FM_SETTING_ENABLE_LIVE_FEATURE_TAB", @"Lab Feature");
        [self addSubview:_liveFeatureCell];
    }
    
    return _liveFeatureCell;
}

- (FrtcTabCell *)recordingCell {
    if(!_recordingCell) {
        FrtcTabControlModel *model = [FrtcTabControlModel modelWithSelectedImageName:@"icon_recording_selected" andDisSelectedImageName:@"icon_recording_un_selected" andTitle:NSLocalizedString(@"FM_VIDEO_MY_RECORDING", @"My Recordings")];
        _recordingCell = [[FrtcTabCell alloc] initWithTabControlModel:model];
        _recordingCell.tag = SettingRecordingTag;
        _recordingCell.delegate = self;
        _recordingCell.imageView.image = [NSImage imageNamed:@"icon_recording_un_selected"];
        _recordingCell.titleView.stringValue = NSLocalizedString(@"FM_VIDEO_MY_RECORDING", @"My Recordings");
        [self addSubview:_recordingCell];
    }
    
    return _recordingCell;
}

-(FrtcTabCell *)accountCell {
    if(!_accountCell) {
        FrtcTabControlModel *model = [FrtcTabControlModel modelWithSelectedImageName:@"icon-account_selected" andDisSelectedImageName:@"icon_new_account" andTitle:NSLocalizedString(@"FM_ACCOUNT_MANAGEMENT", @"Account management")];
        _accountCell = [[FrtcTabCell alloc] initWithTabControlModel:model];
        _accountCell.tag = SettingAccountTag;
        _accountCell.delegate = self;
        _accountCell.imageView.image = [NSImage imageNamed:@"icon_new_account"];
        _accountCell.titleView.stringValue = NSLocalizedString(@"FM_ACCOUNT_MANAGEMENT", @"Account management");
        [self addSubview:_accountCell];
    }
    
    return _accountCell;
}

-(FrtcTabCell *)diagnosisCell {
    if(!_diagnosisCell) {//icon-account账号管理
        FrtcTabControlModel *model = [FrtcTabControlModel modelWithSelectedImageName:@"icon_diagnosis_selected" andDisSelectedImageName:@"icon_diagnosis_un_selected" andTitle:NSLocalizedString(@"FM_ACCOUNT_DIAGNOSIS", @"Diagnosis")];
        _diagnosisCell = [[FrtcTabCell alloc] initWithTabControlModel:model];
        _diagnosisCell.tag = SettingDiagnosis;
        _diagnosisCell.delegate = self;
        _diagnosisCell.imageView.image = [NSImage imageNamed:@"icon_diagnosis_un_selected"];
        _diagnosisCell.titleView.stringValue = NSLocalizedString(@"FM_ACCOUNT_DIAGNOSIS", @"Diagnosis");
        [self addSubview:_diagnosisCell];
    }
    
    return _diagnosisCell;
}

@end
