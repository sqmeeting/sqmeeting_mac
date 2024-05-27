#import "FrtcStaticsViewController.h"
#import "StaticsTableViewCell.h"

@interface FrtcStaticsViewController () <NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic, strong) NSTableView *staticsTableView;

@property (nonatomic) NSInteger staticsCount;

@property (nonatomic, copy) NSMutableArray<MediaDetailModel *> *mediaArray;

@property (strong, nonatomic) NSTimer  *staticsTimer;

@property (nonatomic, copy) NSString *callType;

@property (nonatomic, copy) NSNumber *callRate;

@property (nonatomic, strong) NSScrollView *backGoundView;

@end

@implementation FrtcStaticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
    
    self.staticsCount =  self.staticsModel.mediaStatistics.apr.count + self.staticsModel.mediaStatistics.aps.count
    + self.staticsModel.mediaStatistics.vcr.count + self.staticsModel.mediaStatistics.vcs.count + self.staticsModel.mediaStatistics.vpr.count + self.staticsModel.mediaStatistics.vps.count ;
    
    _mediaArray = [NSMutableArray array];
    [_mediaArray addObjectsFromArray:self.staticsModel.mediaStatistics.apr];
    [_mediaArray addObjectsFromArray:self.staticsModel.mediaStatistics.aps];
    [_mediaArray addObjectsFromArray:self.staticsModel.mediaStatistics.vpr];
    [_mediaArray addObjectsFromArray:self.staticsModel.mediaStatistics.vps];
    [_mediaArray addObjectsFromArray:self.staticsModel.mediaStatistics.vcr];
    [_mediaArray addObjectsFromArray:self.staticsModel.mediaStatistics.vcs];

    //self.callType = self.staticsModel.signalStatistics.call_type;
    self.callRate = self.staticsModel.signalStatistics.callRate;
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
        make.top.mas_equalTo(self.line1.mas_bottom).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.conferenceNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.conferenceNumberLabel.mas_right).offset(2);
        make.top.mas_equalTo(self.line1.mas_bottom).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.callRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.mas_equalTo(self.view.mas_left).offset(322);
        make.left.mas_equalTo(self.conferenceNumberTextField.mas_right).offset(10);
        make.top.mas_equalTo(self.line1.mas_bottom).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.callRateTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.callRateLabel.mas_right).offset(2);
        make.top.mas_equalTo(self.line1.mas_bottom).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top).offset(82);
        make.width.mas_equalTo(759);
        make.height.mas_equalTo(1);
    }];
    
    [self.participantLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.top.mas_equalTo(self.line2.mas_top).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.mediaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(227);
        make.top.mas_equalTo(self.line2.mas_top).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.formatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(307);
        make.top.mas_equalTo(self.line2.mas_top).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.actualRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(411);
        make.top.mas_equalTo(self.line2.mas_top).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.frameRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(502);
        make.top.mas_equalTo(self.line2.mas_top).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.packetLossLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset([self distance]);
        make.top.mas_equalTo(self.line2.mas_top).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.jitterBufferLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(690);
        make.top.mas_equalTo(self.line2.mas_top).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.backGoundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(124);
        make.left.mas_equalTo(self.view.mas_left);
        make.width.mas_equalTo(759);
        make.height.mas_equalTo(440);
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

- (void)handleStaticsEvent:(FrtcStatisticalModel *)staticsModel {
    self.staticsModel = staticsModel;
    self.callRate =staticsModel.signalStatistics.callRate;
    self.staticsCount =  staticsModel.mediaStatistics.apr.count + staticsModel.mediaStatistics.aps.count
    + staticsModel.mediaStatistics.vcr.count + staticsModel.mediaStatistics.vcs.count + staticsModel.mediaStatistics.vpr.count + staticsModel.mediaStatistics.vps.count ;
    
    long rates = [self.callRate longValue];
    
    NSString *callRateString;
    if (rates > 100000) {
        long rate1 = rates / 100000;
        long rate2 = rates % 100000;
        callRateString = [NSString stringWithFormat:@"%ld / %ld", rate1, rate2];
    } else {
        callRateString = [NSString stringWithFormat:@"%ld", rates];
    }
    self.callRateTextField.stringValue = callRateString;
    
    _mediaArray = [NSMutableArray array];
    [_mediaArray removeAllObjects];
    [_mediaArray addObjectsFromArray:staticsModel.mediaStatistics.apr];
    [_mediaArray addObjectsFromArray:staticsModel.mediaStatistics.aps];
    [_mediaArray addObjectsFromArray:staticsModel.mediaStatistics.vpr];
    [_mediaArray addObjectsFromArray:staticsModel.mediaStatistics.vps];
    [_mediaArray addObjectsFromArray:staticsModel.mediaStatistics.vcr];
    [_mediaArray addObjectsFromArray:staticsModel.mediaStatistics.vcs];

    [self.staticsTableView reloadData];
}

#pragma mark -NSTableViewDelegate, NSTableViewDataSource-
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _staticsCount;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
      // Retrieve to get the @"MyView" from the pool or,
      // if no version is available in the pool, load the Interface Builder versio
    
    StaticsTableViewCell *cell = [tableView makeViewWithIdentifier:@"StaticsTableViewCell" owner:self];
    if(cell == nil) {
        cell = [[StaticsTableViewCell alloc] initWithFrame:NSMakeRect(0, 0, 759, 40)];
        cell.identifier = @"StaticsTableViewCell";
    }
    
    if(row % 2 == 0) {
        cell.layer.backgroundColor = [NSColor colorWithString:@"#F6F6F6" andAlpha:1.0].CGColor;
    } else {
        cell.layer.backgroundColor = [NSColor colorWithString:@"#FBFBFB" andAlpha:1.0].CGColor;
    }

    MediaDetailModel *model = _mediaArray[row];
    [cell updateCellInfomation:model];
    
    return cell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 40;
}

