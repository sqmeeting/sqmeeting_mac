#import "CollectionViewItem.h"
#import "CollectionView.h"
#import "NSFont+Enhancement.h"
#import "NSColor+Utils.h"


@interface CollectionViewItem ()

@property (weak) IBOutlet NSImageView *collImageView;
@property (weak) IBOutlet NSImageView *appIconImageView;
@property (weak) IBOutlet NSTextField *titleField;

//@property (strong) NSImageView *collImageView;
//@property (strong) NSTextField *titleField;
@property (strong) NSTrackingArea* trackingArea;

@end

@implementation CollectionViewItem

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.view.wantsLayer = YES;
    self.view.layer.borderWidth = 1;
    self.view.layer.cornerRadius = 4;
    
    [self setup];
    [self setColors];
        
    self.view.frame = NSMakeRect(0, 0, 100, 100);
}

- (void)viewWillAppear {
    [super viewWillAppear];
    
    if(!self.representedObject) {
        return;
    }
    self.collImageView.image = [self.representedObject objectForKey:@"snapshotImage"]; //UI: show snapshot: app wiindow, or desktop
    //self.appIconImageView.image = [self.representedObject objectForKey:@"appIconImage"];
    self.titleField.stringValue = [self.representedObject objectForKey:@"title"];
}


#pragma mark - set

- (void)setup {
    _trackingArea = [[NSTrackingArea alloc] initWithRect:self.view.bounds
                                                 options:NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited | NSTrackingAssumeInside
                                                   owner:self userInfo:nil];
    [self.view addTrackingArea:_trackingArea];
}

- (void)setColors {
    [self setEnableBtnSelectedBgColorString:@"#026FFE"
                withUnSelectedBgColorString:@"#FFFFFF"];
    [self setEnableBorderSelectedBgColorString:@"#026FFE" withUnSelectedBgColorString:@"#DEDEDE"];
    [self setEnableTitleSelectedBgColorString:@"#FFFFFF" withUnSelectedBgColorString:@"#333333"];
}

- (void)setEnableBtnSelectedBgColorString:(NSString *)selectColor
              withUnSelectedBgColorString:(NSString *)unSelectColor {
    
    _btnBgColorEnableSelected = [NSColor colorWithRGBString:selectColor withAlpha:1];
    _btnBgColorEnableUnSelected = [NSColor colorWithRGBString:unSelectColor withAlpha:1];

}

- (void)setEnableBorderSelectedBgColorString:(NSString *)selectColor
                 withUnSelectedBgColorString:(NSString *)unSelectColor {
    
    _btnBorderColorEnableSelected = [NSColor colorWithRGBString:selectColor withAlpha:1];
    _btnBorderColorEnableUnSelected = [NSColor colorWithRGBString:unSelectColor withAlpha:1];
    

    
}

- (void)setEnableTitleSelectedBgColorString:(NSString *)selectColor
                withUnSelectedBgColorString:(NSString *)unSelectColor {
    
    _titleColorEnableSelected = [NSColor colorWithRGBString:selectColor withAlpha:1];
    _titleColorEnableUnSelected = [NSColor colorWithRGBString:unSelectColor withAlpha:1];
    
//    CollectionView * collectionView = (CollectionView *)[self view];
//    [collectionView setTitleColorEnableSelected:_titleColorEnableSelected];
//    [collectionView setTitleColorEnableUnSelected:_titleColorEnableUnSelected];
    
    //[self updateBtnBackgroundColor];
}


#pragma mark - tracking area

- (void)updateTrackingAreas {
    if (_trackingArea) {
        [self.view removeTrackingArea:_trackingArea];
        //[_trackingArea release];
    }
    _trackingArea = [[NSTrackingArea alloc] initWithRect:self.view.bounds
                                                 options:NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited | NSTrackingAssumeInside
                                                   owner:self
                                                userInfo:nil];
    [self.view addTrackingArea:_trackingArea];
}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    _isSelected = selected;

    if (_isSelected) {
        _titleField.textColor = _titleColorEnableSelected;
 
        self.view.wantsLayer = YES;
        self.view.layer.backgroundColor = _btnBgColorEnableSelected.CGColor;
        self.view.layer.borderColor = _btnBorderColorEnableSelected.CGColor;
    } else {
        _titleField.textColor = _titleColorEnableUnSelected;
     
        self.view.wantsLayer = YES;
        self.view.layer.backgroundColor = _btnBgColorEnableUnSelected.CGColor;
        self.view.layer.borderColor = _btnBorderColorEnableUnSelected.CGColor;
    }
}

#pragma mark - Mouse Event handler

- (void)mouseEntered:(NSEvent *)event {
    [super mouseEntered:event];
    
    if (!_isSelected) {
        self.view.layer.borderColor = _btnBorderColorEnableSelected.CGColor;
    }
}

- (void)mouseExited:(NSEvent *)event {
    [super mouseEntered:event];

    if (!_isSelected) {
        self.view.layer.borderColor = _btnBorderColorEnableUnSelected.CGColor;
    }
}

@end
