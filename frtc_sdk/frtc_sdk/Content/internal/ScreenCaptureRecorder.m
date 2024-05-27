#import "ScreenCaptureRecorder.h"
#import "ContentAudioBridge.h"

#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 130000
int ReSample32bitTo16(char* in, char* out, int nInputLen) {
    int count = nInputLen / 4;

    for (int i = 0; i < count; i++) {
        float tmp = ((float*)in)[i];
        short reout;
        if (tmp < -0.999999f) {
            reout = -32766;
        }
        else if (tmp >= 0.999999f) {
            reout = 32767;
        }
        else
            reout = (short)(tmp * (32767.0f));

        ((short*)out)[i] = reout;
    }
    return nInputLen / 2;
}

@implementation SCContentInfo

@end

@interface ScreenCaptureRecorder()

@property (nonatomic, strong) NSArray<SCWindow *> *shareableWindows;

@property (nonatomic, assign) CGDirectDisplayID pMonitorID;

@end

@implementation ScreenCaptureRecorder

+ (ScreenCaptureRecorder *)getInstance {
    static ScreenCaptureRecorder *kSingleInstance = nil;
    static dispatch_once_t once_taken = 0;
    dispatch_once(&once_taken, ^{
        kSingleInstance = [[ScreenCaptureRecorder alloc] init];
    });
    
    return kSingleInstance;
}

- (void)selectDisplayWithMonitorID:(CGDirectDisplayID)pMonitorID {
    self.pMonitorID = pMonitorID;
}

- (void)selectCGWindowID:(CGWindowID)windowID {
    
}

- (void)startCaptureDisplayWithEnableContentAudio:(BOOL)enableContentAudio {
    [SCShareableContent getShareableContentExcludingDesktopWindows:YES
                                               onScreenWindowsOnly:NO
                                                 completionHandler:^(SCShareableContent *shareableContent, NSError *error) {
        
      if (error) {
        NSLog(@"getShareableContentExcludingDesktopWindows error: %@", error);
      } else {
          SCDisplay *captureDisplay;
          NSArray<SCDisplay *> *displays = [shareableContent displays];
          for (SCDisplay *display in displays) {
              if(display.displayID == self.pMonitorID) {
                  captureDisplay = display;
                  break;;
              }
          }
   
          SCRunningApplication *testApp;
          NSString *mainBundleIndntifier  = [[NSBundle mainBundle] bundleIdentifier];
          for (SCRunningApplication *app in shareableContent.applications) {
              if ([app.bundleIdentifier isEqualToString:mainBundleIndntifier]) {
                  testApp = app;
                  break;
              }
          }
          
          NSArray *exclusions = [[NSArray alloc] initWithObjects:testApp, nil];
                        
          NSArray *emptyArray = [[NSArray alloc] init];
          SCContentFilter *filter = [[SCContentFilter alloc] initWithDisplay:captureDisplay
                                                       excludingApplications:exclusions
                                                            exceptingWindows:emptyArray];
          
        // prepare scstream config
          SCStreamConfiguration *conf = [[SCStreamConfiguration alloc] init];
          
//          [conf setWidth:captureDisplay.width * 2];
//          [conf setHeight:captureDisplay.height * 2];
          
          [conf setWidth:4096];
          [conf setHeight:2304];
          [conf setScalesToFit:YES];
          [conf setDestinationRect:CGRectMake(0, 0, captureDisplay.width * 2, captureDisplay.height * 2)];
          
          [conf setDestinationRect:CGRectMake(0, 0, 4096, 2304)];
          [conf setShowsCursor:YES];
          [conf setQueueDepth:8];
          [conf setColorSpaceName:kCGColorSpaceDisplayP3];//kCGColorSpaceGenericRGB  kCGColorSpaceSRGB
          //[conf setColorSpaceName:kCGColorSpaceSRGB];
          //[conf setColorSpaceName:kCGColorSpaceGenericRGB];
          [conf setPixelFormat:'BGRA'];
          
          if (@available(macOS 13.0, *)) {
              conf.capturesAudio = enableContentAudio;
              conf.channelCount = 1;
          } else {
              // Fallback on earlier versions
          }

          // prepare stream
          self.scstream = [[SCStream alloc] initWithFilter:filter configuration:conf delegate:nil];
        
          // set output
          NSError *err;
          [self.scstream addStreamOutput:self type:SCStreamOutputTypeScreen sampleHandlerQueue:nil error: &err];
          if (@available(macOS 13.0, *)) {
              if(enableContentAudio) {
                  [self.scstream addStreamOutput:self type:SCStreamOutputTypeAudio sampleHandlerQueue:nil error: &err];
              }
          }
          // start stream
          [self.scstream startCaptureWithCompletionHandler:^(NSError *_Nullable error) {
          if(error) {
              NSLog(@"err: %@", error);
          }
        }];
      }
    }];
}

