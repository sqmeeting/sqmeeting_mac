//
//  DisplayBorderWindow.h
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface DisplayBorderWindow : NSWindow

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)windowStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)deferCreation;

@end

NS_ASSUME_NONNULL_END
