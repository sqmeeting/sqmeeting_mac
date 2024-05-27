#import "FrtcRecurrenceDetailViewControllerCell.h"
#import "HoverImageView.h"

@interface FrtcRecurrenceDetailViewControllerCell () <HoverImageViewDelegate>

@property (nonatomic, strong) HoverImageView *moreImageView;

@end

@implementation FrtcRecurrenceDetailViewControllerCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if(self = [super initWithFrame:frameRect]) {
        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited;
        
        NSTrackingArea *focusTrackingArea = [[NSTrackingArea alloc] initWithRect:frameRect
                                                                         options:focusTrackingAreaOptions owner:self userInfo:nil];
        [self addTrackingArea:focusTrackingArea];
        
        self.wantsLayer = YES;
        [self configCellLayout];
    }
    return self;
}

- (void)configCellLayout {
    [self.timeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(16);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.wordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeTextField.mas_right).offset(4);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.willBeginTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeTextField.mas_right).offset(4);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(22);
    }];
}

- (void)updateBKColor:(BOOL)flag {
    if (flag) {
        self.layer.backgroundColor = [NSColor colorWithString:@"#E4EFFF" andAlpha:1.0].CGColor;
        self.timeTextField.textColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0];
        if(self.isInvite || self.isAddMeeting) {
            self.moreImageView.hidden = YES;
        } else {
            self.moreImageView.hidden = NO;
        }
    } else {
        self.timeTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        self.moreImageView.hidden = YES;
        if(self.cellTag % 2 == 0) {
            self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
        } else {
            self.layer.backgroundColor = [NSColor colorWithString:@"#F9F9F9" andAlpha:1.0].CGColor;
        }
    }
}


#pragma mark  -- mouse evetn--
- (void)mouseEntered:(NSEvent *)event {
    [self updateBKColor:YES];
}

- (void)mouseExited:(NSEvent *)event {
    [self updateBKColor:NO];
}

#pragma --HoverImageViewDelegate--
- (void)didIntoArea:(BOOL)isInImageViewArea withSenderTag:(NSInteger)tag {
    
}

- (void)hoverImageViewClickedwithSenderTag:(NSInteger)tag {
    if(self.delegate && [self.delegate respondsToSelector:@selector(popUpFunctionControllerWithFrame:withRow:)]) {
        [self.delegate popUpFunctionControllerWithFrame:self.moreImageView.frame withRow:self.row];
    }
}


- (NSTextField *)timeTextField {
    if (!_timeTextField) {
        _timeTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _timeTextField.backgroundColor = [NSColor clearColor];
        _timeTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightRegular];
        _timeTextField.alignment = NSTextAlignmentLeft;
        _timeTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _timeTextField.editable = NO;
        _timeTextField.bordered = NO;
        _timeTextField.wantsLayer = NO;
        _timeTextField.stringValue = @"2023-10-11   周三      14:00-15:00";
        [self addSubview:_timeTextField];
    }
    
    return _timeTextField;
}

- (NSTextField *)wordTextField {
    if (!_wordTextField) {
        _wordTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _wordTextField.backgroundColor = [NSColor clearColor];
        _wordTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightRegular];
        _wordTextField.alignment = NSTextAlignmentLeft;
        _wordTextField.textColor = [NSColor colorWithString:@"#23D862" andAlpha:1.0];
        _wordTextField.editable = NO;
        _wordTextField.bordered = NO;
        _wordTextField.wantsLayer = NO;
        _wordTextField.stringValue = NSLocalizedString(@"FM_MEETING_STARTED", @"In Progress");
        _wordTextField.hidden = YES;
        [self addSubview:_wordTextField];
    }
    
    return _wordTextField;
}

- (NSTextField *)willBeginTextField {
    if (!_willBeginTextField) {
        _willBeginTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _willBeginTextField.backgroundColor = [NSColor clearColor];
        _willBeginTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightRegular];
        _willBeginTextField.alignment = NSTextAlignmentLeft;
        _willBeginTextField.textColor = [NSColor colorWithString:@"#FF7218" andAlpha:1.0];
        _willBeginTextField.editable = NO;
        _willBeginTextField.bordered = NO;
        _willBeginTextField.wantsLayer = NO;
        _willBeginTextField.stringValue = NSLocalizedString(@"FM_MEETING_BEGIN_IN", @"Upcoming");
        _willBeginTextField.hidden = YES;
        [self addSubview:_willBeginTextField];
    }
    
    return _willBeginTextField;
}

- (HoverImageView *)moreImageView {
    if(!_moreImageView) {
        _moreImageView = [[HoverImageView alloc] initWithFrame:CGRectMake(0, 0, 17, 16)];
        _moreImageView.delegate = self;
        _moreImageView.image = [NSImage imageNamed:@"icon_recurrence_more"];
        [_moreImageView setWantsLayer:YES];
        _moreImageView.layer.borderWidth = 1.0;
        _moreImageView.layer.cornerRadius = 4.0;
        _moreImageView.layer.masksToBounds = YES;
        _moreImageView.hidden = YES;
        CGColorRef color = CGColorRetain([NSColor colorWithString:@"#026FFE" andAlpha:1.0].CGColor);
        [_moreImageView.layer setBorderColor:color];
        [self addSubview:_moreImageView];
    }
    
    return _moreImageView;
}



@end
