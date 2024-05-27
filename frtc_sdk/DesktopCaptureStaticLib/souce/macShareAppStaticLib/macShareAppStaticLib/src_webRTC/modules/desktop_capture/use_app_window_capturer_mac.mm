//
//  use_app_window_capturer_mac.cpp
//  TestWebrtc
//
//  Created by yingyong.Mao on 2022/3/2.
//

#import "common.h"
#include "use_app_window_capturer_mac.hpp"
#include "api/video/i420_buffer.h" //for I420Buffer
#include "libyuv.h"

#import "SaveFileForCGImage.hpp"

#import "MacShareAppStaticLibClass.hpp"

#include <CoreFoundation/CoreFoundation.h>


using namespace libyuv;

void UseAppWindowCapturerMac::OnFrameYUV420Buffer(uint8_t * yuvBuffer,
                                                  int length,
                                                  int width,
                                                  int height,
                                                  int stride,
                                                  Capture_VideoSampleType type,
                                                  std::string sourceID) {
    
    //NSString *strSourceID = [NSString stringWithCString:sourceID.c_str() encoding:[NSString defaultCStringEncoding]];
    //NSLog(@"[UseAppWindowCapturerMac::OnFrameYUV420Buffer]: source type as sourceID : %@", [strSourceID isEqualToString:@"1"]? @"App Window data" : @"pause image");

    //TODO: -yingyong.Mao -2022-3-7
    //要通过macShareAppStatic 返回给上层调用部分。
    
    if (nullptr != this->contentOutputCB) {
        this->contentOutputCB(yuvBuffer,
                              length,
                              width,
                              height,
                              stride,
                              //Capture_VideoSampleType::SAMPLE_TYPE_I420,
                              type,
                              sourceID);
    }
}


//================================================
//for LifyCycle
//================================================
#pragma mark - UseAppWindowCapturerMac LifyCycle

//static UseAppWindowCapturerMac *singletonInstance = nil;

static std::shared_ptr<UseAppWindowCapturerMac> singletonInstance(new UseAppWindowCapturerMac);

std::shared_ptr<UseAppWindowCapturerMac> UseAppWindowCapturerMac::getInstance() {
    //NSLog(@"[UseAppWindowCapturerMac] : getInstance() Enter");
    //static UseAppWindowCapturerMac *singletonInstance = nil;
    /*
     static dispatch_once_t once_taken = 0;
     dispatch_once(&once_taken, ^{
     singletonInstance = new UseAppWindowCapturerMac();
     NSLog(@"[UseAppWindowCapturerMac] : getInstance() -> new UseAppWindowCapturerMac: singletonInstance = %p", singletonInstance);
     });
     */
    
    if (NULL == singletonInstance) {
        //singletonInstance = new UseAppWindowCapturerMac();
        singletonInstance->appWindowCapture_ = nullptr;
    }
    
    //NSLog(@"[UseAppWindowCapturerMac] : getInstance() Leave");
    return singletonInstance;
}

void UseAppWindowCapturerMac::releaseInstance() {
    NSLog(@"[UseAppWindowCapturerMac] : releaseInstance() Enter");
    if (NULL != singletonInstance) {
        singletonInstance.reset();
        //        delete singletonInstance;
        //        singletonInstance = NULL;
    }
    NSLog(@"[UseAppWindowCapturerMac] : releaseInstance() Leave");
}

UseAppWindowCapturerMac::UseAppWindowCapturerMac() {
    this->sharingAppPauseImage_ = nil;
    //this->yuvByteBuffer_ = nullptr;
    //this->yuvByteBuffer_scaled_dst_ = nullptr;
    this->start_flag_ = false;
    
    this->nCountCaptureEmpty = 0;
    //NSLog(@"[UseAppWindowCapturerMac] UseAppWindowCapturerMac: by default: start_flag_[%p] = false: not share", &start_flag_);
}

UseAppWindowCapturerMac::~UseAppWindowCapturerMac() {
    NSLog(@"[~UseAppWindowCapturerMac] Enter");
    
    //    if (NULL != appWindowCapture_) {
    //        free (appWindowCapture_);
    //        appWindowCapture_ = NULL;
    //    }
    
    //    if (NULL != yuvByteBuffer_) {
    //        free (yuvByteBuffer_);
    //        yuvByteBuffer_ = NULL;
    //    }
    
    //    if (NULL != yuvByteBuffer_scaled_dst_) {
    //        free (yuvByteBuffer_scaled_dst_);
    //        yuvByteBuffer_scaled_dst_ = NULL;
    //    }
    NSLog(@"[~UseAppWindowCapturerMac] Leave");
}

//================================================
//for Thread
//================================================
#pragma mark - UseAppWindowCapturerMac LifyCycle

void createCaptureAppContentTimerThread() {
    
}

void UseAppWindowCapturerMac::resumeCaptureAppContentTimer(dispatch_source_t timer) {
    dispatch_resume(timer);
}

void UseAppWindowCapturerMac::suspendCaptureAppContentTimer(dispatch_source_t timer) {
    dispatch_suspend(timer);
}

//destroy
void UseAppWindowCapturerMac::cancelCaptureAppContentTimer(dispatch_source_t timer) {
    if (nullptr != timer) {
        dispatch_source_cancel(timer);
    }
    timer = nullptr;
}

//================================================
//for Capture App Window
//================================================
#pragma mark - UseAppWindowCapturerMac Capture App Window

void UseAppWindowCapturerMac::StopCapture() {
    //NSLog(@"[UseAppWindowCapturerMac] : StopCapture Enter");
    std::lock_guard<std::mutex> timerLock(_theLock);
    start_flag_ = false;
    //NSLog(@"[UseAppWindowCapturerMac] StopCapture: start_flag_[%p] ", &start_flag_);
    //NSLog(@"[UseAppWindowCapturerMac] StopCapture: start_flag_[%p] = %@", &start_flag_, start_flag_?@"true: sharing":@"false: stop share");
    //        if (capture_thread_ && capture_thread_->joinable()) {
    //            capture_thread_->join();
    //        }
    
    //NSLog(@"[UseAppWindowCapturerMac] : StopCapture -> dispatch_source_cancel(_captureAppContentTimer [%p])", _captureAppContentTimer);
    
    if (NULL != _captureAppContentTimer) {
        cancelCaptureAppContentTimer(_captureAppContentTimer);
        //_captureAppContentTimer = NULL;
    }
    
    //NSLog(@"[UseAppWindowCapturerMac] : StopCapture -> appWindowCapture_[%p]->StopCapture()", appWindowCapture_);
    
    if (NULL != appWindowCapture_) {
        appWindowCapture_->StopCapture();
        //delete appWindowCapture_;
        //appWindowCapture_ = NULL;
    }
    
    if (NULL != imageData_pauseImage_Ptr) {
        free(imageData_pauseImage_Ptr);
        imageData_pauseImage_Ptr = NULL;
    }
    
    //    if (nullptr != yuvByteBuffer_) {
    //        free(yuvByteBuffer_);
    //        yuvByteBuffer_ = nullptr;
    //    }
    
    //NSLog(@"[UseAppWindowCapturerMac] : StopCapture Leave");
}

void UseAppWindowCapturerMac::StartCapture() {
    if (start_flag_) {
        //NSLog(@"[UseAppWindowCapturerMac] : StartCapture: start_flag_ = %@, Capture already been running...", start_flag_?@"true: sharing":@"false: stop share");
        
        RTC_LOG(WARNING) << "Capture already been running...";
        return;
    }
    start_flag_ = true;
    //NSLog(@"[UseAppWindowCapturerMac] : StartCapture: start_flag_ = %@", start_flag_?@"true: sharing":@"false: stop share");
    
    //NSLog(@"[UseAppWindowCapturerMac] : StartCapture -> create _captureAppContentTimer [%p] then start capture App window.", _captureAppContentTimer);
    // Start new thread to capture
    
    //        capture_thread_.reset(new std::thread([this]() {
    //            dc_->Start(this);
    //
    //            while (start_flag_) {
    //                dc_->CaptureFrame();
    //                std::this_thread::sleep_for(std::chrono::milliseconds(1000 / fps_));
    //            }
    //        }));
    
    
    //if (NULL == appWindowCapture_) {
    //NSLog(@"[UseAppWindowCapturerMac] : StartCapture -> [before] appWindowCapture_[%p] =  new WindowCapturerMac", appWindowCapture_);
    
    DesktopCaptureOptions options = DesktopCaptureOptions::CreateDefault();
    appWindowCapture_ = new WindowCapturerMac(options.full_screen_window_detector(),
                                              options.configuration_monitor());
    
    //NSLog(@"[UseAppWindowCapturerMac] : StartCapture -> [after] appWindowCapture_[%p] =  new WindowCapturerMac", appWindowCapture_);
    //}
    
    
    //appWindowCapture_ = DesktopCapturer::CreateRawWindowCapturer(options);
    
    //appWindowCapture_ = std::unique_ptr<WindowCapturerMac>(new WindowCapturerMac(options.full_screen_window_detector(),
    //                                                                             options.configuration_monitor()));
    


    //TODO: -yingyong.Mao -2022-4-2
    
/*
    //[version-1]: webRTC get all app window list.
    webrtc_mac_capturer::DesktopCapturer::SourceList appWindowSourceList;
    appWindowCapture_->GetSourceList(&appWindowSourceList);
    //winCapture->SelectSource(appWindowSourceList->front().id);
    
    
    for (int i = 0; i < appWindowSourceList.size(); ++i) {
        std::string title = (appWindowSourceList[i].title);
        NSLog(@"[%s][%d]: --- --- appWindowSourceList[%d].id : %ld, title: %s", __func__, __LINE__, i, appWindowSourceList[i].id, title.c_str());

        //TODO: -yingyong.Mao -2022-3-21
        //if (title == "QQ影音") {
        if (!(title.empty())
            && 0 < title.length()
            && title.compare(this->sourceAppContentName) == 0) {
            
            NSLog(@"[%s][%d]: --- --- appWindowSourceList[%d].id : %ld, title: %s", __func__, __LINE__, i, appWindowSourceList[i].id, title.c_str());
            appWindowCapture_->SelectSource(appWindowSourceList[i].id); //appWindowID.
            break;
        }
    }
*/
    
    //[version -2]: UI send the app windowID to share.
    appWindowCapture_->SelectSource(sourceAppContentWindowID); //appWindowID.
    appWindowCapture_->FocusOnSelectedSource();
    appWindowCapture_->Start(this);
    
    NSTimeInterval timeIntervalInMicroSecond = 1000 / fps_;
    //NSLog(@"[Thread Running] capture: [adaptor->captureAppContent]: intervalInMS = %f", timeIntervalInMicroSecond);
    //NSLog(@"[Thread Running] capture: [adaptor->captureAppContent]: adaptor->_capability.framerate = %zu", fps_);
    
    //NSTimeInterval delayTime = 1.0f;
    //dispatch_time_t startDelayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * 0));
    
    std::weak_ptr<UseAppWindowCapturerMac> weakSelf(shared_from_this());
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _captureAppContentTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_captureAppContentTimer, dispatch_walltime(NULL, 0), timeIntervalInMicroSecond * NSEC_PER_MSEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_captureAppContentTimer, ^{
        
        //TODO: -test -ymao -2022-1-18 -for minimize sharing app window
        //===begin========================================================
        //        if (_weak_self->_device->isAllWindowMinmized) {
        //            NSLog(@"[Thread Running] capture:  isAllWindowMinmized() ");
        //
        //            return;
        //        }
        
        //===end========================================================
        
        //NSLog(@"[Thread Running] capture:  call captureAppContent() ");
        
        static uint64_t startCaptureTime = 0 ;
        static uint64_t captureTime = 0;
        static uint64_t lastEndCaptureLoopTime = 0;
        static uint64_t lastCaptureLoopTime = 0;
        
        lastCaptureLoopTime = getCPUTime() - lastEndCaptureLoopTime;
        //NSLog(@"[Thread Running] capture: [adaptor->captureAppContent]: [Time]: lastCaptureLoopTime = %llu", lastCaptureLoopTime);
        //NSLog(@"[Thread Running] capture: [adaptor->captureAppContent]: [Time]: start_flag_ = %@", start_flag_?@"true: sharing":@"false: stop share");
        
        startCaptureTime = getCPUTime();
        
        std::lock_guard<std::mutex> timerLock(_theLock);
        std::shared_ptr<UseAppWindowCapturerMac> sp(weakSelf.lock());
        if (!sp) {
            return;
        }
        appWindowCapture_->CaptureFrame();
        
        captureTime = getCPUTime() - startCaptureTime;
        //NSLog(@"[Thread Running] capture: [adaptor->captureAppContent]: [Time]: captureContentTime = %llu", captureTime);
        lastEndCaptureLoopTime = getCPUTime();
        
    });
    dispatch_resume(_captureAppContentTimer);
}

