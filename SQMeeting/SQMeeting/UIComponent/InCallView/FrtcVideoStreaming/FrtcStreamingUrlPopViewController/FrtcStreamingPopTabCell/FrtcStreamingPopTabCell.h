#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcStreamingPopTabCellDelegate <NSObject>

- (void)popupShareStreamingUrlWindow;

@end

@interface FrtcStreamingPopTabCell : NSControl

@property (nonatomic, strong) NSImageView *imageView;

@property (nonatomic, strong) NSTextField *titleView;

@property (nonatomic, strong) NSColor *effectBackgroundColor;

@property (nonatomic, weak) id<FrtcStreamingPopTabCellDelegate> delegate;

- (FrtcStreamingPopTabCell *)initStreamingPopCell;

- (void)selected;

- (void)disSelected;

@end

NS_ASSUME_NONNULL_END
