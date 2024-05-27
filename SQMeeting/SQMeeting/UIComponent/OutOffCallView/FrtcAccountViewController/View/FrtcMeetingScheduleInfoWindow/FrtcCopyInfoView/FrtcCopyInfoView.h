#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcCopyInfoViewDelegate <NSObject>

- (void)copyInfo;

@end

@interface FrtcCopyInfoView : NSView

@property (nonatomic, weak) id<FrtcCopyInfoViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
