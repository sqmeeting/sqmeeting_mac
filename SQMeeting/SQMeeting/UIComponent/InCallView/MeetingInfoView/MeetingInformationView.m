#import "MeetingInformationView.h"
#import "FrtcBaseImplement.h"

@interface MeetingInformationView ()

@property (nonatomic, getter=isDynamicMessageFinished) BOOL bDynamicMessageFinished;

@end


@implementation MeetingInformationView

- (void)drawRect:(NSRect)dirtyRect {
    NSRect rect  = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [super drawRect:rect];
    
    // Drawing code here.
    self.wantsLayer = YES;

    NSColor *color1 = [NSColor colorWithString:@"#0299FE" andAlpha:0.0];
    NSColor *color2 = [NSColor colorWithString:@"#0581FF" andAlpha:0.164];
    NSColor *color3 = [NSColor colorWithString:@"#0565FF" andAlpha:0.24];
    NSColor *color4 = [NSColor colorWithString:@"#046AFF" andAlpha:0.164];
    NSColor *color5 = [NSColor colorWithString:@"#026FFE" andAlpha:0.0];
    NSGradient *gradient = [[NSGradient alloc] initWithColorsAndLocations:color1, 0.0, color2, 0.25, color3, 0.51, color4, 0.73, color5, 1.0, nil];
    [gradient drawInRect:rect angle:0];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if(self) {
        [self infomationTextField];
        self.bDynamicMessageFinished = YES;
    }
    return self;
}

- (NSTextField *)infomationTextField {
    if(!_infomationTextField) {
        _infomationTextField = [[NSTextField alloc] init];
        _infomationTextField.editable = NO;
        _infomationTextField.bordered = NO;
        _infomationTextField.wantsLayer = YES;
        _infomationTextField.layer.backgroundColor = [NSColor clearColor].CGColor;
        _infomationTextField.backgroundColor = [NSColor clearColor];
        _infomationTextField.alignment = NSTextAlignmentLeft;
        _infomationTextField.maximumNumberOfLines = 1.0;
        _infomationTextField.font = [NSFont systemFontOfSize:16.0f];
        _infomationTextField.lineBreakMode = NSLineBreakByWordWrapping;
        _infomationTextField.textColor = [[FrtcBaseImplement baseImpleSingleton] whiteColor];
        [self addSubview:_infomationTextField];
    }
    
    return _infomationTextField;
}

- (void)setupViewSize:(CGSize)size {
    self.size = size;
    CGRect rect = CGRectMake([self getScreenLandscapeWidth], (self.frame.size.height - size.height)/2, size.width, size.height);
    self.infomationTextField.frame = rect;
}

- (CGFloat)getScreenLandscapeWidth {
    CGSize size = self.frame.size;
    return size.width;
}

- (void)updateNewAnimation {
    [_infomationTextField.layer removeAllAnimations];
}

- (void)restart {
    if (self.isStillnessInfo || !self.bDynamicMessageFinished) {
        self.infomationTextField.frame = CGRectMake(self.frame.size.width, (self.frame.size.height - _size.height)/2, _size.width, _size.height);
        [self configMessageViewAnimation:self.duration];
    }
}

- (void)stop {
    [self.infomationTextField.layer removeAllAnimations];
}

- (void)reSetupStilnessLayout {
    CGRect rect = CGRectMake((self.frame.size.width - self.size.width)/2, (self.frame.size.height - self.size.height)/2, self.size.width, self.size.height);
    self.infomationTextField.frame = rect;
}

- (void)configMessageViewAnimation:(double)duration {
    self.duration = duration;
    [self setHidden:NO];
    self.alphaValue = 1;
    self.animator.alphaValue = 1;
    if(self.isStillnessInfo) {
        CGRect rect = CGRectMake((self.frame.size.width - self.size.width)/2, (self.frame.size.height - self.size.height)/2, self.size.width, self.size.height);
        rect = CGRectMake(0, (self.frame.size.height - self.size.height)/2, self.frame.size.width, self.size.height);
        self.infomationTextField.frame = rect;
        self.infomationTextField.alignment = NSTextAlignmentCenter;
        self.infomationTextField.lineBreakMode = NSLineBreakByTruncatingTail;
    } else {
        self.infomationTextField.alignment = NSTextAlignmentLeft;
        self.infomationTextField.lineBreakMode = NSLineBreakByWordWrapping;
        self.bDynamicMessageFinished = NO;
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation.delegate = self;
        NSValue *value1 = [NSValue valueWithPoint:CGPointMake([self getScreenLandscapeWidth], (self.frame.size.height - _size.height)/2)];
        NSValue *value2 = [NSValue valueWithPoint:CGPointMake(-self.size.width, (self.frame.size.height - self.size.height)/2)];
        animation.values=@[value1,value2];
        animation.duration = duration;
        animation.repeatCount = self.cycleNumbers;
        animation.removedOnCompletion = YES;
        animation.fillMode = kCAFillModeForwards;
        [self.infomationTextField.layer addAnimation:animation forKey:nil];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        self.bDynamicMessageFinished = flag;
        context.duration = 1;
        //self.animator.alphaValue = 0;
    }
    completionHandler:^{
        if(self.delegate && [self.delegate respondsToSelector:@selector(repeateUpdateView)]) {
            [self.delegate repeateUpdateView];
        }
    }];
}

@end