- (NSTableView *)staticsTableView {
    if(!_staticsTableView) {
        _staticsTableView = [[NSTableView alloc] initWithFrame:NSMakeRect(0, 123, 759, 440)];
        _staticsTableView.backgroundColor = [NSColor whiteColor];
        NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@""];
      
        [_staticsTableView addTableColumn:column];
        _staticsTableView.delegate = self;
        _staticsTableView.dataSource = self;
        _staticsTableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
 
        [_staticsTableView setHeaderView:nil];
        [_staticsTableView setIntercellSpacing:NSMakeSize(0, 0)];

        _staticsTableView.focusRingType = NSFocusRingTypeNone;
        _staticsTableView.translatesAutoresizingMaskIntoConstraints = YES;
        
        if(@available(macos 11.0, *)) {
            _staticsTableView.style = NSTableViewStylePlain;
        }
        
        [self.view addSubview:_staticsTableView];
        [_staticsTableView reloadData];
    }
    
    return _staticsTableView;
}

- (NSScrollView *) backGoundView {
    if (!_backGoundView) {
        _backGoundView = [[NSScrollView alloc] init];
        _backGoundView.wantsLayer = YES;
        _backGoundView.layer.backgroundColor = [NSColor blackColor].CGColor;
        _backGoundView.documentView = self.staticsTableView;
        _backGoundView.hasVerticalScroller = YES;
        _backGoundView.hasHorizontalScroller = NO;
        _backGoundView.scrollerStyle = NSScrollerStyleOverlay;
        _backGoundView.scrollerKnobStyle = NSScrollerKnobStyleDark;
        _backGoundView.scrollsDynamically = YES;
        _backGoundView.autohidesScrollers = NO;
        _backGoundView.verticalScroller.hidden = NO;
        _backGoundView.horizontalScroller.hidden = YES;
        _backGoundView.automaticallyAdjustsContentInsets = NO;
        //_backGoundView.backgroundColor = [NSColor whiteColor];
        [self.view addSubview:_backGoundView];
    }

    return _backGoundView;
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
        _titleTextField.stringValue = self.conferenceName;
        
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
        _conferenceNumberLabel.stringValue = [NSString stringWithFormat:@"%@：",NSLocalizedString(@"FM_MEETING_NUMBER", @"Meeting ID")];
        [self.view addSubview:_conferenceNumberLabel];
    }
    
    return _conferenceNumberLabel;
}

