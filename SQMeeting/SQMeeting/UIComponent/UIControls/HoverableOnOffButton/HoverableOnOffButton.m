#import "HoverableOnOffButton.h"

@implementation HoverableOnOffButtonCell

@synthesize textLeftOffset;
@synthesize textTopOffset;


- (void) setOnStatusHoverImagePath:(NSString*)fileName
{
    _onStatusHoverImage = [NSImage imageNamed:fileName];
    [self updateImage];
}

- (void) setOffStatusHoverImagePath:(NSString*)fileName
{
    _offStatusHoverImage = [NSImage imageNamed:fileName];
    [self updateImage];
}

- (void) setPressedImagePath:(NSString*)fileName
{
    NSImage* pressedImage = [NSImage imageNamed:fileName];
    //[pressedImage retain];
    [self setAlternateImage:pressedImage];
}

- (void) setOnStatusImagePath:(NSString*)fileName
{
    _onStatusImage = [NSImage imageNamed:fileName];
    [self updateImage];
}

- (void) setDisabledOnStatusImagePath:(NSString*)path
{
    _disabledonStatusImage = [NSImage imageNamed:path];
    [self updateImage];
}

- (void) setDisabledOffStatusImagePath:(NSString*)path
{
    _disabeldoffStatusImage = [NSImage imageNamed:path];
    [self updateImage];
}

- (void)awakeFromNib
{
    [self setShowsBorderOnlyWhileMouseInside:YES];
    [self updateImage];
    // let pressed image using alternate image
    [self setHighlightsBy:NSContentsCellMask];
    return;
}

- (id) init
{
    self = [super init];
    
    if(self)
    {
        [self updateImage];
        [self setShowsBorderOnlyWhileMouseInside:YES];
        // let pressed image using alternate image
        [self setHighlightsBy:NSContentsCellMask];
    }
    
    return self;
}

- (void) setOffStatusImagePath:(NSString*)fileName
{
    _offStatusImage = [NSImage imageNamed:fileName];
    [self updateImage];
}

- (void) setEnabled:(BOOL)flag
{
    [super setEnabled:flag];
    [self updateImage];
}

- (void)updateImage
{
    BOOL hovered = self->_hovered;
    BOOL off = ([self state] != NSOnState);
    BOOL enabled = [self isEnabled];

    NSImage* image = self->_onStatusImage;
    if(enabled)
    {
        if (hovered && off)
        {
            image = _offStatusHoverImage;
        }
        else if (hovered && !off)
        {
            image = _onStatusHoverImage;
        }
        else if (!hovered && off)
        {
            image = _offStatusImage;
        }
        else if (!hovered && !off)
        {
            image = _onStatusImage;
        }
    }
    else
    {
        if(!off && _disabledonStatusImage)
        {
            image = _disabledonStatusImage;
        }
        else if(!off && _disabledonStatusImage == nil)
        {
            image = _onStatusImage;
        }
        else if(off && _disabeldoffStatusImage)
        {
            image = _disabeldoffStatusImage;
        }
        else if(off && _disabeldoffStatusImage == nil)
        {
            image = _offStatusImage;
        }
    }
    
    if (image != nil)
    {
        [self setImage:image];
    }
}

- (void)setState:(NSInteger)value
{
    [super setState:value];
    [self updateImage];
    [self updateTextColor];
}

- (void)mouseEntered:(NSEvent *)event 
{
    _hovered = YES;
    [self updateImage];
    [self updateTextColor];
}

- (void)mouseExited:(NSEvent *)event 
{
    _hovered = NO;
    [self updateImage];
    [self updateTextColor];
}

- (void) setTextColor:(NSColor*)color
{
    _onStatusTextColor = color;
    _offStatusTextColor = color;
    _hoverStatusTextColor = color;
    
    [self updateTextColor];
}

- (void) setOnStatusTextColor:(NSColor*)color
{
    _onStatusTextColor = color;
    
    [self updateTextColor];
}

- (void) setOffStatusTextColor:(NSColor*)color
{
    _offStatusTextColor = color;
    
    [self updateTextColor];
}

- (void) setHoverStatusTextColor:(NSColor*)color
{
    _hoverStatusTextColor = color;
    [self updateTextColor];
}

