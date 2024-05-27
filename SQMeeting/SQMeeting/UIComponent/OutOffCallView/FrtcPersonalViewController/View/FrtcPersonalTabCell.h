#import <Cocoa/Cocoa.h>
#import "FrtcPersonalModel.h"
#import "EditImageView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FrtcPersonalTabTag) {
    PersonalNameTag = 101,
    PersonalAccountTag,
    PersonalRecordingTag,
    PersonalPasswordTag,
    PersonalLogoutTag
};

@protocol FrtcPersonalTabCellDelegate <NSObject>

- (void)popupWindow;

@end


@interface FrtcPersonalTabCell : NSControl

@property (nonatomic, strong) NSImageView *imageView;

@property (nonatomic, strong) NSTextField *titleView;

@property (nonatomic, strong) NSTextField *detailTextField;

@property (nonatomic, strong) EditImageView *editImageView;

@property (nonatomic, strong) NSColor *effectBackgroundColor;

@property (nonatomic, assign) FrtcPersonalTabTag personalTag;

@property (nonatomic, weak) id<FrtcPersonalTabCellDelegate> delegate;

- (FrtcPersonalTabCell *)initWithPersonalControlModel:(FrtcPersonalModel *)personalControl;

- (void)selected;

- (void)disSelected;

@end

NS_ASSUME_NONNULL_END
