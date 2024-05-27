#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcRequestUnMuteViewDelegate <NSObject>

- (void)ignoreRequest;

- (void)viewRequest;

@end

@interface FrtcRequestUnMuteView : NSView

- (void)updateRequestName:(NSString *)name;

@property (nonatomic, weak) id<FrtcRequestUnMuteViewDelegate> requestUnMuteDelegate;

@end

NS_ASSUME_NONNULL_END
