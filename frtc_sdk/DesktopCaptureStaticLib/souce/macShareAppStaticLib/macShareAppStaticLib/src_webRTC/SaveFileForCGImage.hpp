//
//  SaveFileForCGImage.hpp
//  TestWebrtc
//
//  Created by yingyong.Mao on 2022/3/1.
//

#ifndef SaveFileForCGImage_hpp
#define SaveFileForCGImage_hpp

#include <stdio.h>
#include <algorithm>
#include <string>
#include "assert.h"
#include <stdio.h>
#include <wchar.h>
#include <iostream>
#include <sstream>
#import <Cocoa/Cocoa.h>
#include <CoreFoundation/CoreFoundation.h>

using namespace std;

namespace webrtc_mac_capturer {

static void yuvWriteToFile(uint8_t *buf, int length, int width, int height, NSString *path) {
    static int _dumpFrameCountCur = 1, _dumpFrameCountMax = 100; //1000
    _dumpFrameCountCur++;
    NSString *dumpFile = [NSString stringWithFormat:@"%@/dumpFile/yuv_%d_%dx%d.yuv",
                          path, //@".",
                          _dumpFrameCountCur % _dumpFrameCountMax,
                          width, height];
    
    NSData *data = [NSData dataWithBytes:(const void*)buf length:length];
    NSURL* url = [NSURL fileURLWithPath:dumpFile isDirectory: false] ;
    [data writeToURL:url atomically:true] ;
    
    NSLog(@"[yuvWriteToFile]: write image to %@", dumpFile);
}

static void CGImageWriteToFile(CGImageRef image, NSString *path) {
    static int _dumpFrameCountCur = 1, _dumpFrameCountMax = 1000;
    _dumpFrameCountCur++;
    NSString *dumpFile = [NSString stringWithFormat:@"%@/%dump_d.png",
                          path,
                          _dumpFrameCountCur % _dumpFrameCountMax];
    
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:dumpFile];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);
    CGImageDestinationAddImage(destination, image, nil);
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"Failed to write image to %@", dumpFile);
    }
    NSLog(@"[CGImageWriteToFile]: write image to %@", dumpFile);

    CFRelease(destination);
}

}

#endif /* SaveFileForCGImage_hpp */
