#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, EnableMessageGroundViewType) {
    EnableMessageGroundViewTop = 0,
    EnableMessageGroundViewMiddle,
    EnableMessageGroundViewBottom
};

@protocol EnableMessageGroundViewTypeDelegate <NSObject>

- (void)EnableMessageGroundViewClicked:(EnableMessageGroundViewType)type;

@end

@interface FrtcEnableMessageBackgroundView : NSView

@property (nonatomic, strong) NSImageView *imageView;

@property (nonatomic, strong) NSImageView *selectedTagImageView;

@property (nonatomic, strong) NSTextField *titleTextField;

@property (nonatomic, assign) EnableMessageGroundViewType type;

@property (nonatomic, weak) id<EnableMessageGroundViewTypeDelegate> delegate;

- (void)updateBKColor:(BOOL)flag;

- (void)messageBackgroundViewSelected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
