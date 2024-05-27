#import "FrtcContentViewController.h"
#import "FrtcBaseImplement.h"
#import "Masonry.h"

#import "HoverableButton.h"
#import "FrtcHoverButton.h"
#import "FrtcCallInterface.h"
#import "NSColor+Utils.h"

#import "ContentCollectionViewController.h"

@interface FrtcContentViewController ()

@property (nonatomic, strong) NSTextField * titleTextField;

@property (nonatomic, strong) NSButton * startShareBtn;

@property (nonatomic, strong) NSView * backgroudView;

//0: Desktop Display Content.
//1: App Content.
@property (nonatomic, assign) unsigned int contentType;
@property (nonatomic, assign) NSInteger    selectedDesktopIndex;
@property (nonatomic, assign) NSInteger    selectedAppIndex;


@property (nonatomic, strong) NSMutableArray<HoverableButton *> * contentBtnArray; //user could select.

@property (nonatomic, assign) NSInteger leftMargin;

@end

@implementation FrtcContentViewController


- (void)dealloc {
    //NSLog(@"[%s]", __func__);
}

- (void)createContentCollectionVC {
    // Do any additional setup after loading the view.
    NSLog(@"[createContentCollectionVC] Enter");
    
    ContentCollectionViewController *pVC = [[ContentCollectionViewController alloc] init];
    NSLog(@"[createContentCollectionVC] line: %d", __LINE__);
    
    pVC.view.frame = NSMakeRect(0, 0, 600, 400);
    
    NSLog(@"[createContentCollectionVC] line: %d", __LINE__);
    
    pVC.view.wantsLayer = YES;
    pVC.view.layer.backgroundColor = [NSColor cyanColor].CGColor;
    
    NSLog(@"[createContentCollectionVC] line: %d", __LINE__);
    [self.view addSubview: pVC.view];
    
    //    self.view.window.contentViewController = pVC;
    
    // [self.view.window.contentView addSubview:pVC.view];
    
    NSLog(@"[createContentCollectionVC] Leave");
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do view setup here.
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
    
    self.title = @"ok";
    
    _leftMargin = 16;
    
    //1.title Area.
    NSRect rectTitleTextField = NSMakeRect(self.view.frame.size.width / 2 - [self distance] / 2,
                                           self.view.frame.size.height - 24 - 10,
                                           [self distance], 24);
    [self titleTextField:rectTitleTextField];
    
    NSRect rectTopLine = NSMakeRect(0, self.view.frame.size.height - 40 - 1, self.view.frame.size.width, 0.5);
    NSImageView *topLineImageView = [self createTopLine: rectTopLine];
    [self.view addSubview:topLineImageView];
    
    NSRect rectContentBackgroundView = NSMakeRect(0, //16,
                                                  64 + 1 + 10 - 16, // 1: for the topLineImageView
                                                  self.view.frame.size.width,// - 16 * 2,
                                                  self.view.frame.size.height - 40 - 64 - 1*2 - 16);
    [self createCollectionView:rectContentBackgroundView];
    
    
    //3.ToolBar Area.
    NSView *toolBarView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, self.view.frame.size.width, 64)];
    [self.view addSubview:toolBarView];
    
    NSRect rectDownLine = NSMakeRect(0, 63, self.view.frame.size.width, 0.5);
    NSImageView *downLineImageView = [self createDownLine:rectDownLine];
    [toolBarView addSubview:downLineImageView];
    
    //content audio set button.
    NSRect rectContentAudioView = NSMakeRect(24, 16, [self distanceContentAudio], 32);
    [self contentAudioBtn:rectContentAudioView withView:toolBarView];
    
    //start sharing button.
    NSRect rectStartSharingBtn = [self myRect];//NSMakeRect(self.view.frame.size.width-24-88, 16, 88, 32);
    [self createStartSharingButton:rectStartSharingBtn withView:toolBarView];
}

- (CGFloat)distance {
    NSString * language = [FMLanguageConfig userLanguage] ? : [NSLocale preferredLanguages].firstObject;
    
    if ([language hasPrefix:@"en"]) {
        return 230.0;
    } else {
        return 200.0;
    }
}

