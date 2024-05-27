#import <Cocoa/Cocoa.h>
#import "FrtcTabControlModel.h"

NS_ASSUME_NONNULL_BEGIN

@class FrtcTabCell;
@protocol FrtcTabCellDelegate <NSObject>

- (void)didSelectedCell:(FrtcTabCell *)cell;

@end

@interface FrtcTabCell : NSControl

- (void)selected;

- (void)disSelected;

@property (nonatomic, strong) NSImageView* imageView;

@property (nonatomic, strong) NSTextField* titleView;

@property (nonatomic, strong) NSColor* effectBackgroundColor;

@property (nonatomic, weak) id <FrtcTabCellDelegate> delegate;

- (FrtcTabCell *)initWithTabControlModel:(FrtcTabControlModel *)tabControl;

@end

NS_ASSUME_NONNULL_END
