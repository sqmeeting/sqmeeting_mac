#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EditImageViewDelegate <NSObject>

- (void)popupModifyMeetingUserNameWindow;

@end

@interface EditImageView : NSImageView

@property (nonatomic ,weak) id<EditImageViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
