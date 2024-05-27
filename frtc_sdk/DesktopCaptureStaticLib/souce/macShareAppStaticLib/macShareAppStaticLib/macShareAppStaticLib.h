//
//  macShareAppStaticLib.h
//  macShareAppStaticLib
//
//  Created by yingyong.Mao on 2022/3/3.
//

#import <Foundation/Foundation.h>
#import "common.h"

using namespace std;


#pragma mark- MacShareAppStaticLibDelegate



//[method 1]: if the UI is Objective-C Object

@protocol MacShareAppStaticLibDelegate <NSObject>

// This is copied from MP; should be consistent with MP definition

//call, return YUV420 frame buffer to caller.
- (void)outputVideoBufferYUV:(void *)buffer
                      length:(int)length
                       width:(int)width
                      height:(int)height
                        type:(int)type;

@end



#pragma mark- class macShareAppStaticLib

@interface macShareAppStaticLib : NSObject

//[method 1]: if the UI is Objective-C Object
@property (nonatomic, weak) id<MacShareAppStaticLibDelegate> delegate_;

- (void)setDelegate:(id<MacShareAppStaticLibDelegate>)delegate;

+ (macShareAppStaticLib*)getInstance;

- (void)startAppWindowCapturerMac;





@end
