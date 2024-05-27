#import <Cocoa/Cocoa.h>
#import "FrtcButtonMode.h"
#import "FrtcButtonCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface FrtcButton : NSButton <FrtcButtonCellDeletegate>

- (instancetype)initWithFrame:(NSRect)frame
               withNormalMode:(FrtcButtonMode *)normalMode
                withHoverMode:(FrtcButtonMode *)hoverMode;

@property (nonatomic, strong) FrtcButtonMode *normalButtonMode;

@property (nonatomic, strong) FrtcButtonMode *hoverButtonMode;

@property (nonatomic, strong) FrtcButtonCell * btnCell;

@property (nonatomic, assign, getter=isHoverd) BOOL hoverd;

- (void)updateButtonWithButtonMode:(FrtcButtonMode *)buttonMode;

- (void)customizedPrimaryStyle;

@end

NS_ASSUME_NONNULL_END
