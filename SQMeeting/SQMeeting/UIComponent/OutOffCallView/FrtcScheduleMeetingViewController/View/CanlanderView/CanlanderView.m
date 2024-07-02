#import "CanlanderView.h"
#import "HoverImageView.h"
#import "FrtcDefaultTextField.h"

@interface CanlanderView () <HoverImageViewDelegate>

@property (nonatomic, strong) HoverImageView *endCanlanderImageView;

@end

@implementation CanlanderView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor whiteColor].CGColor;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        
        [self setupView];
    }
    
    return self;
}

#pragma mark --HoverImageViewDelegate--
- (void)hoverImageViewClickedwithSenderTag:(NSInteger)tag {
    if(self.calanlerViewDelegate && [self.calanlerViewDelegate respondsToSelector:@selector(popupCalanderViewWithInterger:)]) {
        [self.calanlerViewDelegate popupCalanderViewWithInterger:self.viewTag];
    }
}

- (void)setupView {
    [self.timeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.endCanlanderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-9);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
}

#pragma ---lazy code--
- (NSTextField *)timeTextField {
    if (!_timeTextField) {
        _timeTextField =  [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _timeTextField.backgroundColor = [NSColor clearColor];
        _timeTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightRegular];
        _timeTextField.alignment = NSTextAlignmentLeft;
        _timeTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
        _timeTextField.bordered = NO;
        _timeTextField.editable = NO;
        
        NSDate *theDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd EE";
        NSString *dateString = [formatter stringFromDate:theDate];
        _timeTextField.stringValue = dateString;
        [self addSubview:_timeTextField];
    }
    
    return _timeTextField;
}

- (HoverImageView *)endCanlanderImageView {
    if(!_endCanlanderImageView) {
        _endCanlanderImageView = [[HoverImageView alloc] initWithFrame:CGRectMake(0, 0, 15.38, 14.77)];
        _endCanlanderImageView.tag = 202;
        _endCanlanderImageView.delegate = self;
        _endCanlanderImageView.image = [NSImage imageNamed:@"icon-calander"];
        [self addSubview:_endCanlanderImageView];
    }
    
    return _endCanlanderImageView;
}

@end
