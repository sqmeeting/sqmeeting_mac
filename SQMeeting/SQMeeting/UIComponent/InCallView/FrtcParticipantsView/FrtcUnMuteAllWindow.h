#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FrtcUnMuteAllWindowDelegate <NSObject>

-(void)unMuteAll;

@end

@interface FrtcUnMuteAllWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size;

@property (nonatomic, weak) id<FrtcUnMuteAllWindowDelegate> unMuteAllDelegate;

@end

NS_ASSUME_NONNULL_END
