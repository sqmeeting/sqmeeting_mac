#import "NumberLimiteFormatter.h"

@implementation NumberLimiteFormatter

- (id)init {

   if(self = [super init]){

      self.maxLength = INT_MAX;
   }

  return self;
}

- (void)setMaximumLength:(int)len {
    self.maxLength = len;
}

- (int)maximumLength {
    return self.maxLength;
}

- (NSString *)stringForObjectValue:(id)object {
    return (NSString *)object;
}

- (BOOL)getObjectValue:(id *)object forString:(NSString *)string errorDescription:(NSString **)error {
    *object = string;
  
    return YES;
}

- (BOOL)isPartialStringValid:(NSString * _Nonnull * _Nonnull)partialStringPtr proposedSelectedRange:(nullable NSRangePointer)proposedSelRangePtr originalString:(NSString *)origString originalSelectedRange:(NSRange)origSelRange errorDescription:(NSString * _Nullable * _Nullable)error {
    if ([*partialStringPtr length] > self.maxLength) {
        return NO;
    }

    return YES;
}

- (NSAttributedString *)attributedStringForObjectValue:(id)anObject withDefaultAttributes:(NSDictionary *)attributes {
    return nil;
}

@end
