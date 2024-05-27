#import "FrtcPersonalModel.h"

@implementation FrtcPersonalModel

+ (FrtcPersonalModel *)modelWithSelectedImageName:(NSString *)selectedImageName
                            andDisSelectedImageName:(NSString *)disSelectedImageName
                                           andTitle:(NSString *)title {
    FrtcPersonalModel  *model = [[FrtcPersonalModel alloc] init];
    
    model.selectedImageName = selectedImageName;
    model.disSelectedImageName = disSelectedImageName;
    model.title = title;
    
    return model;
}

@end
