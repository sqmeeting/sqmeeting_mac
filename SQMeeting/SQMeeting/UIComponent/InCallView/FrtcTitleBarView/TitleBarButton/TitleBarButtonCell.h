//
//  TitleBarButtonCell.h
//  FrtcMeeting
//
//  Created by yafei on 2021/12/31.
//  Copyright © 2021 Frtc Team. All rights reserved.
//

#import <Cocoa/Cocoa.h>


NS_ASSUME_NONNULL_BEGIN

@protocol TitleBarButtonCellDeletegate <NSObject>

- (void) highlitCallBack:(BOOL)flag;

@end

@interface TitleBarButtonCell : NSButtonCell

@property (weak, nonatomic) id<TitleBarButtonCellDeletegate> delegate;

@end

NS_ASSUME_NONNULL_END
