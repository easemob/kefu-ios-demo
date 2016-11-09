/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "FacialView.h"
#import "Emoji.h"
#import "ConvertToCommonEmoticonsHelper.h"

#define kEmojiMargin 10.f
#define kEmojiSpace 12.f

@interface FacialView () <UIScrollViewDelegate>
{
    NSDictionary *_emojiDic;
}

@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation FacialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _faces = [NSMutableArray arrayWithArray:[ConvertToCommonEmoticonsHelper emotionsArray]];
        _emojiDic = [ConvertToCommonEmoticonsHelper emotionsDictionary];
        _scrollview = [[UIScrollView alloc] initWithFrame:frame];
        _scrollview.pagingEnabled = YES;
        _scrollview.showsHorizontalScrollIndicator = NO;
        _scrollview.showsVerticalScrollIndicator = NO;
        _scrollview.alwaysBounceHorizontal = NO;
        _scrollview.delegate = self;
        _pageControl = [[UIPageControl alloc] init];
        [self addSubview:_scrollview];
        [self addSubview:_pageControl];
    }
    return self;
}


//给faces设置位置
-(void)loadFacialView:(int)page size:(CGSize)size
{
    int maxRow = 4 + 1;
    int maxCol = 8;
    int pageSize = 4 * 8;
    CGFloat itemWidth = self.frame.size.width / maxCol;
    CGFloat itemHeight = self.frame.size.height / maxRow;
    
    CGRect frame = self.frame;
    frame.size.height -= itemHeight;
    _scrollview.frame = frame;
    
    NSInteger totalPage = [_faces count]%pageSize == 0 ? [_faces count]/pageSize : [_faces count]/pageSize + 1;
    [_scrollview setContentSize:CGSizeMake(totalPage * CGRectGetWidth(self.frame), itemHeight * 4)];
    
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = totalPage;
    _pageControl.frame = CGRectMake(0, (maxRow - 1) * itemHeight + 5, CGRectGetWidth(self.frame), itemHeight - 10);
    _pageControl.pageIndicatorTintColor = RGBACOLOR(170, 170, 170, 1);
    _pageControl.currentPageIndicatorTintColor = RGBACOLOR(73, 73, 73, 1);
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setFrame:CGRectMake(CGRectGetWidth(self.frame) - 10.f - (itemWidth + 25), CGRectGetHeight(self.frame) - 40, itemWidth + 25, 32)];
    [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setBackgroundColor:RGBACOLOR(41, 170, 234, 1)];
    sendButton.layer.cornerRadius = 2.5f;
    [self addSubview:sendButton];
    
    for (int i = 0; i < totalPage; i ++) {
        for (int row = 0; row < maxRow - 1; row++) {
            for (int col = 0; col < maxCol; col++) {
                int index = i * pageSize + row * maxCol + col;
                if (index != 0 && (index - (pageSize-1))%pageSize == 0) {
                    [_faces insertObject:@"" atIndex:index];
                    break;
                }
                if (index < [_faces count]) {
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    [button setBackgroundColor:[UIColor clearColor]];
                    [button setFrame:CGRectMake(kEmojiMargin + i * CGRectGetWidth(self.frame) + col * itemWidth + col * kEmojiSpace, row * kEmojiSpace + row * itemHeight + kEmojiSpace, itemWidth, itemHeight)];
                    [button setFrame:CGRectMake(i * CGRectGetWidth(self.frame) + col * itemWidth, row * itemHeight, itemWidth, itemHeight)];
                    [button.titleLabel setFont:[UIFont fontWithName:@"AppleColorEmoji" size:29.0]];
                    NSString *imageName = [_emojiDic valueForKey:[_faces objectAtIndex:index]];
                    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                    button.tag = index;
                    [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
                    [_scrollview addSubview:button];
                }
                else{
                    break;
                }
            }
        }
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setBackgroundColor:[UIColor clearColor]];
        [deleteButton setFrame:CGRectMake(i * CGRectGetWidth(self.frame) + (8 - 1) * itemWidth + (itemWidth - 32)/2, (4 - 1) * itemHeight+(itemHeight - 32)/2, 32, 32)];
        [deleteButton setImage:[UIImage imageNamed:@"icon_faceborad_delete"] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"icon_faceborad_delete"] forState:UIControlStateHighlighted];
        deleteButton.tag = 10000;
        [deleteButton addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollview addSubview:deleteButton];
    }
}


-(void)selected:(UIButton*)bt
{
    if (bt.tag == 10000 && _delegate) {
        [_delegate deleteSelected:nil];
    }else{
        NSString *str = [_faces objectAtIndex:bt.tag];
        if (_delegate) {
            [_delegate selectedFacialView:str];
        }
    }
}

- (void)sendAction:(id)sender
{
    if (_delegate) {
        [_delegate sendFace];
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset =  scrollView.contentOffset;
    if (offset.x == 0) {
        _pageControl.currentPage = 0;
    } else {
        int page = offset.x / CGRectGetWidth(scrollView.frame);
        _pageControl.currentPage = page;
    }
}
@end
