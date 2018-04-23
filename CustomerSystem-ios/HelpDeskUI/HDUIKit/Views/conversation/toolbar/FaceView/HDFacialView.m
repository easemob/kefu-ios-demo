/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */


#import "HDFacialView.h"
#import "HDEmoji.h"
#import "HDFaceView.h"
#import "HDEmotionManager.h"
#import "UIButton+WebCache.h"


@interface EmojiButton :UIButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType frame:(CGRect)frame;

@end

@implementation EmojiButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType frame:(CGRect)frame {
    EmojiButton *btn = [super buttonWithType:buttonType];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setFrame:frame];
    return btn;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageWidth = contentRect.size.width;
    CGFloat imageHeight = contentRect.size.height * (1 - 0.25);
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleX = 0;
    CGFloat titleHeight = contentRect.size.height * 0.25;
    CGFloat titleY = contentRect.size.height - titleHeight;
    CGFloat titleWidth = contentRect.size.width;
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}

@end


@interface EmojiButton (UIButtonImageWithLable)
- (void) setImage:(NSString *)url withTitle:(NSString *)title forState:(UIControlState)stateType;

- (void) setImage:(NSURL *)url withTitle:(NSString *)title forState:(UIControlState)stateType placeholderImage:(UIImage *)placeholder;
@end

@implementation EmojiButton (UIButtonImageWithLable)

- (void)setImage:(NSURL *)url withTitle:(NSString *)title forState:(UIControlState)stateType placeholderImage:(UIImage *)placeholder {
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0,
                                              0.0,
                                              20,
                                              0)];
    [self sd_setImageWithURL:url forState:stateType placeholderImage:placeholder];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [self setTitleColor:[UIColor blackColor] forState:stateType];
    
    [self setTitle:title forState:UIControlStateNormal];
}

- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType {
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0,
                                              0.0,
                                              20,
                                              0)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [self setTitleColor:[UIColor blackColor] forState:stateType];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(CGRectGetHeight(self.bounds)-20,
                                              -image.size.width,
                                              0,
                                              0.0)];
    [self setTitle:title forState:stateType];
}

@end

@protocol HDCollectionViewCellDelegate

@optional

- (void)didSendEmotion:(HDEmotion*)emotion;

@end

@interface HDCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<HDCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) EmojiButton *hdImageButton;
@property (nonatomic, strong) HDEmotion *hdEmotion;

@end

@implementation HDCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _hdImageButton = [EmojiButton buttonWithType:UIButtonTypeCustom frame:self.bounds];
        _hdImageButton.userInteractionEnabled = YES;
        [self.contentView addSubview:_hdImageButton];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _hdImageButton.frame = self.bounds;
}

