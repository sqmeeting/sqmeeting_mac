#import <Cocoa/Cocoa.h>

@interface HoverableOnOffButtonCell: NSButtonCell
{
    NSImage* _onStatusHoverImage;
    NSImage* _onStatusImage;
    NSImage* _offStatusHoverImage;
    NSImage* _offStatusImage;
    NSImage* _disabledonStatusImage;
    NSImage* _disabeldoffStatusImage;
    BOOL _hovered;
    
    NSColor* _onStatusTextColor;
    NSColor* _offStatusTextColor;
    NSColor* _hoverStatusTextColor;
    
    int textLeftOffset;
    int textTopOffset;
}

- (void) setOnStatusHoverImagePath:(NSString*)path;
- (void) setOnStatusImagePath:(NSString*)path;
- (void) setOffStatusHoverImagePath:(NSString*)path;
- (void) setOffStatusImagePath:(NSString*)path;
- (void) setPressedImagePath:(NSString*)path;
- (void) setDisabledOnStatusImagePath:(NSString*)path;
- (void) setDisabledOffStatusImagePath:(NSString*)path;
- (void) mouseEntered:(NSEvent*)theEvent;
- (void) mouseExited:(NSEvent*)theEvent;
- (void) updateImage;

- (void) setTextColor:(NSColor*)color;
- (void) setOnStatusTextColor:(NSColor*)color;
- (void) setOffStatusTextColor:(NSColor*)color;
- (void) setHoverStatusTextColor:(NSColor*)color;
- (void) updateTextColor;

- (void)setTitle:(NSString *)aString;

@property int textLeftOffset;
@property int textTopOffset;

@end

@interface HoverableOnOffDialPadButtonCell: HoverableOnOffButtonCell {
    
}
@end

@interface HoverableOnOffButton: NSButton
- (void) setOnStatusHoverImagePath:(NSString*)path;
- (void) setOnStatusImagePath:(NSString*)path;
- (void) setOffStatusHoverImagePath:(NSString*)path;
- (void) setOffStatusImagePath:(NSString*)path;
- (void) setPressedImagePath:(NSString*)path;
- (void) setDisabledOnStatusImagePath:(NSString*)path;
- (void) setDisabledOffStatusImagePath:(NSString*)path;

- (void) setTextColor:(NSColor*)color;
- (void) setOnStatusTextColor:(NSColor*)color;
- (void) setOffStatusTextColor:(NSColor*)color;
- (void) setHoverStatusTextColor:(NSColor*)color;

- (void) setTextTopOffset:(int)topOffset;

- (void)setTitle:(NSString *)aString;
+ (Class) cellClass;
@end
