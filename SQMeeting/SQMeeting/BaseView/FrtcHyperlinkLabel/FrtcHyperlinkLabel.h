#import <Cocoa/Cocoa.h>

@interface FrtcHyperlinkLabel : NSTextField

@property (nonatomic, copy)   NSString            *hyperlink;

@property (nonatomic, strong) NSTrackingArea      *trackingArea;

@property (nonatomic, assign) BOOL                isTopAlignment;

@end
