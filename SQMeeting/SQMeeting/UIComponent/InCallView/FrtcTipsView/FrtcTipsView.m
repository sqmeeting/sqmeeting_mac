#import "FrtcTipsView.h"
#import "Masonry.h"
#import "FrtcBaseImplement.h"

@interface FrtcTipsView()

@end


@implementation FrtcTipsView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    if(self) {
        [self configLayout];
        self.wantsLayer = YES;
        self.layer.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] buttonTitleColor].CGColor;
        self.layer.cornerRadius = 4.0f;
    }
    
    return self;
}


#pragma mark --layout

- (void)configLayout {
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.mas_equalTo(self.mas_centerX);
         make.centerY.mas_equalTo(self.mas_centerY);
         make.width.mas_greaterThanOrEqualTo(0);
         make.height.mas_greaterThanOrEqualTo(0);
     }];
}

- (NSTextField *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[NSTextField alloc] init];
        _descriptionLabel.editable = NO;
        _descriptionLabel.bordered = NO;
        _descriptionLabel.backgroundColor = [NSColor clearColor];
        _descriptionLabel.alignment = NSTextAlignmentCenter;
        _descriptionLabel.font = [NSFont systemFontOfSize:16.0];
        _descriptionLabel.stringValue = NSLocalizedString(@"FM_AUDIO_MUTE_REMINDER", @"Your are muted.");
        _descriptionLabel.textColor = [[FrtcBaseImplement baseImpleSingleton] whiteColor];
        
        [self addSubview:_descriptionLabel];
    }
    
    return _descriptionLabel;
}

@end
