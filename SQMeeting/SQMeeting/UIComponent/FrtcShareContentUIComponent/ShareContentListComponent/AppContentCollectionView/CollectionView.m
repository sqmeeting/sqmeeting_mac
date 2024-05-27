#import "CollectionView.h"
#import "NSColor+Utils.h"


@implementation CollectionView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
//        self.titleColorEnableSelected = [NSColor blueColor];
//        self.titleColorEnableUnSelected = [NSColor blackColor];
//
//        self.btnBgColorEnableSelected = [NSColor blueColor];
//        self.btnBgColorEnableUnSelected = [NSColor blackColor];
    }
    return self;
}

#pragma mark - for title

- (NSDictionary *)getTitleFontAttrbutedDic {
    NSFont *font = nil;
    if (nil != _titleFontName && 0 < [_titleFontName length]) {
        font = [NSFont fontWithName:_titleFontName size:_titleFontSize];
    } if (0 < _titleFontSize) {
        font = [NSFont systemFontOfSize:_titleFontSize];
    } else {
        font = [NSFont systemFontOfSize:14];
    }
    
    if (nil == _currentTitleColor) {
        _currentTitleColor = [NSColor grayColor];
    }
    
    //font = nil;
    //__currentTitleColor = nil;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:_titleTextAlignment]; //defalut: NSTextAlignmentLeft
    [style setLineBreakMode:NSLineBreakByTruncatingTail];
    
    NSDictionary *attributes = @{
        NSFontAttributeName             : font,
        NSForegroundColorAttributeName  : _currentTitleColor,
        NSParagraphStyleAttributeName   : style
    };
    return attributes;
}

- (NSSize)getSizeOfVerticallyText {
    NSAttributedString *inputStr = [[NSAttributedString alloc] initWithString:_titleText
                                                                   attributes:[self getTitleFontAttrbutedDic]];
    return [inputStr size];
}

#pragma mark -

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    /*
    //    [_titleText drawInRect:NSMakeRect(0, 0, 100, 30) //_titleRect
    //            withAttributes:[self getTitleFontAttrbutedDic]];
    
    // Drawing code here.
//    NSRect imageRect = NSMakeRect(5, 5, self.frame.size.width -10,self.frame.size.height -10);
//    NSBezierPath* imageRoundedRectanglePath = [NSBezierPath bezierPathWithRoundedRect:imageRect xRadius: 4 yRadius: 4];
    NSRect imageRect = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height);
    NSBezierPath* imageRoundedRectanglePath = [NSBezierPath bezierPathWithRoundedRect:imageRect xRadius:4 yRadius:4];
    
    NSColor* fillColor = nil;
    NSColor* strokeColor = nil;
    
    //默认是未选中的
    NSLog(@"[drawRect]: _isSelected : %@", _isSelected?@"Yes": @"No");

    if (_isSelected) {
        //fillColor = [NSColor colorWithCalibratedRed: 0.851 green: 0.851 blue: 0.851 alpha: 1];
                    //[NSColor colorWithString:@"#026FFE" andAlpha:1.0];
        fillColor = [NSColor blueColor];
        //fillColor = _btnBgColorEnableSelected;
        //strokeColor = [NSColor colorWithCalibratedRed: 0.408 green: 0.592 blue: 0.855 alpha: 1];
        //strokeColor = _btnBgColorEnableSelected;
        strokeColor = [NSColor blueColor];
    } else {
        //fillColor = [NSColor clearColor];
        fillColor = [NSColor whiteColor];
        //fillColor = _btnBgColorEnableUnSelected;
//        strokeColor = [NSColor colorWithCalibratedRed: 0.749 green: 0.749 blue: 0.749 alpha: 1];
        //strokeColor = _btnBgColorEnableUnSelected;
        strokeColor = [NSColor whiteColor];
    }
    
    //fillColor = _currentBtnBgColor;
    
    [fillColor setFill];
    [imageRoundedRectanglePath fill];
    [strokeColor setStroke];
    
    [super drawRect:dirtyRect];
    */
}

- (void)setIsSelected:(BOOL)isSelected {
    
    NSLog(@"[setIsSelected]: Enter");
    
    _isSelected = isSelected;
    NSLog(@"[setIsSelected]: _isSelected : %@", _isSelected?@"Yes": @"No");
    if (_isSelected) {
        //_currentTitleColor = _titleColorEnableSelected;
        _currentTitleColor = [NSColor blackColor];
    } else {
        //_currentTitleColor = _titleColorEnableUnSelected;
        _currentTitleColor = [NSColor whiteColor];
    }
    
    
    [self setNeedsDisplay:YES];
    
    NSLog(@"[setIsSelected]: Leave");
}

//
//
//
//- (void)mouseEntered:(NSEvent *)event {
//    NSLog(@"[mouseEntered]");
//
//}
//
//- (void)mouseMoved:(NSEvent *)event {
//    NSLog(@"[mouseMoved]");
//
//}
//
//- (void)mouseUp:(NSEvent *)event {
//    NSLog(@"[mouseUp]");
//
//}
//
//- (void)mouseExited:(NSEvent *)event {
//    NSLog(@"[mouseExited]");
//
//}
//
//- (void)mouseDown:(NSEvent *)event {
//    NSLog(@"[mouseDown]");
//
//}
//
//- (void)mouseDragged:(NSEvent *)event {
//    NSLog(@"[mouseDragged]");
//}

@end
