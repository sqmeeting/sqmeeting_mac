#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSUInteger, EnumMouseEventType) {
    //App config
    ENUM_MOUSE_OFF = 100, // mouse out off the button area.
    ENUM_MOUSE_HOVER,     // mouse in button area but not press.
    ENUM_MOUSE_PRESSED,   // mouse pressed in button area.
};

#pragma mark - mouse event State

typedef NS_ENUM(NSUInteger, EnumButtonStatus) {
    //App config
    ENUM_BTN_DISABLE_OFF = 100, // btn disabled.
    ENUM_BTN_DISABLE_HOVER,     // btn disabled.
    ENUM_BTN_DISABLE_PRESSED,   // btn disabled.
    ENUM_BTN_ENABLE_OFF,        // mouse out off the button area.
    ENUM_BTN_ENABLE_HOVER,      // mouse in button area but not press.
    ENUM_BTN_ENABLE_PRESSED,    // mouse pressed in button area.
};

@interface HoverableButton : NSControl {
    NSString *_titleText;
    NSString *_titleFontName;
    CGFloat   _titleFontSize;
    NSTextAlignment _titleTextAlignment;
    
    NSImage *_imageDisableOff;
    NSImage *_imageDisableHover;
    NSImage *_imageDisablePressed;
    NSImage *_imageEnableOff;
    NSImage *_imageEnableHover;
    NSImage *_imageEnablePressed;
    
    NSColor *_titleColorDisableOff;
    NSColor *_titleColorDisableHover;
    NSColor *_titleColorDisablePressed;
    NSColor *_titleColorEnableOff;
    NSColor *_titleColorEnableHover;
    NSColor *_titleColorEnablePressed;

    NSColor *_btnBgColorDisableOff;
    NSColor *_btnBgColorDisableHover;
    NSColor *_btnBgColorDisablePressed;
    NSColor *_btnBgColorEnableOff;
    NSColor *_btnBgColorEnableHover;
    NSColor *_btnBgColorEnablePressed;
    
    NSColor *_btnBorderColorDisableOff;
    NSColor *_btnBorderColorDisableHover;
    NSColor *_btnBorderColorDisablePressed;
    NSColor *_btnBorderColorEnableOff;
    NSColor *_btnBorderColorEnableHover;
    NSColor *_btnBorderColorEnablePressed;
    
    BOOL  _isSelectTypeBtn;
    BOOL  _isSelected;
    BOOL  _preSelected;
    NSColor *_btnBgColorEnableSelected;
    NSColor *_btnBgColorEnableUnSelected;
    NSColor *_titleColorEnableSelected;
    NSColor *_titleColorEnableUnSelected;
    
    NSRect  _imageRect;
    NSRect  _titleRect;
    
    NSImage *_currentImage;
    NSColor *__currentTitleColor;

    NSColor *_currentBtnBgColor;
    NSColor *_currentBorderColor;
    CGFloat  _currentBorderWidth;
    
    NSTrackingArea *_trackingArea;
    EnumButtonStatus _btnStatus;
    
    BOOL  _isMouseDown;
    BOOL  _isShowBorder;
    

}

- (void)setTitle:(NSString *)aString;
- (void)setTitleFont:(NSString *)fontName withSize:(CGFloat)size;

- (void)setDisableOffImagePath:(NSString *)offFileName
            withHoverImagePath:(NSString *)hoverfileName
          withPressedImagePath:(NSString *)pressedfileName;

- (void)setEnableOffImagePath:(NSString *)offFileName
           withHoverImagePath:(NSString *)hoverfileName
         withPressedImagePath:(NSString *)pressedfileName;

- (void)setEnableImage:(NSImage *)enableImage;

- (void)setDisableOffTextColorString:(NSString *)offColor
                withHoverColorString:(NSString *)hoverColor
              withPressedColorString:(NSString *)pressedColor;

- (void)setEnableOffTextColorString:(NSString *)offColor
               withHoverColorString:(NSString *)hoverColor
             withPressedColorString:(NSString *)pressedColor;

- (void)setDisableOffBtnBgColorString:(NSString *)offColor
                 withHoverColorString:(NSString *)hoverColor
               withPressedColorString:(NSString *)pressedColor;

- (void)setEnableOffBtnBgColorString:(NSString *)offColor
                withHoverColorString:(NSString *)hoverColor
              withPressedColorString:(NSString *)pressedColor;

- (void)setEnableOffBtnBorderColorString:(NSString *)offColor
                    withHoverColorString:(NSString *)hoverColor
                  withPressedColorString:(NSString *)pressedColor;

#pragma mark - for selected status.

- (void)setEnableBtnSelectedBgColorString:(NSString *)selectColor
              withUnSelectedBgColorString:(NSString *)unSelectColor
                 withPressedBgColorString:(NSString *)pressedColor;

- (void)setEnableTitleSelectedBgColorString:(NSString *)selectColor
                withUnSelectedBgColorString:(NSString *)unSelectColor
                   withPressedBgColorString:(NSString *)pressedColor;


#pragma mark -

- (void)setImageRect:(NSRect)rect;

- (void)setTitleRect:(NSRect)rect;


- (void)setTitleTextAlignment:(NSTextAlignment)textAlignment;

- (NSDictionary *)getTitleFontAttrbutedDic;

- (void)setEnabled:(BOOL)enabled;

- (NSSize)getSizeOfVerticallyText;

- (void)setSelectTypeBtn:(BOOL)flag;
- (void)setSelected:(BOOL)flag;
- (BOOL)getSelected;

- (void)setShowBorder:(BOOL)showBorder;
- (void)setBorderWidth:(CGFloat)borderWidth;


// -----------------------------------
// Tracking Area
// -----------------------------------

#pragma mark - tracking area

- (void)updateTrackingAreas;


// -----------------------------------
// Update
// -----------------------------------

#pragma mark - update

- (void)updateUI:(EnumMouseEventType)mouseEventType;
- (void)updateImage;
- (void)updateTextColor;
- (void)updateBtnBackgroundColor;

- (void)setBtnStautsWithMouseEvent:(EnumMouseEventType)eventType;

// -----------------------------------
// darw
// -----------------------------------

#pragma mark - draw

// -----------------------------------
// Target action for mouse down.
// -----------------------------------

#pragma mark - target action

- (void)invokeTargetAction;

// -----------------------------------
// Mouse event.
// -----------------------------------

#pragma mark - mouse event


@end
