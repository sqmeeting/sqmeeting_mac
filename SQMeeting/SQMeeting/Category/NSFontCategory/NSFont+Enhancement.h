#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSInteger, SFProDisplay){
    SFProDisplayLight,
    SFProDisplayRegular,
    SFProDisplayMedium,
    SFProDisplayBold,
    SFProDisplaySemibold,
    SFProDisplayArialMT
};

@interface NSFont (Enhancement)

+ (NSFont*)fontWithSFProDisplay:(CGFloat)size andType:(SFProDisplay)type;

@end
