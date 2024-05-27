#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (AESTest)

-(NSData*)AES256EncryptWithKey:(NSString*)key;
-(NSData*)AES256DecryptWithKey:(NSString*)key;

- (void)test;

@end

NS_ASSUME_NONNULL_END
