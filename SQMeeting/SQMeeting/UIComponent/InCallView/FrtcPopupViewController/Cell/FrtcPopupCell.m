#import "FrtcPopupCell.h"

#define CELL_POP_UP_SELECTED_COLOR  [NSColor colorWithString:@"#1F80FF" andAlpha:1]
#define CELL_POP_UP_DISSELECTED_COLOR  [NSColor whiteColor]

@interface FrtcPopupCell () {
    BOOL _mouseDown;
    BOOL _mouseIn;
}

@end

@implementation FrtcPopupCell

- (void)drawRect:(NSRect)dirtyRect {
    NSRect rect  = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [super drawRect:rect];
    [self.effectBackgroundColor setFill];
    // Drawing code here.
    NSRectFill(rect);
}

- (FrtcPopupCell *)initPopupCellWithFrame:(CGRect)frame withCellType:(PopupCellType)type {
    self = [super initWithFrame:frame];
    
    if (self) {
        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited;
        
        NSRect rect = NSMakeRect(0, 0, 166, 24);
        NSTrackingArea *focusTrackingArea = [[NSTrackingArea alloc] initWithRect:rect
                                                                         options:focusTrackingAreaOptions owner:self userInfo:nil];
        [self addTrackingArea:focusTrackingArea];
        self.type = type;
        
        [self setupUI];
    }
    
    return self;
}

- (instancetype)init {
    self = [super init];
    
    if(self) {
        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited;
        
        NSRect rect = NSMakeRect(0, 0, 166, 24);
        NSTrackingArea *focusTrackingArea = [[NSTrackingArea alloc] initWithRect:rect
                                                                         options:focusTrackingAreaOptions owner:self userInfo:nil];
        [self addTrackingArea:focusTrackingArea];
        
        [self setupUI];
        
        self.target = self;
        self.action = @selector(didSelectedPopCell);
    }
    
    return self;
}

- (void)didSelectedPopCell {
    NSLog(@"The section is %ld and the row is %ld", self.section, self.row);
    
    if(self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(hoverSelectedWithSection:wihtRow:)]) {
        [self.cellDelegate hoverSelectedWithSection:self.section wihtRow:self.row];
    }
}

- (void)dealloc {
    NSLog(@"FrtcPopupCell dealloc");
}

#pragma mark -- public functions
- (void)selected {
    self.needsDisplay = YES;
    
    self.titleView.textColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1];
    self.effectBackgroundColor = CELL_POP_UP_SELECTED_COLOR;
    self.imageView.image = [NSImage imageNamed:@"icon_pop_description_white"];
}

- (void)disSelected {
    self.effectBackgroundColor = CELL_POP_UP_DISSELECTED_COLOR;
    self.needsDisplay = YES;
    self.imageView.image = [NSImage imageNamed:@"icon_pop_description"];
    self.titleView.textColor = [NSColor colorWithString:@"#222222" andAlpha:1];
}

- (void)setupUI {
    [self addSubview:self.imageView];
    [self addSubview:self.titleView];
    
    self.effectBackgroundColor = CELL_POP_UP_DISSELECTED_COLOR;
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(12);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).mas_offset(7);
        make.width.mas_offset(131);
        make.height.mas_greaterThanOrEqualTo(0);
        make.centerY.mas_equalTo(self.mas_centerY);//.offset(-2.5);
    }];
    
    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor whiteColor].CGColor;
}
#pragma mark  -- mouse evetn--
- (void)mouseEntered:(NSEvent *)event {
    if(!self.isHover) {
        return;
    }
    
    [[NSCursor pointingHandCursor] set];
    [self selected];
    _mouseIn = YES;
}

- (void)mouseExited:(NSEvent *)event {
    if(!self.isHover) {
        return;
    }
    
    [[NSCursor arrowCursor] set];
    [self disSelected];
    _mouseIn = NO;
}

- (void)mouseDown:(NSEvent *)theEvent {
    _mouseDown = YES;
}

- (void)mouseUp:(NSEvent *)theEvent {
    if (_mouseDown) {
        _mouseDown = NO;
        if (_mouseIn && self.target && self.action) {
            [self.target performSelector:self.action withObject:self afterDelay:0.0];
        }
    }
}

#pragma mark  -- getter
- (NSImageView *)imageView {
    if (!_imageView) {
        _imageView = [[NSImageView alloc] init];
        _imageView.image = [NSImage imageNamed:@"icon_pop_description"];
//        if(self.type == PopupSection) {
//            _imageView.image = [NSImage imageNamed:@"icon_pop_section"];
//        } else {
//            _imageView.image = [NSImage imageNamed:@"icon_pop_description"];
//        }
    }
    
    return _imageView;
}

- (NSTextField *)titleView {
    if (!_titleView) {
        _titleView = [[NSTextField alloc] init];
//        if(self.type == PopupSection) {
//            _titleView.textColor = [NSColor colorWithString:@"#666666" andAlpha:1];
//            _titleView.stringValue = NSLocalizedString(@"FM_SELECT_SPEAKER", @"Select Speaker");
//        } else {
//            _titleView.textColor = [NSColor colorWithString:@"#222222" andAlpha:1];
//        }
        _titleView.textColor = [NSColor colorWithString:@"#222222" andAlpha:1];
        _titleView.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleView.font = [NSFont systemFontOfSize:12 weight:NSFontWeightRegular];
        [_titleView setBordered:NO];
        [_titleView setEditable:NO];
        [_titleView setSelectable:NO];
        _titleView.backgroundColor = [NSColor clearColor];
    }
    
    return _titleView;
}

@end
