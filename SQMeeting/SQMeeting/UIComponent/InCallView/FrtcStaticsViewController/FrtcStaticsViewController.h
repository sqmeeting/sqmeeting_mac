#import <Cocoa/Cocoa.h>
#import "FrtcStatisticalModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FrtcStaticsViewController : NSViewController

@property (nonatomic, strong) NSTextField *titleTextField;

@property (nonatomic, strong) NSView *line1;

@property (nonatomic, strong) NSTextField *conferenceNumberLabel;
@property (nonatomic, strong) NSTextField *conferenceNumberTextField;
@property (nonatomic, strong) NSTextField *callRateLabel;
@property (nonatomic, strong) NSTextField *callRateTextField;

@property (nonatomic, strong) NSView *line2;

@property (nonatomic, strong) NSTextField *participantLabel;
@property (nonatomic, strong) NSTextField *mediaLabel;
@property (nonatomic, strong) NSTextField *formatLabel;
@property (nonatomic, strong) NSTextField *actualRateLabel;
@property (nonatomic, strong) NSTextField *frameRateLabel;
@property (nonatomic, strong) NSTextField *packetLossLabel;
@property (nonatomic, strong) NSTextField *jitterBufferLabel;

- (void)handleStaticsEvent:(FrtcStatisticalModel *)staticsModel;
@property (nonatomic, strong) FrtcStatisticalModel *staticsModel;
@property (nonatomic, copy) NSString *conferenceName;
@property (nonatomic, copy) NSString *conferenceAlias;

@end

NS_ASSUME_NONNULL_END
