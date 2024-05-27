#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrtcMediaStaticsModel : NSObject

@property (nonatomic, assign) int rttTime;

@property (nonatomic, assign) int upRate;
@property (nonatomic, assign) int downRate;

@property (nonatomic, assign) int audioUpRate;
@property (nonatomic, assign) int audioUpPackLost;

@property (nonatomic, assign) int audioDownRate;
@property (nonatomic, assign) int audioDownPackLost;

@property (nonatomic, assign) int videoUpRate;
@property (nonatomic, assign) int videoUpPackLost;

@property (nonatomic, assign) int videoDownRate;
@property (nonatomic, assign) int videoDownPackLost;

@property (nonatomic, assign) int contentUpRate;
@property (nonatomic, assign) int contentUpPackLost;

@property (nonatomic, assign) int contentdownRate;
@property (nonatomic, assign) int contentdownPackLost;

@property (nonatomic, copy) NSNumber *callRate;



@end

NS_ASSUME_NONNULL_END
