#import "FrtcTagFunctionCell.h"

#define CELL_SELECTED_COLOR  [NSColor colorWithString:@"#F8F9FA" andAlpha:1]
#define CELL_DISSELECTED_COLOR  [NSColor colorWithString:@"#FFFFFF" andAlpha:1]

@interface FrtcTagFunctionCell () {
    BOOL _mouseDown;
}

@end

@implementation FrtcTagFunctionCell

- (void)drawRect:(NSRect)dirtyRect {
    NSRect rect  = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [super drawRect:rect];
    
    // Drawing code here.
    [self.effectBackgroundColor setFill];
    NSRectFill(rect);
}

//- (instancetype)initWithFrame:(NSRect)frameRect {
//    self = [super initWithFrame:frameRect];
//    
//    if(self) {
//        [self setupUI];
//        
//        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited;
//        
//        //NSRect rect = NSMakeRect(0, 0, 74, 28);
//        NSRect rect = NSMakeRect(0, 0, frameRect.size.width, frameRect.size.height);
//        NSTrackingArea *focusTrackingArea = [[NSTrackingArea alloc] initWithRect:rect
//                                                                         options:focusTrackingAreaOptions owner:self userInfo:nil];
//        [self addTrackingArea:focusTrackingArea];
//    }
//    
//    return self;
//}

- (instancetype)initWithType:(NSString *)type {
    self = [super init];
    
    if(self) {
        [self setupUI];
        
        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited;
        
        NSRect rect;
        if([type isEqualToString:@"recurrence"]) {
            rect = NSMakeRect(0, 0, 74, 28);
        } else {
            rect = NSMakeRect(0, 0, 140, 28);
        }
        
       NSTrackingArea *focusTrackingArea = [[NSTrackingArea alloc] initWithRect:rect
                                                                         options:focusTrackingAreaOptions owner:self userInfo:nil];
        [self addTrackingArea:focusTrackingArea];
    }
    
    return self;
}

- (instancetype)init {
    self = [super init];
    
    if(self) {
        [self setupUI];
        
        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited;
        
        //NSRect rect = NSMakeRect(0, 0, 74, 28);
        NSRect rect = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height);
        NSTrackingArea *focusTrackingArea = [[NSTrackingArea alloc] initWithRect:rect
                                                                         options:focusTrackingAreaOptions owner:self userInfo:nil];
        [self addTrackingArea:focusTrackingArea];
    }
    
    return self;
}

- (void)setupUI {
    [self addSubview:self.titleView];
    
    self.effectBackgroundColor = CELL_DISSELECTED_COLOR;
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    self.wantsLayer = YES;
    self.layer.backgroundColor = CELL_DISSELECTED_COLOR.CGColor;
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

- (void)mouseEntered:(NSEvent *)event {
    [[NSCursor pointingHandCursor] set];
    [self selected];
}

- (void)mouseExited:(NSEvent *)event {
    [[NSCursor arrowCursor] set];
    [self disSelected];
}

#pragma mark -- public functions
- (void)selected {
    self.needsDisplay = YES;
    self.effectBackgroundColor = CELL_SELECTED_COLOR;
}

- (void)disSelected {
    self.effectBackgroundColor = CELL_DISSELECTED_COLOR;
    self.needsDisplay = YES;
}

- (NSTextField *)titleView {
    if (!_titleView) {
        _titleView = [[NSTextField alloc] init];
        _titleView.textColor = [NSColor colorWithString:@"333333" andAlpha:1];
        _titleView.font = [NSFont fontWithSFProDisplay:13 andType:SFProDisplayRegular];
        _titleView.alignment = NSTextAlignmentCenter;
        [_titleView setBordered:NO];
        [_titleView setEditable:NO];
        [_titleView setSelectable:NO];
        _titleView.backgroundColor = [NSColor clearColor];
    }
    
    return _titleView;
}

@end
