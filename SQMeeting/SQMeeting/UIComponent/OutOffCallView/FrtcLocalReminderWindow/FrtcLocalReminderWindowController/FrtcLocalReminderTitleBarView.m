#import "FrtcLocalReminderTitleBarView.h"
#import "NSFont+Enhancement.h"


@interface FrtcLocalReminderTitleBarView ()

@property (nonatomic, assign) NSFont       *textFont;
@property (nonatomic, strong) NSColor      *textColor;

@property (nonatomic, strong) NSString     *titleString;
@property (nonatomic, strong) NSDictionary *attributes;
@property (nonatomic, strong) NSImage      *backgroundImage;
@property (nonatomic, strong) NSButton     *cancelButton;

@end

@implementation FrtcLocalReminderTitleBarView

#pragma mark -- UI init --

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundImage = [NSImage imageNamed:@"local_reminder_title_bar_bg"];
    self.cancelButton = [[NSButton alloc] initWithFrame:NSMakeRect(self.bounds.size.width - 12 - 12, 10, 12, 12)];
    NSImage *image = [NSImage imageNamed:@"local_reminder_close_btn"];
    [_cancelButton setImage:image];
    [_cancelButton setImagePosition:NSImageOnly];
    [_cancelButton setBordered:NO];
    [_cancelButton setTitle:@""];
    [_cancelButton setTarget:self];
    [_cancelButton setAction:@selector(closeButtonClicked:)];
    [self addSubview:_cancelButton];
}

- (void)setTitleString:(NSString *)text {
    //NSLog(@"[%s]: text: %@", __func__, text);
    _titleString = text;
    [self setNeedsDisplay:YES];
}

- (void)setFont:(NSFont *)font {
    _textFont = font;
    [self setNeedsDisplay:YES];
}

- (NSDictionary *)getAttributeds {
    //NSLog(@"[%s]: ", __func__);
    if (nil == _attributes) {
        _attributes = @{
            NSFontAttributeName: _textFont, //[NSFont systemFontOfSize:14.0],
            NSForegroundColorAttributeName: [NSColor whiteColor]
        };
    }
    return _attributes;
}


#pragma mark -- UI --

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    [self.backgroundImage drawInRect:self.bounds];
    
    NSSize textSize = [_titleString sizeWithAttributes:self.attributes];
    CGFloat x = (dirtyRect.size.width - textSize.width) / 2.0;
    CGFloat y = (dirtyRect.size.height - textSize.height) / 2.0;

    [_titleString drawAtPoint:NSMakePoint(x, y) withAttributes:self.attributes];
}

- (void)closeButtonClicked:(id)sender {
    //NSLog(@"[%s]: ", __func__);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeButtonOnTitleBarClicked:)]) {
        [self.delegate closeButtonOnTitleBarClicked:sender];
    }
}


@end
