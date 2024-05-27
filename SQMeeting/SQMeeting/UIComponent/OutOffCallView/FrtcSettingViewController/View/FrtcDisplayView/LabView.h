#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LabViewDelegate <NSObject>

- (void)enableLabFeature:(BOOL)enableLabFeature;

@end

@interface LabView : NSView

@property (nonatomic, weak) id<LabViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
