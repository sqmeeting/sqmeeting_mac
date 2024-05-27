#import "LoginSecureTextField.h"
#import "LoginVerticalSecureTextFieldCell.h"

@implementation LoginSecureTextField

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customiseTextField];
        self.imageView = [[NSImageView alloc] initWithFrame:CGRectMake(8, 10, 20, 20)];
        self.imageView.imageAlignment   =  NSImageAlignTopLeft;
        self.imageView.imageScaling     =  NSImageScaleAxesIndependently;
        [self addSubview:self.imageView];
    }
    return self;
}

-(void) customiseTextField {
    self.cell = [[LoginVerticalSecureTextFieldCell alloc] init];
    self.editable = YES;
    self.bordered = YES;
    self.textColor = [NSColor colorWithString:@"222222" andAlpha:1.0];
    self.alignment = NSTextAlignmentLeft;
    [self setFocusRingType:NSFocusRingTypeNone];
    self.backgroundColor = [NSColor whiteColor];
    [self.cell setFont:[NSFont systemFontOfSize:14]];
    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor whiteColor].CGColor;
    self.stringValue = @"";
    self.layer.cornerRadius = 4.0f;
    self.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
    self.layer.borderWidth = 1.0;
}

- (BOOL)performKeyEquivalent:(NSEvent *)event {
    if (([event type] == NSEventTypeKeyDown) && ([event modifierFlags] & NSEventModifierFlagCommand)) {
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
