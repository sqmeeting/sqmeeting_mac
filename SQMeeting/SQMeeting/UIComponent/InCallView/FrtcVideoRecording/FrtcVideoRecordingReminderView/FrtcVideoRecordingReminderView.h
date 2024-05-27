#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TipsReminderViewType) {
    TipsReminderViewRecording = 201,
    TipsReminderViewStreaming
};

@interface FrtcVideoRecordingReminderView : NSView

@property (nonatomic, strong) NSImageView *imageView;

@property (nonatomic, strong) NSTextField *title;

@end

NS_ASSUME_NONNULL_END
