#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrtcTabControlModel : NSObject

+ (FrtcTabControlModel *)modelWithSelectedImageName:(NSString*)selectedImageName
                            andDisSelectedImageName:(NSString*)disSelectedImageName
                                           andTitle:(NSString*)title;

@property (nonatomic, copy) NSString* selectedImageName;

@property (nonatomic, copy) NSString* disSelectedImageName;

@property (nonatomic, copy) NSString* title;

@end

NS_ASSUME_NONNULL_END
