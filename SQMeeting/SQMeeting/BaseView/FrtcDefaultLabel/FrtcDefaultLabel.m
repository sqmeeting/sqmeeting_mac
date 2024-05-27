#import "FrtcDefaultLabel.h"
#import "FrtcVerticalCenterTextFieldCell.h"
#import "FrtcBaseImplement.h"

@implementation FrtcDefaultLabel

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customiseLabel];
    }
    
    return self;
}

- (void)customiseLabel {
    self.cell = [[FrtcVerticalCenterTextFieldCell alloc] init];
    self.editable = NO;
    self.bordered = NO;
    self.textColor = [[FrtcBaseImplement baseImpleSingleton] baseColor];
    self.alignment = NSTextAlignmentLeft;
    [self setFocusRingType:NSFocusRingTypeNone];
    self.backgroundColor = [NSColor clearColor];
    [self.cell setFont:[NSFont systemFontOfSize:16]];
    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor clearColor].CGColor;
    self.stringValue = @"";
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

@end
