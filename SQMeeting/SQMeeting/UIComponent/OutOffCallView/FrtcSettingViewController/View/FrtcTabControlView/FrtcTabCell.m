#import "FrtcTabCell.h"
#import "Masonry.h"
#import "NSColor+Enhancement.h"
#import "NSFont+Enhancement.h"

#define CELL_SELECTED_COLOR  [NSColor colorWithString:@"E4EEFF" andAlpha:1]
#define CELL_DISSELECTED_COLOR  [NSColor colorWithString:@"FFFFFF" andAlpha:1]

@interface FrtcTabCell () {
    FrtcTabControlModel *tabControlModel;
    BOOL _mouseDown;
}

@end

@implementation FrtcTabCell

- (void)drawRect:(NSRect)dirtyRect {
    NSRect rect  = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [super drawRect:rect];
    
    [self.effectBackgroundColor setFill];
    NSRectFill(rect);
}

- (instancetype)init {
    self = [super init];
    
    if(self) {
        [self setupUI];
    }
    
    return self;
}

- (FrtcTabCell *)initWithTabControlModel:(FrtcTabControlModel *)tabControl {
    self = [super init];
    
    if (self) {
        tabControlModel = tabControl;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.imageView];
    [self addSubview:self.titleView];
    
    self.effectBackgroundColor = CELL_DISSELECTED_COLOR;
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).mas_offset(8);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
        make.centerY.mas_equalTo(self.mas_centerY);//.offset(-2.5);
    }];
    
    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor colorWithString:@"fbfbfb" andAlpha:1].CGColor;
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

    self.titleView.textColor = [NSColor colorWithString:@"026FFE" andAlpha:1];
    self.effectBackgroundColor = CELL_SELECTED_COLOR;
    
    self.imageView.image = [NSImage imageNamed:tabControlModel.selectedImageName];
}

- (void)disSelected {
    self.effectBackgroundColor = CELL_DISSELECTED_COLOR;
    self.needsDisplay = YES;
    
    self.titleView.textColor = [NSColor colorWithString:@"333333" andAlpha:1];
    self.imageView.image = [NSImage imageNamed:tabControlModel.disSelectedImageName];
}

#pragma mark  -- getter
- (NSImageView *)imageView {
    if (!_imageView) {
        _imageView = [[NSImageView alloc] init];
    }
    
    return _imageView;
}

- (NSTextField *)titleView {
    if (!_titleView) {
        _titleView = [[NSTextField alloc] init];
        _titleView.textColor = [NSColor colorWithString:@"333333" andAlpha:1];
        _titleView.font = [NSFont fontWithSFProDisplay:14 andType:SFProDisplayRegular];
        [_titleView setBordered:NO];
        [_titleView setEditable:NO];
        [_titleView setSelectable:NO];
        _titleView.backgroundColor = [NSColor clearColor];
    }
    
    return _titleView;
}

@end
