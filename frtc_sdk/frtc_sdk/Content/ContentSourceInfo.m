#import "ContentSourceInfo.h"

@implementation ContentSourceInfo

- (NSString *)description {
    return [NSString stringWithFormat:@"[contentType:%d, contentKey:%d, contentShareable:%d, contentName:%@, processId:%d, processName:%@, sessionId:%@, isHideIntoTrayLyoutCtrl:%d, isFullScreenLyoutCtrl:%d]", _contentType, _contentKey, _contentShareable, _contentName, _processId, _sessionId, _processName, _isHideIntoTrayLyoutCtrl, _isFullScreenLyoutCtrl];
}

@end
