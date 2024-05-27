#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionView : NSView

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) NSCollectionViewItemHighlightState highlightState;

@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *titleFontName;
@property (nonatomic, assign) CGFloat   titleFontSize;
@property (nonatomic, assign) NSTextAlignment titleTextAlignment;

@property (nonatomic, strong) NSColor *btnBgColorEnableSelected;
@property (nonatomic, strong) NSColor *btnBgColorEnableUnSelected;
@property (nonatomic, strong) NSColor *titleColorEnableSelected;
@property (nonatomic, strong) NSColor *titleColorEnableUnSelected;

@property (nonatomic, strong) NSColor *currentTitleColor;
@property (nonatomic, strong) NSColor *currentBtnBgColor;
@property (nonatomic, strong) NSColor *currentBorderColor;
@property (nonatomic, assign) CGFloat  currentBorderWidth;


@end

NS_ASSUME_NONNULL_END