void UseAppWindowCapturerMac::setContentOutputCallback(ContentOutputCallback cb) {
    this->contentOutputCB = cb;
}

void UseAppWindowCapturerMac::setCapability(CONTENT_CAPS_STRUCT capability) {
    //NSLog(@"[UseAppWindowCapturerMac] : setCapability: capability:[%d, %d, %d]", capability.width, capability.height, capability.framerate);
    this->capability = capability;
}

void UseAppWindowCapturerMac::setAppContentName(std::string sourceAppContentName, unsigned int sourceAppContentWindowID) {
    this->sourceAppContentName = sourceAppContentName;
    this->sourceAppContentWindowID = sourceAppContentWindowID;
}

void UseAppWindowCapturerMac::i420Scale(uint8_t *srcYuvData, uint8_t *dstYuvData, int width, int height, int dstWidth, int dstHeight) {
    
    const uint8_t* src_y = srcYuvData;    //y平面字节数组的起始位置
    uint8_t* dst_y = dstYuvData;          //旋转后的y平面数组的起始位置
    
    libyuv::I420Scale(srcYuvData,             //y平面字节数组的起始位置
                      width,                  //y平面每行的长度，一般为 width
                      src_y+width*height ,    //u平面字节数组的起始位置, 一般为 src_y+width*height
                      width/2,                //u平面每行的长度，一般为width/2
                      src_y + width * height * 5 / 4,    //v平面字节数组的起始位置, 一般为 src_y+width*height*5/4
                      width/2 ,        //v平面每行的长度，一般为 width/2
                      width,           //这里指旋转前的宽度 src_width
                      height,          //这里指旋转前的高度 are_height
                      dstYuvData,      //旋转后的y平面数组的起始位置
                      width,           //旋转后的y平面每行的长度，一般如果是90或270则为height, 其他为width
                      dst_y + width * height,  //旋转后的u平面字节数组的起始位置，一般为 dst_y + width * height
                      width/2,                 //旋转后的u平面每行的长度，一般如果是90或270则为 height/2, 其他为 width/2
                      dst_y + width * height * 5 / 4,     //旋转后的v平面字节数组的起始位置，一般为 dst_y + width * height * 5 / 4
                      width/2,         //旋转后的v平面每行的长度，一般如果是90或270则为 height/2, 其他为 width/2
                      dstWidth,        //旋转后的宽度
                      dstHeight,       //旋转后的高度
                      kFilterNone
                      );
}

void clip(uint8_t *srcYuvData, uint8_t *dstYuvData, int width, int height, int cropX, int cropY, int cropWidth, int cropHeight) {
    ConvertToI420(
                  srcYuvData,
                  width*height*3/2,
                  dstYuvData,
                  cropWidth,
                  dstYuvData+cropWidth*cropHeight,
                  (cropWidth+1)/2,
                  dstYuvData+cropWidth*cropHeight+((cropWidth+1)/2)*((cropHeight+1)/2),
                  (cropWidth+1)/2,
                  cropX,
                  cropY,
                  width,
                  height,
                  cropWidth,
                  cropHeight,
                  kRotate0,
                  FOURCC_YU12);
};



//2022-3-10
//work_ok_lower_than_10fps

//[without_scale]: work ok,

//DesktopCapturer::Callback interface.
//send RGB
void UseAppWindowCapturerMac::OnCaptureResult(DesktopCapturer::Result result, std::unique_ptr<DesktopFrame> frame) {
    
    //NSLog(@"[UseAppWindowCapturerMac]: OnCaptureResult : %d", __LINE__);
    
    //MacShareAppStaticLibClass *macShareAppLib = MacShareAppStaticLibClass::getInstance();
    //NSLog(@"[UseAppWindowCapturerMac] OnCaptureResult: macShareAppLib[%p]->start_flag_[%p] ", &macShareAppLib,  &(macShareAppLib->start_flag_));
    //NSLog(@"[UseAppWindowCapturerMac] OnCaptureResult: macShareAppLib->start_flag_ = %@", (macShareAppLib->start_flag_)?@"true: sharing":@"false: stop share");
    
    if (true != start_flag_) {
        //NSLog(@"[UseAppWindowCapturerMac] OnCaptureResult: start_flag_[%p] ", &start_flag_);
        NSLog(@"[UseAppWindowCapturerMac] OnCaptureResult: start_flag_ = false, means stop share, so return.");
        return;
    }
    
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        static uint64_t startTime = 0;
        //static uint64_t durationTime = 0;
        //static uint64_t startCaptureTime = 0;
        //static uint64_t captureTime = 0;
        static uint64_t lastEndCaptureLoopTime = 0;
        static uint64_t lastCaptureLoopTime = 0;
        
        //static int index = 0;
        lastCaptureLoopTime = clock();
        lastEndCaptureLoopTime = lastCaptureLoopTime;
        //NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [%d] : lastCaptureLoopTime = %llu", index++, lastCaptureLoopTime - lastEndCaptureLoopTime);
        
        if (result != DesktopCapturer::Result::SUCCESS) {
            //[1].capture failed, maybe the window was minimized!
            //NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: capture failed, maybe the window is minimized! will load and show pasue image.");
            
            //[bug fix]: share App, sometimes remote content is black.
            //if < MAX_CAPTURE_FAILED_COUNT return, else sent & show pause-pic.
            if (this->nCountCaptureEmpty < MAX_CAPTURE_FAILED_COUNT) {
                //NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: capture failed, but count: %d < MAX_CAPTURE_FAILED_COUNT, so return!", this->nCountCaptureEmpty);
                this->nCountCaptureEmpty++;
                return;
            } else {
                //NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: capture failed, and count: %d >= MAX_CAPTURE_FAILED_COUNT, so sent & show pause-pic!", this->nCountCaptureEmpty);
                this->nCountCaptureEmpty = 0;
            }
            
            //for pause image.
            static int width = 0;
            static int height = 0;
            static int yuv_i420_str_length = 0;
            
            //if (nullptr == yuvByteBuffer_pauseImage) {
            if (nullptr == imageData_pauseImage_Ptr) {
                //CaptureDesktopQuartz_PauseImage()
                
                //load pause-image
                //get raw data of the CGImage
                if (nil == sharingAppPauseImage_) {
                    sharingAppPauseImage_ = [NSImage imageNamed:@"sharing-app-content-pause"]; //sharing-app-content-pause-no-str, content-paused
                }
                if (nil == sharingAppPauseImage_) {
                    NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: sharing-app-content-pause not exist !!!");
                    return;
                }
                
                //NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: pause sharing-app, sharingAppPauseImage_.size : [%f, %f] ", sharingAppPauseImage_.size.width, sharingAppPauseImage_.size.height);
                
                //#if !TARGET_OS_OSX // TODO(macOS ISS#2323203)
                //            CGImageRef cgImage = image.CGImage;
                //#else // [TODO(macOS ISS#2323203)
                CGImageRef cgImage = [sharingAppPauseImage_ CGImageForProposedRect:NULL context:NULL hints:NULL];
                //#endif // ]TODO(macOS ISS#2323203)
                
                //CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(cgImage);
                CGColorSpaceRef colorRef = CGColorSpaceCreateDeviceRGB();
                
                width = sharingAppPauseImage_.size.width;
                height = sharingAppPauseImage_.size.height;
                yuv_i420_str_length = (width * height * 3) / 2;
                
                // Get source image data
                imageData_pauseImage_Ptr = (uint8_t *)malloc(width * height * 4);
                CGContextRef imageContext = CGBitmapContextCreate(imageData_pauseImage_Ptr,
                                                                  width, height,
                                                                  8,
                                                                  static_cast<size_t>(width * 4),
                                                                  colorRef,
                                                                  kCGImageAlphaPremultipliedFirst// no Alpha: kCGImageAlphaNoneSkipFirst //alphaInfo
                                                                  );
                // to BGRA: kCGImageAlphaPremultipliedFirst
                CGContextDrawImage(imageContext, CGRectMake(0, 0, width, height), cgImage);
                CGContextRelease(imageContext);
                CGColorSpaceRelease(colorRef);
                
                sharingAppPauseImage_ = nil;
            }
            
            if (nullptr != imageData_pauseImage_Ptr) {
                //yuvWriteToFile(frame->data(), str_length, width, height, @"");
                
                startTime = getCPUTime();
                //NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: -> OnFrameYUV420Buffer, send pause image while sharing app is minimized by user");

                unsigned int target_stride = 0;
                int str_length = width * height * 4;
                //this->OnFrameYUV420Buffer(yuvByteBuffer_pauseImage, width * height * 4, width, height, target_stride, Capture_VideoSampleType::SAMPLE_TYPE_ARGB, "0");
                this->OnFrameYUV420Buffer(imageData_pauseImage_Ptr, str_length, width, height, target_stride, Capture_VideoSampleType::SAMPLE_TYPE_BGRA, "0");
                
                //NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [Time]: OnFrameYUV420Buffer to send stream time = %llu", getCPUTime() - startTime);
                //NSLog(@"[UseAppWindowCapturerMac] : OnCaptureResult: imageData_pauseImage_Ptr buffer src length: %d, width: %d, height: %d", str_length, width, height);
                
            } else {
                NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: imageData_pauseImage_Ptr is nullprt");
            }
            
        } else {
            //[2].for sharing app window data: capture successfully.
            
            //[bug fix]: share App, sometimes remote content is black.
            this->nCountCaptureEmpty = 0;
            
            int width = frame->size().width();
            int height = frame->size().height();
            //int target_width = width;
            //int target_height = height;
            //  int target_width = this->capability.width;
            //  int target_height = this->capability.height;
            
            //int target_framerate = this->capability.framerate;
            //NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: capture frame: [%d, %d] -> target i420: [%d, %d, %d]", width, height, target_width, target_height, target_framerate);
            //NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]:this->capability.width, height: [%d, %d] -> frame width, height i420: [%d, %d, %d]", this->capability.width, this->capability.height, width, height, target_framerate);
            
            if (nullptr != frame->data()) {
                unsigned int target_stride = frame->stride() / 4;
                int str_length = target_stride * height * 4;
                //int str_length = width * height * 4;
                //yuvWriteToFile(frame->data(), str_length, width, height, @""); //save ARGB file.
                
                uint8_t * argbByteBuffer_ = (uint8 *)malloc(str_length);
                memset(argbByteBuffer_, 0, str_length);
                memcpy(argbByteBuffer_, frame->data(), str_length);
                
                //startTime = getCPUTime();
                //this->OnFrameYUV420Buffer((uint8_t *)frame->data(), str_length, width, height, target_stride, Capture_VideoSampleType::SAMPLE_TYPE_ARGB, "1");
                this->OnFrameYUV420Buffer(argbByteBuffer_, str_length, width, height, target_stride, Capture_VideoSampleType::SAMPLE_TYPE_ARGB, "1");
                frame.reset();
                
                //NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [Time]: OnFrameYUV420Buffer to send stream time = %llu", getCPUTime() - startTime);
                //NSLog(@"[UseAppWindowCapturerMac] : OnCaptureResult: argbByteBuffer_ buffer src length: %d, width: %d, height: %d", str_length, width, height);
            }
            
        }
    }
}

