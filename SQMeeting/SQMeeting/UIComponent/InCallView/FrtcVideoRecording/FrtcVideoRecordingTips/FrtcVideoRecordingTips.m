#import "FrtcVideoRecordingTips.h"

@implementation FrtcVideoRecordingTips

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self tipsViewLayout];
        self.wantsLayer = YES;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.0;
        self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
       // self.window.isOpaque = NO;
    }
    
    return self;
}

#pragma mark --Layout--
- (void)tipsViewLayout {
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

- (NSTextField *)title {
    if (!_title){
        _title = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _title.bordered = NO;
        _title.drawsBackground = NO;
        _title.stringValue = @"结束录制";
        _title.font = [NSFont systemFontOfSize:12 weight:NSFontWeightRegular];
        _title.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _title.alignment = NSTextAlignmentLeft;
        _title.editable = NO;
        [self addSubview:_title];
    }
    
    return _title;
}

@end
