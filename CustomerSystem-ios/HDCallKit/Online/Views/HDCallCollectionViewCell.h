//
//  HDCallCollectionViewCell.h
//  HLtest
//
//  Created by houli on 2022/3/7.
//

#import <UIKit/UIKit.h>
#import "HDCallCollectionViewCellItem.h"
#import "UIImage+HDIconFont.h"
NS_ASSUME_NONNULL_BEGIN

@interface HDCallCollectionViewCell : UICollectionViewCell
@property(nonatomic ,strong)UIView *callView;
@property (nonatomic, strong) HDCallCollectionViewCellItem *item;
- (void)selected;

@end





NS_ASSUME_NONNULL_END
