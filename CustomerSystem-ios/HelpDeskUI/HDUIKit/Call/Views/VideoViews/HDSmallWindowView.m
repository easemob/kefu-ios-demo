//
//  HDSmallWindowView.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/3/4.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDSmallWindowView.h"
#import "HDCallCollectionViewCell.h"
#define fDeviceWidth ([UIScreen mainScreen].bounds.size.width)
#define fDeviceHeight ([UIScreen mainScreen].bounds.size.height)
#define kPoirtSpace  10
@interface HDSmallWindowView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSMutableArray *_cellArray;     //collectionView数据
}
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) HDCallCollectionViewCell *currentCell;
@end
@implementation HDSmallWindowView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = [UIColor grayColor];
        /**
         *  创建collectionView self自动调用setter getter方法
         */
        [self addSubview:self.collectionView];
        
    }
    return self;
}

- (void)setItemData:(NSArray<HDCallCollectionViewCellItem *> *)items{
    
    //collectionView数据
    _cellArray = [items mutableCopy];
    
    [self.collectionView reloadData];
}
- (void)setSelectCallItemChangeVideoView:(HDCallCollectionViewCellItem *)item withIndex:(NSInteger)index{
   
    
    [_cellArray replaceObjectAtIndex:index withObject:item];
    
    [self.collectionView reloadData];
}

- (void)refreshView:(UIView *)view withScreen:(BOOL)landscape{

    
    
    
}
- (BOOL)setThirdUserdidJoined:(HDCallCollectionViewCellItem *)item{
    BOOL isNeedAdd = YES;
    @synchronized(_cellArray){
        for (HDCallCollectionViewCellItem * tt in _cellArray) {
            if (tt.uid  == item.uid) {
                isNeedAdd = NO;
                break;
            }
        }
        if (isNeedAdd) {
            [_cellArray addObject: item];
        }
    };
    return isNeedAdd;
}
- (void)removeCurrentCellItem:(HDCallCollectionViewCellItem *)item{
    
//    [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathWithIndex:0]];
    
    [_cellArray removeObject:item];

    
}
- (void)addCurrentCellItem:(HDCallCollectionViewCellItem *)item{
    
    [_cellArray addObject:item];
    
    [self reloadData];
}
- (void)reloadData{
    
    [self.collectionView reloadData];
    
}
-(NSArray *)items{
    
    return _cellArray;
    
}
#pragma mark - 创建collectionView并设置代理

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:_flowLayout];
        _collectionView.showsVerticalScrollIndicator = FALSE;
        _collectionView.showsHorizontalScrollIndicator = FALSE;
//        //定义每个UICollectionView 的大小
//        float with = [UIScreen mainScreen].bounds.size.width;
//
//        _flowLayout.itemSize = CGSizeMake(84+84*0.3,84);
        //定义每个UICollectionView 横向的间距
        _flowLayout.minimumLineSpacing = 25;
        //定义每个UICollectionView 纵向的间距
        _flowLayout.minimumInteritemSpacing = 0;
        //定义每个UICollectionView 的边距距
//        flowLayout.sectionInset = UIEdgeInsetsMake(0, 25, 5, 25);//上左下右
        //注册cell和ReusableView（相当于头部）
        [_collectionView registerClass:[HDCallCollectionViewCell class] forCellWithReuseIdentifier:@"HDCallCollectionViewCell"];
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //背景颜色
        _collectionView.backgroundColor = [UIColor clearColor];
        //自适应大小
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _collectionView;
}

#pragma mark - UICollectionView delegate dataSource

#pragma mark 定义展示的UICollectionViewCell的个数

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_cellArray count];

}
#pragma mark 定义展示的Section的个数

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView

{
    return 1;
}
#pragma mark 每个UICollectionView展示的内容

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *identify = @"HDCallCollectionViewCell";
    HDCallCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];

    cell.item = _cellArray[indexPath.item];

    return cell;

}
- (void)setAudioMuted:(HDCallCollectionViewCellItem *)item{
    if ([_cellArray containsObject:item]) {
        NSInteger index = [_cellArray indexOfObject:item];
        [self setSelectCallItemChangeVideoView:item withIndex:index];
        
       }
}


 
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
 

#pragma mark UICollectionView被选中时调用的方法

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    if (self.clickCellItemBlock) {
        self.clickCellItemBlock(_cellArray[indexPath.item], indexPath);
    }
     
    self.currentCell = (HDCallCollectionViewCell *)  [self.collectionView cellForItemAtIndexPath:indexPath];
    
//    [self.collectionView reloadData];
    NSLog(@"选择%ld",indexPath.item);

}
//定义每个UICollectionView 的边距
-(UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//边距的顺序是 上左下右
  return UIEdgeInsetsMake(0,0,0,0);
}


//2、设置Cell的大小
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath

{

CGFloat screenWith=fDeviceWidth;

//每行2个Cell

CGFloat cellWidth=(screenWith-4*kPoirtSpace)/3;

return CGSizeMake(cellWidth,collectionView.frame.size.height);

}



@end
