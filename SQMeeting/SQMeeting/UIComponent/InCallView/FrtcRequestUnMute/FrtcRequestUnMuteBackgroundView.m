#import "FrtcRequestUnMuteBackgroundView.h"

@interface FrtcRequestUnMuteBackgroundView()

@property (nonatomic, strong) NSImageView  *imageView;

@property (nonatomic, strong) NSTextField *descriptionTextField;

@end

@implementation FrtcRequestUnMuteBackgroundView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        [self setupUI];
    }
    
    return self;
}

#pragma mark -- setup UI
- (void)setupUI {
    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor colorWithString:@"#F8F9FA" andAlpha:1].CGColor;
    [self setupPersonalViewCellLayout];
}

- (void)setupPersonalViewCellLayout {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(NSMakeSize(200, 132));
    }];
    
    [self.descriptionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(11);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

- (NSImageView *)imageView {
    if (!_imageView) {
        _imageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 132)];
        [_imageView setImage:[NSImage imageNamed:@"icon_request_unmute"]];
        _imageView.imageAlignment =  NSImageAlignTopLeft;
        _imageView.imageScaling =  NSImageScaleAxesIndependently;
        [self addSubview:_imageView];
    }
    
    return _imageView;
}

- (NSTextField *)descriptionTextField {
    if (!_descriptionTextField) {
        _descriptionTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _descriptionTextField.backgroundColor = [NSColor clearColor];
        _descriptionTextField.font = [NSFont systemFontOfSize:13 weight:NSFontWeightRegular];
        _descriptionTextField.alignment = NSTextAlignmentCenter;
        _descriptionTextField.textColor = [NSColor colorWithString:@"#999999" andAlpha:1.0];;
        _descriptionTextField.bordered = NO;
        _descriptionTextField.editable = NO;
        _descriptionTextField.stringValue = NSLocalizedString(@"FM_BACKGOUND_VIEW_UN_MUTE_DESCRIPTION", @"No requests");
        [self addSubview:_descriptionTextField];
    }
    
    return _descriptionTextField;
}
    
@end
