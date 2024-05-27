#import <Cocoa/Cocoa.h>
#import "UserListModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FrtcUserListDisplayTag) {
    FrtcUserListWillDisplayTag = 0,
    FrtcUserListHadDisplayTag
};

@protocol FrtcInviteUserListViewControllerDelegate <NSObject>

- (void)selectUsers:(NSMutableArray<NSDictionary *> *)usersList;

@end

@interface FrtcInviteUserListViewController : NSViewController

@property (nonatomic, strong) UserListModel * allUserListModel;

@property (nonatomic, assign) FrtcUserListDisplayTag disPlayTag;

@property (nonatomic, weak) id<FrtcInviteUserListViewControllerDelegate> delegate;

- (void)updateSelectUserInfo:(NSArray *)userList;

@end

NS_ASSUME_NONNULL_END
