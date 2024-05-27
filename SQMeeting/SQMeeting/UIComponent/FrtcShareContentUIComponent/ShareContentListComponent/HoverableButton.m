#import "HoverableButton.h"
#import "NSColor+Utils.h"

@implementation HoverableButton

#pragma mark - init

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self setup];
    }
    return self;
}

// -----------------------------------
// Set
// -----------------------------------

#pragma mark - set

- (void)setup {
    _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited | NSTrackingAssumeInside owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
    _btnStatus = ENUM_BTN_DISABLE_OFF;
    
    //_titleFontName = [NSFont systemFontOfSize:11];
    _titleFontSize = [NSFont systemFontSize];
    
    _currentBorderWidth = 0;
    _currentBorderColor = [NSColor lightGrayColor];
    _currentBtnBgColor = [NSColor lightGrayColor];
}

- (void)setTitle:(NSString *)aString {
    _titleText = aString;
}

- (void)setDisableOffImagePath:(NSString *)offFileName
            withHoverImagePath:(NSString *)hoverfileName
          withPressedImagePath:(NSString *)pressedfileName {
    _imageDisableOff = [NSImage imageNamed:offFileName];
    _imageDisableHover = [NSImage imageNamed:hoverfileName];
    _imageDisablePressed = [NSImage imageNamed:pressedfileName];
    //[self setAlternateImage:pressedImage];
    
    [self updateImage];
}

- (void)setEnableOffImagePath:(NSString *)offFileName
           withHoverImagePath:(NSString *)hoverfileName
         withPressedImagePath:(NSString *)pressedfileName {
    _imageEnableOff = [NSImage imageNamed:offFileName];
    _imageEnableHover = [NSImage imageNamed:hoverfileName];
    _imageEnablePressed = [NSImage imageNamed:pressedfileName];
    //[self setAlternateImage:pressedImage];
    
    [self updateImage];
}

- (void)setEnableImage:(NSImage *)enableImage {
    //    _imageDisableOff = disableImage;
    //    _imageDisableHover = disableImage;
    //    _imageDisablePressed = disableImage;
    _imageEnableOff = enableImage;
    _imageEnableHover = enableImage;
    _imageEnablePressed = enableImage;
    
    [self updateImage];
}


#pragma mark - for Text Color

- (void)setDisableOffTextColorString:(NSString *)offColor
                withHoverColorString:(NSString *)hoverColor
              withPressedColorString:(NSString *)pressedColor {
    _titleColorDisableOff = [NSColor colorWithRGBString:offColor withAlpha:1];
    _titleColorDisableHover = [NSColor colorWithRGBString:hoverColor withAlpha:1];
    _titleColorDisablePressed = [NSColor colorWithRGBString:pressedColor withAlpha:1];
    
    [self updateTextColor];
}

- (void)setEnableOffTextColorString:(NSString *)offColor
               withHoverColorString:(NSString *)hoverColor
             withPressedColorString:(NSString *)pressedColor {
    _titleColorEnableOff = [NSColor colorWithRGBString:offColor withAlpha:1];
    _titleColorEnableHover = [NSColor colorWithRGBString:hoverColor withAlpha:1];
    _titleColorEnablePressed = [NSColor colorWithRGBString:pressedColor withAlpha:1];
    
    [self updateTextColor];
}


#pragma mark - for Background Color

- (void)setDisableOffBtnBgColorString:(NSString *)offColor
                 withHoverColorString:(NSString *)hoverColor
               withPressedColorString:(NSString *)pressedColor {
    _btnBgColorDisableOff = [NSColor colorWithRGBString:offColor withAlpha:1];
    _btnBgColorDisableHover = [NSColor colorWithRGBString:hoverColor withAlpha:1];
    _btnBgColorDisablePressed = [NSColor colorWithRGBString:pressedColor withAlpha:1];
    
    [self updateBtnBackgroundColor];
}

- (void)setEnableOffBtnBgColorString:(NSString *)offColor
                withHoverColorString:(NSString *)hoverColor
              withPressedColorString:(NSString *)pressedColor {
    _btnBgColorEnableOff = [NSColor colorWithRGBString:offColor withAlpha:1];
    _btnBgColorEnableHover = [NSColor colorWithRGBString:hoverColor withAlpha:1];
    _btnBgColorEnablePressed = [NSColor colorWithRGBString:pressedColor withAlpha:1];
    
    [self updateBtnBackgroundColor];
}


