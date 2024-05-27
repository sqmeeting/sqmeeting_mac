#import "FrtcTabControlModel.h"

@implementation FrtcTabControlModel

+ (FrtcTabControlModel *)modelWithSelectedImageName:(NSString*)selectedImageName
                            andDisSelectedImageName:(NSString*)disSelectedImageName
                                           andTitle:(NSString*)title {
    FrtcTabControlModel* model = [[FrtcTabControlModel alloc] init];
    
    model.selectedImageName = selectedImageName;
    model.disSelectedImageName = disSelectedImageName;
    model.title = title;
    
    return model;
}



@end
