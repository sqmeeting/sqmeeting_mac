#import "FrtcVideoRecordingReminderView.h"

@implementation FrtcVideoRecordingReminderView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self tipsReminderViewLayout];
        self.wantsLayer = YES;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.0;
        self.layer.backgroundColor = [NSColor colorWithString:@"#222222" andAlpha:0.8].CGColor;
       // self.window.isOpaque = NO;
    }
    
    return self;
}

- (void)tipsReminderViewLayout {
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
}

#pragma mark --getter load--
- (NSImageView *)imageView {
    if (!_imageView){
        _imageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        [_imageView setImage:[NSImage imageNamed:@"icon_show_recording"]];
        _imageView.imageAlignment = NSImageAlignTopLeft;
       // _imageView.imageScaling   =  NSImageScaleAxesIndependently;
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

@end