- (void)start {
  [SCShareableContent getShareableContentExcludingDesktopWindows:YES
                                             onScreenWindowsOnly:NO
                                               completionHandler:^(SCShareableContent *shareableContent, NSError *error) {
      
    if (error) {
      NSLog(@"getShareableContentExcludingDesktopWindows error: %@", error);
    } else {
      // prepare display
        NSArray<SCDisplay *> *displays = [shareableContent displays];
        for (SCDisplay *display in displays) {
            NSLog(@"display id: %d", display.displayID);
        }

        SCDisplay *display = displays[0];
        SCWindow *target_window = nil;
                    
        for (SCWindow *window in shareableContent.windows) {
            if (window.windowID == 56) {
                target_window = window;
                break;
            }
        }
        SCContentFilter *filter = [[SCContentFilter alloc] initWithDesktopIndependentWindow:target_window];

        NSAssert(filter, @"filter should not be null");
        
        [self getWindowList:shareableContent];
        
       // [self getApplicationList:shareableContent];
      
      // prepare scstream config
        SCStreamConfiguration *conf = [[SCStreamConfiguration alloc] init];
        
        [conf setWidth:display.width * 2];
        [conf setHeight:display.height * 2];
        [conf setScalesToFit:YES];
        [conf setDestinationRect:CGRectMake(0, 0, display.width * 2, display.height * 2)];
        [conf setShowsCursor:YES];
        [conf setQueueDepth:8];
        //[conf setColorSpaceName:kCGColorSpaceDisplayP3];//kCGColorSpaceGenericRGB  kCGColorSpaceSRGB
        [conf setColorSpaceName:kCGColorSpaceSRGB];
        //[conf setColorSpaceName:kCGColorSpaceGenericRGB];
        [conf setPixelFormat:'BGRA'];
        
        if (@available(macOS 13.0, *)) {
//            conf.capturesAudio = YES;
//            conf.channelCount = 1;
        } else {
            // Fallback on earlier versions
        }
      
        // prepare stream
        self.scstream = [[SCStream alloc] initWithFilter:filter configuration:conf delegate:nil];
      
        // set output
        NSError *err;
        [self.scstream addStreamOutput:self type:SCStreamOutputTypeScreen sampleHandlerQueue:nil error: &err];
        if (@available(macOS 13.0, *)) {
//            [self.scstream addStreamOutput:self type:SCStreamOutputTypeAudio sampleHandlerQueue:nil error: &err];
        } else {
            // Fallback on earlier versions
        }
        // start stream
        [self.scstream startCaptureWithCompletionHandler:^(NSError *_Nullable error) {
        if(error) {
            NSLog(@"err: %@", error);
        }
      }];
    }
  }];
}

