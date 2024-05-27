#import "FrtcTagSelectCell.h"

@interface FrtcTagSelectCell () {
    FrtcTabControlSelectMode *tabControlModel;
    BOOL _mouseDown;
}

@end

@implementation FrtcTagSelectCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (FrtcTagSelectCell *)initWithTabControlModel:(FrtcTabControlSelectMode *)tabControl {
    self = [super init];
    
    if (self) {
        tabControlModel = tabControl;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    [self addSubview:self.titleView];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1].CGColor;
}

#pragma mark -- delegate
- (void)mouseDown:(NSEvent *)theEvent {
    _mouseDown = YES;
    self.needsDisplay = YES;
}

- (void)mouseUp:(NSEvent *)theEvent {
    if (_mouseDown) {
        _mouseDown = NO;
        self.needsDisplay = YES;
        if ([self.delegate respondsToSelector:@selector(didSelectedCell:)]) {
            [self.delegate didSelectedCell:self];
        }
    }
}

#pragma mark -- public functions
- (void)selected {
    self.needsDisplay = YES;
    self.titleView.textColor = tabControlModel.selectedColor;
    self.titleView.font = tabControlModel.selectTitleFont;
}

- (void)disSelected {
    self.needsDisplay = YES;
    self.titleView.textColor = tabControlModel.disSelectedColor;
    self.titleView.font = tabControlModel.unSelectTitleFont;;
}

#pragma mark  -- getter
- (NSTextField *)titleView {
    if (!_titleView) {
        _titleView = [[NSTextField alloc] init];
        _titleView.textColor = tabControlModel.selectedColor;
        _titleView.font = tabControlModel.selectTitleFont;
        [_titleView setBordered:NO];
        [_titleView setEditable:NO];
        [_titleView setSelectable:NO];
        _titleView.backgroundColor = [NSColor clearColor];
    }
    
    return _titleView;
}


@end
