#import "FrtcSDKBundle.h"

@implementation FrtcSDKBundle

+ (NSBundle *)bundle {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"frtc_sdk_bundle" ofType:@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    return resourceBundle;
}
 
+ (NSString *)bundlePath:(NSString *)path {
    NSBundle *myBundle = [FrtcSDKBundle bundle];
     
    if (myBundle && path) {
        return [[myBundle resourcePath] stringByAppendingPathComponent: path];
    }
     
    return nil;
}

@end
