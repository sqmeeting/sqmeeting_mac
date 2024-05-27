#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrtcTimeViewControllerCell : NSTableCellView

@property (nonatomic, strong) NSTextField *userNameTextField;

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, assign, getter=isCanSelected) BOOL canSelected;

@end

NS_ASSUME_NONNULL_END
