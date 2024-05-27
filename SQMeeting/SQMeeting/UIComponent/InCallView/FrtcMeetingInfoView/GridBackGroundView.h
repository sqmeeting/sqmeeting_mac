#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GridBackGroundViewType) {
    GridBackGroundViewGallery = 0,
    GridBackGroundViewPresenter
};

@protocol GridBackGroundViewDelegate <NSObject>

- (void)gridBackGroundViewClicked:(GridBackGroundViewType)type;

@end

@interface GridBackGroundView : NSView

@property (nonatomic, strong) NSImageView *imageView;

@property (nonatomic, strong) NSTextField *titleTextField;

@property (nonatomic, assign) GridBackGroundViewType type;

@property (nonatomic, weak) id<GridBackGroundViewDelegate> delegate;

- (void)updateBKColor:(BOOL)flag;

@end

NS_ASSUME_NONNULL_END
