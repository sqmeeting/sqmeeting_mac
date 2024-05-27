#import "FrtcRtfViewController.h"
#import "FrtcMultiTypesButton.h"
#import <WebKit/WebKit.h>

@interface FrtcRtfViewController () <WebFrameLoadDelegate>

@property (nonatomic, strong) NSTextField   *titleTextField;

@property (nonatomic, strong) WebView *rtfWebView;

@property (nonatomic, strong) FrtcMultiTypesButton *alreadyReadButton;

@property (nonatomic, strong) WKWebView *myWebview;

@property (nonatomic, strong) NSTextView *textView;

@property (nonatomic, strong) NSScrollView *scrollView;

@end

@implementation FrtcRtfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
    [self setupRtfViewUI];
}

- (void)setupRtfViewUI {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(32);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(327);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.alreadyReadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-16);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(158);
        make.height.mas_equalTo(36);
     }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(13);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(344);
        make.height.mas_equalTo(567);
    }];
}

//Invoked when a page load completes.
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
    if (frame == [sender mainFrame]) {
        NSString *url = [[[[frame dataSource] request] URL]
                         absoluteString];
        NSLog(@"Loaded URL completed: %@", url);
    }
}

//Invoked if an error occurs when starting to load data for a page.
- (void)webView:(WebView *)sender didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame{
    if (frame == [sender mainFrame]) {
        NSLog(@"Load WebWidgt Failed  didFailProvisionalLoadWithError: [%s]", [[error description] UTF8String]);
    }
}

//Invoked when an error occurs loading a committed data source.
- (void)webView:(WebView *)sender didFailLoadWithError:(NSError *)error forFrame:(WebFrame *)frame {
    NSLog(@"Load WebWidgt Failed withError : [%s]", [[error description] UTF8String]);
    if (frame == [sender mainFrame]){
        NSLog(@"didFailLoadWithError:processException");
        if ([error code] == 102 || 204 == [error code]) {
            NSLog(@"Ignore Frame load interrupted error...");
        } else {
            //[self processException:error.localizedDescription];
        }
    }
}

- (void)webView:(WebView *)sender didClearWindowObject:(WebScriptObject *)windowObject forFrame:(WebFrame *)frame {
    [windowObject setValue:self forKey:@"controller"];
}

#pragma mark --butto sender--
- (void)onAlreadyePressed:(FrtcMultiTypesButton *)sender {
    if(self.rtfViewDelegate && [self.rtfViewDelegate respondsToSelector:@selector(userProtocolAlreadRead)]) {
        [self.rtfViewDelegate userProtocolAlreadRead];
    }
    
    [self.view.window orderOut:nil];
}

- (NSTextField *)titleTextField {
    if (!_titleTextField) {
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:24 weight:NSFontWeightSemibold];
        _titleTextField.alignment = NSTextAlignmentCenter;
        //_titleTextField.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleTextField.maximumNumberOfLines = 2;
        _titleTextField.textColor = [NSColor colorWithString:@"222222" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = NSLocalizedString(@"FM_PROTOCOL", @"Service and Privacy Agreement of SQ Meeting CE ");
        [self.view addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (WebView *)rtfWebView {
    if(!_rtfWebView) {
        _rtfWebView = [[WebView alloc] initWithFrame:CGRectMake(0, 0, 344, 567)];
        _rtfWebView.frameLoadDelegate = self;
     
        [self.view addSubview:_rtfWebView];
    }
    
    return _rtfWebView;
}

- (WKWebView *)myWebview {
    if(!_myWebview) {
        _myWebview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 344, 567)];
        NSURL *rtfUrl = [[NSBundle mainBundle] URLForResource:@"security" withExtension:@"rtf"];
        NSData *data = [NSData dataWithContentsOfURL:rtfUrl];
        [self.myWebview loadData:data MIMEType:@"application/rtf" characterEncodingName:@"" baseURL:rtfUrl];
        [self.view addSubview:_myWebview];
    }
    
    return _myWebview;
}

- (FrtcMultiTypesButton *)alreadyReadButton {
    if (!_alreadyReadButton) {
        _alreadyReadButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 158, 36) withTitle:NSLocalizedString(@"FM_I_HAVE_READ", @"I have read it")];
        _alreadyReadButton.hover = NO;
        _alreadyReadButton.target = self;
        _alreadyReadButton.layer.cornerRadius = 8.0;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_I_HAVE_READ", @"I have read it")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#026FFE" andAlpha:1.0]
                          range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [_alreadyReadButton setAttributedTitle:attrTitle];
        _alreadyReadButton.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
       // _alreadyReadButton.bordered = YES;
        _alreadyReadButton.action = @selector(onAlreadyePressed:);
        _alreadyReadButton.layer.borderWidth = 1.0;
        _alreadyReadButton.layer.borderColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0].CGColor;
        [self.view addSubview:_alreadyReadButton];
    }
    return _alreadyReadButton;
}

- (NSTextView *)textView {
    if (!_textView) {
        NSError *error;
        NSString *dealText = [NSString
                            stringWithContentsOfFile:[[NSBundle mainBundle]
                                                      pathForResource:@"FrtcEula"
                                                      ofType:@"txt"]
                            encoding:NSUTF8StringEncoding
                            error: &error];
        _textView = [[NSTextView alloc] initWithFrame:CGRectMake(0, 0, 344, 567)];
        _textView.editable = NO;
        //_textView.scrollableTextView;
        
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:dealText];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [dealText length])];
        [attributedString addAttribute:NSFontAttributeName
                                  value:[NSFont systemFontOfSize:14.0f]
                                  range:NSMakeRange(0, [dealText length])];
        [attributedString addAttribute:NSFontAttributeName
                                  value:[NSFont boldSystemFontOfSize:25.f]
                                  range:NSMakeRange(0, 8)];
        //[_textView setAttributedText:attributedString];
        [[_textView textStorage] setAttributedString:attributedString];
    }
    
    return _textView;
}

- (NSScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[NSScrollView alloc] init];
        [self.view addSubview:_scrollView];
        [_scrollView setHasVerticalScroller:YES];
        [_scrollView setHasHorizontalScroller:NO];
        [_scrollView setDocumentView:self.textView];
    }
    
    return _scrollView;
}

@end
