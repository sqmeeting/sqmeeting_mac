#import "JSONModel.h"
#import "MediaStatisticsModel.h"
#import "SignalStatisticsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FrtcStatisticalModel : JSONModel

@property (nonatomic, strong) MediaStatisticsModel *mediaStatistics;

@property (nonatomic, strong) SignalStatisticsModel *signalStatistics;

@end

NS_ASSUME_NONNULL_END
