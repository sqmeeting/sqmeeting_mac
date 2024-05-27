#import <Cocoa/Cocoa.h>
#import "MediaDetailModel.h"
#import "StaticsTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface StaticsTableViewCell : NSTableCellView

@property (nonatomic, strong) StaticsTextField *participantLabel;

@property (nonatomic, strong) StaticsTextField *channelLabel;

@property (nonatomic, strong) StaticsTextField *protocolLabel;

@property (nonatomic, strong) StaticsTextField *formatLabel;

@property (nonatomic, strong) StaticsTextField *rateLabel;

@property (nonatomic, strong) StaticsTextField *rateUsedLabel;

@property (nonatomic, strong) StaticsTextField *packetLostLable;

@property (nonatomic, strong) StaticsTextField *jitterLabel;

@property (nonatomic, strong) StaticsTextField *errorConcealmentLable;

@property (nonatomic, strong) StaticsTextField *encryptedLabel;

- (void)updateCellInfomation:(MediaDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
