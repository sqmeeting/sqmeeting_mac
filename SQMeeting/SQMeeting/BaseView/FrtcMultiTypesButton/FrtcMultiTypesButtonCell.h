#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PMButtonCellDeletegate <NSObject>
- (void)highlitCallBack:(BOOL)flag;
@end

@interface FrtcMultiTypesButtonCell : NSButtonCell
@property (weak, nonatomic) id<PMButtonCellDeletegate> delegate;
@end

NS_ASSUME_NONNULL_END
