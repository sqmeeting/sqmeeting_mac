#import <Cocoa/Cocoa.h>
#import "HoverImageView.h"
#import "DeleteHoverImageView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcDeleteUserListViewCellDelegate <NSObject>

- (void)deleteUserWithCellRow:(NSInteger)row;

@end

@interface FrtcDeleteUserListViewCell : NSTableCellView

@property (nonatomic, strong) DeleteHoverImageView *selectImageView;

@property (nonatomic, strong) NSImageView *headerImageView;

@property (nonatomic, strong) NSTextField *userNameTextField;

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, strong) NSView *whiteView;

@property (nonatomic, weak) id<FrtcDeleteUserListViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
