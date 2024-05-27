#import <Cocoa/Cocoa.h>
#import "FrtcMultiTypesButton.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcHistoryCallTableViewCellDelegate <NSObject>

- (void)removeCallHistoryAtRow:(NSInteger)row;

- (void)joinMeetingAtRow:(NSInteger)row;

@end

@interface FrtcHistoryCallTableViewCell : NSTableCellView

@property (nonatomic, strong) NSTextField   *numberLabel;
@property (nonatomic, strong) NSTextField   *numberTextField;
@property (nonatomic, strong) NSTextField   *meetingNameTextField;
@property (nonatomic, strong) NSTextField   *timeTextField;
@property (nonatomic, strong) FrtcMultiTypesButton      *joinMeetingButton;

@property (nonatomic, assign) NSInteger     row;
@property (nonatomic, weak)   id<FrtcHistoryCallTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
