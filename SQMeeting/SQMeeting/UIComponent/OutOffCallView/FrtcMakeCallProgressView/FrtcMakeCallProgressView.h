//
//  FrtcMakeCallProgressView.h
//  For make call pregress animation.
//
//  Created by yingyong.Mao on 2023/5/10.
//

#import <Foundation/Foundation.h>

#import <Cocoa/Cocoa.h>

@interface FrtcMakeCallProgressView : NSView

- (instancetype)initWithFrame:(NSRect)frameRect;

- (void)startAnimation:(nullable id)sender;
- (void)stopAnimation:(nullable id)sender;

@end
