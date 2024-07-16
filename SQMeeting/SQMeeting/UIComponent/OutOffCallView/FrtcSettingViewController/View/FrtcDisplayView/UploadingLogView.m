#import "UploadingLogView.h"
#import "FrtcMultiTypesButton.h"
#import "UploadingLogWindow.h"
#import "FrtcCall.h"
#import "NumberLimiteFormatter.h"
#import "FrtcBorderTextField.h"
#include <sys/sysctl.h>

@interface UploadingLogView () <NSTextFieldDelegate, UploadingLogWindowDelegate>

@property (nonatomic, strong) NSImageView               *imageView;

@property (nonatomic, strong) NSTextField               *uploadLogDetailText;

@property (nonatomic, strong) NSTextField               *textField1;

@property (nonatomic, strong) NSTextField               *textFiled2;

@property (nonatomic, strong) FrtcBorderTextField             *logIssueDescriptionTextField;

@property (nonatomic, strong) FrtcMultiTypesButton                  *upLoadingButton;

@property (nonatomic, assign) NSInteger                 uploadId;

@property (nonatomic, strong) NSTimer                   *showTimer;

@end

@implementation UploadingLogView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)init {
    self = [super init];
    
    if(self) {
        [self configLogView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        [self configLogView];
    }
    
    return self;
}

- (void)configLogView {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(28);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(72);
        make.height.mas_equalTo(72);
    }];
    
    [self.uploadLogDetailText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(16);
        make.left.mas_equalTo(24);
        make.width.mas_equalTo(407);
        make.height.mas_equalTo(44);
    }];
    
    [self.textField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.uploadLogDetailText.mas_bottom).offset(33);
        make.left.mas_equalTo(24);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.textFiled2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.uploadLogDetailText.mas_bottom).offset(33);
        make.left.mas_equalTo(self.textField1.mas_right);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.logIssueDescriptionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textFiled2.mas_bottom).offset(6);
        make.left.mas_equalTo(24);
        make.width.mas_equalTo(408);
        make.height.mas_equalTo(100);
    }];
    
    [self.upLoadingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logIssueDescriptionTextField.mas_bottom).offset(16);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(128);
        make.height.mas_equalTo(36);
    }];
}

- (void)countTime {
    NSString *status = [[FrtcCall sharedFrtcCall] frtcGetUploadStatus:(int)(self.uploadId)];
    NSLog(@"status = %@",status);
}

#pragma mark --UploadingLogWindowDelegate
- (void)loadingClose {
    self.logIssueDescriptionTextField.stringValue = @"";
    _upLoadingButton.layer.backgroundColor = [NSColor colorWithRed:2/255.0 green:111/255.0 blue:254/255.0 alpha:0.3].CGColor;
    _upLoadingButton.hover = NO;
}

#pragma mark -- NSTextField delegate
- (void)controlTextDidChange:(NSNotification *)obj {
    if([self.logIssueDescriptionTextField.stringValue length] > 0) {
        //self.upLoadingButton.enabled = YES;
        
        _upLoadingButton.layer.backgroundColor = [NSColor colorWithRed:2/255.0 green:111/255.0 blue:254/255.0 alpha:1.0].CGColor;
        _upLoadingButton.hover = YES;
    } else {
        //self.upLoadingButton.enabled = NO;
        _upLoadingButton.layer.backgroundColor = [NSColor colorWithRed:2/255.0 green:111/255.0 blue:254/255.0 alpha:0.3].CGColor;
        _upLoadingButton.hover = NO;
    }
}

