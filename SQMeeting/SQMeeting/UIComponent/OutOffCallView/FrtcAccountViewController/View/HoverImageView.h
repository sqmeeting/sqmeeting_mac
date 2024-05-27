#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HoverImageViewDelegate <NSObject>

@optional
- (void)didIntoArea:(BOOL)isInImageViewArea withSenderTag:(NSInteger)tag;

@optional
- (void)hoverImageViewClickedwithSenderTag:(NSInteger)tag;

@end

@interface HoverImageView : NSImageView

@property (nonatomic, weak) id<HoverImageViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
