#import <Cocoa/Cocoa.h>
#import <JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MediaDetailModel;
@interface MediaDetailModel : JSONModel

@property (nonatomic, copy)   NSString *mediaType;
@property (nonatomic, copy)   NSString *participantName;
@property (nonatomic, copy)   NSString *resolution;
@property (nonatomic, strong) NSNumber *csrc;
@property (nonatomic, strong) NSNumber *frameRate;
@property (nonatomic, strong) NSNumber *jitter;
@property (nonatomic, strong) NSNumber *logicPacketLoss;
@property (nonatomic, strong) NSNumber *logicPacketLossRate;
@property (nonatomic, strong) NSNumber *packageLoss;
@property (nonatomic, strong) NSNumber *packageLossRate;
@property (nonatomic, strong) NSNumber *packageTotal;
@property (nonatomic, strong) NSNumber *roundTripTime;
@property (nonatomic, strong) NSNumber *rtpActualBitRate;
@property (nonatomic, strong) NSNumber *rtpLogicBitRate;
@property (nonatomic, strong) NSNumber *ssrc;
@property (nonatomic, assign, getter = isIsAlive)   BOOL isAlive;

@end

NS_ASSUME_NONNULL_END