/*
void UseAppWindowCapturerMac::OnCaptureResult_send_yuv(DesktopCapturer::Result result, std::unique_ptr<DesktopFrame> frame) {
    
    //NSLog(@"[UseAppWindowCapturerMac]: OnCaptureResult : %d", __LINE__);
    
    //MacShareAppStaticLibClass *macShareAppLib = MacShareAppStaticLibClass::getInstance();
    //NSLog(@"[UseAppWindowCapturerMac] OnCaptureResult: macShareAppLib[%p]->start_flag_[%p] ", &macShareAppLib,  &(macShareAppLib->start_flag_));
    //NSLog(@"[UseAppWindowCapturerMac] OnCaptureResult: macShareAppLib->start_flag_ = %@", (macShareAppLib->start_flag_)?@"true: sharing":@"false: stop share");
    
    if (true != start_flag_) {
        //NSLog(@"[UseAppWindowCapturerMac] OnCaptureResult: start_flag_[%p] ", &start_flag_);
        NSLog(@"[UseAppWindowCapturerMac] OnCaptureResult: start_flag_ = false, means stop share, so return.");
        return;
    }
    
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        static uint64_t startTime = 0;
        //static uint64_t durationTime = 0;
        //static uint64_t startCaptureTime = 0;
        //static uint64_t captureTime = 0;
        static uint64_t lastEndCaptureLoopTime = 0;
        static uint64_t lastCaptureLoopTime = 0;
        
        //static int index = 0;
        lastCaptureLoopTime = clock();
        lastEndCaptureLoopTime = lastCaptureLoopTime;
        //NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [%d] : lastCaptureLoopTime = %llu", index++, lastCaptureLoopTime - lastEndCaptureLoopTime);
        
        if (result != DesktopCapturer::Result::SUCCESS) {
            //[1].capture failed, maybe the window was minimized!
            //NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: capture failed, maybe the window is minimized! will load and show pasue image.");
            
	        //[bug fix]: share App, sometimes remote content is black.
            //if < MAX_CAPTURE_FAILED_COUNT return, else sent & show pause-pic.
            if (this->nCountCaptureEmpty < MAX_CAPTURE_FAILED_COUNT) {
                //NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: capture failed, but count: %d < MAX_CAPTURE_FAILED_COUNT, so return!", this->nCountCaptureEmpty);
                this->nCountCaptureEmpty++;
                return;
            } else {
                //NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: capture failed, and count: %d >= MAX_CAPTURE_FAILED_COUNT, so sent & show pause-pic!", this->nCountCaptureEmpty);
                this->nCountCaptureEmpty = 0;
            }
            
            //for pause image.
            static int width = 0;
            static int height = 0;
            static int yuv_i420_str_length = 0;
            
            if (nullptr == yuvByteBuffer_pauseImage) {
                //CaptureDesktopQuartz_PauseImage()
                
                //load pause-image
                //get raw data of the CGImage
                if (nil == sharingAppPauseImage_) {
                    sharingAppPauseImage_ = [NSImage imageNamed:@"sharing-app-content-pause"]; //sharing-app-content-pause-no-str, content-paused
                }
                if (nil == sharingAppPauseImage_) {
                    NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: sharing-app-content-pause not exist !!!");
                    return;
                }
                
                //NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: pause sharing-app, sharingAppPauseImage_.size : [%f, %f] ", sharingAppPauseImage_.size.width, sharingAppPauseImage_.size.height);
                
                //#if !TARGET_OS_OSX // TODO(macOS ISS#2323203)
                //            CGImageRef cgImage = image.CGImage;
                //#else // [TODO(macOS ISS#2323203)
                CGImageRef cgImage = [sharingAppPauseImage_ CGImageForProposedRect:NULL context:NULL hints:NULL];
                //#endif // ]TODO(macOS ISS#2323203)
                
                //CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(cgImage);
                CGColorSpaceRef colorRef = CGColorSpaceCreateDeviceRGB();
                
                width = sharingAppPauseImage_.size.width;
                height = sharingAppPauseImage_.size.height;
                yuv_i420_str_length = (width * height * 3) / 2;
                
                // Get source image data
                //std::shared_ptr<uint8_t> imageData_pauseImage_Ptr((uint8_t *) malloc(width * height * 4));
                uint8_t * imageData_pauseImage_Ptr = (uint8_t *) malloc(width * height * 4);
                CGContextRef imageContext = CGBitmapContextCreate(imageData_pauseImage_Ptr,
                                                                  width, height,
                                                                  8,
                                                                  static_cast<size_t>(width * 4),
                                                                  colorRef,
                                                                  kCGImageAlphaPremultipliedFirst// no Alpha: kCGImageAlphaNoneSkipFirst //alphaInfo
                                                                  );
                // to BGRA: kCGImageAlphaPremultipliedFirst
                CGContextDrawImage(imageContext, CGRectMake(0, 0, width, height), cgImage);
                CGContextRelease(imageContext);
                CGColorSpaceRelease(colorRef);
                
                sharingAppPauseImage_ = nil;
                if (nullptr != imageData_pauseImage_Ptr) {
                    free(imageData_pauseImage_Ptr);
                    //imageData_pauseImage_Ptr = nullptr;
                }
                
                // convert to I420
                int stride_y = width;
                int stride_uv = (width + 1) / 2;
                
                //TODO: -yingyong.Mao -2022-3-21
                int target_width = width;
                int target_height = height;
                //        int target_width = this->capability.width;
                //        int target_height = this->capability.height;
                //int target_framerate = this->capability.framerate;
                //NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: capture frame: [%d, %d] -> target i420: [%d, %d, %d]", width, height, target_width, target_height, target_framerate);
                
                static rtc::scoped_refptr<I420Buffer> i420_buffer_ = nullptr;
                if (i420_buffer_ == nullptr) {
                    i420_buffer_ = I420Buffer::Create(target_width, target_height, stride_y, stride_uv, stride_uv);
                } else if (!i420_buffer_.get() || i420_buffer_->width() * i420_buffer_->height() < width * height) {
                    i420_buffer_ = nullptr;
                    i420_buffer_ = I420Buffer::Create(target_width, target_height, stride_y, stride_uv, stride_uv);
                }
                
                startTime = getCPUTime();
                
                //[method-1]: ABGRToI420
                //            int ret = libyuv::ARGBToI420(imageData_pauseImage_Ptr, width, //frame->stride(),
                //                                         i420_buffer_.get()->MutableDataY(), i420_buffer_.get()->StrideY(),
                //                                         i420_buffer_.get()->MutableDataU(), i420_buffer_.get()->StrideU(),
                //                                         i420_buffer_.get()->MutableDataV(), i420_buffer_.get()->StrideV(),
                //                                         target_width, target_height);
                
                //            int ret = libyuv::RGB24ToI420(imageData_pauseImage_Ptr, width,
                //                                i420_buffer_.get()->MutableDataY(), width,
                //                                i420_buffer_.get()->MutableDataU(), width / 2,
                //                                i420_buffer_.get()->MutableDataV(), width / 2,
                //                                width, height);
                
                //NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [Time]: ARGBToI420() time = %llu", getCPUTime() - startTime);
                
                //[method-2]: convert from ABGR To I420
                //int stride = width;
                //uint8_t* yplane = i420_buffer_->MutableDataY();
                //uint8_t* uplane = i420_buffer_->MutableDataU();
                //uint8_t* vplane = i420_buffer_->MutableDataV();
                
                int ret = libyuv::ConvertToI420(imageData_pauseImage_Ptr, width * height * 3 / 2,
                                                i420_buffer_.get()->MutableDataY(), i420_buffer_.get()->StrideY(),
                                                i420_buffer_.get()->MutableDataU(), i420_buffer_.get()->StrideU(),
                                                i420_buffer_.get()->MutableDataV(), i420_buffer_.get()->StrideV(),
                                                0, 0,
                                                width, height,
                                                width, height,
                                                libyuv::kRotate0,
                                                libyuv::FOURCC_BGRA); //数据输入格式：FOURCC_ARGB
                if (ret != 0) {
                    NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: libyuv::ARGBToI420 return failed!");
                    //frame.release();
                    return;
                }
                
                //int width = frame->size().width();
                //int height = frame->size().height();
                //NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [width, height] : [%d, %d]", width, height);
                
                //    VideoFrame videoFrame = VideoFrame(i420_buffer_, 0, 0, kVideoRotation_0);
                //    this->OnFrame(videoFrame);
                
                //this->OnFrame(frame); //width, height
                
                //frame.release();
                
                startTime = getCPUTime();
                
                //get data from the YUV420 buffer.
                int nYUVBufsize = 0;
                int nVOffset = 0;
                
                yuvByteBuffer_pauseImage = (uint8 *)malloc(yuv_i420_str_length);
                
                for (int i = 0; i < height; i++) {
                    memcpy(yuvByteBuffer_pauseImage + nYUVBufsize, i420_buffer_->DataY() + i * i420_buffer_->StrideY(), width);
                    nYUVBufsize += width;
                }
                
                for (int i = 0; i < height / 2; i++) {
                    memcpy(yuvByteBuffer_pauseImage + nYUVBufsize, i420_buffer_->DataU() + i * i420_buffer_->StrideU(), width / 2);
                    nYUVBufsize += width / 2;
                    
                    memcpy(yuvByteBuffer_pauseImage + width * height * 5 / 4 + nVOffset, i420_buffer_->DataV() + i * i420_buffer_->StrideV(), width / 2);
                    nVOffset += width / 2;
                }
                
                i420_buffer_ = nullptr;
                //NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [Time]: convert to yuvByteBuffer_pauseImage time = %llu", getCPUTime() - startTime);
            }
            
            if (nullptr != yuvByteBuffer_pauseImage) {
                //TODO: -yingyong.Mao -save
                //yuvWriteToFile(frame->data(), str_length, width, height, @"");
                
                startTime = getCPUTime();
                //NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: -> OnFrameYUV420Buffer, send pause image while sharing app is minimized by user");

                this->OnFrameYUV420Buffer(yuvByteBuffer_pauseImage, yuv_i420_str_length, width, height, Capture_VideoSampleType::SAMPLE_TYPE_I420, "0");
                
                //NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [Time]: OnFrameYUV420Buffer to send stream time = %llu", getCPUTime() - startTime);
                //NSLog(@"[UseAppWindowCapturerMac] : OnCaptureResult: i420 buffer src length: %d, width: %d, height: %d", yuv_i420_str_length, width, height);
                //NSLog(@"[UseAppWindowCapturerMac] : OnCaptureResult: yuvByteBuffer_pauseImage dst_length: %d, dstWidth: %d, dstHeight: %d", yuv_i420_str_length, width, height);
                
                //TODO: -yingyong.Mao -2022-4-1
                //            if (yuvByteBuffer_pauseImage != nullptr) {
                //                free(yuvByteBuffer_pauseImage);
                //                yuvByteBuffer_pauseImage = nullptr;
                //            }
            } else {
                NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: yuvByteBuffer_pauseImage is nullprt");
            }
            
        } else {
            //[2].for sharing app window data: capture successfully.
            
            //[bug fix]: share App, sometimes remote content is black.
            this->nCountCaptureEmpty = 0;
            
            // convert to I420
            int width = frame->size().width();
            int height = frame->size().height();
            int stride_y = width;
            int stride_uv = (width + 1) / 2;
            
            //TODO: -yingyong.Mao -2022-3-21
            int target_width = width;
            int target_height = height;
            //        int target_width = this->capability.width;
            //        int target_height = this->capability.height;
            int target_framerate = this->capability.framerate;
            NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: capture frame: [%d, %d] -> target i420: [%d, %d, %d]", width, height, target_width, target_height, target_framerate);
            
            if (test_g_width != width | test_g_height != height) {
                NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: 111--- capture frame: [%d, %d] -> test_g_height: [%d, %d, %d]", width, height, test_g_width, test_g_height, target_framerate);

                test_g_width = width;
                test_g_height = height;
            }
            
            NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]:this->capability.width, height: [%d, %d] -> frame width, height i420: [%d, %d, %d]", this->capability.width, this->capability.height, width, height, target_framerate);

            
            
            static rtc::scoped_refptr<I420Buffer> i420_buffer_ = nullptr;
            
            if (i420_buffer_ == nullptr) {
                i420_buffer_ = I420Buffer::Create(target_width, target_height, stride_y, stride_uv, stride_uv);
            } else if (!i420_buffer_.get() || i420_buffer_->width() * i420_buffer_->height() < width * height) {
                i420_buffer_ = nullptr;
                i420_buffer_ = I420Buffer::Create(target_width, target_height, stride_y, stride_uv, stride_uv);
            }
            
            startTime = getCPUTime();
            
            //[method-1]: ABGRToI420
            int ret = libyuv::ARGBToI420(frame->data(), frame->stride(),
                                         i420_buffer_.get()->MutableDataY(), i420_buffer_.get()->StrideY(),
                                         i420_buffer_.get()->MutableDataU(), i420_buffer_.get()->StrideU(),
                                         i420_buffer_.get()->MutableDataV(), i420_buffer_.get()->StrideV(),
                                         target_width, target_height);
            
            //NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [Time]: ARGBToI420() time = %llu", getCPUTime() - startTime);
            
            //[method-2]: convert from ABGR To I420
            //        int stride = width;
            //        uint8_t* yplane = i420_buffer_->MutableDataY();
            //        uint8_t* uplane = i420_buffer_->MutableDataU();
            //        uint8_t* vplane = i420_buffer_->MutableDataV();
            //
            //        int ret = libyuv::ConvertToI420(frame->data(), 0,
            //                                        i420_buffer_.get()->MutableDataY(), i420_buffer_.get()->StrideY(),
            //                                        i420_buffer_.get()->MutableDataU(), i420_buffer_.get()->StrideU(),
            //                                        i420_buffer_.get()->MutableDataV(), i420_buffer_.get()->StrideV(),
            //                                        0, 0,
            //                                        width, height,
            //                                        width, height,
            //                                        libyuv::kRotate0,
            //                                        libyuv::FOURCC_ARGB);
            
            if (ret != 0) {
                NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: libyuv::ARGBToI420 return failed!");
                //frame.release();
                return;
            }
            
            //        int width = frame->size().width();
            //        int height = frame->size().height();
            
            //NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [width, height] : [%d, %d]", width, height);
            
            //    VideoFrame videoFrame = VideoFrame(i420_buffer_, 0, 0, kVideoRotation_0);
            //    this->OnFrame(videoFrame);
            
            //this->OnFrame(frame); //width, height
            
            //frame.release();
            
            startTime = getCPUTime();
            
            //get data from the YUV420 buffer.
            int nYUVBufsize = 0;
            int nVOffset = 0;
            int str_length = (width * height * 3) / 2;
            
            //TODO: -yingyong.Mao -2022-3-10
            //yuvByteBuffer_  = new char[str_length];
            uint8_t * yuvByteBuffer_ = (uint8 *)malloc(str_length);
            for (int i = 0; i < height; i++) {
                memcpy(yuvByteBuffer_ + nYUVBufsize, i420_buffer_->DataY() + i * i420_buffer_->StrideY(), width);
                nYUVBufsize += width;
            }
            
            for (int i = 0; i < height / 2; i++) {
                memcpy(yuvByteBuffer_ + nYUVBufsize, i420_buffer_->DataU() + i * i420_buffer_->StrideU(), width / 2);
                nYUVBufsize += width / 2;
                
                memcpy(yuvByteBuffer_ + width * height * 5 / 4 + nVOffset, i420_buffer_->DataV() + i * i420_buffer_->StrideV(), width / 2);
                nVOffset += width / 2;
            }
            
            i420_buffer_ = nullptr;
            //NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [Time]: convert to yuvByteBuffer_ time = %llu", getCPUTime() - startTime);
            
            if (nullptr != yuvByteBuffer_) {
                //TODO: -yingyong.Mao -save
                //yuvWriteToFile(frame->data(), str_length, width, height, @"");
                
                startTime = getCPUTime();
                this->OnFrameYUV420Buffer(yuvByteBuffer_, str_length, width, height, Capture_VideoSampleType::SAMPLE_TYPE_I420, "1");
                
                //NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [Time]: OnFrameYUV420Buffer to send stream time = %llu", getCPUTime() - startTime);
                //NSLog(@"[UseAppWindowCapturerMac] : OnCaptureResult: i420 buffer src length: %d, width: %d, height: %d", str_length, width, height);
                //NSLog(@"[UseAppWindowCapturerMac] : OnCaptureResult: yuvByteBuffer_ dst_length: %d, dstWidth: %d, dstHeight: %d", str_length, width, height);
                
                //TODO: -yingyong.Mao -2022-4-1
                //            if (yuvByteBuffer_ != nullptr) {
                //                free(yuvByteBuffer_);
                //                yuvByteBuffer_ = nullptr;
                //            }
            }
            
            //    this->OnCallBack(0,
            //                     str_length,
            //                     width,
            //                     height,
            //                     Capture_VideoSampleType::SAMPLE_TYPE_I420,
            //                     "1",
            //                     this);
        }
    }
}
*/

