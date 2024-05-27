#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcButtonCellDeletegate <NSObject>
- (void)highlitCallBack:(BOOL)flag;
@end

@interface FrtcButtonCell : NSButtonCell

@property (weak, nonatomic) id<FrtcButtonCellDeletegate> delegate;

@end

NS_ASSUME_NONNULL_END