- (CGFloat)distanceContentAudio {
    NSString * language = [FMLanguageConfig userLanguage] ? : [NSLocale preferredLanguages].firstObject;
    
    if ([language hasPrefix:@"en"]) {
        return 220.0;
    } else {
        return 200.0;
    }
}

- (NSRect)myRect {
    NSString * language = [FMLanguageConfig userLanguage] ? : [NSLocale preferredLanguages].firstObject;
    
    if ([language hasPrefix:@"en"]) {
        return  NSMakeRect(self.view.frame.size.width-24-88, 16, 88, 32);
    } else {
        return NSMakeRect(self.view.frame.size.width-24-88, 16, 88, 32);
    }
}

- (void)viewWillAppear {
    CGFloat windowWidth = self.view.bounds.size.width;
    CGFloat windowHeight = self.view.bounds.size.height;
    [self.view.window setRestorable:NO];
    [self.view.window setFrame:NSMakeRect(self.view.window.frame.origin.x,
                                          self.view.window.frame.origin.y,
                                          windowWidth, windowHeight) display:NO];
    self.view.window.contentView.frame = NSMakeRect(0, 0, windowWidth, windowHeight);
}

- (void)viewDidDisappear {
    [super viewDidDisappear];

    if (nil != _desktopList && 0 < [_desktopList count]) {
        [_desktopList removeAllObjects];
        _desktopList = nil;
    }
    
    if (nil != _desktopListArray && 0 < [_desktopListArray count]) {
        
        for (int i = 0; i < [_desktopList count]; ++i) {
            DesktopListModel *desktopListModel = [_desktopList objectAtIndex:i];
            if (nil != desktopListModel) {
                desktopListModel.contentIcon = nil;
                desktopListModel.displayName = nil;
                desktopListModel.snapShotImage = nil;
            }
        }
        
        [_desktopListArray removeAllObjects];
        _desktopListArray = nil;
    }
    
    if (nil != _appListArray && 0 < [_appListArray count]) {
        [_appListArray removeAllObjects];
        _appListArray = nil;
    }
}

- (NSButton *)contentAudioBtn:(NSRect)rect withView:(NSView *)view {
    NSButton *_contentAudioBtn = nil;
    if (!_contentAudioBtn){
        _contentAudioBtn = [[NSButton alloc] initWithFrame:rect];
        [_contentAudioBtn setButtonType:NSButtonTypeSwitch];
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_CONTENT_AUDIO", @"Include Computer Sound")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[[FrtcBaseImplement baseImpleSingleton] baseColor]
                          range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:16]
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [_contentAudioBtn setAttributedTitle:attrTitle];
        attrTitle = nil;
        [_contentAudioBtn setNeedsDisplay:YES];

        
        _contentAudioBtn.target = self;
        _contentAudioBtn.action = @selector(onSendContentAudio:);
        [view addSubview:_contentAudioBtn];
    }
    
    return _contentAudioBtn;
}

- (void)onSendContentAudio:(NSButton *)sender {
    [self onSendContent:sender.state];
}

- (void)createContentBackgroundView:(NSRect)rect {
    if (!_backgroudView) {
        _backgroudView = [[NSView alloc] init];
        _backgroudView.frame = rect;
        _backgroudView.wantsLayer = YES;
        _backgroudView.layer.backgroundColor = [NSColor colorWithRGBString:@"#F8F9FA" withAlpha:1].CGColor;
        _backgroudView.layer.borderColor = [NSColor colorWithRGBString:@"#D7DADD" withAlpha:1].CGColor;
        _backgroudView.layer.borderWidth = 0.5;
        [self.view addSubview:_backgroudView];
    }
}

- (void)titleTextField:(NSRect)rect {
    if (!_titleTextField) {
        _titleTextField = [[NSTextField alloc] initWithFrame:rect];
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:16 weight:NSFontWeightMedium];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"333333" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = NSLocalizedString(@"FM_SHARE_CONTENT_SOURCE", @"Please Select Content Source");
        [self.view addSubview:_titleTextField];
    }
}