//2022-3-10 can work success!

//[scale-2]: I420: scale from src size -> des size (from capblility).

//DesktopCapturer::Callback interface.
void UseAppWindowCapturerMac::OnCaptureResult_scale_2(DesktopCapturer::Result result,
                                                      std::unique_ptr<DesktopFrame> frame) {
    
    NSLog(@"[UseAppWindowCapturerMac]: OnCaptureResult : %d", __LINE__);
    
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        static uint64_t startTime = 0;
        static uint64_t durationTime = 0;
        static uint64_t startCaptureTime = 0 ;
        static uint64_t captureTime = 0;
        static uint64_t lastEndCaptureLoopTime = 0;
        static uint64_t lastCaptureLoopTime = 0;
        static int index = 0;
        
        lastCaptureLoopTime = clock();
        lastEndCaptureLoopTime = lastCaptureLoopTime;
        NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [%d] : lastCaptureLoopTime = %llu", index++, lastCaptureLoopTime - lastEndCaptureLoopTime);
        
        if (result != DesktopCapturer::Result::SUCCESS) {
            return; // Obviously never called
        }
        
        //scale-1 the DesktopFrame.
        
        //        CopyIntersectingPixelsFrom(const DesktopFrame& src_frame,
        //                                    double horizontal_scale,
        //                                    double vertical_scale)
        
        //        int dstWidth = 1920;
        //        int dstHeight = 1080;
        
        //        int dstWidth = 1280;
        //        int dstHeight = 720;
        //
        //        int width = frame->size().width();
        //        int height = frame->size().height();
        //        NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [width, height] : [%d, %d]", width, height);
        //
        //        double horizontal_scale = dstHeight / height;
        //        double vertical_scale = dstWidth / width;
        //
        //        NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [horizontal_scale, vertical_scale] : [%d, %d]", horizontal_scale, vertical_scale);
        //        DesktopSize dstSize = DesktopSize(dstWidth, dstHeight);
        //        std::unique_ptr<DesktopFrame> dstScaledFrame(new BasicDesktopFrame(dstSize));
        //        dstScaledFrame->CopyIntersectingPixelsFrom(*frame, horizontal_scale, vertical_scale);
        //
        //        width = dstWidth;
        //        height = dstHeight;
                
        // convert to I420
        int width = frame->size().width();
        int height = frame->size().height();
        int stride_y = width;
        int stride_uv = (width + 1) / 2;
        int target_width = width;
        int target_height = height;
        
        NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [width, height] : [%d, %d]", width, height);
        
        static rtc::scoped_refptr<I420Buffer> i420_buffer_ = nullptr;
        if (i420_buffer_ == nullptr) {
            i420_buffer_ = I420Buffer::Create(target_width, target_height, stride_y, stride_uv, stride_uv);
        } else if (!i420_buffer_.get() || i420_buffer_->width() * i420_buffer_->height() < width * height) {
            i420_buffer_ = I420Buffer::Create(target_width, target_height, stride_y, stride_uv, stride_uv);
        }
        
        startTime = getCPUTime();
        
        //ABGRToI420
        int ret = libyuv::ARGBToI420(frame->data(), frame->stride(),
                                     i420_buffer_.get()->MutableDataY(), i420_buffer_.get()->StrideY(),
                                     i420_buffer_.get()->MutableDataU(), i420_buffer_.get()->StrideU(),
                                     i420_buffer_.get()->MutableDataV(), i420_buffer_.get()->StrideV(),
                                     target_width, target_height);
        if (ret != 0) {
            NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: libyuv::ARGBToI420 return failed!");
            return;
        }
        
        //        int stride = width;
        //        uint8_t* yplane = i420_buffer_->MutableDataY();
        //        uint8_t* uplane = i420_buffer_->MutableDataU();
        //        uint8_t* vplane = i420_buffer_->MutableDataV();
        //
        //        libyuv::ConvertToI420(frame->data(), 0,
        //                              i420_buffer_.get()->MutableDataY(), i420_buffer_.get()->StrideY(),
        //                              i420_buffer_.get()->MutableDataU(), i420_buffer_.get()->StrideU(),
        //                              i420_buffer_.get()->MutableDataV(), i420_buffer_.get()->StrideV(),
        //                              0, 0,
        //                              width, height,
        //                              width, height,
        //                              libyuv::kRotate0,
        //                              libyuv::FOURCC_ARGB);
        
        //        int width = frame->size().width();
        //        int height = frame->size().height();
        
        NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [width, height] : [%d, %d]", width, height);
        
        //    VideoFrame videoFrame = VideoFrame(i420_buffer_, 0, 0, kVideoRotation_0);
        //    this->OnFrame(videoFrame);
        //this->OnFrame(frame); //width, height
                
        
        //[scale-2]: I420: scale from src size -> des size (from capblility).
        
        //        int dstHeight = 1080;
        //        int dstWidth = 1920;
        
        //TODO: -yingyong.Mao -need capablity from server.
        int dst_Width = 1280;
        int dst_Height = 720;
        int dst_stride_y = dst_Width;
        int dst_stride_uv = (dst_Width + 1) / 2;
        int dst_target_width = dst_Width;
        int dst_target_height = dst_Height;
        
        static rtc::scoped_refptr<I420Buffer> i420_buffer_scale_dst = nullptr;
        
        if (i420_buffer_scale_dst == nullptr) {
            i420_buffer_scale_dst = I420Buffer::Create(dst_target_width, dst_target_height, dst_stride_y, dst_stride_uv, dst_stride_uv);
        } else if (!i420_buffer_scale_dst.get() || i420_buffer_scale_dst->width() * i420_buffer_scale_dst->height() < dst_Width * dst_Height) {
            i420_buffer_scale_dst = I420Buffer::Create(dst_target_width, dst_target_height, dst_stride_y, dst_stride_uv, dst_stride_uv);
        }
        
        //ABGRToI420
        ret = libyuv::I420Scale(i420_buffer_.get()->MutableDataY(), i420_buffer_.get()->StrideY(),
                                i420_buffer_.get()->MutableDataU(), i420_buffer_.get()->StrideU(),
                                i420_buffer_.get()->MutableDataV(), i420_buffer_.get()->StrideV(),
                                width, height,
                                i420_buffer_scale_dst.get()->MutableDataY(), i420_buffer_scale_dst.get()->StrideY(),
                                i420_buffer_scale_dst.get()->MutableDataU(), i420_buffer_scale_dst.get()->StrideU(),
                                i420_buffer_scale_dst.get()->MutableDataV(), i420_buffer_scale_dst.get()->StrideV(),
                                dst_target_width, dst_target_height,
                                libyuv::kFilterBilinear);
        if (ret != 0) {
            NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: libyuv::ARGBToI420 return failed!");
            return;
        }
        
        width = dst_Width;
        height = dst_Height;
        
        //get data from the YUV420 buffer.
        int nYUVBufsize = 0;
        int nVOffset = 0;
        int str_length = (width * height * 3) / 2;
        
        //TODO: -yingyong.Mao -2022-3-10
        //yuvByteBuffer_  = new char[str_length];
        uint8_t * yuvByteBuffer_ = (uint8 *)malloc(str_length);
        for (int i = 0; i < height; i++) {
            memcpy(yuvByteBuffer_ + nYUVBufsize, i420_buffer_scale_dst->DataY() + i * i420_buffer_scale_dst->StrideY(), width);
            nYUVBufsize += width;
        }
        
        for (int i = 0; i < height / 2; i++) {
            memcpy(yuvByteBuffer_ + nYUVBufsize, i420_buffer_scale_dst->DataU() + i * i420_buffer_scale_dst->StrideU(), width / 2);
            nYUVBufsize += width / 2;
            
            memcpy(yuvByteBuffer_ + width * height * 5 / 4 + nVOffset, i420_buffer_scale_dst->DataV() + i * i420_buffer_scale_dst->StrideV(), width / 2);
            nVOffset += width / 2;
        }
        
        
        //[scale-2]: I420: scale from src size -> des size (from capblility).
        
        //        //        int dstHeight = 1080;
        //        //        int dstWidth = 1920;
        //        int dstWidth = 1280;
        //        int dstHeight = 720;
        //
        //        int dst_length = (dstWidth * dstHeight * 3) * 2;
        //        //yuvByteBuffer_scaled_dst_  = (uint8_t *)malloc(dst_length);
        //        uint8 *yuvByteBuffer_scaled_dst_ = (uint8 *)malloc(dst_length);
        //
        //        i420Scale((uint8_t *)yuvByteBuffer_,
        //                  (uint8_t *)yuvByteBuffer_scaled_dst_,
        //                  width, height,
        //                  dstWidth, dstHeight);
        
        //        int psrc_w = width;
        //        int psrc_h = height;
        //        int pdst_w = dstWidth;
        //        int pdst_h = dstHeight;
        //
        //        // I420_1920x1080 -> I420_1280x720
        //        libyuv::I420Scale(&yuvByteBuffer_[0],                          psrc_w,
        //                          &yuvByteBuffer_[psrc_w * psrc_h],            psrc_w >> 1,
        //                          &yuvByteBuffer_[(psrc_w * psrc_h * 5) >> 2], psrc_w >> 1,
        //                          psrc_w, psrc_h,
        //                          &yuvByteBuffer_scaled_dst_[0],                          pdst_w,
        //                          &yuvByteBuffer_scaled_dst_[pdst_w * pdst_h],            pdst_w >> 1,
        //                          &yuvByteBuffer_scaled_dst_[(pdst_w * pdst_h * 5) >> 2], pdst_w >> 1,
        //                          pdst_w, pdst_h,
        //                          kFilterNone);
        
        
        if (yuvByteBuffer_ != nullptr) {
            NSLog(@"[UseAppWindowCapturerMac] : OnCaptureResult: i420 buffer src length: %d, width: %d, height: %d", str_length, width, height);
            NSLog(@"[UseAppWindowCapturerMac] : OnCaptureResult: yuvByteBuffer_scaled_dst_ dst_length: %d, dstWidth: %d, dstHeight: %d", str_length, dst_Width, dst_Height);
            
            //TODO: -yingyong.Mao
            //yuvWriteToFile(yuvByteBuffer_, str_length, dst_Width, dst_Height, @"");
            unsigned int target_stride = frame->stride() / 4;
            this->OnFrameYUV420Buffer(yuvByteBuffer_, str_length, dst_Width, dst_Height, target_stride, Capture_VideoSampleType::SAMPLE_TYPE_I420, "1");
        }
        
        //        if (yuvByteBuffer_ != nullptr) {
        //            free(yuvByteBuffer_);
        //            yuvByteBuffer_ = nullptr;
        //        }
        
        //    this->OnCallBack(0,
        //                     str_length,
        //                     width,
        //                     height,
        //                     Capture_VideoSampleType::SAMPLE_TYPE_I420,
        //                     "1",
        //                     this);
    }
}