- (void)startAppContentAudio:(uint32_t)appWindowID {
    [SCShareableContent getShareableContentExcludingDesktopWindows:YES
                                               onScreenWindowsOnly:NO
                                                 completionHandler:^(SCShareableContent *shareableContent, NSError *error) {
        
      if (error) {
        NSLog(@"getShareableContentExcludingDesktopWindows error: %@", error);
      } else {
        // prepare display
         
          SCWindow *target_window = nil;
                      
          for (SCWindow *window in shareableContent.windows) {
              if (window.windowID == appWindowID) {
                  target_window = window;
                  break;
              }
          }
          SCContentFilter *filter = [[SCContentFilter alloc] initWithDesktopIndependentWindow:target_window];


          NSAssert(filter, @"filter should not be null");
          
          
          [self getWindowList:shareableContent];
    
          SCStreamConfiguration *conf = [[SCStreamConfiguration alloc] init];
          
          
          if (@available(macOS 13.0, *)) {
              conf.capturesAudio = YES;
              conf.channelCount = 1;
          }
          conf.excludesCurrentProcessAudio = YES;

        
          // prepare stream
          self.scstream = [[SCStream alloc] initWithFilter:filter configuration:conf delegate:nil];
        
          // set output
          NSError *err;
          [self.scstream addStreamOutput:self type:SCStreamOutputTypeAudio sampleHandlerQueue:nil error: &err];

          [self.scstream startCaptureWithCompletionHandler:^(NSError *_Nullable error) {
          if(error) {
              NSLog(@"err: %@", error);
          }
        }];
      }
    }];
}

- (void)startShareAppWithWindowID:(CGWindowID)windowID withEnableContentAudio:(BOOL)enableContentAudio {
    SCWindow *targetWindow;
    for(SCWindow *window in self.shareableWindows) {
        if(window.windowID == windowID) {
            targetWindow = window;
            
            break;
        }
    }
    SCContentFilter *filter = [[SCContentFilter alloc] initWithDesktopIndependentWindow:targetWindow];

    SCStreamConfiguration *conf = [[SCStreamConfiguration alloc] init];
    
//    [conf setWidth:display.width * 2];
//    [conf setHeight:display.height * 2];
    [conf setScalesToFit:YES];
    //[conf setDestinationRect:CGRectMake(0, 0, display.width * 2, display.height * 2)];
    [conf setShowsCursor:YES];
    [conf setQueueDepth:8];
    [conf setColorSpaceName:kCGColorSpaceDisplayP3];//kCGColorSpaceGenericRGB  kCGColorSpaceSRGB
    //[conf setColorSpaceName:kCGColorSpaceSRGB];
    //[conf setColorSpaceName:kCGColorSpaceGenericRGB];
    [conf setPixelFormat:'BGRA'];
    
    if (@available(macOS 13.0, *)) {
        conf.capturesAudio = enableContentAudio;
        conf.channelCount = 1;
    }
  
    // prepare stream
    self.scstream = [[SCStream alloc] initWithFilter:filter configuration:conf delegate:nil];
  
    // set output
    NSError *err;
    [self.scstream addStreamOutput:self type:SCStreamOutputTypeScreen sampleHandlerQueue:nil error: &err];
    [self.scstream addStreamOutput:self type:SCStreamOutputTypeAudio sampleHandlerQueue:nil error: &err];
//    if (@available(macOS 13.0, *)) {
//        [self.scstream addStreamOutput:self type:SCStreamOutputTypeAudio sampleHandlerQueue:nil error: &err];
//    } else {
//        // Fallback on earlier versions
//    }
    // start stream
    [self.scstream startCaptureWithCompletionHandler:^(NSError *_Nullable error) {
    if(error) {
        NSLog(@"err: %@", error);
    }
  }];
}

- (void)stop {
    [self.scstream stopCaptureWithCompletionHandler:^(NSError *_Nullable error) {
        if (error && error.code != SCStreamErrorAttemptToStopStreamState) {
            NSLog(@"destroy_audio_screen_stream: Failed to stop stream with error %s\n",
                       [[error localizedFailureReason] cStringUsingEncoding:NSUTF8StringEncoding]);
        }
    }];
}

