#import "FrtcButton.h"

@interface FrtcButton() <FrtcButtonCellDeletegate>

@end

@implementation FrtcButton

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frame
               withNormalMode:(FrtcButtonMode *)normalMode
                withHoverMode:(FrtcButtonMode *)hoverMode {
    self = [super initWithFrame:frame];
    
    if(self) {
        self.normalButtonMode = normalMode;
        self.hoverButtonMode  = hoverMode;
        [self customizedPrimaryStyle];
    }
    
    return self;
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    NSTrackingAreaOptions options = NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
}

- (void)customizedPrimaryStyle {
    self.btnCell = [[FrtcButtonCell alloc] init];
    self.btnCell.delegate = self;
    self.cell = self.btnCell;
    
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:self.normalButtonMode.title];
    NSUInteger len = [attrTitle length];
    NSRange range = NSMakeRange(0, len);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attrTitle addAttribute:NSForegroundColorAttributeName value:self.normalButtonMode.titleColor
                      range:range];
    [attrTitle addAttribute:NSFontAttributeName value:self.normalButtonMode.font
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
    self.layer.backgroundColor  = self.normalButtonMode.backgroudColor.CGColor;
    self.layer.borderColor      = self.normalButtonMode.borderColor.CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.masksToBounds    = YES;
    self.layer.cornerRadius     = 4.0;
    self.bezelStyle = NSBezelStyleRegularSquare;
}

- (void)updateBKColor:(BOOL)flag {
    if(!self.isHoverd) {
        return;
    }
    
    if (flag) {
        self.layer.backgroundColor = self.hoverButtonMode.backgroudColor.CGColor;
        self.layer.borderColor = self.hoverButtonMode.borderColor.CGColor;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:self.hoverButtonMode.title];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:self.hoverButtonMode.titleColor range:range];
        [attrTitle addAttribute:NSFontAttributeName value:self.hoverButtonMode.font
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [self setAttributedTitle:attrTitle];
    } else {
        self.layer.backgroundColor = self.normalButtonMode.backgroudColor.CGColor;
        self.layer.borderColor = self.normalButtonMode.borderColor.CGColor;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:self.normalButtonMode.title];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:self.normalButtonMode.titleColor range:range];
        [attrTitle addAttribute:NSFontAttributeName value:self.normalButtonMode.font
                          range:range];

        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [self setAttributedTitle:attrTitle];
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

- (void)updateButtonWithButtonMode:(FrtcButtonMode *)buttonMode {
    self.layer.backgroundColor = buttonMode.backgroudColor.CGColor;
    self.layer.borderColor = buttonMode.borderColor.CGColor;
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:buttonMode.title];
    NSUInteger len = [attrTitle length];
    NSRange range = NSMakeRange(0, len);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attrTitle addAttribute:NSForegroundColorAttributeName value:buttonMode.titleColor range:range];
    [attrTitle addAttribute:NSFontAttributeName value:buttonMode.font
                      range:range];

    [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                      range:range];
    [attrTitle fixAttributesInRange:range];
    [self setAttributedTitle:attrTitle];
}

@end
