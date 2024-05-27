#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DeleteHoverImageViewDelegate <NSObject>

@optional
- (void)deltetDidIntoArea:(BOOL)isInImageViewArea withSenderTag:(NSInteger)tag;

- (void)deltetHoverImageViewClickedwithSenderTag:(NSInteger)tag;

@end

@interface DeleteHoverImageView : NSImageView

@property (nonatomic, weak) id<DeleteHoverImageViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
