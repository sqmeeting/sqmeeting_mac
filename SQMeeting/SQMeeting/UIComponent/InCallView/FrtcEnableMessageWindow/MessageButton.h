#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MessageButtonType) {
    MessageButtonUp = 201,
    MessageButtonDown
};

@protocol MessageButtonDelegate <NSObject>

- (void)messageButtonClicked:(MessageButtonType)type;

@end

@interface MessageButton : NSView

@property (nonatomic, strong) NSImageView *imageView;

@property (nonatomic, assign) MessageButtonType buttonType;

@property (nonatomic, weak) id<MessageButtonDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
