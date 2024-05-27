#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN


@protocol FrtcLocalReminderTitleBarViewDelegate <NSObject>

- (void)closeButtonOnTitleBarClicked:(id)sender ;

@end

@interface FrtcLocalReminderTitleBarView : NSView

@property (nonatomic, weak) id<FrtcLocalReminderTitleBarViewDelegate> delegate;
@property (nonatomic, assign) int nReminderCount;

- (void)setTitleString:(NSString *)text;
- (void)setFont:(NSFont *)font;

- (NSDictionary *)getAttributeds;

@end

NS_ASSUME_NONNULL_END
