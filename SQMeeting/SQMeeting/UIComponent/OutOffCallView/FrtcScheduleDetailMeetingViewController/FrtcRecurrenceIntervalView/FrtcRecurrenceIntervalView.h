#import <Cocoa/Cocoa.h>
#import "HoverImageView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol FrtcRecurrenceIntervalViewDelegate <NSObject>

- (void)popupScheduleRecurrencView;

@end

@interface FrtcRecurrenceIntervalView : NSView

@property (nonatomic, strong) NSTextField *titleTextField;

@property (nonatomic, strong) HoverImageView *arrayImageView;

@property (nonatomic, weak) id<FrtcRecurrenceIntervalViewDelegate> internalViewDelegate;

@end

NS_ASSUME_NONNULL_END