- (void)createStartSharingButton:(NSRect)rect withView:(NSView *)view {
    if (!_startShareBtn) {
        _startShareBtn = [[NSButton alloc] initWithFrame:rect];
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_SHARE_CONTENT_START", @"Start Share")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[[FrtcBaseImplement baseImpleSingleton] whiteColor] range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:16] range:range];
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
        [attrTitle fixAttributesInRange:range];
        [_startShareBtn setAttributedTitle:attrTitle];
        attrTitle = nil;
        
        _startShareBtn.bordered = NO;
        _startShareBtn.wantsLayer = YES;
        _startShareBtn.layer.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] blueColor].CGColor;
        _startShareBtn.layer.cornerRadius = 4;
        [_startShareBtn setNeedsDisplay:YES];
        
        _startShareBtn.target = self;
        _startShareBtn.action = @selector(startShareBtnClick:);
        [view addSubview:_startShareBtn];
    }
}



#pragma mark- Handle Event for Select buttons.

- (void)onSelectContentButtonClickDesktop:(HoverableButton *)sender {
    NSInteger tag = [sender tag];
    self.selectedDesktopIndex = tag;
    
    NSLog(@"[onSelectContentButtonClickDesktop]: selected button tag : %ld", (long)tag);
    NSLog(@"[onSelectContentButtonClickDesktop]: selected button : %@", sender);
    
    //[sender setBtnStautsWithMouseEvent:ENUM_MOUSE_PRESSED];
    
    
    for (HoverableButton * btn in _contentBtnArray) {
        NSLog(@"[onSelectContentButtonClickDesktop]: all buttons : %@", btn);
        
        if ([btn tag] != [sender tag]) {
            NSLog(@"[onSelectContentButtonClickDesktop]: btn.tag : %ld", (long)[btn tag]);
            //[btn setBtnStautsWithMouseEvent:ENUM_MOUSE_OFF];
            
            [btn setSelected:NO];
            NSLog(@"btn.tag[%ld].isSelected : %@", (long)[btn tag], [btn getSelected]?@"Yes":@"Not");
        } else {
            [btn setSelected:YES];
            NSLog(@"btn.tag[%ld].isSelected : %@", (long)[btn tag], [btn getSelected]?@"Yes":@"Not");
        }
        
    }
}

- (void)onSendContent:(NSInteger)sendFlag {
    if ([self.delegate respondsToSelector:@selector(onSendToAudioContent:)]) {
        [self.delegate onSendToAudioContent:sendFlag];
    }
}

- (void)startShareBtnClick:(FrtcHoverButton *)sender {
    [self startShareContentBtnClick:nil];
}

- (void)startShareContentBtnClick:(FrtcHoverButton *)sender {
    switch (_contentType) {
        case 0: {
            if (0 < _desktopListArray.count) {
                DesktopListModel * desktopListModel = [_desktopListArray objectAtIndex:_selectedDesktopIndex];
                if (nil != desktopListModel) {
                    if ([self.delegate respondsToSelector:@selector(onCollectionViewSelectChangedToShareDesktopWithDisplayID:)]) {
                        [self.delegate onCollectionViewSelectChangedToShareDesktopWithDisplayID:_selectedDesktopIndex];
                    }
                }
            }
        }
            break;
        case 1: {
            if (0 < _appListArray.count) {
                AppListModel * appListModel = [_appListArray objectAtIndex:_selectedAppIndex];
                if (nil != appListModel) {
                    
                    unsigned int appWindowID = appListModel.contentKey;
                    NSString * contentName = appListModel.contentName;
                    if (self.delegate && [self.delegate respondsToSelector:@selector(onCollectionViewSelectChangedToShareAppWithAppWindowID:withAppContentName:)]) {
                        [self.delegate onCollectionViewSelectChangedToShareAppWithAppWindowID:appWindowID
                                                                           withAppContentName:contentName];
                    }
                }
            }
        }
            break;
        default: {
           
            
        }
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(onCollectionViewSelectChangedToShareDesktopWithDisplayID:)]) {
        [self.delegate onRleaseSelectContentWindowAndVC];
    }
}

