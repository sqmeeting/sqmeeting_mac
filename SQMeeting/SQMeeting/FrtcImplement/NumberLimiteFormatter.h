#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NumberLimiteFormatter : NSFormatter

@property (nonatomic, assign) int maxLength;

- (void)setMaximumLength:(int)len;

- (int)maximumLength;

@end

NS_ASSUME_NONNULL_END
