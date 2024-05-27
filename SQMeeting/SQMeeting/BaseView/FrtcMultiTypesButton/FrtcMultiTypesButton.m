#import "FrtcMultiTypesButton.h"
#import "FrtcBaseImplement.h"

@interface FrtcMultiTypesButton()<PMButtonCellDeletegate>
@end

@implementation FrtcMultiTypesButton

- (instancetype)initFirstWithFrame:(NSRect)frame withTitle:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        self.btnStyle = FR_BTN_PRIMARY;
        [self customizedPrimaryStyle:title];
    }
    return self;
}

- (instancetype)initSecondaryWithFrame:(NSRect)frame withTitle:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        self.btnStyle = FR_BTN_SECONDARY;
        [self customizedSecondaryStyle:title];
    }
    return self;
}

- (instancetype)initThirdWithFrame:(NSRect)frame withTitle:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        self.btnStyle = FR_BTN_THIRD;
        [self customizedThirdStyle:title];
    }
    return self;
}

- (instancetype)initForthWithFrame:(NSRect)frame withTitle:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        self.btnStyle = FR_BTN_FORTH;
        [self customizedForthStyle:title];
    }
    return self;
}

- (instancetype)initFifthWithFrame:(NSRect)frame withTitle:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        self.btnStyle = FR_BTN_FIFTH;
        [self customizedFifthStyle:title];
    }
    return self;
}

- (instancetype)initSixWithFrame:(NSRect)frame withTitle:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        self.btnStyle = FR_BTN_SIX;
        [self customizedFifthStyle:title];
    }
    return self;
}

- (instancetype)initEightWithFrame:(NSRect)frame withTitle:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        self.btnStyle = FR_BTN_EIGHT;
        [self customizedEightStyle:title];
    }
    return self;
}

- (instancetype)initNineWithFrame:(NSRect)frame
                         withTitle:(NSString *)title
                      withFontSize:(CGFloat)fontSize
                  withCornerRadius:(CGFloat)cornerRadius {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.btnStyle = FR_BTN_NINE; //custom the FR_BTN_PRIMARY;
        [self customizedNineStyle:title withFontSize:fontSize withCornerRadius:cornerRadius];
    }
    return self;
}

- (instancetype)initTenWithFrame:(NSRect)frame
                        withTitle:(NSString *)title
                     withFontSize:(CGFloat)fontSize
                   withTitleColor:(NSColor *)titleColor
                 withCornerRadius:(CGFloat)cornerRadius
              withBackgroundColor:(NSColor *)backgroundColor
                       withBorder:(BOOL)isBorder
                  withBorderColor:(NSColor *)borderColor
                  withBorderWidth:(CGFloat)borderWidth {

    self = [super initWithFrame:frame];
    if (self) {
        self.btnStyle = FR_BTN_TEN;
        [self customizedTenTitle:title
                     withFontSize:fontSize
                   withTitleColor:titleColor
                 withCornerRadius:cornerRadius
              withBackgroundColor:backgroundColor
                       withBorder:isBorder
                  withBorderColor:borderColor
                  withBorderWidth:borderWidth];
    }
    return self;
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    NSTrackingAreaOptions options = NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
}

- (void)customizedItemsStyle:(NSString *)title {
    self.btnCell = [[FrtcMultiTypesButtonCell alloc] init];
    self.btnCell.delegate = self;
    self.cell = self.btnCell;
    NSString *titleStr = [NSString stringWithFormat:@"    %@", title];
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:titleStr];
    NSUInteger len = [attrTitle length];
    NSRange range = NSMakeRange(0, len);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    [attrTitle addAttribute:NSForegroundColorAttributeName value:[[FrtcBaseImplement baseImpleSingleton] whiteColor]
                      range:range];
    [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                      range:range];
    
    [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                      range:range];
    [attrTitle fixAttributesInRange:range];
    [self setAttributedTitle:attrTitle];
    attrTitle = nil;
    [self setNeedsDisplay:YES];
    [self setBordered:NO];
    [self bezelStyle];
    [self setWantsLayer:YES];
    self.layer.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] titleButtonBackGroundColor].CGColor;
    self.layer.masksToBounds = YES;
    self.bezelStyle = NSBezelStyleRegularSquare;
}

