#import "FrtcHyperlinkLabel.h"
#import "FrtcBorderTextFieldCell.h"

@interface FrtcHyperlinkLabel ()

@property (nonatomic, copy)   NSMutableAttributedString* displayString;
@property (nonatomic, copy)   NSString* textString;
@property (nonatomic, strong) NSColor*  displayColor;
@property (nonatomic, strong) NSDictionary* attributes;

@end

@implementation FrtcHyperlinkLabel

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSRect textRect = [self.displayString.string boundingRectWithSize:NSMakeSize(dirtyRect.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.attributes];
    if (self.maximumNumberOfLines == 1) {
        textRect = [self.displayString.string boundingRectWithSize:NSMakeSize(dirtyRect.size.width, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.attributes];
    }
    CGFloat y = (NSHeight(self.bounds) - textRect.size.height) / 2 - 2;
    if (self.isTopAlignment) {
        y = -6;
    }
    if (self.alignment == NSTextAlignmentCenter) {
        CGFloat x = (NSWidth(self.bounds) - textRect.size.width) / 2;
        [self.displayString drawInRect:NSMakeRect(x, y, textRect.size.width,textRect.size.height)];
    }
    else if (self.alignment == NSTextAlignmentLeft) {
        [self.displayString drawInRect:NSMakeRect(0, y, textRect.size.width,textRect.size.height)];
    }else if (self.alignment == NSTextAlignmentRight){
        NSArray* textList = [self.displayString.string componentsSeparatedByString:@"\n"];
        
        if (textList.count == 1) {
            CGFloat x = NSWidth(self.bounds) - textRect.size.width;
            [self.displayString drawInRect:NSMakeRect(x, y, textRect.size.width,textRect.size.height)];
        }else {
            NSInteger index = 0;
            for (NSString* string in textList) {
                NSRect rect = [string boundingRectWithSize:NSMakeSize(dirtyRect.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.attributes];
                NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:string attributes:self.attributes];
                CGFloat x = NSWidth(self.bounds) - rect.size.width;
                CGFloat h = NSHeight(self.bounds)/(textList.count);
                [attrString drawInRect:NSMakeRect(x, h*index, rect.size.width, rect.size.height)];
                index ++;
            }
        }
    }
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self customisedLabel];
    }
    return self;
}

- (void)customisedLabel {
    [[self cell] setBezeled:NO];
    [[self cell] setBordered:NO];
    self.editable = NO;
    self.bordered = NO;
    self.maximumNumberOfLines = 0;
    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.textColor = [NSColor colorWithString:@"2e2e2e" andAlpha:1.0];
    self.trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited owner:self userInfo:nil];
    [self addTrackingArea:self.trackingArea];
    self.backgroundColor = [NSColor clearColor];
}



- (NSAttributedString *)displayString {
    NSFont* font = self.font;
    if (!self.font) {
        font = [NSFont fontWithSFProDisplay:12 andType:SFProDisplayRegular];
    }
    if (self.textString == nil) {
        self.textString = @"";
    }
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.maximumLineHeight = MAXFLOAT;
    paragraphStyle.alignment = self.alignment;

    self.attributes = @{NSForegroundColorAttributeName:self.displayColor,
                        NSFontAttributeName: self.font,
                        NSParagraphStyleAttributeName:paragraphStyle,
                        };
    
    NSMutableAttributedString * attibutedTitle = [[NSMutableAttributedString alloc] initWithString:self.textString attributes:self.attributes];
    return attibutedTitle;
}

- (void)setStringValue:(NSString *)stringValue {
    if (stringValue == nil) {
        stringValue = @"";
    }
    [super setStringValue:stringValue];
    self.textString = stringValue;
    [self setNeedsDisplay];
}

- (void)setAlignment:(NSTextAlignment)alignment {
    [super setAlignment:alignment];
    [self setNeedsDisplay];
}

- (void)setTextColor:(NSColor *)textColor {
    [super setTextColor:[NSColor clearColor]];
    self.displayColor = textColor;
    [self setNeedsDisplay];
}


#pragma mark -- mouse events
- (void)updateTrackingAreas {
    if (self.trackingArea) {
        [self removeTrackingArea:self.trackingArea];
    }
    self.trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited | NSTrackingEnabledDuringMouseDrag owner:self userInfo:nil];
    [self addTrackingArea:self.trackingArea];
    
}

- (void)mouseEntered:(NSEvent *)event {
    if (self.hyperlink) {
        NSCursor *cursor = [NSCursor pointingHandCursor];
        [cursor set];
    }
}

- (void)mouseExited:(NSEvent *)event {
    if (self.hyperlink) {
        NSCursor *cursor = [NSCursor arrowCursor];
        [cursor set];
    }
}

- (void)mouseDown:(NSEvent *)event {
   
}

- (void)mouseUp:(NSEvent *)event {
    if (self.hyperlink) {
        NSCursor *cursor = [NSCursor pointingHandCursor];[cursor set];

        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:self.hyperlink]];
    }
}

@end
