#import "FrtcMeetingUserView.h"
#import "FrtcSDKBundle.h"

@implementation FrtcMeetingUserView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    
    if(self) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor colorWithRed:0 green:0 blue:0 alpha:0.6].CGColor;
        
        self.nameLabel = [[NSTextField alloc] initWithFrame:CGRectMake(0, -4, frame.size.width, frame.size.height)];
        [self addSubview:self.nameLabel];
        [self configNameLabel:self.nameLabel];
        
        self.pinView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [self addSubview:self.pinView];
        [self configPinView:self.pinView];
        self.pinView.hidden = YES;
        
        self.muteView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [self addSubview:self.muteView];
        [self configMuteView:self.muteView];
        self.muteView.hidden = YES;
    }
    
    return self;
}

- (void)configBackGroundView:(NSImageView *)iamgeView {
    NSString *imagePath = [FrtcSDKBundle bundlePath:@"DisplayName@2x.png"];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
    [iamgeView setImage:image];
    iamgeView.imageScaling = NSImageScaleAxesIndependently;
}

- (void)configPinView:(NSImageView *)iamgeView {
    NSString *imagePath = [FrtcSDKBundle bundlePath:@"icon-status-pin@2x.png"];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
    [iamgeView setImage:image];
    iamgeView.imageScaling = NSImageScaleAxesIndependently;
}

- (void)configMuteView:(NSImageView *)iamgeView {
    NSString *imagePath = [FrtcSDKBundle bundlePath:@"icon-status-mute-white@2x.png"];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
    [iamgeView setImage:image];
    iamgeView.imageScaling = NSImageScaleAxesIndependently;
}

- (void)configNameLabel:(NSTextField *)nameLabel {
    nameLabel.bordered = NO;
    nameLabel.drawsBackground = NO;
    nameLabel.backgroundColor = [NSColor clearColor];
    nameLabel.textColor = [NSColor whiteColor];
    nameLabel.font = [NSFont systemFontOfSize:12];
    nameLabel.alignment = NSTextAlignmentLeft;
    nameLabel.maximumNumberOfLines = 1;
    nameLabel.editable = NO;
    nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
}

- (void)configNamePinCardView {
    self.pinView.frame = CGRectMake(0, 0, 30, 30);
    self.nameLabel.frame = CGRectMake(35, -4, self.frame.size.width, self.frame.size.height);
}

- (void)configNameNoPinCardView {
    self.nameLabel.frame = CGRectMake(0, -4, self.frame.size.width, self.frame.size.height);
}

- (void)configNewUserNameView:(BOOL)pin {
    self.pin = pin;
    [self finalLayout];
}

- (void)updateMuteView:(BOOL)userMute {
    self.userMute = userMute;
    [self finalLayout];
}

- (void)finalLayout {
    if(self.isPin && self.isUserMute) {
        self.pinView.hidden = NO;
        self.muteView.hidden = NO;
        
        NSFont *font             = [NSFont systemFontOfSize:12.0f];
        NSDictionary *attributes = @{ NSFontAttributeName:font };
        CGSize size              = [self.nameLabel.stringValue sizeWithAttributes:attributes];
        self.nameLabel.frame =  CGRectMake(8, (24 - size.height) / 2, size.width + 5, size.height);
        self.pinView.frame   =  CGRectMake(size. width + 10 + 6, 4, 16, 16);
        self.muteView.frame  =  CGRectMake(size. width + 10 + 6 + 16 + 5, 4, 16, 16);
        self.frame = CGRectMake(self.frame.origin.x , self.frame.origin.y, size.width + 10 + 6 + 16 + 5 + 16 + 5, 24);
        
        NSString *imagePath = [FrtcSDKBundle bundlePath:@"icon-incall-mute@2x.png"];
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
        [self.muteView setImage:image];
    } else if(!self.isPin && !self.isUserMute) {
        self.pinView.hidden = YES;
        self.muteView.hidden = NO;
        
        NSFont *font             = [NSFont systemFontOfSize:12.0f];
        NSDictionary *attributes = @{ NSFontAttributeName:font };
        CGSize size              = [self.nameLabel.stringValue sizeWithAttributes:attributes];
        self.nameLabel.frame = CGRectMake(8, (24 - size.height) / 2, size.width + 5, size.height);
        self.muteView.frame =  CGRectMake(size. width + 10 + 6, 4, 16, 16);
        self.frame = CGRectMake(self.frame.origin.x , self.frame.origin.y, size.width + 10 + 6 + 16 + 5, 24);
        
        NSString *imagePath = [FrtcSDKBundle bundlePath:@"icon-incall-unmute@2x.png"];
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
        [self.muteView setImage:image];
    } else if(self.isPin &&!self.isUserMute) {
        self.pinView.hidden = NO;
        self.muteView.hidden = NO;
        
        NSFont *font             = [NSFont systemFontOfSize:12.0f];
        NSDictionary *attributes = @{ NSFontAttributeName:font };
        CGSize size              = [self.nameLabel.stringValue sizeWithAttributes:attributes];
        self.nameLabel.frame =  CGRectMake(8, (24 - size.height) / 2, size.width + 5, size.height);
        self.pinView.frame   =  CGRectMake(size. width + 10 + 6, 4, 16, 16);
        self.muteView.frame  =  CGRectMake(size. width + 10 + 6 + 16 + 5, 4, 16, 16);
        self.frame = CGRectMake(self.frame.origin.x , self.frame.origin.y, size.width + 10 + 6 + 16 + 5 + 16 + 5, 24);
        NSString *imagePath = [FrtcSDKBundle bundlePath:@"icon-incall-unmute@2x.png"];
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
        [self.muteView setImage:image];
    } else if(!self.isPin && self.isUserMute) {
        self.pinView.hidden = YES;
        self.muteView.hidden = NO;
        
        self.muteView.frame = CGRectMake(5, 0, 30, 30);
        self.nameLabel.frame = CGRectMake(40, 0, 300, self.frame.size.height);
        
        NSFont *font             = [NSFont systemFontOfSize:12.0f];
        NSDictionary *attributes = @{ NSFontAttributeName:font };
        CGSize size              = [self.nameLabel.stringValue sizeWithAttributes:attributes];
        self.nameLabel.frame = CGRectMake(8, (24 - size.height) / 2, size.width + 5, size.height);
        self.muteView.frame =  CGRectMake(size.width + 10 + 6, 4, 16, 16);
        self.frame = CGRectMake(self.frame.origin.x , self.frame.origin.y, size.width + 10 + 6 + 16 + 5, 24);
        
        NSString *imagePath = [FrtcSDKBundle bundlePath:@"icon-incall-mute@2x.png"];
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
        [self.muteView setImage:image];
    }
}

- (void)configContentWidth {
    NSFont *font             = [NSFont systemFontOfSize:12.0f];
    NSDictionary *attributes = @{ NSFontAttributeName:font };
    CGSize size              = [self.nameLabel.stringValue sizeWithAttributes:attributes];
    self.nameLabel.frame = CGRectMake(8, (24 - size.height) / 2, size.width + 5, size.height);
    self.frame = CGRectMake(self.frame.origin.x , self.frame.origin.y, size.width + 5, 24);
}



@end
