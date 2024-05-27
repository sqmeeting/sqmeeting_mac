#import "DetailTimeTextField.h"
#import "FrtcVerticalCenterTextFieldCell.h"
#import "FrtcBaseImplement.h"
#import "DetailTimeTextFieldCell.h"

@implementation DetailTimeTextField

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customiseTextField];
    }
    return self;
}

-(void)customiseTextField {
    self.cell = [[DetailTimeTextFieldCell alloc] init];
    //self.cell.backgroundColor = [NSColor redColor];
    self.editable = YES;
    self.bordered = YES;
    self.textColor = [NSColor colorWithString:@"222222" andAlpha:1.0];
    self.alignment = NSTextAlignmentLeft;
    [self setFocusRingType:NSFocusRingTypeNone];
    [self.cell setFont:[NSFont systemFontOfSize:14]];
    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor whiteColor].CGColor;
    self.layer.borderColor = [NSColor colorWithString:@"999999" andAlpha:1.0].CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 4.0f;
    self.stringValue = @"";
}

- (BOOL)performKeyEquivalent:(NSEvent *)event {
    if (([event type] == NSEventTypeKeyDown) && ([event modifierFlags] & NSEventModifierFlagCommand)) {
        NSResponder * responder = [[self window] firstResponder];
        
        if ((responder != nil) && [responder isKindOfClass:[NSTextView class]]) {
            NSTextView * textView = (NSTextView *)responder;
            NSRange range = [textView selectedRange];
            bool bHasSelectedTexts = (range.length > 0);
            
            unsigned short keyCode = [event keyCode];
           
            bool bHandled = false;
           // NSUpArrowFunctionKey;
            //6 Z, 7 X, 8 C, 9 V
            if (keyCode == 6)
            {
                if ([[textView undoManager] canUndo])
                {
                    [[textView undoManager] undo];
                    bHandled = true;
                }
            }
            else if (keyCode == 7 && bHasSelectedTexts)
            {
                [textView cut:self];
                bHandled = true;
            }
            else if (keyCode== 8 && bHasSelectedTexts)
            {
                [textView copy:self];
                bHandled = true;
            }
            else if (keyCode == 9)
            {
                [textView paste:self];
                bHandled = true;
            }
            
            if (bHandled)
                return YES;
        }
    }
    
    return NO;
}

- (void)keyDown:(NSEvent *)theEvent {
    if ([theEvent modifierFlags] & NSEventModifierFlagNumericPad) { // arrow keys have this mask
        NSString *theArrow = [theEvent charactersIgnoringModifiers];
        unichar keyChar = 0;
        if ( [theArrow length] == 0 )
            return;            // reject dead keys
        if ( [theArrow length] == 1 ) {
            keyChar = [theArrow characterAtIndex:0];
            if ( keyChar == NSLeftArrowFunctionKey ) {
                //[self offsetLocationByX:-10.0 andY:0.0];
                [[self window] invalidateCursorRectsForView:self];
                return;
            }
            if ( keyChar == NSRightArrowFunctionKey ) {
                //[self offsetLocationByX:10.0 andY:0.0];
                [[self window] invalidateCursorRectsForView:self];
                return;
            }
            if ( keyChar == NSUpArrowFunctionKey ) {
                //[self offsetLocationByX:0 andY: 10.0];
                [[self window] invalidateCursorRectsForView:self];
                return;
            }
            if ( keyChar == NSDownArrowFunctionKey ) {
                //[self offsetLocationByX:0 andY:-10.0];
                [[self window] invalidateCursorRectsForView:self];
                return;
            }
            [super keyDown:theEvent];
        }
    }
    [super keyDown:theEvent];
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
