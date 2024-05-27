#import "PasswordTextField.h"
#import "PasswordTextFieldCell.h"

@interface PasswordTextField () <SecureImageViewDelegate>

@end

@implementation PasswordTextField

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customiseTextField];
        
        self.secureImageView = [[SecureImageView alloc] initWithFrame:CGRectMake(248, 8, 24, 24)];
        self.secureImageView.imageAlignment   =  NSImageAlignTopLeft;
        self.secureImageView.imageScaling     =  NSImageScaleAxesIndependently;
        self.secureImageView.image            = [NSImage imageNamed:@"icon-passcode-show"];
        self.secureImageView.secureImageViewDelegate  = self;
        [self addSubview:self.secureImageView];
    }
    return self;
}

- (void)customiseTextField {
    self.cell = [[PasswordTextFieldCell alloc] init];
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

#pragma mark --SecureImageViewDelegate--
- (void)changePasswordView {
    if(self.passwordDelegate && [self.passwordDelegate respondsToSelector:@selector(switchPasswordView:)]) {
        [self.passwordDelegate switchPasswordView:self.tag];
    }
}

- (void)lost {
    [self.window makeFirstResponder:nil];
    [self.secureImageView becomeFirstResponder];
    [self resetCursorRects];
}

- (void)resetCursorRects {
    [self addCursorRect:[self bounds] cursor:[NSCursor pointingHandCursor]];
}

- (BOOL)performKeyEquivalent:(NSEvent *)event {
    if (([event type] == NSEventTypeKeyDown) && ([event modifierFlags] & NSEventModifierFlagCommand))
    {
        NSResponder * responder = [[self window] firstResponder];
        
        if ((responder != nil) && [responder isKindOfClass:[NSTextView class]])
        {
            NSTextView * textView = (NSTextView *)responder;
            NSRange range = [textView selectedRange];
            bool bHasSelectedTexts = (range.length > 0);
            
            unsigned short keyCode = [event keyCode];
           
            bool bHandled = false;
            
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

@end
