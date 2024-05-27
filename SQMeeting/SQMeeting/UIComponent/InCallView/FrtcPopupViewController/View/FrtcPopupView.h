#import <Cocoa/Cocoa.h>
#import "FrtcPopupCell.h"

NS_ASSUME_NONNULL_BEGIN
@protocol FrtcPopupViewDelegate <NSObject>

- (NSInteger)popupViewSectionCount;

- (NSInteger)popupViewItemCountWithSection:(NSInteger)section;

- (FrtcPopupCell *)frtcPopupViewWithSection:(NSInteger)section withRow:(NSInteger)row;

- (void)shouldDidSelectedPopCell:(NSInteger)section withRow:(NSInteger)row;

@end

@interface FrtcPopupView : NSView

- (instancetype)initWithSection:(NSInteger)section withMediaType:(NSInteger)type;

@property (nonatomic, weak) id<FrtcPopupViewDelegate> popViewdelegate;

- (void)reloadPopViewData;

@end

NS_ASSUME_NONNULL_END