//2022-3-10  can work success!

//[scale-1 the DesktopFrame] : scale the DesktopFrame, but cutted, not right, only show the top-left rec.

//DesktopCapturer::Callback interface.
void UseAppWindowCapturerMac::OnCaptureResult_scale_1_DesktopFrame_scale(DesktopCapturer::Result result, std::unique_ptr<DesktopFrame> frame) {
    //void UseAppWindowCapturerMac::OnCaptureResult(DesktopCapturer::Result result, std::unique_ptr<DesktopFrame> frame) {
    NSLog(@"[UseAppWindowCapturerMac]: OnCaptureResult : %d", __LINE__);
    
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        static uint64_t startTime = getCPUTime();
        //static uint64_t durationTime = 0;
        
        //static uint64_t startCaptureTime = 0 ;
        //static uint64_t captureTime = 0;
        static uint64_t lastEndCaptureLoopTime = 0;
        static uint64_t lastCaptureLoopTime = 0;
        static int index = 0;

        lastCaptureLoopTime = clock();
        lastEndCaptureLoopTime = lastCaptureLoopTime;
        NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [%d] : lastCaptureLoopTime = %llu", index++, lastCaptureLoopTime - lastEndCaptureLoopTime);
        
        if (result != DesktopCapturer::Result::SUCCESS) {
            return; // Obviously never called
        }
        
        
        //scale the DesktopFrame.
        //        CopyIntersectingPixelsFrom(const DesktopFrame& src_frame,
        //                                    double horizontal_scale,
        //                                    double vertical_scale)
        
        //        int dstWidth = 1920;
        //        int dstHeight = 1080;
        
        int dstWidth = 1280;
        int dstHeight = 720;
        
        int width = frame->size().width();
        int height = frame->size().height();
        NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [width, height] : [%d, %d]", width, height);
        
        double horizontal_scale = (double)((double)dstHeight / (double)height);
        double vertical_scale = (double)((double)dstWidth / (double)width);
        
        NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [horizontal_scale, vertical_scale] : [%f, %f]", horizontal_scale, vertical_scale);
        
        DesktopSize dstSize = DesktopSize(dstWidth, dstHeight);
        std::unique_ptr<DesktopFrame> dstScaledFrame(new BasicDesktopFrame(dstSize));
        dstScaledFrame->CopyIntersectingPixelsFrom(*frame, horizontal_scale, vertical_scale);
        
        NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [Time]: CopyIntersectingPixelsFrom() time = %llu", getCPUTime() - startTime);
        
        width = dstWidth;
        height = dstHeight;
        
        // convert to I420
        //        int width = frame->size().width();
        //        int height = frame->size().height();
        int stride_y = width;
        int stride_uv = (width + 1) / 2;
        int target_width = width;
        int target_height = height;
        
        NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [width, height] : [%d, %d]", width, height);
        
        static rtc::scoped_refptr<I420Buffer> i420_buffer_ = nullptr;
        
        if (i420_buffer_ == nullptr) {
            i420_buffer_ = I420Buffer::Create(target_width, target_height, stride_y, stride_uv, stride_uv);
        } else if (!i420_buffer_.get() || i420_buffer_->width() * i420_buffer_->height() < width * height) {
            i420_buffer_ = I420Buffer::Create(target_width, target_height, stride_y, stride_uv, stride_uv);
        }
        
        startTime = getCPUTime();
        
        //[method-1]: ABGRToI420
        int ret = libyuv::ARGBToI420(dstScaledFrame->data(), dstScaledFrame->stride(),
                                     i420_buffer_.get()->MutableDataY(), i420_buffer_.get()->StrideY(),
                                     i420_buffer_.get()->MutableDataU(), i420_buffer_.get()->StrideU(),
                                     i420_buffer_.get()->MutableDataV(), i420_buffer_.get()->StrideV(),
                                     target_width, target_height);
        
        NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [Time]: ARGBToI420() time = %llu", getCPUTime() - startTime);
        if (ret != 0) {
            NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: libyuv::ARGBToI420 return failed!");
            return;
        }
        
        //        int stride = width;
        //        uint8_t* yplane = i420_buffer_->MutableDataY();
        //        uint8_t* uplane = i420_buffer_->MutableDataU();
        //        uint8_t* vplane = i420_buffer_->MutableDataV();
        //
        //        libyuv::ConvertToI420(frame->data(), 0,
        //                              i420_buffer_.get()->MutableDataY(), i420_buffer_.get()->StrideY(),
        //                              i420_buffer_.get()->MutableDataU(), i420_buffer_.get()->StrideU(),
        //                              i420_buffer_.get()->MutableDataV(), i420_buffer_.get()->StrideV(),
        //                              0, 0,
        //                              width, height,
        //                              width, height,
        //                              libyuv::kRotate0,
        //                              libyuv::FOURCC_ARGB);
        
        //        int width = frame->size().width();
        //        int height = frame->size().height();
        
        NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [width, height] : [%d, %d]", width, height);
        
        //    VideoFrame videoFrame = VideoFrame(i420_buffer_, 0, 0, kVideoRotation_0);
        //    this->OnFrame(videoFrame);
        
        //this->OnFrame(frame); //width, height
                
        startTime = getCPUTime();
        
        //get data from the YUV420 buffer.
        int nYUVBufsize = 0;
        int nVOffset = 0;
        int str_length = (width * height * 3) / 2;
        
        //TODO: -yingyong.Mao -2022-3-10
        //yuvByteBuffer_  = new char[str_length];
        uint8_t * yuvByteBuffer_ = (uint8 *)malloc(str_length);
        
        for (int i = 0; i < height; i++) {
            memcpy(yuvByteBuffer_ + nYUVBufsize, i420_buffer_->DataY() + i * i420_buffer_->StrideY(), width);
            nYUVBufsize += width;
        }
        
        for (int i = 0; i < height / 2; i++) {
            memcpy(yuvByteBuffer_ + nYUVBufsize, i420_buffer_->DataU() + i * i420_buffer_->StrideU(), width / 2);
            nYUVBufsize += width / 2;
            
            memcpy(yuvByteBuffer_ + width * height * 5 / 4 + nVOffset, i420_buffer_->DataV() + i * i420_buffer_->StrideV(), width / 2);
            nVOffset += width / 2;
        }
        
        NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [Time]: convert to yuvByteBuffer_ time = %llu", getCPUTime() - startTime);
        if (yuvByteBuffer_ != nullptr) {
            startTime = getCPUTime();
            
            //yuvWriteToFile(dstScaledFrame->data(), str_length, width, height, @"");
            unsigned int target_stride = frame->stride() / 4;
            this->OnFrameYUV420Buffer(yuvByteBuffer_, str_length, width, height, target_stride, Capture_VideoSampleType::SAMPLE_TYPE_I420, "1");
            
            NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [Time]: OnFrameYUV420Buffer to send stream time = %llu", getCPUTime() - startTime);
            NSLog(@"[UseAppWindowCapturerMac] : OnCaptureResult: i420 buffer src length: %d, width: %d, height: %d", str_length, width, height);
            NSLog(@"[UseAppWindowCapturerMac] : OnCaptureResult: yuvByteBuffer_ dst_length: %d, dstWidth: %d, dstHeight: %d", str_length, width, height);
        }
        
        //    this->OnCallBack(0,
        //                     str_length,
        //                     width,
        //                     height,
        //                     Capture_VideoSampleType::SAMPLE_TYPE_I420,
        //                     "1",
        //                     this);
    }
}

