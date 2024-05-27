#import <Cocoa/Cocoa.h>
#import "HoverImageView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol FrtcInviteUserListViewCellDelegate <NSObject>

- (void)selectedUser:(BOOL)selected withCellRow:(NSInteger)row;

@end

@interface FrtcInviteUserListViewCell : NSTableCellView

@property (nonatomic, strong) HoverImageView *selectImageView;

@property (nonatomic, strong) NSImageView *headerImageView;

@property (nonatomic, strong) NSTextField *userNameTextField;

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, weak) id<FrtcInviteUserListViewCellDelegate> delegate;

- (void)haveSelected;

- (void)haveUnSelected;

@end

NS_ASSUME_NONNULL_END
