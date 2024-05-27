#import <Cocoa/Cocoa.h>
#import "CollectionViewItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContentCollectionViewController : NSViewController<NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout> {
    
}

@property (nonatomic, strong) NSArray          *tempdata;
@property (nonatomic, strong) NSCollectionView   *collectionView;
@property (nonatomic, strong) NSScrollView     *scrollView;

@property (nonatomic, strong) NSCollectionViewFlowLayout *collectionViewLayout;

@end

NS_ASSUME_NONNULL_END