//DesktopCapturer::Callback interface.
void UseAppWindowCapturerMac::OnCaptureResult_old(DesktopCapturer::Result result,
                                                  std::unique_ptr<DesktopFrame> frame) {
    NSLog(@"[UseAppWindowCapturerMac]: OnCaptureResult : %d", __LINE__);
    
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        //static uint64_t startCaptureTime = 0 ;
        //static uint64_t captureTime = 0;
        static uint64_t lastEndCaptureLoopTime = 0;
        static uint64_t lastCaptureLoopTime = 0;
        
        static int index = 0;
        lastCaptureLoopTime = clock();
        lastEndCaptureLoopTime = lastCaptureLoopTime;
        NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [%d] : lastCaptureLoopTime = %llu", index++, lastCaptureLoopTime - lastEndCaptureLoopTime);
        
        if (result != DesktopCapturer::Result::SUCCESS) {
            return; // Obviously never called
        }
        
        //scale the DesktopFrame.
        /*
         //        CopyIntersectingPixelsFrom(const DesktopFrame& src_frame,
         //                                    double horizontal_scale,
         //                                    double vertical_scale)
         
         //        int dstWidth = 1920;
         //        int dstHeight = 1080;
         
         int dstWidth = 1280;
         int dstHeight = 720;
         
         int width = frame->size().width();
         int height = frame->size().height();
         NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [width, height] : [%d, %d]", width, height);
         
         double horizontal_scale = dstHeight / height;
         double vertical_scale = dstWidth / width;
         DesktopSize dstSize = DesktopSize(dstWidth, dstHeight);
         std::unique_ptr<DesktopFrame> dstScaledFrame(new BasicDesktopFrame(dstSize));
         dstScaledFrame->CopyIntersectingPixelsFrom(frame, horizontal_scale, vertical_scale);
         */
        
        
        //[convert] convert from RGB -> I420.
        //2022-3-9
        int width = frame->size().width();
        int height = frame->size().height();
        static rtc::scoped_refptr<I420Buffer> i420_buffer_;
        // int half_width = (width + 1) / 2;
        
        //TODO: yingyong.Mao -2022-3-5-
        //此处打开，UI项目会报错：
        //Showing Recent Messages
        //Undefined symbol: webrtc_mac_capturer::VideoFrameBuffer::CropAndScale(int, int, int, int, int, int)
        
        if (i420_buffer_ == NULL) {
            i420_buffer_ = I420Buffer::Create(width, height);
        } else if (!i420_buffer_.get() ||
                   i420_buffer_->width() * i420_buffer_->height() < width * height) {
            
            //rtc::scoped_refptr<I420Buffer> i420_buffer_;
            i420_buffer_ = I420Buffer::Create(width, height);
        }
        
        int stride = width;
        int str_length = (width * height * 3) / 2;
        
        uint8_t* yplane = i420_buffer_->MutableDataY();
        uint8_t* uplane = i420_buffer_->MutableDataU();
        uint8_t* vplane = i420_buffer_->MutableDataV();
        
        int result = libyuv::ConvertToI420(frame->data(),
                                           0, //str_length, //0,
                                           yplane, stride,
                                           uplane, (stride + 1) / 2,
                                           vplane, (stride + 1) / 2,
                                           0, 0,
                                           width, height,
                                           width, height,
                                           libyuv::kRotate0,
                                           libyuv::FOURCC_ARGB);
        
        //        int result = libyuv::ConvertToI420(frame->data(),
        //                                           0,
        //                                           i420_buffer_->MutableDataY(), i420_buffer_->StrideY(),
        //                                           i420_buffer_->MutableDataU(), i420_buffer_->StrideU(),
        //                                           i420_buffer_->MutableDataV(), i420_buffer_->StrideV(),
        //                                           0, 0,
        //                                           width, height,
        //                                           width, height,
        //                                           libyuv::kRotate0,
        //                                           libyuv::FOURCC_ARGB);
        
        if (result != 0) {
            NSLog(@"[]: ConvertToI420 failed");
            return;
        }
                
        NSLog(@"[UseAppWindowCapturerMac] : OnCaptureResult: i420 buffer src length: %d, width: %d, height: %d", str_length, width, height);
        NSLog(@"[UseAppWindowCapturerMac] : OnCaptureResult: yuvByteBuffer_ dst_length: %d, dstWidth: %d, dstHeight: %d", str_length, width, height);
        
        //get data from the YUV420 buffer.
        int nYUVBufsize = 0;
        int nVOffset = 0;
        
        //yuvByteBuffer_  = new char[str_length];
        uint8_t * yuvByteBuffer_ = (uint8 *)malloc(str_length);
        for (int i = 0; i < height; i++) {
            memcpy(yuvByteBuffer_ + nYUVBufsize, i420_buffer_->DataY() + i * i420_buffer_->StrideY(), width);
            nYUVBufsize += width;
        }
        
        for (int i = 0; i < height / 2; i++) {
            memcpy(yuvByteBuffer_ + nYUVBufsize, i420_buffer_->DataU() + i * i420_buffer_->StrideU(), width / 2);
            nYUVBufsize += width / 2;
            
            memcpy(yuvByteBuffer_ + width * height * 5 / 4 + nVOffset, i420_buffer_->DataV() + i * i420_buffer_->StrideV(), width / 2);
            nVOffset += width / 2;
        }
        
        //yuvWriteToFile(yuvByteBuffer_, str_length, width, height, @"");
        unsigned int target_stride = frame->stride() / 4;
        this->OnFrameYUV420Buffer(yuvByteBuffer_, str_length, width, height, target_stride, Capture_VideoSampleType::SAMPLE_TYPE_I420, "1");
        
        if (nullptr != yuvByteBuffer_) {
            free(yuvByteBuffer_);
            yuvByteBuffer_ = nullptr;
        }
        
        //2022-3-10
        /*
         
         int width = frame->size().width();
         int height = frame->size().height();
         NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [width, height] : [%d, %d]", width, height);
         
         int str_length = (width * height * 3) / 2;
         uint8_t * yuvByteBuffer_ = (uint8 *)malloc(str_length);
         
         
         uint8_t *srcYuvData = frame->data();
         uint8_t *dstYuvData = yuvByteBuffer_;
         int cropX = 0;
         int cropY = 0; // 以左上角为原点，裁剪起始点
         int cropWidth = width;
         int cropHeight = height;
         int srcWidth = width;
         int srcHeight = height;
         int dstWidth = width;
         int dstHeight = height;
         
         //        int result = ConvertToI420(srcYuvData,
         //                                   width*height*3/2,
         //                                   dstYuvData,
         //                                   cropWidth,
         //                                   dstYuvData + cropWidth * cropHeight,
         //                                   cropWidth / 2, //(cropWidth+1)/2,
         //                                   // dstYuvData + cropWidth * cropHeight + ((cropWidth + 1)/2) * ((cropHeight + 1)/2),
         //                                   dstYuvData + cropWidth * cropHeight + (cropWidth /2) * (cropHeight /2),
         //                                   cropWidth /2, //(cropWidth + 1)/2,
         //                                   cropX,
         //                                   cropY,
         //                                   width,
         //                                   height,
         //                                   cropWidth,
         //                                   cropHeight,
         //                                   libyuv::kRotate0,
         //                                   //libyuv::FOURCC_I420);
         //                                   libyuv::FOURCC_ARGB);
         
         int result = ConvertToI420(srcYuvData,
         width * height * 3/2,
         dstYuvData,
         cropWidth,
         dstYuvData + cropWidth * cropHeight,
         cropWidth / 2, //(cropWidth+1)/2,
         //                                           dstYuvData + cropWidth * cropHeight + ((cropWidth + 1)/2) * ((cropHeight + 1)/2),
         dstYuvData + cropWidth * cropHeight + (cropWidth /2) * (cropHeight /2),
         cropWidth /2, //(cropWidth + 1)/2,
         cropX, cropY,
         srcWidth, srcHeight,
         cropWidth, cropHeight,
         libyuv::kRotate0,
         //libyuv::FOURCC_I420);
         libyuv::FOURCC_ARGB);
         
         */
        
        
        /*
         // 2022-3-10-
         // build error
         
         
         int str_length = (width * height * 3) / 2;
         uint8_t * yuvByteBuffer_ = (uint8 *)malloc(str_length);
         
         uint8_t *srcYuvData = frame->data();
         uint8_t *dstYuvData = yuvByteBuffer_;
         
         int width = frame->size().width();
         int height = frame->size().height();
         
         if (!srcYuvData.get() ||
         srcYuvData->width() * i420_buffer_->height() < width * height) {
         srcYuvData = I420Buffer::Create(width, height);
         }
         int result = libyuv::ConvertToI420(frame->data(),
         0,                     srcYuvData->MutableDataY(),
         srcYuvData->StrideY(), srcYuvData->MutableDataU(),
         srcYuvData->StrideU(), srcYuvData->MutableDataV(),
         srcYuvData->StrideV(),
         0, 0,
         width, height,
         width, height,
         libyuv::kRotate0,
         libyuv::FOURCC_ARGB);
         */
        
        
        /*
         if (result != 0) {
         NSLog(@"[]: ConvertToI420 failed");
         return;
         }
         
         //yuvWriteToFile(yuvByteBuffer_, str_length, width, height, @"");
         this->OnFrameYUV420Buffer(yuvByteBuffer_, str_length, width, height, Capture_VideoSampleType::SAMPLE_TYPE_I420, "1");
         */
        
        //    VideoFrame videoFrame = VideoFrame(i420_buffer_, 0, 0, kVideoRotation_0);
        //    this->OnFrame(videoFrame);
        
        //this->OnFrame(frame); //, width, height
        
        /*
         
         //get data from the YUV420 buffer.
         int nYUVBufsize = 0;
         int nVOffset = 0;
         
         //yuvByteBuffer_  = new char[str_length];
         uint8_t * yuvByteBuffer_ = (uint8 *)malloc(str_length);
         
         
         for (int i = 0; i < height; i++) {
         memcpy(yuvByteBuffer_ + nYUVBufsize, i420_buffer_->DataY() + i * i420_buffer_->StrideY(), width);
         nYUVBufsize += width;
         }
         
         for (int i = 0; i < height / 2; i++) {
         
         memcpy(yuvByteBuffer_ + nYUVBufsize, i420_buffer_->DataU() + i * i420_buffer_->StrideU(), width / 2);
         nYUVBufsize += width / 2;
         
         memcpy(yuvByteBuffer_ + width * height * 5 / 4 + nVOffset, i420_buffer_->DataV() + i * i420_buffer_->StrideV(), width / 2);
         nVOffset += width / 2;
         }
         
         
         yuvWriteToFile(yuvByteBuffer_, str_length, width, height, @"");
         this->OnFrameYUV420Buffer(yuvByteBuffer_, str_length, width, height, Capture_VideoSampleType::SAMPLE_TYPE_I420, "1");
         */
        
        
        /*
         // UI convert to YUV
         //     ConvertRGBA2YUV(width, height, (uint8_t *)buffer, (uint8_t *)buf->getData());
         
         int str_length = (width * height * 3) / 2;
         
         yuvWriteToFile(frame->data(), str_length, width, height, @"");
         
         this->OnFrameYUV420Buffer(frame->data(), str_length, width, height, Capture_VideoSampleType::SAMPLE_TYPE_I420, "1");
         */
        
        
        /*
         
         //[scale-2]: I420: scale from src size -> des size (from capblility).
         
         //        int dstHeight = 1080;
         //        int dstWidth = 1920;
         int dstHeight = 720;
         int dstWidth = 1280;
         
         int dst_length = (dstWidth * dstHeight * 3) * 2;
         //yuvByteBuffer_scaled_dst_  = (uint8_t *)malloc(dst_length);
         uint8 *yuvByteBuffer_scaled_dst_ = (uint8 *)malloc(dst_length);
         
         //        i420Scale((uint8_t *)yuvByteBuffer_,
         //                  (uint8_t *)yuvByteBuffer_scaled_dst_,
         //                  width, height,
         //                  dstWidth, dstHeight);
         
         int psrc_w = width;
         int psrc_h = height;
         int pdst_w = dstWidth;
         int pdst_h = dstHeight;
         
         // I420_1920x1080 -> I420_1280x720
         libyuv::I420Scale(&yuvByteBuffer_[0],                          psrc_w,
         &yuvByteBuffer_[psrc_w * psrc_h],            psrc_w >> 1,
         &yuvByteBuffer_[(psrc_w * psrc_h * 5) >> 2], psrc_w >> 1,
         psrc_w, psrc_h,
         &yuvByteBuffer_scaled_dst_[0],                          pdst_w,
         &yuvByteBuffer_scaled_dst_[pdst_w * pdst_h],            pdst_w >> 1,
         &yuvByteBuffer_scaled_dst_[(pdst_w * pdst_h * 5) >> 2], pdst_w >> 1,
         pdst_w, pdst_h,
         kFilterNone);
         
         if (nullptr != yuvByteBuffer_) {
         free(yuvByteBuffer_);
         yuvByteBuffer_ = nullptr;
         }
         
         NSLog(@"[UseAppWindowCapturerMac] : OnCaptureResult: i420 buffer src length: %d, width: %d, height: %d", str_length, width, height);
         NSLog(@"[UseAppWindowCapturerMac] : OnCaptureResult: yuvByteBuffer_ dst_length: %d, dstWidth: %d, dstHeight: %d", dst_length, dstWidth, dstHeight);
         
         this->OnFrameYUV420Buffer((uint8_t *)yuvByteBuffer_scaled_dst_,
         dst_length, dstWidth, dstHeight,
         Capture_VideoSampleType::SAMPLE_TYPE_I420,
         "1");
         
         */
        
        
        /*
         //[scale -1]: I420: scale from src size -> des size (from capblility).
         
         //        int dstHeight = 1080;
         //        int dstWidth = 1920;
         
         int dstHeight = 720;
         int dstWidth = 1280;
         
         static rtc::scoped_refptr<I420Buffer> i420_buffer_scaled_dest_;
         
         if (i420_buffer_scaled_dest_ == NULL) {
         i420_buffer_scaled_dest_ = I420Buffer::Create(dstWidth, dstHeight);
         } else if (!i420_buffer_scaled_dest_.get() ||
         i420_buffer_scaled_dest_->width() * i420_buffer_scaled_dest_->height() < dstWidth * dstHeight) {
         
         i420_buffer_scaled_dest_ = I420Buffer::Create(dstWidth, dstHeight);
         }
         
         //void i420Scale(uint8_t *srcYuvData, uint8_t *dstYuvData, int width, int height, int dstWidth, int dstHeight) {
         uint8_t *srcYuvData = yplane;
         uint8_t *dstYuvData = i420_buffer_scaled_dest_->MutableDataY();
         int srcWidth = width;
         int srcHeight = height;
         
         //after scale.
         int dst_length = (dstWidth * dstHeight * 3) / 2;
         
         //get data from the YUV420 buffer.
         int nYUVBufsize = 0;
         int nVOffset = 0;
         
         i420Scale(srcYuvData, dstYuvData, srcWidth, srcHeight, dstWidth, dstHeight);
         
         
         NSLog(@"[UseAppWindowCapturerMac] : OnCaptureResult: i420 buffer src length: %d, width: %d, height: %d", str_length, width, height);
         NSLog(@"[UseAppWindowCapturerMac] : OnCaptureResult: yuvByteBuffer_ dst_length: %d, dstWidth: %d, dstHeight: %d", dst_length, dstWidth, dstHeight);
         
         //TODO: -yingyong.Mao -2022-3-4
         yuvByteBuffer_  = new char[dst_length];
         
         for (int i = 0; i < dstHeight; i++) {
         memcpy(yuvByteBuffer_ + nYUVBufsize, i420_buffer_scaled_dest_->DataY() + i * i420_buffer_scaled_dest_->StrideY(), dstWidth);
         nYUVBufsize += dstWidth;
         }
         
         for (int i = 0; i < dstHeight / 2; i++) {
         
         memcpy(yuvByteBuffer_ + nYUVBufsize, i420_buffer_scaled_dest_->DataU() + i * i420_buffer_scaled_dest_->StrideU(), dstWidth / 2);
         nYUVBufsize += dstWidth / 2;
         
         memcpy(yuvByteBuffer_ + dstWidth * dstHeight * 5 / 4 + nVOffset, i420_buffer_scaled_dest_->DataV() + i * i420_buffer_scaled_dest_->StrideV(), dstWidth / 2);
         nVOffset += dstWidth / 2;
         }
         
         this->OnFrameYUV420Buffer(yuvByteBuffer_, dst_length, dstWidth, dstHeight, Capture_VideoSampleType::SAMPLE_TYPE_I420, "1");
         */
                
        //    this->OnCallBack(0,
        //                     str_length,
        //                     width,
        //                     height,
        //                     Capture_VideoSampleType::SAMPLE_TYPE_I420,
        //                     "1",
        //                     this);
    }
}

