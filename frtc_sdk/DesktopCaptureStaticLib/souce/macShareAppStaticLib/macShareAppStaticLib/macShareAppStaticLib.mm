//
//  macShareAppStaticLib.m
//  macShareAppStaticLib
//
//  Created by yingyong.Mao on 2022/3/3.
//

//Add by yingyong.Mao -2022-3-3
#include "common.h" //for WEBRTC_MAC and WEBRTC_POSIX

#import "macShareAppStaticLib.h"

#include "modules/desktop_capture/use_app_window_capturer_mac.hpp"

@implementation macShareAppStaticLib

#pragma mark- CallBack for UI.

#pragma mark- CallBack for UseAppWindowCapturerMac
void outputAppWindowContentBuffer(void* buffer,
                                  int length,
                                  int width,
                                  int height,
                                  Capture_VideoSampleType type,
                                  std::string sourceID) {
    
    NSLog(@"[macShareAppStaticLib] : call delegate -> outputAppWindowContentBuffer: length: %d, width: %d, height: %d, RTCSDK::VideoSampleType: %d",
          length, width, height, type);
    
    //[method 1]: if the UI is Objective-C Object
    if ([macShareAppStaticLib getInstance].delegate_ != nil
        && [[macShareAppStaticLib getInstance].delegate_ respondsToSelector:@selector(outputVideoBufferYUV:length:width:height:type:)]) {

        [[macShareAppStaticLib getInstance].delegate_ outputVideoBufferYUV:buffer
                                                                   length:length
                                                                    width:width
                                                                   height:height
                                                                     type:type];
    }
    
    //[method 2]: if the UI is C++ Object
    
    
    
}


#pragma mark- macShareAppStaticLib

+ (macShareAppStaticLib*)getInstance {
    
    NSLog(@"[macShareAppStaticLib] : getInstance");

    static macShareAppStaticLib *kSingleInstance = nil;
    static dispatch_once_t once_taken = 0;
    dispatch_once(&once_taken, ^{
        kSingleInstance = [[macShareAppStaticLib alloc] init];
    });
    return kSingleInstance;
}

- (void)startAppWindowCapturerMac {
    UseAppWindowCapturerMac *pUseAppWinCapturerMac = new UseAppWindowCapturerMac();
    pUseAppWinCapturerMac->setContentOutputCallback(outputAppWindowContentBuffer);
    pUseAppWinCapturerMac->createCaptureAppContentTimerThread();

}

- (void)setDelegate:(id<MacShareAppStaticLibDelegate>)delegate {
    self.delegate_ = delegate;
}

- (void)startAppWindowCapturerMac:(id<MacShareAppStaticLibDelegate>) delegate {
    
    UseAppWindowCapturerMac *pUseAppWinCapturerMac = new UseAppWindowCapturerMac();
    pUseAppWinCapturerMac->setContentOutputCallback(outputAppWindowContentBuffer);
    pUseAppWinCapturerMac->createCaptureAppContentTimerThread();
    
}




@end
