#import "FrtcPopupView.h"
#import "FrtcPopupCell.h"

@interface FrtcPopupView () <FrtcPopupCellDelegate>

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger rowForFirstSection;

@end

@implementation FrtcPopupView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithSection:(NSInteger)section withMediaType:(NSInteger)type {
//    CGRect rect;
//    if(section == 1) {
//        rect = CGRectMake(0, 0, 166, 53);
//    } else {
//        NSMutableArray* camList = [[NSMutableArray alloc ] init];
//        [[FrtcCall sharedFrtcCall] frtcCameraList:camList];
//        rect = CGRectMake(0, 0, 166, 106);
//    }
    //self = [super initWithFrame:rect];
    self = [super init];
    
    if(self) {
        [self configView];
        self.section = section;
        self.type    = type;
        [self setupPopupView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        [self configView];
    }
    
    return self;
}

- (BOOL)isFlipped {
    return YES;
}

- (void)reloadPopViewData {
    if(self.popViewdelegate && [self.popViewdelegate respondsToSelector:@selector(popupViewSectionCount)]) {
        self.section = [self.popViewdelegate popupViewSectionCount];
    }
    
    [self setupPopupView];
}

- (void)configView {
    if(self.popViewdelegate && [self.popViewdelegate respondsToSelector:@selector(popupViewSectionCount)]) {
        self.section = [self.popViewdelegate popupViewSectionCount];
    }
}

- (NSInteger)itemNumberWithSection:(NSInteger)section {
    if(self.popViewdelegate && [self.popViewdelegate respondsToSelector:@selector(popupViewItemCountWithSection:)]) {
        return [self.popViewdelegate popupViewItemCountWithSection:section];
    } else {
        return -1;
    }
}

- (FrtcPopupCell *)getFrtcPopupCellWithSection:(NSInteger)section withRow:(NSInteger)row {
    if(self.popViewdelegate && [self.popViewdelegate respondsToSelector:@selector(frtcPopupViewWithSection:withRow:)]) {
        return [self.popViewdelegate frtcPopupViewWithSection:section withRow:row];
    } else {
        return nil;
    }
}

#pragma mark --FrtcPopupCellDelegate--
- (void)hoverSelectedWithSection:(NSInteger)section wihtRow:(NSInteger)row {
    if(self.popViewdelegate && [self.popViewdelegate respondsToSelector:@selector(shouldDidSelectedPopCell:withRow:)]) {
        [self.popViewdelegate shouldDidSelectedPopCell:section withRow:row];
    }
}

- (void)setupPopupView {
    for(NSInteger i = 0; i < self.section; i++) {
        NSInteger row = [self itemNumberWithSection:i];
        if(i == 0) {
            self.rowForFirstSection = row;
        }
        
        for(NSInteger j = 0; j < row; j++) {
            FrtcPopupCell *cell = [self getFrtcPopupCellWithSection:i withRow:j];
            cell.section = i;
            cell.row     = j;
            cell.cellDelegate = self;
           
            if(i == 0) {
                [cell setFrame:CGRectMake(0, 5 * (i + 1) + j * 24, 166, 24)];
            } else if(i == 1) {
                [cell setFrame:CGRectMake(0, 5 * (i + 1) + self.rowForFirstSection * 24 + j * 24, 166, 24)];
            }
            [self addSubview:cell];
        }
        
        if(self.section != 1 && i == 0) {
            NSView *line = [[NSView alloc] initWithFrame:CGRectMake(0, 5 + self.rowForFirstSection * 24 + 1, 166, 1)];
            line.wantsLayer = YES;
            line.layer.backgroundColor = [NSColor colorWithString:@"#D1D1D1" andAlpha:1.0].CGColor;
            [self addSubview:line];
        }
    }
}

@end
