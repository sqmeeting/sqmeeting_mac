#import <Cocoa/Cocoa.h>
#import "FrtcInCallModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FrtcMeetingDetailInfoWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size;

- (void)setupMeetingInfo:(FrtcInCallModel *)model;

@end

NS_ASSUME_NONNULL_END