#pragma mark - for Borader Color

- (void)setDisableOffBtnBorderColorString:(NSString *)offColor
                     withHoverColorString:(NSString *)hoverColor
                   withPressedColorString:(NSString *)pressedColor {
    _btnBorderColorDisableOff = [NSColor colorWithRGBString:offColor withAlpha:1];
    _btnBorderColorDisableHover = [NSColor colorWithRGBString:hoverColor withAlpha:1];
    _btnBorderColorDisablePressed = [NSColor colorWithRGBString:pressedColor withAlpha:1];
    
    [self updateBtnBorderColor];
}

- (void)setEnableOffBtnBorderColorString:(NSString *)offColor
                    withHoverColorString:(NSString *)hoverColor
                  withPressedColorString:(NSString *)pressedColor {
    _btnBorderColorEnableOff = [NSColor colorWithRGBString:offColor withAlpha:1];
    _btnBorderColorEnableHover = [NSColor colorWithRGBString:hoverColor withAlpha:1];
    _btnBorderColorEnablePressed = [NSColor colorWithRGBString:pressedColor withAlpha:1];
    
    [self updateBtnBorderColor];
}

#pragma mark - for selected status.

- (void)setEnableBtnSelectedBgColorString:(NSString *)selectColor
              withUnSelectedBgColorString:(NSString *)unSelectColor
                 withPressedBgColorString:(NSString *)pressedColor {
    
    _btnBgColorEnableSelected = [NSColor colorWithRGBString:selectColor withAlpha:1];
    _btnBgColorEnableUnSelected = [NSColor colorWithRGBString:unSelectColor withAlpha:1];
    _btnBgColorEnablePressed = [NSColor colorWithRGBString:pressedColor withAlpha:1];
    
    [self updateBtnBackgroundColor];
}

- (void)setEnableTitleSelectedBgColorString:(NSString *)selectColor
                withUnSelectedBgColorString:(NSString *)unSelectColor
                   withPressedBgColorString:(NSString *)pressedColor {
    
    _titleColorEnableSelected = [NSColor colorWithRGBString:selectColor withAlpha:1];
    _titleColorEnableUnSelected = [NSColor colorWithRGBString:unSelectColor withAlpha:1];
    _titleColorEnablePressed = [NSColor colorWithRGBString:pressedColor withAlpha:1];
    
    [self updateBtnBackgroundColor];
}


#pragma mark - set

- (void)setImageRect:(NSRect)rect {
    _imageRect = rect;
}

- (void)setTitleRect:(NSRect)rect {
    _titleRect = rect;
}

- (void)setTitleFont:(NSString *)fontName
            withSize:(CGFloat)size {
    _titleFontName = fontName;
    _titleFontSize = size;
}

- (void)setTitleTextAlignment:(NSTextAlignment)textAlignment {
    _titleTextAlignment = textAlignment;
}

- (NSDictionary *)getTitleFontAttrbutedDic {
    NSFont *font = nil;
    if (nil != _titleFontName && 0 < [_titleFontName length]) {
        font = [NSFont fontWithName:_titleFontName size:_titleFontSize];
    } if (0 < _titleFontSize) {
        font = [NSFont systemFontOfSize:_titleFontSize];
    } else {
        font = [NSFont systemFontOfSize:11];
    }
    
    if (nil == __currentTitleColor) {
        __currentTitleColor = [NSColor grayColor];
    }
    
    //font = nil;
    //__currentTitleColor = nil;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:_titleTextAlignment]; //defalut: NSTextAlignmentLeft
    [style setLineBreakMode:NSLineBreakByTruncatingTail];
    
    NSDictionary *attributes = @{
        NSFontAttributeName             : font,
        NSForegroundColorAttributeName  : __currentTitleColor,
        NSParagraphStyleAttributeName   : style
    };
    return attributes;
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self updateUI:ENUM_MOUSE_OFF];
}

