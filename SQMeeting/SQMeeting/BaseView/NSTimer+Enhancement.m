#import "NSTimer+Enhancement.h"

@implementation NSTimer (Enhancement)

+ (NSTimer *)plua_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)(void))block repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(plua_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)plua_blockInvoke:(NSTimer *)timer {
    void (^block)(void) = timer.userInfo;
    if(block) {
        block();
    }
}

@end