void UseAppWindowCapturerMac::OnFrame(const VideoFrame& video_frame) {
    
}

//void UseAppWindowCapturerMac::OnCallBack(void *buffer,
//                                         int length,
//                                         int width,
//                                         int height,
//                                         Capture_VideoSampleType type,
//                                         std::string sourceID,
//                                         UseAppWindowCapturerMac * thisObj) {
//    
//    NSLog(@"[UseAppWindowCapturerMac]: [OnCallBack]");
//    
//    
//    thisObj->contentOutputCB(0,
//                             length,
//                             width,
//                             height,
//                             Capture_VideoSampleType::SAMPLE_TYPE_I420,
//                             "1");
//}

void UseAppWindowCapturerMac::getByteFromI42Buffer(int width, int height) {
    //    int nYUVBufsize = 0;
    //    int nVOffset = 0;
    //    size_t str_length = (width * height * 3) / 2;
    //
    //    //TODO: -yingyong.Mao -2022-3-4
    //    yuvByteBuffer_  = new char[str_length];
    //
    //    for (int i = 0; i < height; i++) {
    //        memcpy(yuvByteBuffer_ + nYUVBufsize, i420_buffer_->DataY() + i * i420_buffer_->StrideY(), width);
    //        nYUVBufsize += width;
    //    }
    //
    //    for (int i = 0; i < height / 2; i++) {
    //
    //        memcpy(yuvByteBuffer_ + nYUVBufsize, i420_buffer_->DataU() + i * i420_buffer_->StrideU(), width / 2);
    //        nYUVBufsize += width / 2;
    //
    //        memcpy(yuvByteBuffer_ + width * height * 5 / 4 + nVOffset, i420_buffer_->DataV() + i * i420_buffer_->StrideV(), width / 2);
    //        nVOffset += width / 2;
    //    }
}

