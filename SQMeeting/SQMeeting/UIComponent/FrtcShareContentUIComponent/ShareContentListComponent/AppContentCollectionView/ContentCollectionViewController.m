#import "CollectionViewItem.h"
#import "CollectionView.h"

#import "ContentCollectionViewController.h"

@implementation ContentCollectionViewController


- (void)viewDidLoad {
   [super viewDidLoad];
   [self createCollectionView];
}

- (void)viewWillAppear {
    [super viewWillAppear];
    [_collectionView reloadData];
}

- (void)createCollectionView {
    NSCollectionViewFlowLayout *layout = [[NSCollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 10; //row space
    layout.minimumInteritemSpacing = 10; //column space
    layout.itemSize = NSMakeSize(110, 110);
    layout.scrollDirection = NSCollectionViewScrollDirectionVertical;
    layout.sectionInset = NSEdgeInsetsMake(0, 0, 0, 0);

    self.collectionView = [[NSCollectionView alloc] initWithFrame:NSMakeRect(0, 16, 600, 400)];
    self.collectionView.collectionViewLayout = layout;
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView setSelectable:YES];
    
    [self.collectionView registerClass:[CollectionViewItem class]forItemWithIdentifier:@"Slide"];

    _scrollView = [[NSScrollView alloc]initWithFrame:NSMakeRect(0, 0, 600, 400)];
    
    
    [_scrollView setDocumentView:_collectionView];
    
    [_collectionView setWantsLayer:YES];
    _collectionView.layer.backgroundColor = [NSColor colorWithString:@"#F8F9FA" andAlpha:1.0].CGColor;
    
    [self.view addSubview:_scrollView];
    
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self dataSource];

}

- (void)dataSource{
    NSLog(@"cat dataSource");
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
    
    [self.collectionView reloadData];
}

- (NSScrollView *) backGoundView {
    NSTextField *testField1 = [NSTextField labelWithString:@"桌面-222"];
    testField1.frame = CGRectMake(10, 10, 114, 20);
    testField1.textColor = [NSColor yellowColor];

    NSScrollView *_backGoundView;
    if (!_backGoundView) {
        _backGoundView = [[NSScrollView alloc] init];
        _backGoundView.frame = CGRectMake(10, 100, 400, 300);
        _backGoundView.wantsLayer = YES;
        _backGoundView.layer.backgroundColor = [NSColor greenColor].CGColor;
        _backGoundView.hasVerticalScroller = YES;
        _backGoundView.hasHorizontalScroller = NO;
        _backGoundView.scrollerStyle = NSScrollerStyleOverlay;
        _backGoundView.scrollerKnobStyle = NSScrollerKnobStyleDark;
        _backGoundView.scrollsDynamically = YES;
        _backGoundView.autohidesScrollers = NO;
        _backGoundView.verticalScroller.hidden = NO;
        _backGoundView.horizontalScroller.hidden = YES;
        _backGoundView.automaticallyAdjustsContentInsets = NO;
        _backGoundView.backgroundColor = [NSColor whiteColor];
        [self.view addSubview:_backGoundView];
    }

    return _backGoundView;
}

#pragma mark- NSCollectionViewDelegate

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    NSLog(@"----%lu", (unsigned long)collectionView.selectionIndexes.firstIndex);
}

#pragma mark- NSCollectionViewDataSource

- (NSInteger)collectionView:(NSCollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {

    if (self.tempdata.count == 0) {
        return 0;
    }

    return self.tempdata.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView {
    
    return 1;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView
     itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewItem *item = [collectionView makeItemWithIdentifier:@"Slide" forIndexPath:indexPath];

    item.representedObject = self.tempdata[indexPath.item];
    item.view.wantsLayer = YES;
    item.view.layer.borderColor = [NSColor grayColor].CGColor;
    item.view.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
    
    return item;
}


- (void)mouseEntered:(NSEvent *)event {

}


@end
