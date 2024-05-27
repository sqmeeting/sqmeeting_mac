#import "FrtcModifyCancelTypeWindow.h"
#import "AppDelegate.h"
#import "FrtcButton.h"

@interface FrtcModifyCancelTypeWindow ()

@property (nonatomic, assign) NSSize        windowSize;

@property (nonatomic, assign) NSRect        windowFrame;

@property (nonatomic, strong) NSView        *parentView;

@property (nonatomic, assign) BOOL          defaultCenter;

@property (nonatomic, weak)   AppDelegate   *appDelegate;

@property (nonatomic, strong) NSTextField   *titleTextField;

@property (nonatomic, strong) NSTextField   *infoTextField;

@property (nonatomic, strong) FrtcButton *modifyNoramlButton;

@property (nonatomic, strong) FrtcButton *modifyRecurrenceButton;

@end

@implementation FrtcModifyCancelTypeWindow

- (instancetype)initWithSize:(NSSize)size {
    self = [super init];
    
    if (self) {
        self.defaultCenter = YES;
        self.releasedWhenClosed = NO;
        //self.titleVisibility = NSWindowTitleHidden;
        self.windowSize = size;
        [self setMovable:NO];
        self.titlebarAppearsTransparent = YES;
        self.backgroundColor = [NSColor whiteColor];
        self.styleMask =  NSWindowStyleMaskTitled;
        self.contentView.wantsLayer = YES;
        //self.contentView.layer.cornerRadius = 4;
        
        [[self standardWindowButton:NSWindowZoomButton] setHidden:YES];
        [[self standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
        [[self standardWindowButton:NSWindowCloseButton] setHidden:NO];
        
        self.styleMask = self.styleMask | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskClosable;
        self.titlebarAppearsTransparent = YES;
        self.backgroundColor = [NSColor whiteColor];
        [self standardWindowButton:NSWindowZoomButton].enabled = NO;
        [self standardWindowButton:NSWindowCloseButton].enabled = YES;
        
        [self standardWindowButton:NSWindowZoomButton].enabled = NO;
        [self standardWindowButton:NSWindowCloseButton].enabled = YES;
        [self standardWindowButton:NSWindowMiniaturizeButton].enabled = NO;
        [[self standardWindowButton:NSWindowZoomButton] setHidden:YES];
        [[self standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
        [[self standardWindowButton:NSWindowCloseButton] setHidden:NO];
        self.contentMaxSize = size;
        [self setupModifyCancelTypeWindowUI];
    }
    
    return self;
}

- (void)showWindow {
    self.appDelegate = (AppDelegate*)[NSApplication sharedApplication].delegate;
    NSWindow* window = [NSApplication sharedApplication].windows.firstObject;
    NSView* view = window.contentView;
    NSRect frameRelativeToWindow = [view convertRect:view.bounds toView:nil];
    NSPoint pointRelativeToScreen = [view.window convertRectToScreen:frameRelativeToWindow].origin;
    NSPoint pos = NSZeroPoint;
    if (self.defaultCenter) {
        pos.x = pointRelativeToScreen.x + (view.bounds.size.width-self.windowSize.width-view.frame.origin.x)/2;
        pos.y = pointRelativeToScreen.y + (view.bounds.size.height-self.windowSize.height-view.frame.origin.y)/2;
    } else {
        pos = self.frame.origin;
    }
    [self setFrame:NSMakeRect(0, 0, self.windowSize.width, self.windowSize.height) display:YES];
    [self setFrameOrigin:pos];
    [view.window addChildWindow:self ordered:NSWindowAbove];
    self.parentView = view;
    [self makeKeyAndOrderFront:self.parentWindow];
    
    //[self.meetingIDText.window makeFirstResponder:nil];
}

- (void)showWindowWithWindow:(NSWindow *)window {
    NSView* view = window.contentView;
    NSRect frameRelativeToWindow = [view convertRect:view.bounds toView:nil];
    NSPoint pointRelativeToScreen = [view.window convertRectToScreen:frameRelativeToWindow].origin;
    NSPoint pos = NSZeroPoint;
    if (self.defaultCenter) {
        pos.x = pointRelativeToScreen.x + (view.bounds.size.width-self.windowSize.width-view.frame.origin.x)/2;
        pos.y = pointRelativeToScreen.y + (view.bounds.size.height-self.windowSize.height-view.frame.origin.y)/2;
    } else {
        pos = self.frame.origin;
    }
    [self setFrame:NSMakeRect(0, 0, self.windowSize.width, self.windowSize.height) display:YES];
    [self setFrameOrigin:pos];
    [view.window addChildWindow:self ordered:NSWindowAbove];
    
    [self setParentView:view];
    [self makeKeyAndOrderFront:self.parentWindow];
}

- (void)adjustToSize:(NSSize)size {
    NSRect frameRelativeToWindow = [self.parentView convertRect:self.parentView.bounds toView:nil];
    NSPoint pointRelativeToScreen = [self.parentView.window convertRectToScreen:frameRelativeToWindow].origin;
    NSPoint pos = NSZeroPoint;
    pos.x = pointRelativeToScreen.x + (self.parentView.bounds.size.width-size.width-self.parentView.frame.origin.x)/2;
    pos.y = pointRelativeToScreen.y + (self.parentView.bounds.size.height-size.height-self.parentView.frame.origin.y)/2;
    [self setFrame:NSMakeRect(0, 0, size.width, size.height) display:YES];
    [self setFrameOrigin:pos];
}

- (void)setupModifyCancelTypeWindowUI {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).offset(30);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.infoTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(7);
        if([self isEnglish]) {
            make.width.mas_equalTo(294);
        } else {
            make.width.mas_greaterThanOrEqualTo(0);
        }
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.modifyRecurrenceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([self isEnglish] ? 25: 41);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-24);
        make.width.mas_equalTo([self isEnglish]? 140 : 124);
        make.height.mas_equalTo(32);
    }];
    
    [self.modifyNoramlButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([self isEnglish] ? -25: -41);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-24);
        make.width.mas_equalTo([self isEnglish] ? 126: 110);
        make.height.mas_equalTo(32);
    }];
}

