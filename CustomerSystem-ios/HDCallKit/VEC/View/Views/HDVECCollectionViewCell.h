//
//  HDCallCollectionViewCell.h
//  HLtest
//
//  Created by houli on 2022/3/7.
//

#import <UIKit/UIKit.h>
#import "HDVECCollectionViewCellItem.h"
#import "UIImage+HDIconFont.h"
NS_ASSUME_NONNULL_BEGIN

@interface HDVECCollectionViewCell : UICollectionViewCell
@property(nonatomic ,strong)UIView *callView;
@property (nonatomic, strong) HDVECCollectionViewCellItem *item;
- (void)selected;

@end





NS_ASSUME_NONNULL_END
