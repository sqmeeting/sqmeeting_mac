#import <Foundation/Foundation.h>

@interface NSTimer (Enhancement)

+ (NSTimer *)plua_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void(^)(void))block repeats:(BOOL)repeats;

@end