#pragma mark- handle desktop data
- (void)handleDesktopEvent:(NSArray *)desktopList {
    if ([desktopList count] == 0) {
        return;
    }
    
    @autoreleasepool {
        if (nil != _desktopList && 0 < [_desktopList count]) {
            [_desktopList removeAllObjects];
            _desktopList = nil;
        }

        if (nil != _desktopListArray && 0 < [_desktopListArray count]) {
            [_desktopListArray removeAllObjects];
            _desktopListArray = nil;
        }
        
        _desktopList = [NSMutableArray array];
        [_desktopList removeAllObjects];
        [_desktopList addObjectsFromArray:desktopList];
     
        _desktopListArray = [[NSMutableArray alloc] initWithCapacity:8];
        
        for (int i = 0; i < [_desktopList count]; ++i) {
            NSDictionary *dic = [_desktopList objectAtIndex:i];
            if (nil != dic) {
                NSString *displayName = [dic objectForKey:@"name"];
                NSNumber *dispIdNumber = [dic objectForKey:@"displayID"];
                int dispId = [dispIdNumber intValue];
                
                CGImageRef cgImage = [self captureDesktopSnapshot:dispId];
                NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithCGImage:cgImage];
                CGImageRelease(cgImage);
               
                NSImage *image = [[NSImage alloc] init];
                [image addRepresentation:bitmapRep];
                bitmapRep = nil;
                
                NSImage *scaleImage = [self resizeImage:image forSize:NSMakeSize(116, 70)];
                scaleImage.size = NSMakeSize(116, 70);
                image = nil;
                
                DesktopListModel *desktopListModel = [[DesktopListModel alloc] init];
                desktopListModel.contentType = 0; //0: desktop; 1: app.
                desktopListModel.displayID = dispId;
                desktopListModel.displayName = displayName;
                desktopListModel.snapShotImage = scaleImage; //image;
                scaleImage = nil;
                
                [_desktopListArray addObject:desktopListModel];
                desktopListModel = nil;
            }
        }
        
    }
    
    [self getAppListArray];
    [self.collectionView reloadData];
}

- (CGImageRef) captureDesktopSnapshot:(int) dispId {
    CGImageRef imageRef = CGDisplayCreateImage(dispId);
    return imageRef;
}

- (CGImageRef) captureAppWindowSnapshot:(int) windowId {
    CGImageRef imageRef = CGWindowListCreateImage(CGRectNull,
                                                  kCGWindowListOptionIncludingWindow,
                                                  windowId,
                                                  kCGWindowImageBoundsIgnoreFraming);
    if (!imageRef) {
        return nullptr;
    } else {
        return imageRef;
    }
}

- (NSImage*)resizeImage:(NSImage*)sourceImage
                forSize:(CGSize)targetSize {

    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;

    CGFloat widthFactor = targetWidth / width;
    CGFloat heightFactor = targetHeight / height;
    scaleFactor = (widthFactor > heightFactor)? widthFactor : heightFactor;

    CGFloat readHeight = targetHeight / scaleFactor; // 需要读取的源图像的高度或宽度
    CGFloat readWidth = targetWidth / scaleFactor;
    CGPoint readPoint = CGPointMake(widthFactor > heightFactor? 0 : (width - readWidth) * 0.5,
                                    widthFactor < heightFactor? 0 : (height - readHeight) * 0.5);

    NSImage *newImage = [[NSImage alloc] initWithSize:targetSize];
    CGRect thumbnailRect = {{0.0, 0.0}, targetSize};
    NSRect imageRect = {readPoint, {readWidth, readHeight}};

    [newImage lockFocus];
    [sourceImage drawInRect:thumbnailRect fromRect:imageRect operation:NSCompositingOperationCopy fraction:1.0];
    [newImage unlockFocus];

    return newImage;
}

