#import "FrtcGridModeView.h"
#import "GridBackGroundView.h"
#import "FrtcCallInterface.h"

@interface FrtcGridModeView ()<GridBackGroundViewDelegate>

@property (nonatomic, strong) NSView *galleryView;

@property (nonatomic, strong) NSView *presenterView;

@property (nonatomic, strong) NSImageView *galleryImageView;

@property (nonatomic, strong) NSImageView *presenterImageView;

@property (nonatomic, strong) NSTextField *galleryTitleTextField;

@end;

@implementation FrtcGridModeView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor colorWithString:@"#F8F9FA" andAlpha:1.0].CGColor;
        
        [self gridModeViewLayout];
    }
    
    return self;
}

- (void)gridModeViewLayout {
    [self.galleryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(16);
        make.width.mas_equalTo(104);
        make.height.mas_equalTo(28);
    }];
    
    [self.galleryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(4);
        make.top.mas_equalTo(8);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(12);
    }];
    
    [self.galleryTitleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.centerY.mas_equalTo(self.galleryImageView.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.presenterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.galleryView.mas_right).offset(16);
        make.centerY.mas_equalTo(self.galleryView.mas_centerY);
        make.width.mas_equalTo(104);
        make.height.mas_equalTo(28);
    }];
    
    [self.presenterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(2);
        make.top.mas_equalTo(8);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(12);
    }];
    
    [self.presenterTitleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(self.presenterImageView.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.galleryBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(60);
        make.width.mas_equalTo(104);
        make.height.mas_equalTo(92);
    }];
    
    [self.presenterBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.galleryBackgroundView.mas_right).offset(16);
        make.top.mas_equalTo(60);
        make.width.mas_equalTo(104);
        make.height.mas_equalTo(92);
    }];
}

#pragma mark --GridBackGroundViewDelegate
- (void)gridBackGroundViewClicked:(GridBackGroundViewType)type {
    BOOL isSelectGridMode;
    if(type == GridBackGroundViewGallery) {
        [[FrtcCallInterface singletonFrtcCall] switchGridMode:YES];
        isSelectGridMode = YES;
    } else if(type == GridBackGroundViewPresenter) {
        [[FrtcCallInterface singletonFrtcCall] switchGridMode:NO];
        isSelectGridMode = NO;
    }
    
    if(self.gridModeDelegate && [self.gridModeDelegate respondsToSelector:@selector(selectGridMode:)]) {
        [self.gridModeDelegate selectGridMode:isSelectGridMode];
    }
    self.hidden = YES;
}

#pragma mark --lazy load getter--
- (NSView *)galleryView {
    if(!_galleryView) {
        _galleryView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 104, 28)];
        _galleryView.wantsLayer = YES;
        _galleryView.layer.backgroundColor = [NSColor whiteColor].CGColor;
        
        [self addSubview:_galleryView];
    }
    
    return _galleryView;
}

- (NSView *)presenterView {
    if(!_presenterView) {
        _presenterView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 104, 28)];
        _presenterView.wantsLayer = YES;
        _presenterView.layer.backgroundColor = [NSColor whiteColor].CGColor;
        
        [self addSubview:_presenterView];
    }
    
    return _presenterView;
}

- (NSImageView *)galleryImageView {
    if(!_galleryImageView) {
        _galleryImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        _galleryImageView.image = [NSImage imageNamed:@"icon-gallery"];
        [self.galleryView addSubview:_galleryImageView];
    }
    
    return _galleryImageView;
}

- (NSImageView *)presenterImageView {
    if(!_presenterImageView) {
        _presenterImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        _presenterImageView.image = [NSImage imageNamed:@"icon-present"];
        [self.presenterView addSubview:_presenterImageView];
    }
    
    return _presenterImageView;
}

- (NSTextField *)galleryTitleTextField {
    if (!_galleryTitleTextField) {
        _galleryTitleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _galleryTitleTextField.backgroundColor = [NSColor clearColor];
        _galleryTitleTextField.font = [NSFont systemFontOfSize:12 weight:NSFontWeightRegular];
        _galleryTitleTextField.alignment = NSTextAlignmentLeft;
        _galleryTitleTextField.textColor = [NSColor colorWithString:@"#666666" andAlpha:1.0];
        _galleryTitleTextField.bordered = NO;
        _galleryTitleTextField.editable = NO;
        _galleryTitleTextField.stringValue = NSLocalizedString(@"FM_GALLERT_MODE", @"Gallery View");
        
        [self.galleryView addSubview:_galleryTitleTextField];
    }
    
    return _galleryTitleTextField;
}

- (NSTextField *)presenterTitleTextField {
    if (!_presenterTitleTextField) {
        _presenterTitleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _presenterTitleTextField.backgroundColor = [NSColor clearColor];
        _presenterTitleTextField.font = [NSFont systemFontOfSize:12 weight:NSFontWeightRegular];
        _presenterTitleTextField.alignment = NSTextAlignmentLeft;
        _presenterTitleTextField.textColor = [NSColor colorWithString:@"#666666" andAlpha:1.0];
        _presenterTitleTextField.bordered = NO;
        _presenterTitleTextField.editable = NO;
        _presenterTitleTextField.stringValue = NSLocalizedString(@"FM_PRESENTER_MODE", @"Presenter View");
        
        [self.presenterView addSubview:_presenterTitleTextField];
    }
    
    return _presenterTitleTextField;
}

- (GridBackGroundView *)galleryBackgroundView {
    if(!_galleryBackgroundView) {
        _galleryBackgroundView = [[GridBackGroundView alloc] initWithFrame:CGRectMake(0, 0, 104, 92)];
        _galleryBackgroundView.type = GridBackGroundViewGallery;
        _galleryBackgroundView.delegate = self;
        _galleryBackgroundView.imageView.image = [NSImage imageNamed:@"icon-gallery-center"];
        _galleryBackgroundView.titleTextField.stringValue = NSLocalizedString(@"FM_GALLERT_MODE", @"Gallery View");
        [self addSubview:_galleryBackgroundView];
    }
    
    return _galleryBackgroundView;
}

- (GridBackGroundView *)presenterBackgroundView {
    if(!_presenterBackgroundView) {
        _presenterBackgroundView = [[GridBackGroundView alloc] initWithFrame:CGRectMake(0, 0, 104, 92)];
        _presenterBackgroundView.type = GridBackGroundViewPresenter;
        _presenterBackgroundView.delegate = self;
        _presenterBackgroundView.imageView.image = [NSImage imageNamed:@"icon-presenter-center"];
        _presenterBackgroundView.titleTextField.stringValue = NSLocalizedString(@"FM_PRESENTER_MODE", @"Presenter View");
        [self addSubview:_presenterBackgroundView];
    }
    
    return _presenterBackgroundView;
}


@end