- (void)setEmotion:(HDEmotion *)emotion
{
    _hdEmotion = emotion;
    if ([emotion isKindOfClass:[HDEmotion class]]) {
        if (emotion.emotionType == HDEmotionGif) {
            [_hdImageButton setImage:[NSURL URLWithString:emotion.emotionThumbnail] withTitle:emotion.emotionTitle forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading"]];
//            [_hdImageButton setImage:[UIImage imageNamed:emotion.emotionThumbnail] withTitle:emotion.emotionTitle forState:UIControlStateNormal];
        } else if (emotion.emotionType == HDEmotionPng) {
            [_hdImageButton setImage:[UIImage imageNamed:emotion.emotionThumbnail] forState:UIControlStateNormal];
            _hdImageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [_hdImageButton setTitle:nil forState:UIControlStateNormal];
            [_hdImageButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [_hdImageButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        } else {
            [_hdImageButton.titleLabel setFont:[UIFont fontWithName:@"AppleColorEmoji" size:29.0]];
            [_hdImageButton setTitle:emotion.emotionThumbnail forState:UIControlStateNormal];
            [_hdImageButton setImage:nil forState:UIControlStateNormal];
            [_hdImageButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [_hdImageButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        [_hdImageButton addTarget:self action:@selector(sendEmotion:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [_hdImageButton setTitle:nil forState:UIControlStateNormal];
        [_hdImageButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_hdImageButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_hdImageButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/faceDelete"] forState:UIControlStateNormal];
        [_hdImageButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/faceDelete_select"] forState:UIControlStateHighlighted];
        [_hdImageButton addTarget:self action:@selector(sendEmotion:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)sendEmotion:(id)sender
{
    if (_delegate) {
        if ([_hdEmotion isKindOfClass:[HDEmotion class]]) {
            [_delegate didSendEmotion:_hdEmotion];
        } else {
            [_delegate didSendEmotion:nil];
        }
    }
}

@end

@interface HDFacialView () <UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HDCollectionViewCellDelegate>
{
    CGFloat _itemWidth;
    CGFloat _itemHeight;
}

@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *emotionManagers;

@end

@implementation HDFacialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pageControl = [[UIPageControl alloc] init];
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        [self.collectionView registerClass:[HDCollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.pagingEnabled = YES;
        _collectionView.userInteractionEnabled = YES;
//        [self addSubview:_scrollview];
        [self addSubview:_pageControl];
        [self addSubview:_collectionView];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section < [_emotionManagers count]) {
        HDEmotionManager *emotionManager = [_emotionManagers objectAtIndex:section];
        return [emotionManager.emotions count];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (_emotionManagers == nil || [_emotionManagers count] == 0) {
        return 1;
    }
    return [_emotionManagers count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identify = @"collectionCell";
    HDCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (!cell) {
        
    }
    [cell sizeToFit];
    HDEmotionManager *emotionManager = [_emotionManagers objectAtIndex:indexPath.section];
    HDEmotion *emotion = [emotionManager.emotions objectAtIndex:indexPath.row];
    cell.emotion = emotion;
    cell.userInteractionEnabled = YES;
    cell.delegate = self;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    HDEmotionManager *emotionManager = [_emotionManagers objectAtIndex:section];
    CGFloat itemWidth = self.frame.size.width / emotionManager.emotionCol;
    NSInteger pageSize = emotionManager.emotionRow*emotionManager.emotionCol;
    NSInteger lastPage = (pageSize - [emotionManager.emotions count]%pageSize);
    if (lastPage < emotionManager.emotionRow ||[emotionManager.emotions count]%pageSize == 0) {
        return CGSizeMake(0, 0);
    } else{
        NSInteger size = lastPage/emotionManager.emotionRow;
        return CGSizeMake(size*itemWidth, self.frame.size.height);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        reusableview = headerView;
        
    }
    if (kind == UICollectionElementKindSectionFooter){
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        reusableview = footerview;
    }
    return reusableview;
}

#pragma mark --UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HDEmotionManager *emotionManager = [_emotionManagers objectAtIndex:indexPath.section];
    NSInteger maxRow = emotionManager.emotionRow;
    NSInteger maxCol = emotionManager.emotionCol;
    CGFloat itemWidth = self.frame.size.width / maxCol;
    CGFloat itemHeight = (self.frame.size.height) / maxRow;
    return CGSizeMake(itemWidth, itemHeight);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma makr - HDCollectionViewCellDelegate
//if判断里面加了png格式的发送
#pragma mark smallpngface
- (void)didSendEmotion:(HDEmotion *)emotion
{
    if (emotion) {
        if (emotion.emotionType == HDEmotionDefault || emotion.emotionType == HDEmotionPng) {
            if (_delegate) {
                [_delegate selectedFacialView:emotion.emotionId];
            }
        } else {
            if (_delegate) {
                [_delegate sendFace:emotion];
            }
        }
    } else {
        [_delegate deleteSelected:nil];
    }
}

-(void)loadFacialView:(NSArray*)emotionManagers size:(CGSize)size
{
    for (UIView *view in [self.scrollview subviews]) {
        [view removeFromSuperview];
    }
    _emotionManagers = emotionManagers;
    [_collectionView reloadData];
}

-(void)loadFacialViewWithPage:(NSInteger)page
{
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:page]
                            atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                    animated:NO];
    CGPoint offSet = _collectionView.contentOffset;
    if (page == 0) {
        [_collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
    } else {
        [_collectionView setContentOffset:CGPointMake(CGRectGetWidth(self.frame)*((int)(offSet.x/CGRectGetWidth(self.frame))+1), 0) animated:NO];
    }
//    [_collectionView setContentOffset:CGPointMake(CGRectGetWidth(self.frame)*2, 0) animated:NO];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

@end
