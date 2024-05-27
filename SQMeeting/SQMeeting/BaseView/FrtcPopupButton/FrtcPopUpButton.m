#import "FrtcPopUpButton.h"

@interface FrtcPopUpButtonCell : NSPopUpButtonCell

@end

@implementation FrtcPopUpButtonCell

- (NSRect)titleRectForBounds:(NSRect)cellFrame {
    NSRect rect = [super titleRectForBounds:cellFrame];
    return NSMakeRect(rect.origin.x - 1, rect.origin.y, rect.size.width, rect.size.height);
}

@end

@implementation FrtcPopUpButton

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupData];
    }
    return self;
}

- (void)setupData {
    self.cell = [[FrtcPopUpButtonCell alloc] init];
    [(FrtcPopUpButtonCell *)[self cell] setBezelStyle:NSSmallIconButtonBezelStyle];
    [[self cell] setArrowPosition:NSPopUpArrowAtBottom];
}

- (void)setFontWithString:(NSString*)color alpha:(CGFloat)alpha size:(CGFloat)size andType:(SFProDisplay)type{
    NSArray *itemArray = [self itemArray];
    NSDictionary *attributes = [NSDictionary
                                dictionaryWithObjectsAndKeys:
                                [NSColor colorWithString:color andAlpha:alpha], NSForegroundColorAttributeName,
                                [NSFont fontWithSFProDisplay:size andType:type],
                                NSFontAttributeName, nil];
    for (int i = 0; i < [itemArray count]; i++) {
        NSMenuItem *item = [itemArray objectAtIndex:i];
        NSAttributedString *as = [[NSAttributedString alloc]
                                  initWithString:[item title]
                                  attributes:attributes];
        
        [item setAttributedTitle:as];
    }
}

@end
