#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcRecurrenceDetailViewControllerCellDelegate <NSObject>

- (void)popUpFunctionControllerWithFrame:(NSRect)frame withRow:(NSInteger)row;

@end

@interface FrtcRecurrenceDetailViewControllerCell : NSTableCellView

@property (nonatomic, strong) NSTextField *timeTextField;
@property (nonatomic, strong) NSTextField *weekTextField;
@property (nonatomic, strong) NSTextField *hourTextField;
@property (nonatomic, strong) NSTextField *wordTextField;
@property (nonatomic, strong) NSTextField *willBeginTextField;

@property (nonatomic, assign) NSInteger cellTag;

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, assign, getter=isInvite) BOOL invite;

@property (nonatomic, assign, getter=isAddMeeting) BOOL addMeeting;

@property (nonatomic, weak) id<FrtcRecurrenceDetailViewControllerCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