- (void)getAppListArray {
    NSArray *array = [[FrtcCall sharedFrtcCall] frtcGetApplicationList];
    if ([array count] <= 0) {
        return;
    }
    
    @autoreleasepool {
        if (nil != _appListArray && 0 < [_appListArray count]) {
            [_appListArray removeAllObjects];
            _appListArray = nil;
        }
        
        _appListArray = [[NSMutableArray alloc] initWithCapacity:8];
        for (int i = 0; i < [array count]; i++) {
            ContentSourceInfo *sourceInfo = (ContentSourceInfo *)array[i];
            
            unsigned int appWindowID = sourceInfo.contentKey;
            CGImageRef cgImage = [self captureAppWindowSnapshot:appWindowID];
            if (cgImage == nil) {
            
                
                return;
            }
            NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithCGImage:cgImage];
           
            CGImageRelease(cgImage);
         
            NSImage *snapshotImage = [[NSImage alloc] init];
            [snapshotImage addRepresentation:bitmapRep];
            
            CGFloat width = snapshotImage.size.width;
            CGFloat height = snapshotImage.size.height;
            CGFloat targetWidth = 116;
            CGFloat targetHeight = 70;
            CGFloat scaleFactor = 0.0;

            if (height >= width) {
                scaleFactor = targetHeight / height;
                targetWidth = width * scaleFactor;
            } else {
                scaleFactor = targetWidth / width;
                targetHeight = height * scaleFactor;
            }
            
            snapshotImage.size = NSMakeSize(targetWidth, targetHeight);
            bitmapRep = nil;
            
            NSImage *scaleImage = nil;
            if (nullptr == snapshotImage) {
                scaleImage = sourceInfo.contentIcon;
            } else {
                scaleImage = snapshotImage;
                scaleImage.size = NSMakeSize(targetWidth, targetHeight);

                snapshotImage = nil;
                bitmapRep = nil;
            }
            
            AppListModel *applistModel = [[AppListModel alloc] init];
            applistModel.contentKey = sourceInfo.contentKey;
            applistModel.contentType = sourceInfo.contentType;
            applistModel.contentName = sourceInfo.contentName;
            applistModel.contentShareable = sourceInfo.contentShareable;
            applistModel.contentIcon = sourceInfo.contentIcon;

            applistModel.contentWindowSnapshot = scaleImage; //snapshotImage;
            scaleImage = nil;
            
            applistModel.processId = sourceInfo.processId;
            applistModel.sessionId = sourceInfo.sessionId;
            applistModel.processName = sourceInfo.processName;
            
            [_appListArray addObject:applistModel];
            applistModel = nil;
        }
    }
}

