#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "FrtcScreenBorderView.h"
#import "FrtcScreenBorderAppView.h"
#import "FrtcMediaStaticsView.h"


@interface FrtcScreenBorderWindow : NSObject <NSWindowDelegate> 

@property (nonatomic, strong) NSWindow                          *border;
@property (nonatomic, strong) FrtcScreenBorderView              *screenBorderView;
@property (nonatomic, strong) FrtcScreenBorderAppView           *screenAppBorderView;
@property (nonatomic, strong) FrtcMediaStaticsView              *staticsView;
@property (nonatomic, assign) uint32_t                          screenID;
@property (nonatomic, assign) NSInteger                         type;

- (void)displayBorderWindow:(BOOL)isDisplay;

- (void)showReminderView:(NSString *)stringValue;

- (void)updateBackGroundView:(NSInteger)type;

@end