- (void)updateTextColor
{
    BOOL hovered = self->_hovered;
    BOOL off = ([self state] != NSOnState);
    
    NSColor* txtColor = self->_onStatusTextColor;
    if (off)
    {
        txtColor = hovered ? _hoverStatusTextColor : _offStatusTextColor;
    }

    if (txtColor == nil)
    {
        return;
    }
    
    NSString* title = [self title];

    if (nil == title || [title length] == 0) {
        return;
    }
    
    NSMutableDictionary* attributes = [[[self attributedTitle] attributesAtIndex:0 effectiveRange:NULL] mutableCopy];
    [attributes setValue:txtColor forKey:NSForegroundColorAttributeName];
    
    NSAttributedString *newTitle = [[NSAttributedString alloc] initWithString:[[self attributedTitle] string] attributes:attributes];
    [self setAttributedTitle:newTitle];

}

- (NSRect) drawTitle:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView
{
    frame.origin.x += textLeftOffset;
    frame.origin.y += textTopOffset;
    
    return [super drawTitle:title withFrame:frame inView:controlView];
}

- (void)setTitle:(NSString *)aString
{
//    NSRange effectiveRange;
//	NSDictionary *attributeDict;
//    NSUInteger len = [oirginalAttributedTitle length];
//    
//    if(len > 0)
//    {
//        NSRange range = NSMakeRange(0, len);
//        
//        attributeDict = [oirginalAttributedTitle attributesAtIndex:range.location
//                                               effectiveRange:&effectiveRange];	// first attribute at index 0
//        
//        if (aString != nil) {
//            NSMutableAttributedString *newAttributedTitle = [[NSMutableAttributedString alloc]
//                                                             initWithString:aString
//                                                             attributes:attributeDict];
//            [self setAttributedTitle:newAttributedTitle];
//            
//        }
//        
//    }
//    else
//    {
//        [super setTitle:aString];
//    }
    
    [super setTitle:aString];
    
}
@end

@implementation HoverableOnOffDialPadButtonCell

- (NSRect) drawTitle:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView
{
    frame.size.height = frame.size.height/1.1;
    
    return [super drawTitle:title withFrame:frame inView:controlView];
}

@end

@implementation HoverableOnOffButton
- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    
    if (self)
    {
        [self setAllowsMixedState:NO];
        [self setBordered:NO];
        
        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited;
        
        NSRect rect = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height);
        NSTrackingArea *focusTrackingArea = [[NSTrackingArea alloc] initWithRect:rect
                                                                         options:focusTrackingAreaOptions owner:self userInfo:nil];
        [self addTrackingArea:focusTrackingArea];
    }
    
    return self;
}

- (void) setOnStatusHoverImagePath:(NSString*)path
{
    [[self cell] setOnStatusHoverImagePath:path];
}

- (void) setOnStatusImagePath:(NSString*)path
{
    [[self cell] setOnStatusImagePath:path];
}

- (void) setOffStatusHoverImagePath:(NSString*)path
{
    [[self cell] setOffStatusHoverImagePath:path];
}

- (void) setOffStatusImagePath:(NSString*)path
{
    [[self cell] setOffStatusImagePath:path];
}

- (void) setPressedImagePath:(NSString*)path
{
    [[self cell] setPressedImagePath:path];
}

- (void) setDisabledOnStatusImagePath:(NSString*)path
{
    [self.cell setDisabledOnStatusImagePath:path];
}

- (void) setDisabledOffStatusImagePath:(NSString*)path
{
    [[self cell] setDisabledOffStatusImagePath:path];
}

- (void) setTextColor:(NSColor*)color
{
    [[self cell] setTextColor:color];
}

- (void) setOnStatusTextColor:(NSColor*)color
{
    [[self cell] setOnStatusTextColor:color];
}
- (void) setOffStatusTextColor:(NSColor*)color
{
    [[self cell] setOffStatusTextColor:color];
}
- (void) setHoverStatusTextColor:(NSColor*)color
{
    [[self cell] setHoverStatusTextColor:color];
}

- (void) setTextTopOffset:(int)topOffset
{
    [[self cell] setTextTopOffset:topOffset];
}

- (void)setTitle:(NSString *)aString
{
    [[self cell] setTitle:aString];
}

+ (Class) cellClass
{
    Class res =  [HoverableOnOffButtonCell class];
    return res;
}

-(NSInteger)length {
    NSLog(@"wrong invocation for debug.");
    return -1;
}

@end