- (void)createCollectionView:(NSRect)rect {
    NSCollectionViewFlowLayout *layout = [[NSCollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 16; //row space
    layout.minimumInteritemSpacing = 8; //column space
    layout.itemSize = NSMakeSize(152, 120);
    layout.scrollDirection = NSCollectionViewScrollDirectionVertical;
    layout.sectionInset = NSEdgeInsetsMake(0, 0, 0, 0);
    layout.sectionInset = NSEdgeInsetsMake(10, 16, 0, 0);
    self.collectionView = [[NSCollectionView alloc] initWithFrame:NSMakeRect(0, 16, rect.size.width-16*22, rect.size.height)];
    self.collectionView.collectionViewLayout = layout;
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView setSelectable:YES];
    
    [self.collectionView registerClass:[CollectionViewItem class]forItemWithIdentifier:@"Desktops_identify"];
    [self.collectionView registerClass:[CollectionViewItem class]forItemWithIdentifier:@"Apps_identify"];
 
    _scrollView = [[NSScrollView alloc]initWithFrame:NSMakeRect(16, 64, rect.size.width - 16*2, rect.size.height)];
    
    [_scrollView setDocumentView:_collectionView];
    [self.view addSubview:_scrollView];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
}


- (NSImageView *)createTopLine:(NSRect) rect {
    if (!_topLine) {
        _topLine = [[NSImageView alloc] initWithFrame:rect];
        [_topLine setImage:[NSImage imageNamed:@"gray_line_content_select"]];
        _topLine.imageAlignment =  NSImageAlignTopLeft;
        _topLine.imageScaling =  NSImageScaleAxesIndependently;
        //[self.view addSubview:_selectLine];
    }
    return _topLine;
}

- (NSImageView *)createDownLine:(NSRect) rect {
    if (!_downLine) {
        _downLine = [[NSImageView alloc] initWithFrame:rect];
        [_downLine setImage:[NSImage imageNamed:@"gray_line_content_select"]]; //icon-select-line
        _downLine.imageAlignment =  NSImageAlignTopLeft;
        _downLine.imageScaling =  NSImageScaleAxesIndependently;
        //[self.view addSubview:_selectLine];
    }
    return _downLine;
}

- (void)dataSource {
    NSImage *computerImage = [NSImage imageNamed:NSImageNameComputer];
    NSImage *open_folder_normalImage = [NSImage imageNamed:@"AppIcon"];
    NSImage *desktopImage = [NSImage imageNamed:@"AppIcon"];
    
    NSDictionary *item1 = @{
        @"title":@"Mac_",
        @"image":computerImage
    };
    NSDictionary *item2 = @{
        @"title":@"folder",
        @"image":computerImage
    };
    
    NSDictionary *item3 = @{
        @"title":@"desktop",
        @"image":desktopImage
    };
    
    self.tempdata = @[item1, item2, item3, item1, item2, item3];
}


#pragma mark- NSCollectionViewDelegate

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    NSIndexPath *indexPath = indexPaths.anyObject;
    if (!indexPath) {
        return;
    }
    
    switch (indexPath.section) {
        case 0: { //0: Desktop Display Content.
            _contentType = 0;
            _selectedDesktopIndex = indexPath.item;
        }
            break;
        case 1: { //1: App Content.
            _contentType = 1;
            _selectedAppIndex = indexPath.item;
        }
            break;
        default:
            break;
    }
}


#pragma mark- NSCollectionViewDataSource
- (NSInteger)collectionView:(NSCollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    switch (section) {
        case 0: {
            if (_desktopListArray.count == 0) {
                return 0;
            } else {
                return _desktopListArray.count;
            }
        }
            break;
        case 1: {
            if (_appListArray.count == 0) {
                return 0;
            } else {
                return _appListArray.count;
            }
        }
            break;
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView {
    NSInteger numberOfSections = 0;
    if (_desktopListArray.count > 0) {
        ++numberOfSections;
    }
    if (_appListArray.count > 0) {
        ++numberOfSections;
    }
    return numberOfSections;
}

- (CGFloat)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 16;
}

-(CGFloat)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView
     itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewItem *item = nil;
    
    switch (indexPath.section) {
        case 0: {
            item = [collectionView makeItemWithIdentifier:@"Desktops_identify" forIndexPath:indexPath];

            DesktopListModel *desktopModel = [_desktopListArray objectAtIndex:indexPath.item];
            NSDictionary *itemObject = @{
                @"snapshotImage":desktopModel.snapShotImage, //get desktop snapshot
                @"title":(desktopModel.displayName != nil ? desktopModel.displayName : @"") //@"desktop",
            };
            //item.representedObject = self.tempdata[indexPath.item];
            item.representedObject = itemObject;
            item.contentType = 0;
            item.appListModelObject = desktopModel;
        }
            break;
        case 1: {
            item = [collectionView makeItemWithIdentifier:@"Apps_identify" forIndexPath:indexPath];

            AppListModel *appModel = [_appListArray objectAtIndex:indexPath.item];
            NSDictionary *itemObject = @{
                @"snapshotImage":appModel.contentWindowSnapshot, //get app Window snapshot
                @"title":(appModel.contentName != nil ? appModel.contentName :@"") 
            };
            item.representedObject = itemObject;
            item.contentType = 1;
            item.appListModelObject = appModel;
        }
            break;
        default:
            break;
    }
    
    item.view.wantsLayer = YES;
    item.view.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
    item.view.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
    return item;
}


@end
