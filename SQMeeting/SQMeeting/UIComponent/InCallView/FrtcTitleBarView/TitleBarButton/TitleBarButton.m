#import "TitleBarButton.h"

@implementation TitleBarButton


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

//    CGContextRef context = [NSGraphicsContext currentContext].CGContext; // Core Graphics上下文，其实就是张画布
//    CGFloat minx = CGRectGetMinX(dirtyRect), midx =    CGRectGetMidX(dirtyRect), maxx = CGRectGetMaxX(dirtyRect);
//    CGFloat miny = CGRectGetMinY(dirtyRect), midy = CGRectGetMidY(dirtyRect), maxy = CGRectGetMaxY(dirtyRect);
//    CGContextMoveToPoint(context, minx, midy); // 设置绘制起点为（minx, midy）
//    CGContextAddArcToPoint(context, minx, miny, midx, miny, 4.0); // 绘制view左下圆角
//    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, 4.0); // 绘制view右下圆角
//    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, 4.0); // 绘制view右上圆角
//    CGContextAddArcToPoint(context, minx, maxy, minx, midy, 4.0); // 绘制view左上圆角
//    CGContextClosePath(context);
//    CGContextSetFillColorWithColor(context, [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor); //填充view的背景颜色#FFFFFF
//    CGContextSetStrokeColorWithColor(context, [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor);
//    CGContextStrokePath(context);
//    CGContextFillPath(context);
    
    self.wantsLayer = YES;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4.0;
    
    self.layer.borderWidth = 1.0;
    self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
    self.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
}

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self titleBarButtonLayout];
        
        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved |
                                                                 NSTrackingCursorUpdate |
                                                                 NSTrackingActiveWhenFirstResponder |
                                                                 NSTrackingActiveInKeyWindow |
                                                                 NSTrackingActiveInActiveApp |
                                                                 NSTrackingActiveAlways |
                                                                 NSTrackingAssumeInside |
                                                                 NSTrackingInVisibleRect |
                                                                    NSTrackingEnabledDuringMouseDrag;
                                                             
        NSRect rect = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height);
        NSTrackingArea *focusTrackingArea = [[NSTrackingArea alloc] initWithRect:rect
                                                                         options:focusTrackingAreaOptions owner:self userInfo:nil];
        [self addTrackingArea:focusTrackingArea];
    }
    return self;
}

- (void)titleBarButtonLayout {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(12);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(6);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)mouseEntered:(NSEvent *)event {
    [[NSCursor pointingHandCursor] set];
    
    if(self.titleBarButtonDelegate && [self.titleBarButtonDelegate respondsToSelector:@selector(didIntoArea: withSenderType:)]) {
        [self.titleBarButtonDelegate didIntoArea:YES withSenderType:self.buttonType];
    }
}

- (void)mouseExited:(NSEvent *)event {
    [[NSCursor arrowCursor] set];
    if(self.titleBarButtonDelegate && [self.titleBarButtonDelegate respondsToSelector:@selector(didIntoArea: withSenderType:)]) {
        [self.titleBarButtonDelegate didIntoArea:NO withSenderType:self.buttonType];
    }
}

- (void)mouseDown:(NSEvent *)event {
    [super mouseDown:event];
    [NSApp sendAction:@selector(clicked:) to:self from:self];
}

- (void)clicked:(id)sender {
    if(self.titleBarButtonDelegate && [self.titleBarButtonDelegate respondsToSelector:@selector(titleBarButtonClicked:)]) {
        [self.titleBarButtonDelegate titleBarButtonClicked:self.buttonType];
    }
}

#pragma mark --getter load--
- (NSImageView *)imageView {
    if (!_imageView){
        _imageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        [_imageView setImage:[NSImage imageNamed:@"icon-user"]];
        _imageView.imageAlignment = NSImageAlignTopLeft;
        _imageView.imageScaling   =  NSImageScaleAxesIndependently;
        [self addSubview:_imageView];
    }
    
    return _imageView;
}

- (NSTextField *)title {
    if (!_title){
        _title = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _title.bordered = NO;
        _title.drawsBackground = NO;
        _title.stringValue = NSLocalizedString(@"FM_MEETING_INFO", @"Meeting info");
        _title.backgroundColor = [NSColor clearColor];
        _title.layer.backgroundColor = [NSColor colorWithString:@"FFFFFF" andAlpha:1.0].CGColor;
        _title.font = [NSFont systemFontOfSize:12 weight:NSFontWeightRegular];
        _title.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _title.alignment = NSTextAlignmentLeft;
        _title.editable = NO;
        [self addSubview:_title];
    }
    
    return _title;
}

@end