- (void)customizedPrimaryStyle:(NSString *)title {
    self.hover = YES;
    self.btnCell = [[FrtcMultiTypesButtonCell alloc] init];
    self.btnCell.delegate = self;
    self.cell = self.btnCell;
    
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:title];
    NSUInteger len = [attrTitle length];
    NSRange range = NSMakeRange(0, len);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attrTitle addAttribute:NSForegroundColorAttributeName value:[[FrtcBaseImplement baseImpleSingleton] whiteColor]
                      range:range];
    [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:16]
                      range:range];
    
    [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                      range:range];
    [attrTitle fixAttributesInRange:range];
    [self setAttributedTitle:attrTitle];
    attrTitle = nil;
    [self setNeedsDisplay:YES];
    [self setBordered:NO];
    [self bezelStyle];
    [self setWantsLayer:YES];
    self.layer.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] blueColor].CGColor;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8.0;
    self.bezelStyle = NSBezelStyleRegularSquare;
}

- (void)customizedSecondaryStyle:(NSString *)title {
    self.hover = YES;
    self.btnCell = [[FrtcMultiTypesButtonCell alloc] init];
    self.btnCell.delegate = self;
    self.cell = self.btnCell;
  
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:title];
    NSUInteger len = [attrTitle length];
    NSRange range = NSMakeRange(0, len);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attrTitle addAttribute:NSForegroundColorAttributeName value:[[FrtcBaseImplement baseImpleSingleton] baseColor]
                      range:range];
    [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:16]
                      range:range];
    
    [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                      range:range];
    [attrTitle fixAttributesInRange:range];
    [self setAttributedTitle:attrTitle];
    attrTitle = nil;
    [self setNeedsDisplay:YES];
    [self setBordered:NO];
    [self bezelStyle];
    self.wantsLayer = YES;
    self.layer.cornerRadius = 8.0f;
    self.layer.borderColor = [NSColor colorWithString:@"#999999" andAlpha:1.0].CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.masksToBounds = YES;
    self.layer.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] whiteColor].CGColor;
    self.bezelStyle = NSBezelStyleRegularSquare;
}

- (void)customizedThirdStyle:(NSString *)title {
    self.hover = YES;
    self.btnCell = [[FrtcMultiTypesButtonCell alloc] init];
    self.btnCell.delegate = self;
    self.cell = self.btnCell;

    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:title];
    NSUInteger len = [attrTitle length];
    NSRange range = NSMakeRange(0, len);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#026FFE" andAlpha:1.0]
                      range:range];
    [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                      range:range];
    
    [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                      range:range];
    [attrTitle fixAttributesInRange:range];
    [self setAttributedTitle:attrTitle];
    attrTitle = nil;
    [self setNeedsDisplay:YES];
    [self setBordered:NO];
    [self bezelStyle];
    self.wantsLayer = YES;
    self.layer.cornerRadius = 8.0f;
    self.layer.borderColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0].CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.masksToBounds = YES;
    self.layer.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] whiteColor].CGColor;
    self.bezelStyle = NSBezelStyleRegularSquare;
}

- (void)customizedForthStyle:(NSString *)title {
    self.hover = YES;
    self.btnCell = [[FrtcMultiTypesButtonCell alloc] init];
    self.btnCell.delegate = self;
    self.cell = self.btnCell;

    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:title];
    NSUInteger len = [attrTitle length];
    NSRange range = NSMakeRange(0, len);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#666666" andAlpha:1.0]
                      range:range];
    [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:12]
                      range:range];
    
    [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                      range:range];
    [attrTitle fixAttributesInRange:range];
    [self setAttributedTitle:attrTitle];
    attrTitle = nil;
    [self setNeedsDisplay:YES];
    [self setBordered:NO];
    [self bezelStyle];
    self.wantsLayer = YES;
    self.layer.cornerRadius = 8.0f;
    self.layer.borderColor = [NSColor colorWithString:@"#CCCCCC" andAlpha:1.0].CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.masksToBounds = YES;
    self.layer.backgroundColor = [NSColor colorWithString:@"#F8F9FA" andAlpha:1.0].CGColor;
    self.bezelStyle = NSBezelStyleRegularSquare;
}

