//
//  MacShareAppStaticLibClass.hpp
//  For lib macShareAppStaticLib
//
//  Created by yingyong.Mao on 2022/3/7.
//

#ifndef MacShareAppStaticLibClass_hpp
#define MacShareAppStaticLibClass_hpp

#include <stdio.h>
#import "common.h"
#import <Foundation/Foundation.h>
#include <string>

using namespace std;

//[method 2]: if the UI is C++ Object.
//typedef void (*ContentOutputCallback)(void *buffer, int length, int width, int height,  MasShareVideoSampleType type, int sourceID);

//[method 1] if the UI is Objective-C Object.
typedef void (*AppWinContentOutputCallback)(void *buffer,
                                      int length,
                                      int width,
                                      int height,
                                      int stride,
                                      Capture_VideoSampleType type,
                                      std::string sourceID);


class UseAppWindowCapturerMac;

class MacShareAppStaticLibClass {
    
public:
    static MacShareAppStaticLibClass* getInstance();
    void   releaseInstance();
    
private:
    MacShareAppStaticLibClass();
    ~MacShareAppStaticLibClass();
    
public:
    std::atomic_bool start_flag_;
private:
    AppWinContentOutputCallback contentOutputCB;
    CONTENT_CAPS_STRUCT         capability;
    
public:
    void setAppWinContentOutputCallback(AppWinContentOutputCallback cb);
    void setCapability(int width, int height, int framerate);
    void setAppContentName(std::string sourceAppContentName, unsigned int sourceAppContentWindowID);
    void startAppWindowCapturerMac();
    void stopAppWindowCapturerMac();
    
};


#endif /* MacShareAppStaticLibClass_hpp */
