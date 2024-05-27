//
//  MacShareAppStaticLibClass.cpp
//  For lib macShareAppStaticLib
//
//  Created by yingyong.Mao on 2022/3/7.
//

#include "MacShareAppStaticLibClass.hpp"
#include "modules/desktop_capture/use_app_window_capturer_mac.hpp"


static MacShareAppStaticLibClass *kSingleInstance = nil;

#pragma mark- instance

MacShareAppStaticLibClass* MacShareAppStaticLibClass::getInstance() {
    
    //NSLog(@"[MacShareAppStaticLibClass] : getInstance");
    /*
    static MacShareAppStaticLibClass *kSingleInstance = nil;
    static dispatch_once_t once_taken = 0;
    dispatch_once(&once_taken, ^{
        kSingleInstance = new MacShareAppStaticLibClass();
    });
    */
    //NSLog(@"[MacShareAppStaticLibClass] : getInstance : kSingleInstance : %p", kSingleInstance);
    if (NULL == kSingleInstance) {
        kSingleInstance = new MacShareAppStaticLibClass();
    }
    //NSLog(@"[MacShareAppStaticLibClass] : getInstance : kSingleInstance : %p", kSingleInstance);
    return kSingleInstance;
}

void MacShareAppStaticLibClass::releaseInstance() {
    NSLog(@"[MacShareAppStaticLibClass] : releaseInstance Enter");
    /*
    static MacShareAppStaticLibClass *kSingleInstance = nil;
    static dispatch_once_t once_taken = 0;
    dispatch_once(&once_taken, ^{
        kSingleInstance = new MacShareAppStaticLibClass();
    });
    */
    if (NULL != kSingleInstance) {
        delete kSingleInstance;
        kSingleInstance = NULL;
    }
    NSLog(@"[MacShareAppStaticLibClass] : releaseInstance Leave");
}


#pragma mark- Constructor

MacShareAppStaticLibClass::MacShareAppStaticLibClass() {
    this->start_flag_ = false;
    //NSLog(@"[MacShareAppStaticLibClass] MacShareAppStaticLibClass: by default: start_flag_[%p] = false, : not share", &start_flag_);
}

MacShareAppStaticLibClass::~MacShareAppStaticLibClass() {
    NSLog(@"[~MacShareAppStaticLibClass] Enter");
    NSLog(@"[~MacShareAppStaticLibClass] Leave");
}


#pragma mark- Setter

void MacShareAppStaticLibClass::setAppWinContentOutputCallback(AppWinContentOutputCallback cb) {
    this->contentOutputCB = cb;
}

void MacShareAppStaticLibClass::setCapability(int width, int height, int framerate) {
    CONTENT_CAPS_STRUCT capability;
    capability.width = width;
    capability.height = height;
    capability.framerate = framerate;
    //NSLog(@"[MacShareAppStaticLibClass] : setCapability: call pUseAppWinCapturerMac->setCapability: _capability:[%d, %d, %d]", capability.width, capability.height, capability.framerate);
    
    std::shared_ptr<UseAppWindowCapturerMac> pUseAppWinCapturerMac = UseAppWindowCapturerMac::getInstance();
    pUseAppWinCapturerMac->setCapability(capability);
}

//void MacShareAppStaticLibClass::setSourceAppWindowTitle(std::string sourceAppWindowTitle)
void MacShareAppStaticLibClass::setAppContentName(std::string sourceAppContentName, unsigned int sourceAppContentWindowID) {
    NSString *strSourceAppContentName = [NSString stringWithCString:sourceAppContentName.c_str()
                                                           encoding:NSUTF8StringEncoding]; //[NSString defaultCStringEncoding]
    //NSLog(@"[MacShareAppStaticLibClass] : setAppContentName: sourceAppWindowTitle : %@, sourceAppContentWindowID : %d", strSourceAppContentName, sourceAppContentWindowID);
    
    std::shared_ptr<UseAppWindowCapturerMac> pUseAppWinCapturerMac = UseAppWindowCapturerMac::getInstance();
    pUseAppWinCapturerMac->setAppContentName(sourceAppContentName, sourceAppContentWindowID);
}


#pragma mark- Start and Stop Application window capture

void MacShareAppStaticLibClass::startAppWindowCapturerMac() {
    //NSLog(@"[MacShareAppStaticLibClass] : startAppWindowCapturerMac Enter");
    start_flag_ = true;
    
    MacShareAppStaticLibClass *macShareAppLib = MacShareAppStaticLibClass::getInstance();
    //NSLog(@"[MacShareAppStaticLibClass] startAppWindowCapturerMac: macShareAppLib[%p]->start_flag_[%p] ", macShareAppLib, &(macShareAppLib->start_flag_));
    
    std::shared_ptr<UseAppWindowCapturerMac> pUseAppWinCapturerMac = UseAppWindowCapturerMac::getInstance();
    pUseAppWinCapturerMac->setContentOutputCallback(this->contentOutputCB);
    pUseAppWinCapturerMac->StartCapture();
    //NSLog(@"[MacShareAppStaticLibClass] : startAppWindowCapturerMac Leave");
}

void MacShareAppStaticLibClass::stopAppWindowCapturerMac() {
    //NSLog(@"[MacShareAppStaticLibClass] : stopAppWindowCapturerMac Enter");
    start_flag_ = false;
    std::shared_ptr<UseAppWindowCapturerMac> pUseAppWinCapturerMac = UseAppWindowCapturerMac::getInstance();
    pUseAppWinCapturerMac->StopCapture();
    //pUseAppWinCapturerMac->setContentOutputCallback(NULL);
    //pUseAppWinCapturerMac->releaseInstance();
    //NSLog(@"[MacShareAppStaticLibClass] : stopAppWindowCapturerMac Leave");
}