- (NSTextField *)conferenceNumberTextField {
    if (!_conferenceNumberTextField) {
        _conferenceNumberTextField = [self firstSectionBlueTextField];
        _conferenceNumberTextField.stringValue = self.conferenceAlias;
        [self.view addSubview:_conferenceNumberTextField];
    }
    
    return _conferenceNumberTextField;
}

- (NSTextField *)callRateLabel {
    if (!_callRateLabel) {
        _callRateLabel = [self firstSectionTextField];
        _callRateLabel.stringValue = NSLocalizedString(@"FM_CALL_RATE", @"Call Rate");;
        
        [self.view addSubview:_callRateLabel];
    }
    
    return _callRateLabel;
}

- (NSTextField *)callRateTextField {
    if (!_callRateTextField) {
        _callRateTextField = [self firstSectionBlueTextField];
        long rates = [self.callRate longValue];
        
        NSString *callRateString;
        if (rates > 100000) {
            long rate1 = rates / 100000;
            long rate2 = rates % 100000;
            callRateString = [NSString stringWithFormat:@"%ld / %ld", rate1, rate2];
        } else {
            callRateString = [NSString stringWithFormat:@"%ld", rates];
        }
        _callRateTextField.stringValue = callRateString;
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
        _participantLabel.stringValue = NSLocalizedString(@"FM_STATISTIC_PARTICIPANT", @"Participants");
        [self.view addSubview:_participantLabel];
    }
    
    return _participantLabel;
}

- (NSTextField *)mediaLabel {
    if(!_mediaLabel) {
        _mediaLabel = [self secondSectionTextField];
        _mediaLabel.stringValue = NSLocalizedString(@"FM_STATISTIC_CHANNEL", @"Media");
        [self.view addSubview:_mediaLabel];
    }
    
    return _mediaLabel;
}

- (NSTextField *)formatLabel {
    if(!_formatLabel) {
        _formatLabel = [self secondSectionTextField];
        _formatLabel.stringValue = NSLocalizedString(@"FM_STATISTIC_FORMAT", @"Format");
        [self.view addSubview:_formatLabel];
    }
    
    return _formatLabel;
}

- (NSTextField *)actualRateLabel {
    if(!_actualRateLabel) {
        _actualRateLabel = [self secondSectionTextField];
        _actualRateLabel.stringValue = NSLocalizedString(@"FM_STATISTIC_RATEUSED", @"Actual Rate");
        [self.view addSubview:_actualRateLabel];
    }
    
    return _actualRateLabel;
}

- (NSTextField *)frameRateLabel {
    if(!_frameRateLabel) {
        _frameRateLabel = [self secondSectionTextField];
        _frameRateLabel.stringValue = NSLocalizedString(@"FM_STATISTIC_FRAME_RATE", @"Frame Rate");
        [self.view addSubview:_frameRateLabel];
    }
    
    return _frameRateLabel;
}

- (NSTextField *)packetLossLabel {
    if(!_packetLossLabel) {
        _packetLossLabel = [self secondSectionTextField];
        _packetLossLabel.stringValue = NSLocalizedString(@"FM_STATISTIC_LOST", @"Lost");
        [self.view addSubview:_packetLossLabel];
    }
    
    return _packetLossLabel;
}

- (NSTextField *)jitterBufferLabel {
    if(!_jitterBufferLabel) {
        _jitterBufferLabel = [self secondSectionTextField];
        _jitterBufferLabel.stringValue = NSLocalizedString(@"FM_STATISTIC_JITTER", @"Jitter");
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