- (NSSize)getSizeOfVerticallyText {
    NSAttributedString *inputStr = [[NSAttributedString alloc] initWithString:_titleText
                                                                   attributes:[self getTitleFontAttrbutedDic]];
    return [inputStr size];
}

- (void)setSelectTypeBtn:(BOOL)flag {
    _isSelectTypeBtn = flag;
}

- (void)setSelected:(BOOL)flag {
    _isSelected = flag;
    //NSLog(@"[HoverableButton] [setSelected:]  isSelected: %@", flag? @"Yes": @"Not");
    //_btnStatus = flag ? ENUM_BTN_ENABLE_PRESSED : ENUM_BTN_ENABLE_OFF;
    
    [self updateBtnBackgroundColor];
}

- (BOOL)getSelected {
    return _isSelected;
}

- (void)setShowBorder:(BOOL)showBorder {
    _isShowBorder = showBorder;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _currentBorderWidth = borderWidth;
}


// -----------------------------------
// Tracking Area
// -----------------------------------

#pragma mark - tracking area

- (void)updateTrackingAreas {
    if (_trackingArea) {
        [self removeTrackingArea:_trackingArea];
        //[_trackingArea release];
    }
    _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds
                                                 options:NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited | NSTrackingAssumeInside
                                                   owner:self
                                                userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

// -----------------------------------
// Update
// -----------------------------------

#pragma mark - update

- (void)updateUI:(EnumMouseEventType)mouseEventType {
    
    [self setBtnStautsWithMouseEvent:mouseEventType];
    [self updateImage];
    [self updateTextColor];
    
    //[self updateBtnBorderColor];
    //[self updateBtnBackgroundColor];
}

- (void)setBtnStautsWithMouseEvent:(EnumMouseEventType)eventType {
    switch (eventType) {
        case ENUM_MOUSE_OFF: {
            //NSLog(@"[HoverableButton] [setBtnStautsWithMouseEvent] : mouse off: -> updateBtnBorderColor");
            _btnStatus = [self isEnabled] ? ENUM_BTN_ENABLE_OFF : ENUM_BTN_DISABLE_OFF;
            [self updateBtnBorderColor];
            break;
        }
        case ENUM_MOUSE_HOVER: {
            //NSLog(@"[HoverableButton] [setBtnStautsWithMouseEvent] : mouse hover: -> updateBtnBorderColor");
            _btnStatus = [self isEnabled] ? ENUM_BTN_ENABLE_HOVER : ENUM_BTN_DISABLE_HOVER;
            [self updateBtnBorderColor];
            break;
        }
        case ENUM_MOUSE_PRESSED: {
            //NSLog(@"[HoverableButton] [setBtnStautsWithMouseEvent] : mouse press: -> updateBtnBackgroundColor");
            _btnStatus = [self isEnabled] ? ENUM_BTN_ENABLE_PRESSED : ENUM_BTN_DISABLE_PRESSED;
            [self updateBtnBackgroundColor];
            break;
        }
        default: {
            //NSLog(@"[HoverableButton] [setBtnStautsWithMouseEvent] : mouse other: -> !!! no");
            _btnStatus = [self isEnabled] ? ENUM_BTN_ENABLE_OFF : ENUM_BTN_DISABLE_OFF;
            break;
        }
    }
    //    [self updateBtnBackgroundColor];
}

- (void)updateImage {
    switch (_btnStatus) {
        case ENUM_BTN_DISABLE_OFF: {
            _currentImage = _imageDisableOff;
        }
            break;
        case ENUM_BTN_DISABLE_HOVER: {
            _currentImage = _imageDisableHover;
        }
            break;
        case ENUM_BTN_DISABLE_PRESSED: {
            _currentImage = _imageDisablePressed;
        }
            break;
        case ENUM_BTN_ENABLE_OFF: {
            _currentImage = _imageEnableOff;
        }
            break;
        case ENUM_BTN_ENABLE_HOVER: {
            _currentImage = _imageEnableHover;
        }
            break;
        case ENUM_BTN_ENABLE_PRESSED: {
            _currentImage = _imageEnablePressed;
        }
            break;
        default: {
            _currentImage = _imageEnableOff;
        }
            break;
    }
    [self setNeedsDisplay:YES];
}

- (void)updateTextColor {
    
    //for select type button
    if (_isSelectTypeBtn) {
        if (_isSelected) {
            __currentTitleColor = _titleColorEnableSelected;
            NSLog(@"[HoverableButton] [updateTextColor] _isSelected : %@", _isSelected? @"Yes": @"Not");
        } else {
            __currentTitleColor = _titleColorEnableUnSelected;
            NSLog(@"[HoverableButton] [updateTextColor] _isSelected : %@", _isSelected? @"Yes": @"Not");
        }
        [self setNeedsDisplay:YES];
        return;
    }
    
    switch (_btnStatus) {
        case ENUM_BTN_DISABLE_OFF: {
            __currentTitleColor = _titleColorDisableOff;
        }
            break;
        case ENUM_BTN_DISABLE_HOVER: {
            __currentTitleColor = _titleColorDisableHover;
        }
            break;
        case ENUM_BTN_DISABLE_PRESSED: {
            __currentTitleColor = _titleColorDisablePressed;
        }
            break;
        case ENUM_BTN_ENABLE_OFF: {
            __currentTitleColor = _titleColorEnableOff;
        }
            break;
        case ENUM_BTN_ENABLE_HOVER: {
            __currentTitleColor = _titleColorEnableHover;
        }
            break;
        case ENUM_BTN_ENABLE_PRESSED: {
            __currentTitleColor = _titleColorEnablePressed;
        }
            break;
        default: {
            __currentTitleColor = _titleColorEnableOff;
        }
            break;
    }
    [self setNeedsDisplay:YES];
}

- (void)updateBtnBackgroundColor {
    
    //NSLog(@"[HoverableButton] [updateBtnBackgroundColor] enter");
    
    //for select type button
    if (_isSelectTypeBtn) {
        if (_isSelected) {
            _currentBtnBgColor = _btnBgColorEnableSelected;
            //NSLog(@"[HoverableButton] [updateBtnBackgroundColor] _isSelected : %@", _isSelected? @"Yes": @"Not");
        } else {
            _currentBtnBgColor = _btnBgColorEnableUnSelected;
            //NSLog(@"[HoverableButton] [updateBtnBackgroundColor] _isSelected : %@", _isSelected? @"Yes": @"Not");
        }
        [self setNeedsDisplay:YES];
        return;
    }
    
    
    switch (_btnStatus) {
        case ENUM_BTN_DISABLE_OFF: {
            _currentBtnBgColor = _btnBgColorDisableOff;
        }
            break;
        case ENUM_BTN_DISABLE_HOVER: {
            _currentBtnBgColor = _btnBgColorDisableHover;
        }
            break;
        case ENUM_BTN_DISABLE_PRESSED: {
            _currentBtnBgColor = _btnBgColorDisablePressed;
        }
            break;
        case ENUM_BTN_ENABLE_OFF: {
            _currentBtnBgColor = _btnBgColorEnableOff;
        }
            break;
        case ENUM_BTN_ENABLE_HOVER: {
            _currentBtnBgColor = _btnBgColorEnableHover;
        }
            break;
        case ENUM_BTN_ENABLE_PRESSED: {
            _currentBtnBgColor = _btnBgColorEnablePressed;
        }
            break;
        default: {
            _currentBtnBgColor = _btnBgColorEnableOff;
        }
            break;
    }
    [self setNeedsDisplay:YES];
    
    //    if (ENUM_BTN_ENABLE_HOVER == _btnStatus || ENUM_BTN_ENABLE_PRESSED == _btnStatus) {
    //        _currentBorderWidth = 0.5;
    //        _currentBorderColor = [NSColor lightGrayColor];
    //    } else {
    //        _currentBorderWidth = 0;
    //        _currentBorderColor = [NSColor lightGrayColor];
    //    }
    //NSLog(@"[HoverableButton] [updateBtnBackgroundColor] leave");
    
}

- (void)updateBtnBorderColor {
    
    //NSLog(@"[HoverableButton] [updateBtnBackgroundColor] enter");
    
    switch (_btnStatus) {
        case ENUM_BTN_DISABLE_OFF: {
            _currentBorderColor = _btnBorderColorDisableOff;
        }
            break;
        case ENUM_BTN_DISABLE_HOVER: {
            _currentBorderColor = _btnBorderColorDisableHover;
        }
            break;
        case ENUM_BTN_DISABLE_PRESSED: {
            _currentBorderColor = _btnBorderColorDisablePressed;
        }
            break;
        case ENUM_BTN_ENABLE_OFF: {
            _currentBorderColor = _btnBorderColorEnableOff;
        }
            break;
        case ENUM_BTN_ENABLE_HOVER: {
            _currentBorderColor = _btnBorderColorEnableHover;
        }
            break;
        case ENUM_BTN_ENABLE_PRESSED: {
            _currentBorderColor = _btnBorderColorEnablePressed;
        }
            break;
        default: {
            _currentBtnBgColor = _btnBorderColorEnableOff;
        }
            break;
    }
    
    //    if (ENUM_BTN_ENABLE_HOVER == _btnStatus || ENUM_BTN_ENABLE_PRESSED == _btnStatus) {
    //        _currentBorderWidth = 1;
    //        //_currentBorderColor = [NSColor lightGrayColor];
    //        _currentBorderColor = _btnBorderColorEnableHover;
    //    } else {
    //        _currentBorderWidth = 0;
    //        //_currentBorderColor = [NSColor lightGrayColor];
    //        _currentBorderColor = _btnBorderColorEnableOff;
    //    }
    
    [self setNeedsDisplay:YES];
    
    //NSLog(@"[HoverableButton] [updateBtnBorderColor] leave");
}


// -----------------------------------
// darw
// -----------------------------------

#pragma mark - draw

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    [_currentImage drawInRect:_imageRect];
    [_titleText drawInRect:_titleRect withAttributes:[self getTitleFontAttrbutedDic]];
    
    //not show border.
    if (_isShowBorder) {
        if (0 <= _currentBorderWidth) {
            self.layer.borderWidth = _currentBorderWidth;
            self.layer.borderColor = [_currentBorderColor CGColor];
        }
    }
    
    if (nil != _currentBtnBgColor) {
        self.layer.backgroundColor = [_currentBtnBgColor CGColor];
    }
    self.layer.cornerRadius = 4; //3;
    
}