- (void)getWindowList:(SCShareableContent *)shareableContent {
    NSPredicate *filteredWindowPredicate =
            [NSPredicate predicateWithBlock:^BOOL(SCWindow *window, NSDictionary *bindings __unused) {
                NSString *mainBundleIndntifier  = [[NSBundle mainBundle] bundleIdentifier];
                NSString *app_name = window.owningApplication.applicationName;
                NSString *title = window.title;
                return (app_name.length > 0) && (title.length > 0) && [window isOnScreen] && (window.frame.origin.y > 24
                        &&(![window.owningApplication.bundleIdentifier isEqualToString:mainBundleIndntifier]) );
                
            }];
    
    NSArray<SCWindow *> *filteredWindows;
    filteredWindows = [shareableContent.windows filteredArrayUsingPredicate:filteredWindowPredicate];

    NSArray<SCWindow *> *sortedWindows;
    sortedWindows = [filteredWindows sortedArrayUsingComparator:^NSComparisonResult(SCWindow *window, SCWindow *other) {
        NSComparisonResult appNameCmp = [window.owningApplication.applicationName
            compare:other.owningApplication.applicationName
            options:NSCaseInsensitiveSearch];
        if (appNameCmp == NSOrderedAscending) {
            return NSOrderedAscending;
        } else if (appNameCmp == NSOrderedSame) {
            return [window.title compare:other.title options:NSCaseInsensitiveSearch];
        } else {
            return NSOrderedDescending;
        }
    }];

    for (SCWindow *window in sortedWindows) {
        NSString *app_name = window.owningApplication.applicationName;
        NSString *title = window.title;
        CGRect frame = window.frame;
        NSLog(@"The app_name is %@, the title is %@, and the window ID is %d, and %f, and %f, and the frame is %@", app_name, title, window.windowID, frame.size.width, frame.size.height, NSStringFromRect(window.frame));
    }
}

- (NSArray *)getshareableApplicationList {
    NSLog(@"--------getshareableApplicationList----------");
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSArray<SCWindow *> *sortedWindows;
    
    [SCShareableContent getShareableContentExcludingDesktopWindows:YES
                                               onScreenWindowsOnly:NO
                                                 completionHandler:^(SCShareableContent *shareableContent, NSError *error) {
        
      if (error) {
        NSLog(@"getShareableContentExcludingDesktopWindows error: %@", error);
      } else {
          NSPredicate *filteredWindowPredicate =
                  [NSPredicate predicateWithBlock:^BOOL(SCWindow *window, NSDictionary *bindings __unused) {
                      NSString *mainBundleIndntifier  = [[NSBundle mainBundle] bundleIdentifier];
                      NSString *app_name = window.owningApplication.applicationName;
                      NSString *title = window.title;
                      return (app_name.length > 0) && (title.length > 0) && [window isOnScreen] && (window.frame.origin.y > 24) &&    (![window.owningApplication.bundleIdentifier isEqualToString:mainBundleIndntifier]);
                      
                  }];
          
          NSArray<SCWindow *> *filteredWindows;
          filteredWindows = [shareableContent.windows filteredArrayUsingPredicate:filteredWindowPredicate];

          sortedWindows = [filteredWindows sortedArrayUsingComparator:^NSComparisonResult(SCWindow *window, SCWindow *other) {
              NSComparisonResult appNameCmp = [window.owningApplication.applicationName
                  compare:other.owningApplication.applicationName
                  options:NSCaseInsensitiveSearch];
              if (appNameCmp == NSOrderedAscending) {
                  return NSOrderedAscending;
              } else if (appNameCmp == NSOrderedSame) {
                  return [window.title compare:other.title options:NSCaseInsensitiveSearch];
              } else {
                  return NSOrderedDescending;
              }
          }];

          for (SCWindow *window in sortedWindows) {
              NSString *app_name = window.owningApplication.applicationName;
              NSString *title = window.title;
              CGRect frame = window.frame;
              NSLog(@"The app_name is %@, the title is %@, and the window ID is %d, and %f, and %f, and the frame is %@", app_name, title, window.windowID, frame.size.width, frame.size.height, NSStringFromRect(window.frame));
          }
          
          self.shareableWindows = sortedWindows;
      }
        
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return sortedWindows;
}

- (void)getApplicationList:(SCShareableContent *)sharebleContent {
    NSArray<SCRunningApplication *> *filteredApplications;
        filteredApplications = [sharebleContent.applications
            filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SCRunningApplication *app,
                                                                              NSDictionary *bindings __unused) {
                return app.applicationName.length > 0;
            }]];

    NSArray<SCRunningApplication *> *sortedApplications;
    sortedApplications = [filteredApplications
        sortedArrayUsingComparator:^NSComparisonResult(SCRunningApplication *app, SCRunningApplication *other) {
            return [app.applicationName compare:other.applicationName options:NSCaseInsensitiveSearch];
        }];

    for (SCRunningApplication *application in sortedApplications) {
//        const char *name = [application.applicationName UTF8String];
//        const char *bundle_id = [application.bundleIdentifier UTF8String];
        
        NSLog(@"The name is %@, and the bundle_id is %@", application.applicationName, application.bundleIdentifier);
        //obs_property_list_add_string(application_list, name, bundle_id);
    }
}

