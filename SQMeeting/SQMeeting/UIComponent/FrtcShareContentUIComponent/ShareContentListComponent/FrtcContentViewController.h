#import <Cocoa/Cocoa.h>
#import "AppListModel.h"


NS_ASSUME_NONNULL_BEGIN

@protocol FrtcContentViewDelegate <NSObject>

@optional
- (void)onRleaseSelectContentWindowAndVC;

- (void)onCollectionViewSelectChangedToShareDesktopWithDisplayID:(NSInteger)row;
- (void)onCollectionViewSelectChangedToShareAppWithAppWindowID:(unsigned int)appWindowID
                                             withAppContentName:(NSString *)sourceAppContentName;

//origila version: TableView UI for selectting content..
- (void)onTableSelectedChanged:(NSInteger)row;

- (void)onMouseEnterd:(NSInteger) index;

- (void)onMouseExited:(NSInteger) index;

- (void)onSendToAudioContent:(NSInteger)sendFlag;

- (void)onShareApp;

@end

@interface FrtcContentViewController : NSViewController <NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout> {
    
}

@property (nonatomic, strong) NSArray          *tempdata;
@property (nonatomic, strong) NSCollectionView   *collectionView;
@property (nonatomic, strong) NSScrollView     *scrollView;

@property (nonatomic, strong) NSCollectionViewFlowLayout *collectionViewLayout;

@property (nonatomic, strong) NSMutableArray             *desktopList;
//@property (nonatomic, strong) NSTableView              *contentTableView;
@property (nonatomic, strong) NSScrollView               *backGoundView;

@property (nonatomic, strong) NSView               *contentSelectView;

@property (nonatomic, strong) NSImageView          *topLine;
@property (nonatomic, strong) NSImageView          *downLine;

//@property (nonatomic, copy)   NSMutableArray<NSString *> *desktopArray;
@property (nonatomic, copy) NSMutableArray<DesktopListModel *> *desktopListArray;
@property (nonatomic, copy) NSMutableArray<AppListModel *> *appListArray;

@property (nonatomic, weak) id<FrtcContentViewDelegate> delegate;

- (void)handleDesktopEvent:(NSArray *) desktopList;




@end

NS_ASSUME_NONNULL_END
