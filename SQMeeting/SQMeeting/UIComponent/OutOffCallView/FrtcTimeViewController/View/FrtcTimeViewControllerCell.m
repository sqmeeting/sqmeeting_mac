#import "FrtcTimeViewControllerCell.h"

@implementation FrtcTimeViewControllerCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)init {
    if(self = [super init]) {
        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited;
        
        NSRect rect = NSMakeRect(0, 0, 100, 20);
        NSTrackingArea *focusTrackingArea = [[NSTrackingArea alloc] initWithRect:rect
                                                                         options:focusTrackingAreaOptions owner:self userInfo:nil];
        [self addTrackingArea:focusTrackingArea];
        
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor whiteColor].CGColor;
        [self configUserListCellLayout];
    }
    
    return self;
}

#pragma mark  -- mouse evetn--
- (void)mouseEntered:(NSEvent *)event {
    if(self.isCanSelected) {
        [[NSCursor pointingHandCursor] set];
        [self updateBKColor:YES];
    }
}

- (void)mouseExited:(NSEvent *)event {
    if(self.isCanSelected) {
        [[NSCursor arrowCursor] set];
        [self updateBKColor:NO];
    }
}

- (void)configUserListCellLayout {
    [self.userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)updateBKColor:(BOOL)flag {
    if(self.isCanSelected) {
        if (flag) {
            self.layer.backgroundColor = [NSColor colorWithString:@"#F8F9FA" andAlpha:1.0].CGColor;
            //self.userNameTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
        } else {
            self.layer.backgroundColor = [NSColor whiteColor].CGColor;
           // self.userNameTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        }
    }
}

- (NSTextField *)userNameTextField {
    if(!_userNameTextField) {
        _userNameTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _userNameTextField.backgroundColor = [NSColor clearColor];
        _userNameTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightRegular];
        _userNameTextField.alignment = NSTextAlignmentCenter;
        _userNameTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _userNameTextField.bordered = NO;
        _userNameTextField.editable = NO;
        [self addSubview:_userNameTextField];
    }
    
    return _userNameTextField;
}


@end
