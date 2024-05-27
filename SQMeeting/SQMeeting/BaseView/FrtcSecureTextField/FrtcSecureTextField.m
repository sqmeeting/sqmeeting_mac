#import "FrtcSecureTextField.h"
#import "FrtcVerticalSecureTextFieldCell.h"
#import "FrtcBaseImplement.h"

@interface FrtcSecureTextField ()<SecureImageViewDelegate>

@end

@implementation FrtcSecureTextField


- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customiseTextField];
        
        self.secureImageView = [[SecureImageView alloc] initWithFrame:CGRectMake(248, 8, 24, 24)];
        self.secureImageView.imageAlignment   =  NSImageAlignTopLeft;
        self.secureImageView.imageScaling     =  NSImageScaleAxesIndependently;
        self.secureImageView.image            = [NSImage imageNamed:@"icon-passcode-hide"];
        self.secureImageView.secureImageViewDelegate = self;
        self.secureImageView.wantsLayer = YES;
        
        [self addSubview:self.secureImageView];
    }
    
    return self;
}

-(void) customiseTextField {
    self.cell = [[FrtcVerticalSecureTextFieldCell alloc] init];
    self.editable = YES;
    self.bordered = NO;
    self.textColor = [[FrtcBaseImplement baseImpleSingleton] baseColor];
    self.alignment = NSTextAlignmentLeft;
    [self setFocusRingType:NSFocusRingTypeNone];
    self.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] lightGrayColor];
    [self.cell setFont:[NSFont systemFontOfSize:16]];
    self.wantsLayer = YES;
    self.layer.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] lightGrayColor].CGColor;
    self.stringValue = @"";
    self.layer.cornerRadius = 4.0f;
}

#pragma mark --SecureImageViewDelegate--
- (void)changePasswordView {
    if(self.secureTextFieldDelegate && [self.secureTextFieldDelegate respondsToSelector:@selector(switchPasswordView:)]) {
        [self.secureTextFieldDelegate switchPasswordView:self.tag];
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

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
