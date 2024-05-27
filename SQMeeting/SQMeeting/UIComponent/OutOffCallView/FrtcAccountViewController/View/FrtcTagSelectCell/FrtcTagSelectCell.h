#import <Cocoa/Cocoa.h>
#import "FrtcTabControlSelectMode.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FrtcTagSelectTag) {
    FrtcSelectSheduleTag = 0,
    FrtcSelectCallHistoryTag
};

@class FrtcTagSelectCell;
@protocol FrtcTagSelectCellDelegate <NSObject>

- (void)didSelectedCell:(FrtcTagSelectCell *)cell;

@end

@interface FrtcTagSelectCell : NSControl

@property (nonatomic, weak) id <FrtcTagSelectCellDelegate> delegate;

- (FrtcTagSelectCell *)initWithTabControlModel:(FrtcTabControlSelectMode *)tabControl;

- (void)selected;

- (void)disSelected;

@property (nonatomic, strong) NSTextField *titleView;

@end

NS_ASSUME_NONNULL_END
