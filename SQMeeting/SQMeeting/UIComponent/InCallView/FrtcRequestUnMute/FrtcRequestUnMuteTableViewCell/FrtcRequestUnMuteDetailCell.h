#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcRequestUnMuteDetailCellDelegate <NSObject>

- (void)agreeUnMuteWithRow:(NSInteger)row;

@end

@interface FrtcRequestUnMuteDetailCell : NSTableCellView

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, weak) id<FrtcRequestUnMuteDetailCellDelegate> delegate;

- (void)updateCellName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
