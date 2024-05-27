#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FrtcModifyCancelTypeWindowDelegate <NSObject>

- (void)modifyMeetingWithRecurrence:(BOOL)isRecurrence withReversionID:(NSString *)reversionID withRow:(NSInteger)row;

@end

@interface FrtcModifyCancelTypeWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size;

- (void)showWindow;

- (void)adjustToSize:(NSSize)size;

- (void)showWindowWithWindow:(NSWindow *)window;

@property (nonatomic, weak) id<FrtcModifyCancelTypeWindowDelegate> modifyDelegate;

@property (nonatomic, copy) NSString *reversionID;

@property (nonatomic, assign) NSInteger row;

@end

NS_ASSUME_NONNULL_END