#pragma mark --Button Sender--
- (void)onUpLoadingPressed {
    if([self.logIssueDescriptionTextField.stringValue isEqualToString: @""] || self.logIssueDescriptionTextField.stringValue == nil) {
        return;
    }
    
    UploadingLogWindow *uploadLogWindow = [[UploadingLogWindow alloc] initWithSize:NSMakeSize(380, 332)];
    uploadLogWindow.titleVisibility       = NSWindowTitleHidden;
    uploadLogWindow.loadingDelegate = self;

    [uploadLogWindow showWindowWithWindow:self.window];
    NSString *issue;
    
    if(self.logIssueDescriptionTextField.stringValue != nil) {
        issue = self.logIssueDescriptionTextField.stringValue;
    } else {
        issue = @"bug";
    }
    
    NSDictionary *mateData = @{@"version":[self softwareVersion],@"platform":@"mac",@"os":[self systemVersion],@"device":[self modelName],@"issue":issue};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mateData options:0 error:0];
    NSString *loadInfo = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [uploadLogWindow upLoadLogProcess:loadInfo];
}

- (NSString *)modelName {
    size_t size;
    sysctlbyname("hw.model", NULL, &size, NULL, 0);
    char* model = (char *)malloc(size);
    sysctlbyname("hw.model", model, &size, NULL, 0);
    NSString* macModel = [[NSString alloc] initWithBytesNoCopy:model length:size encoding:NSUTF8StringEncoding freeWhenDone:YES];
    
    return macModel;
}

- (NSString *)systemVersion {
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    
    NSOperatingSystemVersion osVersion = [processInfo operatingSystemVersion];
    NSString *systemVersion = [NSString stringWithFormat:@"%ld.%ld.%ld",osVersion.majorVersion, osVersion.minorVersion, osVersion.patchVersion];
    
    return systemVersion;
}

- (NSString *)softwareVersion {
    NSString *majorNumber = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey];
    NSString *buildNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *softwareVersion = [NSString stringWithFormat:@"%@.%@", majorNumber, buildNumber];
    
    return softwareVersion;
}


#pragma mark --lazy load function--
- (NSImageView *)imageView {
    if (!_imageView){
        _imageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 108, 108)];
        [_imageView setImage:[NSImage imageNamed:@"icon_upload_log"]];
        _imageView.imageAlignment = NSImageAlignTopLeft;
        _imageView.imageScaling = NSImageScaleAxesIndependently;
        [self addSubview:_imageView];
    }
    
    return _imageView;
}

- (NSTextField *)uploadLogDetailText {
    if (!_uploadLogDetailText) {
        NSMutableParagraphStyle *textParagraph = [[NSMutableParagraphStyle alloc] init];
        [textParagraph setLineSpacing:10.0];
        textParagraph.alignment = NSTextAlignmentLeft;
        textParagraph.lineBreakMode = NSLineBreakByWordWrapping;
        
        NSDictionary *attrDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph,NSParagraphStyleAttributeName, nil];
        
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_UPLOAD_LOG_FILES_DETAIL", @"If you encounted an error while using App, please upload log to help us locate and solve the problem. Thank you!") attributes:attrDic];
        

        _uploadLogDetailText = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_uploadLogDetailText setAttributedStringValue:attrString];

        _uploadLogDetailText.bordered = NO;
        _uploadLogDetailText.drawsBackground = NO;
        _uploadLogDetailText.backgroundColor = [NSColor clearColor];
        _uploadLogDetailText.textColor = [NSColor colorWithString:@"999999" andAlpha:1.0];
        _uploadLogDetailText.font = [NSFont systemFontOfSize:13];
        _uploadLogDetailText.alignment = NSTextAlignmentLeft;
        _uploadLogDetailText.maximumNumberOfLines = 0;
        _uploadLogDetailText.editable = NO;
        [self addSubview:_uploadLogDetailText];
    }
    
    return _uploadLogDetailText;
}

- (NSTextField *)textField1 {
    if (!_textField1) {
        _textField1 = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _textField1.bordered = NO;
        _textField1.drawsBackground = NO;
        _textField1.backgroundColor = [NSColor clearColor];
        _textField1.textColor = [NSColor colorWithString:@"EB5F5E" andAlpha:1.0];
        _textField1.font = [NSFont systemFontOfSize:14];
        _textField1.alignment = NSTextAlignmentLeft;
        _textField1.maximumNumberOfLines = 0;
        _textField1.editable = NO;
        _textField1.stringValue = @"* ";
        [self addSubview:_textField1];
    }
    
    return _textField1;
}

