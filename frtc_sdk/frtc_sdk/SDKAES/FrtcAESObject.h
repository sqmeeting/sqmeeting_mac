
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrtcAESObject : NSObject

+ (FrtcAESObject *)sharedAESObject;

-(NSData*)AES256EncryptWithKey:(NSString*)key withData:(NSData *)data;
-(NSData*)AES256DecryptWithKey:(NSString*)key withData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
