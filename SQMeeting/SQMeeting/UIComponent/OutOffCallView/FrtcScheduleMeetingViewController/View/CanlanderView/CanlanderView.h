#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CalanderViewDelegate <NSObject>

- (void)popupCalanderViewWithInterger:(NSInteger)tag;

@end

@interface CanlanderView : NSView

@property (nonatomic, strong) NSTextField    *timeTextField;

@property (nonatomic, weak) id<CalanderViewDelegate> calanlerViewDelegate;

@property (nonatomic, assign) NSInteger viewTag;

@end

NS_ASSUME_NONNULL_END
