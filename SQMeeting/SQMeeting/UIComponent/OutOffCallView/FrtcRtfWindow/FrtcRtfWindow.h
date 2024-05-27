//
//  FrtcRtfWindow.h
//  FrtcMeeting
//
//  Created by yafei on 2022/6/9.
//  Copyright © 2022 Frtc Team. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrtcRtfWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size;

- (void)showWindow;

- (void)adjustToSize:(NSSize)size;

@end

NS_ASSUME_NONNULL_END
