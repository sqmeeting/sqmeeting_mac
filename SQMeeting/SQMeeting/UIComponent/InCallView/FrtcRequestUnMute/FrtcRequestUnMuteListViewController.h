#import <Cocoa/Cocoa.h>
#import "FrtcInCallModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcRequestUnMuteListViewControllerDelegate <NSObject>

- (void)agreeOneUserWithUUID:(NSString *)uuid;

- (void)agreeAll;

@end

@interface FrtcRequestUnMuteListViewController : NSViewController

@property (nonatomic, strong) FrtcInCallModel *inCallModel;

@property (nonatomic, copy) NSMutableDictionary *dictionary;

@property (nonatomic, weak) id<FrtcRequestUnMuteListViewControllerDelegate> delegate;

- (void)updateDictionary:(NSMutableDictionary *)dictionary;

- (void)popRequestUnmuteView:(NSMutableDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
