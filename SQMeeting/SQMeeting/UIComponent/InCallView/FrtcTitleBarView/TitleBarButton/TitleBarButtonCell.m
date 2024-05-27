//
//  TitleBarButtonCell.m
//  FrtcMeeting
//
//  Created by yafei on 2021/12/31.
//  Copyright © 2021 Frtc Team. All rights reserved.
//

#import "TitleBarButtonCell.h"

@implementation TitleBarButtonCell

- (void)highlight:(BOOL)flag withFrame:(NSRect)cellFrame inView:(NSView *)controlView{
    [super highlight:flag withFrame:cellFrame inView:controlView];
    [self.delegate highlitCallBack:flag];
}

@end