// -----------------------------------
// Target action for mouse down.
// -----------------------------------

#pragma mark - target action

- (void)invokeTargetAction {
    if (self.target && self.action) {
        [self.target performSelector:self.action withObject:self afterDelay:0.0];
    }
}

// -----------------------------------
// Mouse event.
// -----------------------------------

#pragma mark - mouse event

- (void)mouseEntered:(NSEvent *)event {
    
    //NSLog(@" --- --- --- [HoverableButton] [mouseEntered] ENUM_MOUSE_HOVER --- --- ---");
    [self updateUI:ENUM_MOUSE_HOVER];
}

- (void)mouseExited:(NSEvent *)event {
    //NSLog(@" --- --- ---[HoverableButton] [mouseExited] ENUM_MOUSE_OFF --- --- ---");
    [self updateUI:ENUM_MOUSE_OFF];
}

- (void)mouseDown:(NSEvent *)event {
    //NSLog(@"--- --- --- [HoverableButton] [mouseDown] ENUM_MOUSE_PRESSED --- --- ---");
    _isSelected = YES;
    [self updateUI:ENUM_MOUSE_PRESSED];
}

- (void)mouseUp:(NSEvent *)theEvent {
    
    //NSLog(@"[HoverableButton] [mouseUp]");
    
    if (ENUM_BTN_ENABLE_PRESSED == _btnStatus) {
        self.needsDisplay = YES;
        if ([self isEnabled]) {
            [self invokeTargetAction];
        }
    }
    
    EnumMouseEventType mouseEventType = ENUM_MOUSE_OFF;
    NSPoint locationInView = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    BOOL isMouseIn = [self mouse:locationInView inRect:self.bounds];
    if (isMouseIn) {
        mouseEventType = ENUM_MOUSE_HOVER;
    } else {
        mouseEventType = ENUM_MOUSE_OFF;
    }
    
    //NSLog(@"[HoverableButton] [mouseUp] -> call updateUI:");
    [self updateUI:mouseEventType];
}

//- (void)rightMouseUp:(NSEvent *)theEvent {
//    NSLog(@"%s: %d", __func__, __LINE__);
//}

@end
