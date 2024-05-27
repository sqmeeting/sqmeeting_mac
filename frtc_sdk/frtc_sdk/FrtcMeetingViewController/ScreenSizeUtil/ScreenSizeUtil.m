#import "ScreenSizeUtil.h"
#import <Cocoa/Cocoa.h>

@implementation ScreenSizeUtil

+ (ScreenSizeUtil *)sharedSizeUtil {
    static ScreenSizeUtil *_sharedUtil = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedUtil = [[ScreenSizeUtil alloc] init];
    });
    
    return _sharedUtil;
}

- (NSSize)screenSize:(NSScreen *)screen {
    NSSize screenSize;
    
    NSScreen *mainScreen = [NSScreen mainScreen];
    
    for(NSScreen * screen in [NSScreen screens]) {
        if([screen isEqualTo:screen]) {
            mainScreen = screen;
            break;
        }
    }
    
    NSDictionary *description = [mainScreen deviceDescription];
    screenSize = [[description objectForKey:NSDeviceSize] sizeValue];
    
    return screenSize;
}

- (NSSize)currentScreenSize:(NSScreen *)screen {
    NSSize displayPixelSize = [self screenSize:screen];

    if(displayPixelSize.height >= 1200) {
        return NSMakeSize(1536, 1037);
    } else if(displayPixelSize.height >= 1000 && displayPixelSize.height < 1200) {
        return NSMakeSize(1280, 864);
    } else if(displayPixelSize.height >= 800 && displayPixelSize.height < 1000) {
        return NSMakeSize(1024, 691);
    } else {
        return NSMakeSize(819, 551);
    }
}

- (CGFloat)screenRation:(NSScreen *)screen {
    NSSize displayPixelSize = [self screenSize:screen];

    if(displayPixelSize.height >= 1200) {
        return 1.2;
    } else if(displayPixelSize.height >= 1000 && displayPixelSize.height < 1200) {
        return 1.0;
    } else if(displayPixelSize.height >= 800 && displayPixelSize.height < 1000) {
        return 0.8;
    } else {
        return 0.64;
    }
}

- (CGFloat)disPlayWidth:(NSScreen *)screen {
    return [self currentScreenSize:screen].width;
}

- (CGFloat)disPlayHeight:(NSScreen *)screen {
    return [self currentScreenSize:screen].height;
}


@end
