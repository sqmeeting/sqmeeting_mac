#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcVideoRecordingSuccessViewDelegate <NSObject>

- (void)closeByUser;

@end

@interface FrtcVideoRecordingSuccessView : NSView

@property (nonatomic, weak) id<FrtcVideoRecordingSuccessViewDelegate> closeDelegate;

@end

NS_ASSUME_NONNULL_END
