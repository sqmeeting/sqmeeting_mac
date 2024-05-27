#import "FrtcVideoRecordingTipsView.h"

@interface FrtcVideoRecordingTipsView ()<HoverImageViewDelegate>

@end

@implementation FrtcVideoRecordingTipsView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self tipsViewLayout];
        self.wantsLayer = YES;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.0;
        self.layer.backgroundColor = [NSColor colorWithString:@"#000000" andAlpha:0.8].CGColor;
       // self.window.isOpaque = NO;
    }
    
    return self;
}

#pragma mark --Layout--
- (void)tipsViewLayout {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(12);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(6);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.tipsBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.endRecordingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(12);
    }];
}


#pragma mark --HoverImageViewDelegate--
- (void)didIntoArea:(BOOL)isInImageViewArea withSenderTag:(NSInteger)tag {
    if(isInImageViewArea) {
        self.endRecordingImageView.image = [NSImage imageNamed:@"icon_video_record_stop"];
        self.tipsBackGroundView.layer.backgroundColor = [NSColor colorWithString:@"#000000" andAlpha:1.0].CGColor;
    } else {
        self.endRecordingImageView.image = [NSImage imageNamed:@"icon_record_end"];
        self.tipsBackGroundView.layer.backgroundColor = [NSColor colorWithString:@"#222222" andAlpha:1.0].CGColor;
    }
    
    if(self.tipsViewDelegate && [self.tipsViewDelegate respondsToSelector:@selector(showTipsView:withViewType:)]) {
        [self.tipsViewDelegate showTipsView:isInImageViewArea withViewType:self.viewsType];
    }
}


- (void)hoverImageViewClickedwithSenderTag:(NSInteger)tag {
    if(self.tipsViewDelegate && [self.tipsViewDelegate respondsToSelector:@selector(stopVideoRecording:)]) {
        [self.tipsViewDelegate stopVideoRecording:self.viewsType];
    }
}

#pragma mark --getter load--
- (NSImageView *)imageView {
    if (!_imageView){
        _imageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        [_imageView setImage:[NSImage imageNamed:@"icon_show_recording"]];
        _imageView.imageAlignment = NSImageAlignTopLeft;
        _imageView.imageScaling   =  NSImageScaleAxesIndependently;
        [self addSubview:_imageView];
    }
    
    return _imageView;
}

- (NSTextField *)title {
    if (!_title){
        _title = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _title.bordered = NO;
        _title.drawsBackground = NO;
        _title.stringValue = NSLocalizedString(@"FM_VIDEO_RECORDING_TO_HOST", @"Recording");
        _title.font = [NSFont systemFontOfSize:12 weight:NSFontWeightRegular];
        _title.textColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0];
        _title.alignment = NSTextAlignmentLeft;
        _title.editable = NO;
        [self addSubview:_title];
    }
    
    return _title;//icon_video_record_stop
}

- (HoverImageView *)endRecordingImageView {
    if(!_endRecordingImageView) {
        _endRecordingImageView = [[HoverImageView alloc] initWithFrame:CGRectMake(0, 0, 15.38, 14.77)];
        _endRecordingImageView.delegate = self;
        //_endRecordingImageView.imageScaling =  NSImageScaleAxesIndependently;
        //_endRecordingImageView.image = [NSImage imageNamed:@"icon_video_record_stop"];
        _endRecordingImageView.image = [NSImage imageNamed:@"icon_record_end"];
        [_endRecordingImageView setWantsLayer:YES];

        [self addSubview:_endRecordingImageView];
    }
    
    return _endRecordingImageView;
}

- (TipsBackgroundView *)tipsBackGroundView {
    if(!_tipsBackGroundView) {
        _tipsBackGroundView = [[TipsBackgroundView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        [self addSubview:_tipsBackGroundView];
    }
    
    return _tipsBackGroundView;
}

@end
