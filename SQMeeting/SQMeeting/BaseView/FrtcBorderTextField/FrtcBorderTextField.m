#import "FrtcBorderTextField.h"
#import "FrtcBorderTextFieldCell.h"

@interface FrtcBorderTextField ()

@end

@implementation FrtcBorderTextField

- (instancetype)init {
    self = [super init];
    if (self) {
        [self customiseTextField];
    }
    
    return self;
}

- (void)customiseTextField {
    self.cell = [[FrtcBorderTextFieldCell alloc] init];
    self.focusRingType = NSFocusRingTypeNone;
    self.editable = YES;
    self.selectable = YES;
    self.stringValue = @"";
    self.wantsLayer = YES;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [NSColor colorWithString:@"616161" andAlpha:1].CGColor;
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    self.textColor = [NSColor blackColor];
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
            
            //6 Z, 7 X, 8 C, 9 V
            if (keyCode == 6) {
                if ([[textView undoManager] canUndo]) {
                    [[textView undoManager] undo];
                    bHandled = true;
                }
            } else if (keyCode == 7 && bHasSelectedTexts) {
                [textView cut:self];
                bHandled = true;
            } else if (keyCode== 8 && bHasSelectedTexts) {
                [textView copy:self];
                bHandled = true;
            } else if (keyCode == 9) {
                [textView paste:self];
                bHandled = true;
            }
            
            if (bHandled)
                return YES;
        }
    }
    
    return NO;
}

@end
