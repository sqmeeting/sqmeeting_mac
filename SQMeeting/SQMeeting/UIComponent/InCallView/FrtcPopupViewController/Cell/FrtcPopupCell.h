#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PopupCellType) {
    PopupSection = 0,
    PopupDescription = 1,
};

@protocol FrtcPopupCellDelegate <NSObject>

- (void)hoverSelectedWithSection:(NSInteger)section wihtRow:(NSInteger)row;

@end

@interface FrtcPopupCell : NSControl

@property (nonatomic, strong) NSImageView *imageView;

@property (nonatomic, strong) NSTextField *titleView;

@property (nonatomic, strong) NSColor *effectBackgroundColor;

@property (nonatomic, assign) PopupCellType type;

@property (nonatomic, assign, getter=isHover) BOOL hover;

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, weak) id<FrtcPopupCellDelegate> cellDelegate;

- (FrtcPopupCell *)initPopupCellWithFrame:(CGRect)frame withCellType:(PopupCellType)type;

- (void)selected;

- (void)disSelected;

@end

NS_ASSUME_NONNULL_END
