#import <Cocoa/Cocoa.h>
#import "HoverImageView.h"
#import "FrtcMultiTypesButton.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RosterListAskForUnmuteCellDelegate <NSObject>

- (void)viewAllAskForMuteList;

@end

@interface RosterListAskForUnmuteCell : NSTableCellView

@property (nonatomic, strong) NSView      *spliteLine;

@property (nonatomic, strong) HoverImageView *headerImageView;

@property (nonatomic, strong) NSTextField  *participantName;

@property (nonatomic, strong) FrtcMultiTypesButton    *viewButton;

@property (nonatomic, strong) NSImageView *showNewComingView;

@property (nonatomic, weak) id<RosterListAskForUnmuteCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
