#import "FrtcScreenBorderView.h"
#import "FrtcBaseImplement.h"
#import "CallResultReminderView.h"

#define SIZE 4

@interface FrtcScreenBorderView ()

@property (nonatomic, strong) CallResultReminderView    *reminderView;

@property (strong, nonatomic) NSTimer   *reminderTipsTimer;

@end

@implementation FrtcScreenBorderView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [[[FrtcBaseImplement baseImpleSingleton] sharingBarColor] set];
    
    NSRectFill(self.bounds);
    
    NSRect rect = NSMakeRect(dirtyRect.origin.x + SIZE, 
                             dirtyRect.origin.y + SIZE,
                             dirtyRect.size.width - SIZE * 2, 
                             dirtyRect.size.height - SIZE * 2);
    
    NSRectFillUsingOperation(rect,
                             NSCompositingOperationClear);
}

- (void)dealloc {
    [self cancelTimer];
}

- (BOOL)isFlipped {
    return YES;
}

- (void)showReminderView:(NSString *)stringValue {
    NSString *reminderValue  = stringValue;
    NSFont *font             = [NSFont systemFontOfSize:14.0f];
    NSDictionary *attributes = @{ NSFontAttributeName:font };
    CGSize size              = [reminderValue sizeWithAttributes:attributes];
    
    [self.reminderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(size.width + 28);
        make.height.mas_equalTo(size.height + 20);
    }];
    
    self.reminderView.tipLabel.stringValue = reminderValue;
    self.reminderView.hidden = NO;
    [self runningTimer:2.0];
}

#pragma mark- --timer--
- (void)runningTimer:(NSTimeInterval)timeInterval {
    self.reminderTipsTimer = [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(reminderTipsEvent) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.reminderTipsTimer forMode:NSRunLoopCommonModes];
}

- (void)cancelTimer {
    if(_reminderTipsTimer != nil) {
        [_reminderTipsTimer invalidate];
        _reminderTipsTimer = nil;
    }
}

- (void)reminderTipsEvent {
    [self.reminderView setHidden:YES];
}

- (CallResultReminderView *)reminderView {
    if(!_reminderView) {
        _reminderView = [[CallResultReminderView alloc] initWithFrame:CGRectMake(0, 0, 172, 40)];
        _reminderView.tipLabel.stringValue = @"主持人已开启静音";
        _reminderView.hidden = YES;
        
        [self addSubview:_reminderView];
    }
    
    return _reminderView;
}

@end
