#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScreenSizeUtil : NSObject

+ (ScreenSizeUtil *)sharedSizeUtil;

- (NSSize)screenSize:(NSScreen *)screen;

- (NSSize)currentScreenSize:(NSScreen *)screen;

- (CGFloat)screenRation:(NSScreen *)screen;

- (CGFloat)disPlayWidth:(NSScreen *)screen;

- (CGFloat)disPlayHeight:(NSScreen *)screen;

@end

NS_ASSUME_NONNULL_END
