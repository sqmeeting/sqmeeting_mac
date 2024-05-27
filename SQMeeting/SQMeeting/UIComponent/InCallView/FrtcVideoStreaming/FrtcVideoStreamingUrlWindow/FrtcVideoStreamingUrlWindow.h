#import <Cocoa/Cocoa.h>
#import "FrtcMeetingStreamingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FrtcVideoStreamingUrlWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size;

@property (nonatomic, strong) FrtcMeetingStreamingModel *streamingUrlModel;

- (void)setupStreamingUrlInfo:(FrtcMeetingStreamingModel *)model;

@end

NS_ASSUME_NONNULL_END
