#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FrtcTagFunctionTag) {
    FrtcFunctionCopyTag = 0,
    FrtcFunctionEditTag,
    FrtcFunctionCancelTag,
    FrtcFunctionViewTag,
    FrtcFunctionRemoveTag
};

@class FrtcTagFunctionCell;

@protocol FrtcTagFunctionCellDelegate <NSObject>

- (void)didSelectedCell:(FrtcTagFunctionCell *)cell;

@end

@interface FrtcTagFunctionCell : NSControl

@property (nonatomic, strong) NSTextField* titleView;

@property (nonatomic, strong) NSColor* effectBackgroundColor;

@property (nonatomic, assign) FrtcTagFunctionTag cellTag;

@property (nonatomic, weak) id <FrtcTagFunctionCellDelegate> delegate;

- (instancetype)initWithType:(NSString *)type;

- (void)selected;

- (void)disSelected;

@end

NS_ASSUME_NONNULL_END
