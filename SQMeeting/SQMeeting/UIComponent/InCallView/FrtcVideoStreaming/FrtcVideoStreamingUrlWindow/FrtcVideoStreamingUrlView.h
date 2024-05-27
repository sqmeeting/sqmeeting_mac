#import <Cocoa/Cocoa.h>
#import "FrtcHyperlinkLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FrtcVideoStreamingUrlView : NSView

@property (nonatomic, strong) NSTextField *titleTextField;

@property (nonatomic, strong) NSTextField *meetingUrlTextFieldTips;

@property (nonatomic, strong) NSTextField *meetingUrlTextField;

@property (nonatomic, strong) FrtcHyperlinkLabel   *urlTextField;

@property (nonatomic, strong) NSTextField *streamingPasswordTips;

@property (nonatomic, strong) NSTextField *streamingPasswordDescription;


@end

NS_ASSUME_NONNULL_END
