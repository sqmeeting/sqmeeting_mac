#import <Cocoa/Cocoa.h>

@interface FrtcHoverButtonCell: NSButtonCell

@property (nonatomic, strong) NSImage *onStatusHoverImage;
@property (nonatomic, strong) NSImage *onStatusImage;
@property (nonatomic, strong) NSImage *offStatusHoverImage;
@property (nonatomic, strong) NSImage *offStatusImage;
@property (nonatomic, strong) NSImage *disabledonStatusImage;
@property (nonatomic, strong) NSImage *disabeldoffStatusImage;
@property (nonatomic, assign, getter=isHovered)BOOL hovered;

@property (nonatomic, strong) NSColor *onStatusTextColor;
@property (nonatomic, strong) NSColor *offStatusTextColor;
@property (nonatomic, strong) NSColor *hoverStatusTextColor;

@property (nonatomic, assign) int textLeftOffset;
@property (nonatomic, assign) int textTopOffset;

- (void)setOnStatusImagePath:(NSString*)path;
- (void)setOffStatusImagePath:(NSString*)path;
- (void)updateImage;

- (void)updateTextColor;

- (void)setTitle:(NSString *)aString;

@end


@interface FrtcHoverButton: NSButton

+ (Class) cellClass;

- (void)setOnStatusImagePath:(NSString*)path;

- (void)setOffStatusImagePath:(NSString*)path;

- (void)setState:(NSControlStateValue)state;

- (void)setTitle:(NSString *)aString;



@end