- (void)screen_stream_audio_update:(CMSampleBufferRef)sample_buffer {
    CMFormatDescriptionRef format_description = CMSampleBufferGetFormatDescription(sample_buffer);
       
    const AudioStreamBasicDescription *audio_description =
        CMAudioFormatDescriptionGetStreamBasicDescription(format_description);

    if (audio_description->mChannelsPerFrame < 1) {
       NSLog(@"screen_stream_audio_update: Received sample buffer has less than 1 channel per frame (mChannelsPerFrame set to '%d')\n",
            audio_description->mChannelsPerFrame);
        return;
    }

    char *_Nullable bytes = NULL;
    CMBlockBufferRef data_buffer = CMSampleBufferGetDataBuffer(sample_buffer);
    size_t data_buffer_length = CMBlockBufferGetDataLength(data_buffer);
    CMBlockBufferGetDataPointer(data_buffer, 0, &data_buffer_length, NULL, &bytes);

    NSLog(@"The data_buffer_length is %ld", data_buffer_length);
    NSLog(@"The mBitsPerChannel is %d", audio_description->mBitsPerChannel);
    NSLog(@"The mBytesPerPacket is %d", audio_description->mBytesPerPacket);
    NSLog(@"The mBytesPerFrame is %d", audio_description->mBytesPerFrame);
    NSLog(@"The mChannelsPerFrame is %d", audio_description->mChannelsPerFrame);
    NSLog(@"frames is %d",(uint32_t) (data_buffer_length / audio_description->mBytesPerFrame /audio_description->mChannelsPerFrame));
    NSLog(@"speakers is %d", audio_description->mChannelsPerFrame);
    NSLog(@"samples_per_sec is %u", (uint32_t) audio_description->mSampleRate);
    
    char siTemp[1920] = {0};
    
    int a = ReSample32bitTo16(bytes, siTemp, 3840);
    
    NSLog(@"---------The a is %d----------", a);
    
    [[ContentAudioBridge getInstance] sendAudioDataContent:siTemp length:1920 sampleRate:48000];
}

- (void)stream:(SCStream *)stream didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer ofType:(SCStreamOutputType)type {
    
    if(type == SCStreamOutputTypeAudio) {
        [self screen_stream_audio_update:sampleBuffer];
    }
  
  CVImageBufferRef imgBufferRef = CMSampleBufferGetImageBuffer(sampleBuffer);
   //NSLog(@"===buffer===\n%@===image buffer===\n%@", sampleBuffer, imgBufferRef);
  if (imgBufferRef) {
    CVPixelBufferLockBaseAddress(imgBufferRef,0);
    
    //uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imgBufferRef);
      uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(imgBufferRef, 0);
      //CVPixelBufferGetBaseAddressOfPlane
    //size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imgBufferRef);
    
    size_t width = CVPixelBufferGetWidth(imgBufferRef);
    size_t height = CVPixelBufferGetHeight(imgBufferRef);

   // [self dumpVideoBuffer:baseAddress withWidth:width withHeight:height];
     // NSLog(@"The width is %zu, the height is %zu", width, height);
    if([self.delegate respondsToSelector:@selector(screenCaptureOutBuffer:width:height:)]) {
        [self.delegate screenCaptureOutBuffer:baseAddress width:width height:height ];
    }
      
    CVPixelBufferUnlockBaseAddress(imgBufferRef,0);
    
   // NSLog(@"bytesPerRow: %ld, width: %ld, height: %ld", width, height);
  }
}

- (void)startShareAppWithEnableContentAudio:(BOOL)enableContentAudio {
}

@end

#endif
