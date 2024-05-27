#import "FrtcPersonalTabCell.h"

#define CELL_SELECTED_COLOR  [NSColor colorWithString:@"F8F9FA" andAlpha:1]
#define CELL_DISSELECTED_COLOR  [NSColor colorWithString:@"F8F9FA" andAlpha:1]

@interface FrtcPersonalTabCell () <EditImageViewDelegate>{
    FrtcPersonalModel *personalControlModel;
    BOOL _mouseDown;
    BOOL _mouseIn;
}

@end

@implementation FrtcPersonalTabCell

- (void)drawRect:(NSRect)dirtyRect {
    NSRect rect  = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [super drawRect:rect];
    
    // Drawing code here.
    [self.effectBackgroundColor setFill];
    NSRectFill(rect);
}

- (instancetype)init {
    self = [super init];
    
    if(self) {
        [self setupUI];
    }
    
    return self;
}

- (FrtcPersonalTabCell *)initWithTabControlModel {
    self = [super init];
    
    if (self) {
        [self setupUI];
    }
    
    return self;
}

- (FrtcPersonalTabCell *)initWithPersonalControlModel:(FrtcPersonalModel *)personalControl {
    self = [super init];
    
    if (self) {
        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited;
        
        NSRect rect = NSMakeRect(0, 0, 258, 32);
        NSTrackingArea *focusTrackingArea = [[NSTrackingArea alloc] initWithRect:rect
                                                                         options:focusTrackingAreaOptions owner:self userInfo:nil];
        [self addTrackingArea:focusTrackingArea];
        
        personalControlModel = personalControl;
        [self setupUI];
    }
    
    return self;
}

#pragma mark -- public functions
- (void)selected {
    self.needsDisplay = YES;

    if(self.personalTag == PersonalPasswordTag) {
        self.titleView.textColor = [NSColor colorWithString:@"#026FFE" andAlpha:1];
        self.effectBackgroundColor = [NSColor colorWithString:@"#F6FAFF" andAlpha:1];
    } else if(self.personalTag == PersonalLogoutTag) {
        self.titleView.textColor = [NSColor colorWithString:@"#E32726" andAlpha:1];
        self.effectBackgroundColor = [NSColor colorWithString:@"#FFF7F7" andAlpha:1];
    }
 
    //self.effectBackgroundColor = CELL_SELECTED_COLOR;
    self.imageView.image = [NSImage imageNamed:personalControlModel.selectedImageName];
}

- (void)disSelected {
    self.effectBackgroundColor = CELL_DISSELECTED_COLOR;
    self.needsDisplay = YES;
    
    if(self.personalTag == PersonalPasswordTag || self.personalTag == PersonalLogoutTag || self.personalTag== PersonalRecordingTag) {
        self.titleView.textColor = [NSColor colorWithString:@"#333333" andAlpha:1];
    }
    
    self.imageView.image = [NSImage imageNamed:personalControlModel.disSelectedImageName];
}

- (void)setupUI {
    [self addSubview:self.imageView];
    [self addSubview:self.titleView];
    [self addSubview:self.detailTextField];
    [self addSubview:self.editImageView];
    
    self.effectBackgroundColor = CELL_DISSELECTED_COLOR;
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).mas_offset(8);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
        make.centerY.mas_equalTo(self.mas_centerY);//.offset(-2.5);
    }];
    
    [self.detailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).mas_offset(-24);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
        make.centerY.mas_equalTo(self.titleView.mas_centerY);
    }];
    
    [self.editImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleView.mas_right).mas_offset(8);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor colorWithString:@"fbfbfb" andAlpha:1].CGColor;
}
#pragma mark --EditImageViewDelegate--
- (void)popupModifyMeetingUserNameWindow {
//    if(self.delegate && [self.delegate respondsToSelector:@selector(popupWindow)]) {
//        [self.delegate popupWindow];
//    }
}

#pragma mark  -- mouse evetn--
- (void)mouseEntered:(NSEvent *)event {
    [[NSCursor pointingHandCursor] set];
    if(self.personalTag == PersonalPasswordTag || self.personalTag == PersonalLogoutTag) {
        [self selected];
        _mouseIn = YES;
    }
}

- (void)mouseExited:(NSEvent *)event {
    [[NSCursor arrowCursor] set];
    [self disSelected];
    _mouseIn = NO;
}

- (void)mouseDown:(NSEvent *)theEvent {
    _mouseDown = YES;
}

- (void)mouseUp:(NSEvent *)theEvent {
    if (_mouseDown) {
        _mouseDown = NO;
        if (_mouseIn && self.target && self.action) {
            [self.target performSelector:self.action withObject:self afterDelay:0.0];
        }
    }
}

#pragma mark  -- getter
- (NSImageView *)imageView {
    if (!_imageView) {
        _imageView = [[NSImageView alloc] init];
    }
    
    return _imageView;
}

- (NSTextField *)titleView {
    if (!_titleView) {
        _titleView = [[NSTextField alloc] init];
        _titleView.textColor = [NSColor colorWithString:@"#999999" andAlpha:1];
        _titleView.font = [NSFont systemFontOfSize:14 weight:NSFontWeightRegular];
        [_titleView setBordered:NO];
        [_titleView setEditable:NO];
        [_titleView setSelectable:NO];
        _titleView.backgroundColor = [NSColor clearColor];
    }
    
    return _titleView;
}

- (NSTextField *)detailTextField {
    if(!_detailTextField) {
        _detailTextField = [[NSTextField alloc] init];
        _detailTextField.textColor = [NSColor colorWithString:@"#999999" andAlpha:1];
        _detailTextField.font = [NSFont systemFontOfSize:12 weight:NSFontWeightRegular];
        //_detailTextField
        _detailTextField.alignment = NSTextAlignmentRight;
        [_detailTextField setBordered:NO];
        [_detailTextField setEditable:NO];
        [_detailTextField setSelectable:NO];
        _detailTextField.hidden = YES;
        _detailTextField.backgroundColor = [NSColor clearColor];
    }
    
    return _detailTextField;
}

- (EditImageView *)editImageView {
    if (!_editImageView) {
        _editImageView = [[EditImageView alloc] initWithFrame:NSMakeRect(0, 0, 20, 20)];
        _editImageView.delegate = self;
        _editImageView.hidden = YES;
    }
    
    return _editImageView;
}

@end
