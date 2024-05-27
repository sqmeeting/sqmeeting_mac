#import "FrtcHoverButton.h"

@implementation FrtcHoverButtonCell

@synthesize textLeftOffset;
@synthesize textTopOffset;

- (void)dealloc {
   // [super dealloc];
}



- (void)setOnStatusImagePath:(NSString*)fileName {
    _onStatusImage = [NSImage imageNamed:fileName];

    [self updateImage];
}


- (void)awakeFromNib {
    [self setShowsBorderOnlyWhileMouseInside:YES];
    [self updateImage];
    _hovered = NO;
    // let pressed image using alternate image
    [self setHighlightsBy:NSContentsCellMask];
    return;
}

- (id)init {
    self = [super init];
    
    if(self) {
        [self updateImage];
        [self setShowsBorderOnlyWhileMouseInside:YES];
        [self setHighlightsBy:NSContentsCellMask];
    }
    
    return self;
}

- (void)setOffStatusImagePath:(NSString*)fileName {
    _offStatusImage = [NSImage imageNamed:fileName];
    [self updateImage];
}

- (void)setEnabled:(BOOL)flag {
    [super setEnabled:flag];
    [self updateImage];
}

- (void)updateImage {
    BOOL hovered = self->_hovered;
    BOOL off = ([self state] != NSControlStateValueOn);
    BOOL enabled = [self isEnabled];

    NSImage* image = self->_onStatusImage;
    if(enabled) {
        if (hovered && off) {
            image = _offStatusHoverImage;
        } else if (hovered && !off) {
            image = _onStatusHoverImage;
        } else if (!hovered && off) {
            image = _offStatusImage;
        } else if (!hovered && !off) {
            image = _onStatusImage;
        }
    } else {
        if(!off && _disabledonStatusImage) {
            image = _disabledonStatusImage;
        } else if(!off && _disabledonStatusImage == nil) {
            image = _onStatusImage;
        } else if(off && _disabeldoffStatusImage) {
            image = _disabeldoffStatusImage;
        } else if(off && _disabeldoffStatusImage == nil) {
            image = _offStatusImage;
        }
    }
    
    if (image != nil) {
        [self setImage:image];
        [self setImageScaling:NSImageScaleAxesIndependently];
    }
}

- (void)setState:(NSInteger)value {
    [super setState:value];
    [self updateImage];
    [self updateTextColor];
}

- (void)updateTextColor {
    BOOL hovered = self->_hovered;
    BOOL off = ([self state] != NSControlStateValueOn);
    
    NSColor* txtColor = self->_onStatusTextColor;
    if (off) {
        txtColor = hovered ? _hoverStatusTextColor : _offStatusTextColor;
    }

    if (txtColor == nil) {
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

- (NSRect)drawTitle:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView {
    frame.origin.x += textLeftOffset;
    frame.origin.y += textTopOffset;
    
    return [super drawTitle:title withFrame:frame inView:controlView];
}

- (void)setTitle:(NSString *)aString {
    NSRange effectiveRange;
	NSDictionary *attributeDict;
    NSAttributedString *oirginalAttributedTitle = [self attributedTitle];
    NSUInteger len = [oirginalAttributedTitle length];
    
    if(len > 0) {
        NSRange range = NSMakeRange(0, len);
        
        attributeDict = [oirginalAttributedTitle attributesAtIndex:range.location
                                               effectiveRange:&effectiveRange];	// first attribute at index 0
        
        if (aString != nil) {
            NSMutableAttributedString *newAttributedTitle = [[NSMutableAttributedString alloc]
                                                             initWithString:aString
                                                             attributes:attributeDict];
            [self setAttributedTitle:newAttributedTitle];
            
        }
        
    } else {
        [super setTitle:aString];
    }
    
}

@end

@implementation FrtcHoverButton

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if (self) {
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

- (void)setOnStatusImagePath:(NSString *)path {
    [[self cell] setOnStatusImagePath:path];
}

- (void)setOffStatusImagePath:(NSString *)path {
    [[self cell] setOffStatusImagePath:path];
}

- (void)setTitle:(NSString *)aString {
    [[self cell] setTitle:aString];
}

- (void)setState:(NSControlStateValue)state {
    [[self cell] setState:state];
}

+ (Class)cellClass {
    Class res =  [FrtcHoverButtonCell class];
    return res;
}

- (NSInteger)length {
    return -1;
}

@end
