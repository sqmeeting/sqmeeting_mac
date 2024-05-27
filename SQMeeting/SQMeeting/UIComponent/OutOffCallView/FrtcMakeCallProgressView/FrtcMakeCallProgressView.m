//
//  FrtcFrtcMakeCallProgressView.m
//  For make call pregress animation.
//
//  Created by yingyong.Mao on 2023/5/10.
//


#import "FrtcMakeCallProgressView.h"

#import <QuartzCore/QuartzCore.h>
#import "NSColor+Enhancement.h"

@interface FrtcMakeCallProgressView ()

@property (nonatomic, strong) CALayer     *m_layer;


@end


@implementation FrtcMakeCallProgressView

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor colorWithString:@"000000" andAlpha:0.7].CGColor;
        self.layer.cornerRadius = 8.0;

        _m_layer = [CALayer layer];
        _m_layer.bounds = CGRectMake(0, 0, 32, 32);
        _m_layer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        _m_layer.contents = (id)[[NSImage imageNamed:@"icon_joining_progress"] CGImageForProposedRect:NULL context:nil hints:nil];

        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.fromValue = [NSNumber numberWithFloat:M_PI * 2.0];
        animation.toValue = [NSNumber numberWithFloat:0.0];
        animation.duration = 1.0;
        animation.repeatCount = HUGE_VALF;
        [_m_layer addAnimation:animation forKey:@"rotation"];

        [self.layer addSublayer:_m_layer];
    }
    return self;
}

- (void)startAnimation:(nullable id)sender {
    if (![_m_layer animationForKey:@"rotation"]) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.fromValue = [NSNumber numberWithFloat:M_PI * 2.0];
        animation.toValue = [NSNumber numberWithFloat:0.0];
        animation.duration = 1.0;
        animation.repeatCount = HUGE_VALF;
        [_m_layer addAnimation:animation forKey:@"rotation"];
    }
}

- (void)stopAnimation:(nullable id)sender {
        [_m_layer removeAllAnimations]; // 停止 CALayer 上的所有动画
}


@end