/*
 void UseAppWindowCapturerMac::createCaptureAppContentTimerThread() {
 
 if (start_flag_) {
 RTC_LOG(WARNING) << "Capture already been running...";
 return;
 }
 start_flag_ = true;
 
 DesktopCaptureOptions options = DesktopCaptureOptions::CreateDefault();
 appWindowCapture_ = new WindowCapturerMac(options.full_screen_window_detector(),
 options.configuration_monitor());
 
 webrtc_mac_capturer::DesktopCapturer::SourceList appWindowSourceList;
 appWindowCapture_->GetSourceList(&appWindowSourceList);
 //winCapture->SelectSource(appWindowSourceList->front().id);
 
 for (int i = 0; i < appWindowSourceList.size(); ++i) {
 std::string title = (appWindowSourceList[i].title);
 NSLog(@"appWindowSourceList[i].title : %s", title.c_str() );
 
 //TODO: -yingyong.Mao -2022-3-21
 if (title == "QQ影音") {
 NSLog(@"SelectSource: appWindowSourceList[i].id : %s", title.c_str() );
 NSLog(@"appWindowSourceList[i].id : %s", title.c_str() );
 
 appWindowCapture_->SelectSource(appWindowSourceList[i].id);
 break;
 }
 }
 
 appWindowCapture_->FocusOnSelectedSource();
 appWindowCapture_->Start(this);
 
 __block UseAppWindowCapturerMac* _weak_self = this;
 
 static int plus = 0;
 _weak_self->_captureAppContentTimer = nil;
 
 dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
 
 _weak_self->_captureAppContentTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
 NSTimeInterval timeIntervalInMicroSecond = 1000 / _weak_self->fps_;
 
 NSLog(@"[Thread Running] capture: [adaptor->captureAppContent]: intervalInMS = %f", timeIntervalInMicroSecond);
 
 //    NSLog(@"[Thread Running] capture: [adaptor->captureAppContent]: adaptor->_capability.framerate = %d", _weak_self->_capability.framerate);
 NSLog(@"[Thread Running] capture: [adaptor->captureAppContent]: adaptor->_capability.framerate = %zu", _weak_self->fps_);
 
 NSTimeInterval delayTime = 1.0f;
 //dispatch_time_t startDelayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * 0));
 dispatch_source_set_timer(_captureAppContentTimer, dispatch_walltime(NULL, 0), timeIntervalInMicroSecond * NSEC_PER_MSEC, 0 * NSEC_PER_SEC);
 dispatch_source_set_event_handler(_captureAppContentTimer, ^{
 NSLog(@"[createCaptureAppContentTimerThread]: plus = %d", plus++);
 
 
 //TODO: -test -ymao -2022-1-18 -for minimize sharing app window
 //===begin========================================================
 //        if (_weak_self->_device->isAllWindowMinmized) {
 //            NSLog(@"[Thread Running] capture:  isAllWindowMinmized() ");
 //
 //            return;
 //        }
 
 //===end========================================================
 
 NSLog(@"[Thread Running] capture:  call captureAppContent() ");
 
 static uint64_t startCaptureTime = 0 ;
 static uint64_t captureTime = 0;
 static uint64_t lastEndCaptureLoopTime = 0;
 static uint64_t lastCaptureLoopTime = 0;
 
 lastCaptureLoopTime = getCPUTime() - lastEndCaptureLoopTime;
 NSLog(@"[Thread Running] capture: [adaptor->captureAppContent]: [Time]: lastCaptureLoopTime = %llu", lastCaptureLoopTime);
 
 startCaptureTime = getCPUTime();
 if (NULL != _weak_self) {
 _weak_self->appWindowCapture_->CaptureFrame();
 }
 captureTime = getCPUTime() - startCaptureTime;
 NSLog(@"[Thread Running] capture: [adaptor->captureAppContent]: [Time]: captureContentTime = %llu", captureTime);
 
 lastEndCaptureLoopTime = getCPUTime();
 
 });
 dispatch_resume(_weak_self->_captureAppContentTimer);
 }
 */


////DesktopCapturer::Callback interface.
//void UseAppWindowCapturerMac::OnCaptureResult(DesktopCapturer::Result result,
//                                              std::unique_ptr<DesktopFrame> frame) {
//
//    NSLog(@"[UseAppWindowCapturerMac]: OnCaptureResult : %d", __LINE__);
//
//    @autoreleasepool {
//        // Setup code that might create autoreleased objects goes here.
//
//
//        static uint64_t startCaptureTime = 0 ;
//        static uint64_t captureTime = 0;
//        static uint64_t lastEndCaptureLoopTime = 0;
//        static uint64_t lastCaptureLoopTime = 0;
//        static int index = 0;
//        lastCaptureLoopTime = clock();
//        lastEndCaptureLoopTime = lastCaptureLoopTime;
//        NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [%d] : lastCaptureLoopTime = %llu", index++, lastCaptureLoopTime - lastEndCaptureLoopTime);
//
//
//
//        if (result != DesktopCapturer::Result::SUCCESS) {
//            return; // Obviously never called
//        }
//
//        int width = frame->size().width();
//        int height = frame->size().height();
//
//        NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: [width, height] : [%d, %d]", width, height);
//        static rtc::scoped_refptr<I420Buffer> i420_buffer_;
//        // int half_width = (width + 1) / 2;
//
//        //TODO: yingyong.Mao -2022-3-5-
//        //此处打开，UI项目会报错：
//        //Showing Recent Messages
//        //Undefined symbol: webrtc_mac_capturer::VideoFrameBuffer::CropAndScale(int, int, int, int, int, int)
//
//        if (i420_buffer_ == NULL) {
//            i420_buffer_ = I420Buffer::Create(width, height);
//        } else if (!i420_buffer_.get() || i420_buffer_->width() * i420_buffer_->height() < width * height) {
//            //rtc::scoped_refptr<I420Buffer> i420_buffer_;
//            i420_buffer_ = I420Buffer::Create(width, height);
//        }
//
//
//        int stride = width;
//        uint8_t* yplane = i420_buffer_->MutableDataY();
//        uint8_t* uplane = i420_buffer_->MutableDataU();
//        uint8_t* vplane = i420_buffer_->MutableDataV();
//        libyuv::ConvertToI420(frame->data(), 0,
//                              yplane, stride,
//                              uplane, (stride + 1) / 2,
//                              vplane, (stride + 1) / 2,
//                              0, 0,
//                              width, height,
//                              width, height,
//                              libyuv::kRotate0,
//                              libyuv::FOURCC_ARGB);
//
//        //    VideoFrame videoFrame = VideoFrame(i420_buffer_, 0, 0, kVideoRotation_0);
//        //    this->OnFrame(videoFrame);
//
//        //this->OnFrame(frame);
//
//
//        //get data from the YUV420 buffer.
//        int nYUVBufsize = 0;
//        int nVOffset = 0;
//        int str_length = (width * height * 3) / 2;
//
//        //TODO: -yingyong.Mao -2022-3-10
//        //yuvByteBuffer_  = new char[str_length];
//        uint8_t * yuvByteBuffer_ = (uint8 *)malloc(str_length);
//        for (int i = 0; i < height; i++) {
//            memcpy(yuvByteBuffer_ + nYUVBufsize, i420_buffer_->DataY() + i * i420_buffer_->StrideY(), width);
//            nYUVBufsize += width;
//        }
//
//        for (int i = 0; i < height / 2; i++) {
//            memcpy(yuvByteBuffer_ + nYUVBufsize, i420_buffer_->DataU() + i * i420_buffer_->StrideU(), width / 2);
//            nYUVBufsize += width / 2;
//
//            memcpy(yuvByteBuffer_ + width * height * 5 / 4 + nVOffset, i420_buffer_->DataV() + i * i420_buffer_->StrideV(), width / 2);
//            nVOffset += width / 2;
//        }
//
//        yuvWriteToFile(frame->data(), str_length, width, height, @"");
//        this->OnFrameYUV420Buffer(yuvByteBuffer_, str_length, width, height, Capture_VideoSampleType::SAMPLE_TYPE_I420, "1");
//
//        NSLog(@"[UseAppWindowCapturerMac] : OnCaptureResult: i420 buffer src length: %d, width: %d, height: %d", str_length, width, height);
//        NSLog(@"[UseAppWindowCapturerMac] : OnCaptureResult: yuvByteBuffer_ dst_length: %d, dstWidth: %d, dstHeight: %d", str_length, width, height);
//
//
//        //    this->OnCallBack(0,
//        //                     str_length,
//        //                     width,
//        //                     height,
//        //                     Capture_VideoSampleType::SAMPLE_TYPE_I420,
//        //                     "1",
//        //                     this);
//    }
//}