- (void)customizedFifthStyle:(NSString *)title {
    self.hover = YES;
    self.btnCell = [[FrtcMultiTypesButtonCell alloc] init];
    self.btnCell.delegate = self;
    self.cell = self.btnCell;

    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:title];
    NSUInteger len = [attrTitle length];
    NSRange range = NSMakeRange(0, len);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#333333" andAlpha:1.0]
                      range:range];
    [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                      range:range];
    
    [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                      range:range];
    [attrTitle fixAttributesInRange:range];
    [self setAttributedTitle:attrTitle];
    attrTitle = nil;
    [self setNeedsDisplay:YES];
    [self setBordered:NO];
    [self bezelStyle];
    self.wantsLayer = YES;
    self.layer.cornerRadius = 4.0f;
    self.layer.borderColor = [NSColor colorWithString:@"#CCCCCC" andAlpha:1.0].CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.masksToBounds = YES;
    self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
    self.bezelStyle = NSBezelStyleRegularSquare;
}

- (void)customizedEightStyle:(NSString *)title {
    self.hover = YES;
    self.btnCell = [[FrtcMultiTypesButtonCell alloc] init];
    self.btnCell.delegate = self;
    self.cell = self.btnCell;

    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:title];
    NSUInteger len = [attrTitle length];
    NSRange range = NSMakeRange(0, len);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#222222" andAlpha:1.0]
                      range:range];
    [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                      range:range];
    
    [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                      range:range];
    [attrTitle fixAttributesInRange:range];
    [self setAttributedTitle:attrTitle];
    attrTitle = nil;
    [self setNeedsDisplay:YES];
    [self setBordered:NO];
    [self bezelStyle];
    self.wantsLayer = YES;
    self.layer.cornerRadius = 4.0f;
    self.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.masksToBounds = YES;
    self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
    self.bezelStyle = NSBezelStyleRegularSquare;
}

- (void)customizedNineStyle:(NSString *)title
                withFontSize:(CGFloat)fontSize
            withCornerRadius:(CGFloat)cornerRadius {
    self.hover = YES;
    self.btnCell = [[FrtcMultiTypesButtonCell alloc] init];
    self.btnCell.delegate = self;
    self.cell = self.btnCell;
    
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:title];
    NSUInteger len = [attrTitle length];
    NSRange range = NSMakeRange(0, len);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attrTitle addAttribute:NSForegroundColorAttributeName value:[[FrtcBaseImplement baseImpleSingleton] whiteColor]
                      range:range];
    [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:fontSize]
                      range:range];
    [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                      range:range];
    [attrTitle fixAttributesInRange:range];
    [self setAttributedTitle:attrTitle];
    attrTitle = nil;
    [self setNeedsDisplay:YES];
    [self setBordered:NO];
    [self bezelStyle];
    [self setWantsLayer:YES];
    self.layer.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] blueColor].CGColor;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    self.bezelStyle = NSBezelStyleRegularSquare;
}