- (NSTextField *)textFiled2 {
    if (!_textFiled2) {
        _textFiled2 = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _textFiled2.bordered = NO;
        _textFiled2.drawsBackground = NO;
        _textFiled2.backgroundColor = [NSColor clearColor];
        _textFiled2.textColor = [NSColor colorWithString:@"666666" andAlpha:1.0];
        _textFiled2.font = [NSFont systemFontOfSize:14 weight:NSFontWeightMedium];
        _textFiled2.alignment = NSTextAlignmentLeft;
        _textFiled2.maximumNumberOfLines = 0;
        _textFiled2.editable = NO;
        _textFiled2.stringValue = NSLocalizedString(@"FM_UPLOAD_LOG_ISSUE_DESCRIPTION", @"Problem Description");
        [self addSubview:_textFiled2];
    }
    
    return _textFiled2;
}

- (FrtcBorderTextField *)logIssueDescriptionTextField {
    if (!_logIssueDescriptionTextField) {
        _logIssueDescriptionTextField = [[FrtcBorderTextField alloc] initWithFrame:CGRectMake(0, 0, 332, 36)];
        _logIssueDescriptionTextField.editable = YES;
        _logIssueDescriptionTextField.bordered = YES;
        _logIssueDescriptionTextField.tag = 201;
        _logIssueDescriptionTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _logIssueDescriptionTextField.alignment = NSTextAlignmentLeft;
        [_logIssueDescriptionTextField setFocusRingType:NSFocusRingTypeNone];
        [_logIssueDescriptionTextField.cell setFont:[NSFont systemFontOfSize:12]];
        _logIssueDescriptionTextField.wantsLayer = YES;
        _logIssueDescriptionTextField.layer.backgroundColor = [NSColor whiteColor].CGColor;
        _logIssueDescriptionTextField.layer.borderColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
        _logIssueDescriptionTextField.layer.borderWidth = 1.0;
        _logIssueDescriptionTextField.placeholderString = NSLocalizedString(@"FM_UPLOAD_LOG_PLACHEHOLDER", @"Please describe what went wrong（required, within 100 words）");
        _logIssueDescriptionTextField.layer.cornerRadius = 4.0f;
        _logIssueDescriptionTextField.maximumNumberOfLines = 0;
        _logIssueDescriptionTextField.delegate = self;
        _logIssueDescriptionTextField.lineBreakMode = NSLineBreakByCharWrapping;
        NumberLimiteFormatter *formatter = [[NumberLimiteFormatter alloc] init];
        [formatter setMaximumLength:100];
        [_logIssueDescriptionTextField setFormatter:formatter];
        //_meetingDescriptionTextField.delegate = self;
        _logIssueDescriptionTextField.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        [self addSubview:_logIssueDescriptionTextField];
    }
    
    return _logIssueDescriptionTextField;
}

- (FrtcMultiTypesButton *)upLoadingButton {
    if (!_upLoadingButton){
        _upLoadingButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 128, 36) withTitle:NSLocalizedString(@"FM_UPLOAD_LOG", @"Upload Log")];
        _upLoadingButton.target = self;
        _upLoadingButton.layer.cornerRadius = 4.0;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_UPLOAD_LOG", @"Upload Log")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[[FrtcBaseImplement baseImpleSingleton] whiteColor]
                          range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [_upLoadingButton setAttributedTitle:attrTitle];
        _upLoadingButton.layer.backgroundColor = [NSColor colorWithRed:2/255.0 green:111/255.0 blue:254/255.0 alpha:0.3].CGColor;
        _upLoadingButton.action = @selector(onUpLoadingPressed);
        _upLoadingButton.hover = NO;
        //_upLoadingButton.enabled = NO;
        [self addSubview:_upLoadingButton];
    }
    
    return _upLoadingButton;
}



@end
