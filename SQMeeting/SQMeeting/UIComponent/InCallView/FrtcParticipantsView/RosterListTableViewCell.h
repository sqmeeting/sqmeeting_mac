#import <Cocoa/Cocoa.h>
#import "HoverImageView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RosterListTableViewCellDelegate <NSObject>

- (void)muteSinglePeopleOrNot;

@end

@interface RosterListTableViewCell : NSTableCellView

@property (nonatomic, strong) HoverImageView *headerImageView;

@property (nonatomic, strong) NSTextField  *participantName;

@property (nonatomic, strong) NSView      *spliteLine;

@property (nonatomic, strong) NSImageView *audioMuteStatusImageView;

@property (nonatomic, strong) NSImageView *videoMuteStatusImageView;

@property (nonatomic, strong) NSImageView *pinStatusImageView;

@property (nonatomic, weak) id<RosterListTableViewCellDelegate> tableViewCellDelegate;

@property (nonatomic, assign) NSInteger cellTag;

@property (nonatomic, assign, getter=isAudioMute) BOOL audioMute;

@end

NS_ASSUME_NONNULL_END
