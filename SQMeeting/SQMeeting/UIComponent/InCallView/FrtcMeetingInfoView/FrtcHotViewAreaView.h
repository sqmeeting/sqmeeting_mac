#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcHotViewAreaViewDelegate <NSObject>

- (void)didIntoArea;

@end

@interface FrtcHotViewAreaView : NSView

@property (nonatomic, weak) id<FrtcHotViewAreaViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
