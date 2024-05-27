#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewItem : NSCollectionViewItem

@property (nonatomic, assign) BOOL  isSelectTypeBtn;
@property (nonatomic, assign) BOOL  isSelected;
@property (nonatomic, assign) BOOL  preSelected;

@property (nonatomic, strong) NSColor *btnBgColorEnableSelected;
@property (nonatomic, strong) NSColor *btnBgColorEnableUnSelected;

@property (nonatomic, strong) NSColor *btnBorderColorEnableSelected;
@property (nonatomic, strong) NSColor *btnBorderColorEnableUnSelected;

@property (nonatomic, strong) NSColor *titleColorEnableSelected;
@property (nonatomic, strong) NSColor *titleColorEnableUnSelected;

@property (nonatomic, assign) NSRect  imageRect;
@property (nonatomic, assign) NSRect  titleRect;

@property (nonatomic, strong) NSImage *currentImage;
@property (nonatomic, strong) NSColor *currentTitleColor;

@property (nonatomic, strong) NSColor *currentBtnBgColor;
@property (nonatomic, strong) NSColor *currentBorderColor;
@property (nonatomic, assign) CGFloat  currentBorderWidth;

//0: Desktop Display Content.
//1: App Content.
@property (nonatomic, assign) unsigned int contentType;
@property (nonatomic, strong) id appListModelObject;
@property (nonatomic, strong) id desktopListModel;

@end

NS_ASSUME_NONNULL_END
