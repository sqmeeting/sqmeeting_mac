#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcDatePickerViewControllerDelegate <NSObject>

- (void)selectTime:(NSString *)time withTag:(NSInteger)tag;

@end

@interface FrtcDatePickerViewController : NSViewController

@property (nonatomic, strong) NSDatePicker *datePicker;

@property (nonatomic, weak) id<FrtcDatePickerViewControllerDelegate> delegate;

@property (nonatomic, assign) NSInteger viewControllerTag;

@end

NS_ASSUME_NONNULL_END