#pragma mark --Internal Function--
- (BOOL)isEnglish {
    NSString * language = [FMLanguageConfig userLanguage] ? : [NSLocale preferredLanguages].firstObject;
    
    if([language hasPrefix:@"en"]) {
        return YES;
    } else {
        return NO;
    }
}

- (CGFloat)titleFont {
    if([self isEnglish]) {
        return 12.0;
    } else {
        return 14.0;
    }
}

#pragma mark --Button Sender--
- (void)onModifyRecurrencePressed:(FrtcButton *)sender {
    [self close];
    
    if(self.modifyDelegate && [self.modifyDelegate respondsToSelector:@selector(modifyMeetingWithRecurrence:withReversionID:withRow:)]) {
        [self.modifyDelegate modifyMeetingWithRecurrence:YES withReversionID:self.reversionID withRow:self.row];
    }
}

- (void)onModifyNormalPressed:(FrtcButton *)sender {
    [self close];
    
    if(self.modifyDelegate && [self.modifyDelegate respondsToSelector:@selector(modifyMeetingWithRecurrence:withReversionID:withRow:)]) {
        [self.modifyDelegate modifyMeetingWithRecurrence:NO withReversionID:self.reversionID withRow:self.row];
    }
}

#pragma mark --Lazy Load--
- (NSTextField *)titleTextField {
    if (!_titleTextField){
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.font = [NSFont systemFontOfSize:16 weight:NSFontWeightMedium];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.maximumNumberOfLines = 0;
        _titleTextField.stringValue = NSLocalizedString(@"FM_MEETING_EDIT", @"Edit");
        [self.contentView addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (NSTextField *)infoTextField {
    if (!_infoTextField){
        _infoTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _infoTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightMedium];
        _infoTextField.alignment = NSTextAlignmentCenter;
        _infoTextField.textColor = [NSColor colorWithString:@"#666666" andAlpha:1.0];
        _infoTextField.bordered = NO;
        _infoTextField.editable = NO;
        _infoTextField.maximumNumberOfLines = 0;
        _infoTextField.stringValue = NSLocalizedString(@"FM_MEETING_TYPE_MODIFY", @"You can modify this meeting or modify the series of recurring meetings");
        [self.contentView addSubview:_infoTextField];
    }
    
    return _infoTextField;
}

///FM_MEETING_TYPE_MODIFY = "You can modify this meeting or modify the series of recurring meetings";
///
- (FrtcButton *)modifyRecurrenceButton {
    if (!_modifyRecurrenceButton) {
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_MEETING_RECURRENCE_MODIFY", @"Edit Recurring Meeting") andButtonTitleFont:[NSFont systemFontOfSize:[self titleFont] weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#3588F5" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#3588F5" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_MEETING_RECURRENCE_MODIFY", @"Edit Recurring Meeting") andButtonTitleFont:[NSFont systemFontOfSize:[self titleFont] weight:NSFontWeightRegular]];
      
        _modifyRecurrenceButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 332, 36) withNormalMode:normalMode withHoverMode:hoverMode];
        _modifyRecurrenceButton.target = self;
        _modifyRecurrenceButton.hoverd = YES;
        _modifyRecurrenceButton.action = @selector(onModifyRecurrencePressed:);
        [self.contentView addSubview:_modifyRecurrenceButton];
    }
    
    return _modifyRecurrenceButton;
}

- (FrtcButton *)modifyNoramlButton {
    if (!_modifyNoramlButton) {
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_MEETING_MODIFY_RECURRENCE", @"Edit Current Meeting") andButtonTitleFont:[NSFont systemFontOfSize:[self titleFont] weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#3588F5" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#3588F5" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_MEETING_MODIFY_RECURRENCE", @"Edit Current Meeting") andButtonTitleFont:[NSFont systemFontOfSize:[self titleFont] weight:NSFontWeightRegular]];
      
        _modifyNoramlButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 332, 36) withNormalMode:normalMode withHoverMode:hoverMode];
        _modifyNoramlButton.target = self;
        _modifyNoramlButton.hoverd = YES;
        _modifyNoramlButton.action = @selector(onModifyNormalPressed:);
        [self.contentView addSubview:_modifyNoramlButton];
    }
    
    return _modifyNoramlButton;
}


@end
