#import "FrtcDetailTimeView.h"
#import "DetailTimeTextField.h"

@interface FrtcDetailTimeView ()<NSTextFieldDelegate, NSControlTextEditingDelegate>

@property (nonatomic, strong) NSTextField *minTextField;

@property (nonatomic, strong) NSTextField *textField;

@property (nonatomic, strong) NSTextField *secTextField;
@end

@implementation FrtcDetailTimeView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        self.layer.cornerRadius = 4;
       
        [self setupNewView];
    }
    
    return self;
}


- (void)setupNewView {
    [self.minTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(6);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
        
    [self.secTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.minTextField.mas_right);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

- (NSTextField *)minTextField {
    if (!_minTextField) {
        _minTextField = [[NSTextField alloc] init];
        _minTextField.stringValue = @"";
        _minTextField.layer.backgroundColor = [NSColor whiteColor].CGColor;
        _minTextField.backgroundColor = [NSColor clearColor];
        _minTextField.alignment = NSTextAlignmentLeft;
        _minTextField.textColor = [NSColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];

        _minTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightMedium];
        _minTextField.bordered = NO;
        _minTextField.delegate = self;
        _minTextField.maximumNumberOfLines = 1;
     
        _minTextField.editable = YES;
        _minTextField.tag = 201;
        [self addSubview:_minTextField];
    }
    
    return _minTextField;
}

- (NSTextField *)textField {
    if (!_textField) {
        _textField =  [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _textField.backgroundColor = [NSColor clearColor];
        _textField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightMedium];
        _textField.alignment = NSTextAlignmentCenter;
        _textField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _textField.bordered = NO;
        _textField.editable = NO;
        _textField.stringValue = @":";
        [self addSubview:_textField];
    }
    
    return _textField;
}

- (NSTextField *)secTextField {
    if (!_secTextField) {
        _secTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _secTextField.delegate = self;
        _secTextField.stringValue = @"12345";
        _secTextField.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        _secTextField.editable = YES;
        _secTextField.maximumNumberOfLines = 1;
        _secTextField.tag = 202;
        [self addSubview:_secTextField];
    }
    
    return _secTextField;
}


@end
