#import "FrtcStreamingPopTabCell.h"

#define CELL_SELECTED_COLOR  [NSColor colorWithString:@"#1F80FF" andAlpha:1]
#define CELL_DISSELECTED_COLOR  [NSColor whiteColor]

@interface FrtcStreamingPopTabCell () {
    BOOL _mouseDown;
    BOOL _mouseIn;
}

@end

@implementation FrtcStreamingPopTabCell

- (void)drawRect:(NSRect)dirtyRect {
    NSRect rect  = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [super drawRect:rect];
    [self.effectBackgroundColor setFill];
    // Drawing code here.
    NSRectFill(rect);
}



- (instancetype)init {
    self = [super init];
    
    if(self) {
        [self setupUI];
    }
    
    return self;
}

- (FrtcStreamingPopTabCell *)initStreamingPopCell {
    self = [super init];
    
    if (self) {
        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited;
        
        NSRect rect = NSMakeRect(0, 0, 127, 24);
        NSTrackingArea *focusTrackingArea = [[NSTrackingArea alloc] initWithRect:rect
                                                                         options:focusTrackingAreaOptions owner:self userInfo:nil];
        [self addTrackingArea:focusTrackingArea];
        
        [self setupUI];
    }
    
    return self;
}

#pragma mark -- public functions
- (void)selected {
    self.needsDisplay = YES;
 
    self.titleView.textColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1];
    self.effectBackgroundColor = CELL_SELECTED_COLOR;
    self.imageView.image = [NSImage imageNamed:@"icon_invite_url"];
}

- (void)disSelected {
    self.effectBackgroundColor = CELL_DISSELECTED_COLOR;
    self.needsDisplay = YES;
    self.imageView.image = [NSImage imageNamed:@"icon_invite_url_un_selected"];
    self.titleView.textColor = [NSColor colorWithString:@"#222222" andAlpha:1];
}

- (void)setupUI {
    [self addSubview:self.imageView];
    [self addSubview:self.titleView];
    
    self.effectBackgroundColor = CELL_DISSELECTED_COLOR;
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(12);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).mas_offset(7);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
        make.centerY.mas_equalTo(self.mas_centerY);//.offset(-2.5);
    }];

    self.wantsLayer = YES;
    
    //self.layer.backgroundColor = [NSColor colorWithString:@"#000000" andAlpha:0.16].CGColor;
    self.layer.backgroundColor = [NSColor whiteColor].CGColor;
}
#pragma mark  -- mouse evetn--
- (void)mouseEntered:(NSEvent *)event {
    [[NSCursor pointingHandCursor] set];
    [self selected];
    _mouseIn = YES;
}

- (void)mouseExited:(NSEvent *)event {
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
    }
    
    return _imageView;
}

- (NSTextField *)titleView {
    if (!_titleView) {
        _titleView = [[NSTextField alloc] init];
        _titleView.textColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1];
        _titleView.font = [NSFont systemFontOfSize:12 weight:NSFontWeightRegular];
        [_titleView setBordered:NO];
        [_titleView setEditable:NO];
        [_titleView setSelectable:NO];
        _titleView.backgroundColor = [NSColor clearColor];
    }
    
    return _titleView;
}

@end