- (void)customizedTenTitle:(NSString *)title
               withFontSize:(CGFloat)fontSize
             withTitleColor:(NSColor *)titleColor
           withCornerRadius:(CGFloat)cornerRadius
        withBackgroundColor:(NSColor *)backgroundColor
                 withBorder:(BOOL)isBorder
            withBorderColor:(NSColor *)borderColor
            withBorderWidth:(CGFloat)borderWidth {
    
    self.hover = NO; //YES;
    self.btnCell = [[FrtcMultiTypesButtonCell alloc] init];
    self.btnCell.delegate = self;
    self.cell = self.btnCell;
    
    NSLog(@"self.title: %@, title: %@", self.title, title);

    // [[FrtcBaseImplement baseImpleSingleton] whiteColor]
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:title];
    NSUInteger len = [attrTitle length];
    NSRange range = NSMakeRange(0, len);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attrTitle addAttribute:NSForegroundColorAttributeName value:titleColor
                      range:range];
    [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:fontSize]
                      range:range];
    [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                      range:range];
    [attrTitle fixAttributesInRange:range];
    [self setAttributedTitle:attrTitle];
    attrTitle = nil;
    [self setNeedsDisplay:YES];
    [self setBordered:isBorder];
    
    if (isBorder) {
        self.layer.cornerRadius = cornerRadius;
        self.layer.borderColor = borderColor.CGColor;
        self.layer.borderWidth = borderWidth; //1.0
    }
    
    [self bezelStyle];
    [self setWantsLayer:YES];
    self.layer.backgroundColor = backgroundColor.CGColor; //[[FrtcBaseImplement baseImpleSingleton] blueColor].CGColor;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    self.bezelStyle = NSBezelStyleRegularSquare;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)updateBKColor:(BOOL)flag {
    if(self.isHover == NO) {
        return;
    }
    
    if (self.btnStyle == FR_BTN_PRIMARY) {
        if (flag) {
            self.layer.backgroundColor = [NSColor colorWithString:@"#1F80FF" andAlpha:1.0].CGColor;
        } else {
            self.layer.backgroundColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0].CGColor;
        }
    } else if (self.btnStyle == FR_BTN_SECONDARY) {
        if (flag) {
            self.layer.backgroundColor =[NSColor colorWithString:@"#F8F9FA" andAlpha:1.0].CGColor;;
            self.layer.borderColor = [NSColor colorWithString:@"#666666" andAlpha:1.0].CGColor;
        } else {
            self.layer.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] whiteColor].CGColor;
            self.layer.borderColor = [NSColor colorWithString:@"#999999" andAlpha:1.0].CGColor;
        }
    } else if (self.btnStyle == FR_BTN_ITEM) {
        if (flag) {
            self.layer.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] buttonTitleColor].CGColor;
        } else {
            self.layer.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] titleButtonBackGroundColor].CGColor;
        }
    } else if(self.btnStyle == FR_BTN_THIRD) {
        if (flag) {
            self.layer.backgroundColor = [NSColor colorWithString:@"#1F80FF" andAlpha:1.0].CGColor;
            self.layer.borderColor = [NSColor colorWithString:@"#1F80FF" andAlpha:1.0].CGColor;
            NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:self.title];
            NSUInteger len = [attrTitle length];
            NSRange range = NSMakeRange(0, len);
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] range:range];
            [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                              range:range];
            
            [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                              range:range];
            [attrTitle fixAttributesInRange:range];
            [self setAttributedTitle:attrTitle];
        } else {
            self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
            self.layer.borderColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0].CGColor;
            NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:self.title];
            NSUInteger len = [attrTitle length];
            NSRange range = NSMakeRange(0, len);
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] range:range];
            [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                              range:range];

            [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                              range:range];
            [attrTitle fixAttributesInRange:range];
            [self setAttributedTitle:attrTitle];
        }
    } else if(self.btnStyle == FR_BTN_FORTH) {
        if (flag) {
            self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
            self.layer.borderColor = [NSColor colorWithString:@"#E32726" andAlpha:1.0].CGColor;
            NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:self.title];
            NSUInteger len = [attrTitle length];
            NSRange range = NSMakeRange(0, len);
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#E32726" andAlpha:1.0] range:range];
            [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:12]
                              range:range];
            
            [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                              range:range];
            [attrTitle fixAttributesInRange:range];
            [self setAttributedTitle:attrTitle];
        } else {
            self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
            self.layer.borderColor = [NSColor colorWithString:@"#CCCCCC" andAlpha:1.0].CGColor;
            NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:self.title];
            NSUInteger len = [attrTitle length];
            NSRange range = NSMakeRange(0, len);
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#333333" andAlpha:1.0] range:range];
            [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:12]
                              range:range];

            [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                              range:range];
            [attrTitle fixAttributesInRange:range];
            [self setAttributedTitle:attrTitle];
        }
    } else if(self.btnStyle == FR_BTN_FIFTH) {
        if (flag) {
            self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
            self.layer.borderColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0].CGColor;
            NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:self.title];
            NSUInteger len = [attrTitle length];
            NSRange range = NSMakeRange(0, len);
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] range:range];
            [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                              range:range];
            
            [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                              range:range];
            [attrTitle fixAttributesInRange:range];
            [self setAttributedTitle:attrTitle];
        } else {
            self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
            self.layer.borderColor = [NSColor colorWithString:@"#CCCCCC" andAlpha:1.0].CGColor;
            NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:self.title];
            NSUInteger len = [attrTitle length];
            NSRange range = NSMakeRange(0, len);
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#666666" andAlpha:1.0] range:range];
            [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                              range:range];

            [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                              range:range];
            [attrTitle fixAttributesInRange:range];
            [self setAttributedTitle:attrTitle];
        }
    } else if(self.btnStyle == FR_BTN_SIX) {
        if (flag) {
            self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
            self.layer.borderColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0].CGColor;
            NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:self.title];
            NSUInteger len = [attrTitle length];
            NSRange range = NSMakeRange(0, len);
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] range:range];
            [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                              range:range];
            
            [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                              range:range];
            [attrTitle fixAttributesInRange:range];
            [self setAttributedTitle:attrTitle];
        } else {
            self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
            self.layer.borderColor = [NSColor colorWithString:@"#CCCCCC" andAlpha:1.0].CGColor;
            NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:self.title];
            NSUInteger len = [attrTitle length];
            NSRange range = NSMakeRange(0, len);
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] range:range];
            [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                              range:range];

            [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                              range:range];
            [attrTitle fixAttributesInRange:range];
            [self setAttributedTitle:attrTitle];
        }
    } else if(self.btnStyle == FR_BTN_SEVEN) {
        if (flag) {
            NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:self.title];
            NSUInteger len = [attrTitle length];
            NSRange range = NSMakeRange(0, len);
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] range:range];
            [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                              range:range];
            
            [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                              range:range];
            [attrTitle fixAttributesInRange:range];
            [self setAttributedTitle:attrTitle];
        } else {
            NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:self.title];
            NSUInteger len = [attrTitle length];
            NSRange range = NSMakeRange(0, len);
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#333333" andAlpha:1.0] range:range];
            [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                              range:range];

            [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                              range:range];
            [attrTitle fixAttributesInRange:range];
            [self setAttributedTitle:attrTitle];
        }
    } else if(self.btnStyle == FR_BTN_EIGHT) {
        if (flag) {
            self.layer.borderColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0].CGColor;
            NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:self.title];
            NSUInteger len = [attrTitle length];
            NSRange range = NSMakeRange(0, len);
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] range:range];
            [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                              range:range];
            
            [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                              range:range];
            [attrTitle fixAttributesInRange:range];
            [self setAttributedTitle:attrTitle];
        } else {
            self.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
            NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:self.title];
            NSUInteger len = [attrTitle length];
            NSRange range = NSMakeRange(0, len);
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#222222" andAlpha:1.0] range:range];
            [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                              range:range];

            [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                              range:range];
            [attrTitle fixAttributesInRange:range];
            [self setAttributedTitle:attrTitle];
        }
    } else if (self.btnStyle == FR_BTN_NINE) {
        if (flag) {
            self.layer.backgroundColor = [NSColor colorWithString:@"#1F80FF" andAlpha:1.0].CGColor;
        } else {
            self.layer.backgroundColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0].CGColor;
        }
    } else if (self.btnStyle == FR_BTN_TEN) {
        if (flag) {
            self.layer.backgroundColor = [NSColor colorWithString:@"#F0F0F5" andAlpha:1.0].CGColor;
        } else {
            self.layer.backgroundColor = [NSColor colorWithString:@"#F0F0F5" andAlpha:1.0].CGColor;
        }
    }
}

- (void)highlitCallBack:(BOOL)flag {
   // [self updateBKColor:flag];
}

- (void)mouseEntered:(NSEvent *)event {
    [[NSCursor pointingHandCursor] set];
    [self updateBKColor:YES];
}

- (void)mouseExited:(NSEvent *)event {
    [[NSCursor arrowCursor] set];
    [self updateBKColor:NO];
}

@end
