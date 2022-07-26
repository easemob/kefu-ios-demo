//
//  HDControlBarView.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/3/4.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDControlBarView.h"
#import "DXTipView.h"
#import "HDPopoverViewController.h"
#define kButtonTag  110
/*
 *  设置button位置
 */
typedef NS_ENUM (NSInteger, HDControlBarButtonHangUpLocation) {
    HDControlBarButtonHangUpLocationMiddle     = 1,    /** 中间   */
    HDControlBarButtonHangUpLocationLeft,              /** 左边   */
    HDControlBarButtonHangUpLocationRight,             /** 右边   */
};
@implementation HDControlBarModel

@end

@interface HDControlBarView ()<UIPopoverPresentationControllerDelegate>{
    
    NSArray *_barArray;// 传入的数组
    NSArray *_barArrayBtn;// view 添加的btn
}
@property (strong, nonatomic) DXTipView *tipView;

@end
@implementation HDControlBarView

- (NSMutableArray *)hd_buttonFromArrBarModels:(NSArray<HDControlBarModel *> *)barModelArr view:(UIView *)view withButtonType:(HDControlBarButtonStyle)style{
    NSMutableArray * array;
    switch (style) {
        case HDControlBarButtonStyleVideo:
            
           array = [self hd_dynamicSwitcheBarLayoutArray:barModelArr view:view];
            
            break;
        case HDControlBarButtonStyleUploadFile:
           array = [self hd_UploadSwitcheBarLayoutArray:barModelArr view:view];
            break;
        case HDControlBarButtonStyleVideoNew:
           array = [self hd_dynamicSwitcheBarLayoutArrayNew:barModelArr view:view];
            break;
        default:
            break;
    }
    return array;
}
#pragma mark - 底部导航逻辑 新版界面
- (NSMutableArray *)hd_dynamicSwitcheBarLayoutArrayNew:(NSArray<HDControlBarModel *> *)barModelArr view:(UIView *)view{
    NSMutableArray * array;
    self.backgroundColor = [UIColor whiteColor];
    
    array = [self hd_dynamicSwitcheBarLayoutArrayBaseNew:barModelArr view:view];
    
    return array;
}
#pragma mark - 底部导航逻辑
- (NSMutableArray *)hd_dynamicSwitcheBarLayoutArray:(NSArray<HDControlBarModel *> *)barModelArr view:(UIView *)view{
    NSMutableArray * array;
    self.backgroundColor = [UIColor whiteColor];
    if (barModelArr.count >= 6) {
        //前五个 水平布局 第六个 放到更多里边
        array = [self hd_dynamicSwitcheBarLayoutArrayMore:barModelArr view:view];
    }else{
        if (barModelArr.count%2 == 0) {
        //偶数 平铺 并且 挂断放到最后一位 然后 付费放到第二位
            array = [self hd_dynamicSwitcheBarLayoutArrayEvenNumber:barModelArr view:view];
            
        }else{

            array = [self hd_dynamicSwitcheBarLayoutArrayBase:barModelArr view:view];
        
        }
    }
    return array;
}
//偶数情况 4个
- (NSMutableArray *)hd_dynamicSwitcheBarLayoutArrayEvenNumber:(NSArray<HDControlBarModel *> *)barModelArr view:(UIView *)view{
    //数据做一下重新排列
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:barModelArr];
    NSMutableArray * sortArray =  [self  hd_soreBarModelArray:tmpArray withStyle:HDControlBarButtonHangUpLocationRight];
    CGFloat space = 10;
    CGFloat y = 0;
    CGFloat w = ( view.frame.size.width - space * ( barModelArr.count + 1 ) ) / barModelArr.count;
    CGFloat h = view.frame.size.height;
    
    NSMutableArray *lastArr= [NSMutableArray array];
    
    for (int i =0; i < barModelArr.count; i++)
    {
        HDControlBarModel * model =sortArray[i];
        CGFloat x = i * (w + space) + space;
        CGRect fram = CGRectMake(x , y, w, h);
        UIButton *button = [self hd_createButtonWithTag:i withFrame:fram withTitleName:model.name];
            if (i < 2) {

                [self hd_setButton:button withBackground:HDControlBarButtonBackgroundBlue withSize:button.height/1.5 withImageName:model.imageStr withSelectImage:model.selImageStr];
                
            }else if (i==barModelArr.count-1) {
                [self hd_setButton:button withBackground:HDControlBarButtonBackgroundRed withSize:button.height/1.5 withImageName:model.imageStr withSelectImage:model.selImageStr];
            }else {

                [self hd_setButton:button withBackground:HDControlBarButtonBackgroundBlue withSize:button.height/1.4 withImageName:model.imageStr withSelectImage:model.selImageStr];
            }
        
       
        [view addSubview:button];
        [lastArr addObject:button];
    }
    _barArrayBtn= lastArr;

    return lastArr;
}
//基数情况 3 和5 个
- (NSMutableArray *)hd_dynamicSwitcheBarLayoutArrayBase:(NSArray<HDControlBarModel *> *)barModelArr view:(UIView *)view{
    
    //数据做一下重新排列
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:barModelArr];
    NSMutableArray * sortArray =  [self  hd_soreBarModelArray:tmpArray withStyle:HDControlBarButtonHangUpLocationMiddle];

    if (sortArray.count > 3) {
        NSLog(@"===%@",sortArray);
        CGFloat viewWith =view.frame.size.width;
        CGFloat space = 2;
        CGFloat y = 0;
        CGFloat w = ( viewWith - space * ( barModelArr.count + 1 ) ) / barModelArr.count;
        CGFloat h = view.frame.size.height;
        
        NSMutableArray *lastArr= [NSMutableArray array];
        for (int i =0; i < sortArray.count; i++)
        {
            HDControlBarModel * model =sortArray[i];
            CGFloat x = i * (w + space) + space;
            CGRect fram = CGRectMake(x , y, w, h);
            UIButton *button = [self hd_createButtonWithTag:i withFrame:fram withTitleName:model.name];
            
            if (i < 2) {
                [self hd_setButton:button withBackground:HDControlBarButtonBackgroundBlue withSize:button.height/2 withImageName:model.imageStr withSelectImage:model.selImageStr];
                    
                }else if (i== barModelArr.count/2) {
                    [self hd_setButton:button withBackground:HDControlBarButtonBackgroundRed withSize:button.height withImageName:model.imageStr withSelectImage:model.selImageStr];
                }else {

                    [self hd_setButton:button withBackground:HDControlBarButtonBackgroundBlue withSize:button.height/2 withImageName:model.imageStr withSelectImage:model.selImageStr];
                }
            
            [view addSubview:button];
            [lastArr addObject:button];
        }
        _barArrayBtn= lastArr;
        return lastArr;
    }else{
        NSLog(@"===%@",sortArray);
        CGFloat w1= 0;
        CGFloat viewWith =view.frame.size.width - w1;
        CGFloat space = 20;
        CGFloat y = 0;
        CGFloat w = ( viewWith - space * ( barModelArr.count + 1 ) ) / barModelArr.count;
        CGFloat h = 64;
        
        NSMutableArray *lastArr= [NSMutableArray array];
        for (int i =0; i < sortArray.count; i++)
        {
            HDControlBarModel * model =sortArray[i];
            CGFloat x = i * (w + space) + space;
            CGRect fram = CGRectMake(x + w1 , y, w, h);
            UIButton *button = [self hd_createButtonWithTag:i withFrame:fram withTitleName:model.name];
                
            if (i < barModelArr.count/2 || i == barModelArr.count -1) {
                    
                [self hd_setButton:button withBackground:HDControlBarButtonBackgroundBlue withSize:button.height/1.6 withImageName:model.imageStr withSelectImage:model.selImageStr];
                    
                }else if (i== barModelArr.count/2) {

                    [self hd_setButton:button withBackground:HDControlBarButtonBackgroundRed withSize:button.height withImageName:model.imageStr withSelectImage:model.selImageStr];

                }else {
                    
                    [self hd_setButton:button withBackground:HDControlBarButtonBackgroundBlue withSize:button.height/1.6 withImageName:model.imageStr withSelectImage:model.selImageStr];

                }
      
            [view addSubview:button];
            [lastArr addObject:button];
        }
        _barArrayBtn= lastArr;
        return lastArr;
    }

   
    
}
// 多余5个 更多情况
- (NSMutableArray *)hd_dynamicSwitcheBarLayoutArrayMore:(NSArray<HDControlBarModel *> *)barModelArr view:(UIView *)view{
    CGFloat space = 20;
    CGFloat y = 15;
    CGFloat w = ( view.frame.size.width - space * ( barModelArr.count + 1 ) ) / barModelArr.count;
    CGFloat h = 60;
    
    NSMutableArray *lastArr= [NSMutableArray array];
    
    for (int i =0; i < 5; i++)
    {
        CGFloat x = i * (w + space) + space;
        CGRect fram = CGRectMake(x , y, w, h);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = fram;
        button.layer.cornerRadius=5;
        button.layer.masksToBounds =YES;
        button.tag =  i+kButtonTag;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
        //为button赋值
        [button setTitle:[NSString stringWithFormat:@"%@",barModelArr[i].name]forState:UIControlStateNormal];
         self.backgroundColor = [UIColor whiteColor];
            if (i < 2) {
                [button setImage:[UIImage imageWithIcon:barModelArr[i].imageStr inFont:kfontName size:button.size.width/2 color:[UIColor colorWithRed:206.0/255.0 green:55.0/255.0 blue:56.0/255.0 alpha:1.000] ] forState:UIControlStateNormal];
                [button setImage:[UIImage imageWithIcon:barModelArr[i].selImageStr inFont:kfontName size:button.size.width/2 color:[UIColor colorWithRed:12.0/255.0 green:110.0/255.0 blue:253.0/255.0 alpha:1.000] ] forState:UIControlStateSelected];
                
                
            }else if (i==barModelArr.count/2) {
                [button setImage:[UIImage imageWithIcon:barModelArr[i].imageStr inFont:kfontName size:button.size.width/2 color:[UIColor colorWithRed:206.0/255.0 green:55.0/255.0 blue:56.0/255.0 alpha:1.000]] forState:UIControlStateNormal];
            }else if(i==5-1){
            [button setImage:[UIImage imageWithIcon:barModelArr[i].imageStr inFont:kfontName size:button.size.width/2 color:[UIColor colorWithRed:12.0/255.0 green:110.0/255.0 blue:254.0/255.0 alpha:1.000]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageWithIcon:barModelArr[i].selImageStr inFont:kfontName size:button.size.width/2 color:[UIColor colorWithRed:12.0/255.0 green:110.0/255.0 blue:254.0/255.0 alpha:1.000] ] forState:UIControlStateSelected];
            }else{
                [button setImage:[UIImage imageWithIcon:barModelArr[i].imageStr inFont:kfontName size:button.size.width/2 color:[UIColor colorWithRed:12.0/255.0 green:110.0/255.0 blue:254.0/255.0 alpha:1.000]] forState:UIControlStateNormal];
                [button setImage:[UIImage imageWithIcon:barModelArr[i].selImageStr inFont:kfontName size:button.size.width/2 color:[UIColor colorWithRed:12.0/255.0 green:110.0/255.0 blue:254.0/255.0 alpha:1.000] ] forState:UIControlStateSelected];
            }
        
       
        [view addSubview:button];
        [lastArr addObject:button];
    }
    _barArrayBtn= lastArr;
    return lastArr;
}
// 文件上传
- (NSMutableArray *)hd_UploadSwitcheBarLayoutArray:(NSArray<HDControlBarModel *> *)barModelArr view:(UIView *)view {
    CGFloat space = 20;
    CGFloat y = 15;
    CGFloat w = ( view.frame.size.width - space * ( barModelArr.count + 1 ) ) / barModelArr.count;
    CGFloat h = 60;

    NSMutableArray *lastArr= [NSMutableArray array];
    _barArray = barModelArr;
    for (int i =0; i < barModelArr.count; i++)
    {
        CGFloat x = i * (w + space) + space;
        CGRect fram = CGRectMake(x , y, w, h);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = fram;
        button.layer.cornerRadius=5;
        button.layer.masksToBounds =YES;
        button.tag =  i+kButtonTag;

        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        //为button赋值
        [button setTitle:[NSString stringWithFormat:@"%@",barModelArr[i].name]forState:UIControlStateNormal];
        NSString * imgStr = [NSString stringWithFormat:@"HelpDeskUIResource.bundle/%@",barModelArr[i].imageStr];
        [button setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.frame.size.width + 10, -button.imageView.frame.size.height, 0);
        button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.intrinsicContentSize.height - 5, 0, 0, -button.titleLabel.intrinsicContentSize.width);
        [view addSubview:button];
        [lastArr addObject:button];
        }
    _barArrayBtn= lastArr;
    return lastArr;
}
// 设置button 图片
- (void)hd_setButton:(UIButton *)button withBackground:(HDControlBarButtonBackground)background withSize:(NSUInteger)size withImageName:(NSString *)imageStr withSelectImage:(NSString *)selImageStr{
    
    switch (background) {
        case HDControlBarButtonBackgroundRed:
            [button setImage:[UIImage imageWithIcon:imageStr inFont:kfontName size:size color: [[HDAppSkin mainSkin] contentColorRed]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageWithIcon:selImageStr inFont:kfontName size:size color:[[HDAppSkin mainSkin] contentColorBlue] ] forState:UIControlStateSelected];
            break;
        case HDControlBarButtonBackgroundBlue:
            [button setImage:[UIImage imageWithIcon:imageStr inFont:kfontName size:size color:[[HDAppSkin mainSkin] contentColorBlue] ] forState:UIControlStateNormal];
            [button setImage:[UIImage imageWithIcon:selImageStr inFont:kfontName size:size color:[[HDAppSkin mainSkin] contentColorRed] ] forState:UIControlStateSelected];
            break;
        default:
            break;
    }
    
}
// 数组根据业务需求排列
-(NSMutableArray *)hd_soreBarModelArray:(NSMutableArray *)array withStyle:(HDControlBarButtonHangUpLocation)style{
    for (HDControlBarModel * model in array) {
        if (model.isHangUp) {
            NSInteger index = [array indexOfObject:model];
            switch (style) {
                case  HDControlBarButtonHangUpLocationLeft:
                    [array exchangeObjectAtIndex:0 withObjectAtIndex:index];
                    break;
                case  HDControlBarButtonHangUpLocationRight:
                    [array exchangeObjectAtIndex:array.count-1 withObjectAtIndex:index];
                    break;
                case  HDControlBarButtonHangUpLocationMiddle:
                    [array exchangeObjectAtIndex:array.count/2 withObjectAtIndex:index];
                    break;
                default:
                    break;
            }
           
            break;
        }
    }
    _barArray = array;
    
    return array;
}
- (void)refreshView:(UIView *)view withScreen:(BOOL)landscape{
    
    CGFloat viewVidth;
    CGFloat  landscapeX;
    CGFloat h;
    if (landscape) {
        h = 50;
        viewVidth =view.frame.size.width/2;
        landscapeX =  viewVidth/2;
    }else{
        landscapeX = 0;
        viewVidth = view.frame.size.width;
        h = 60;
    }
    CGFloat space = 20;
    CGFloat y = 15;
    CGFloat w = ( viewVidth - space * ( _barArray.count + 1 ) ) / _barArray.count;
   
    for (int i =0; i < _barArray.count; i++)
    {
        CGFloat x = landscapeX + i * (w + space) + space;
        CGRect fram = CGRectMake(x , y, w, h);
        UIButton *button = _barArrayBtn[i];
        button.frame = fram;
    }
}

- (UIButton *)hd_createButtonWithTag:(NSInteger )tag withFrame:(CGRect)frame withTitleName:(NSString *)titleName{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.layer.cornerRadius=5;
    button.layer.masksToBounds =YES;
    button.tag =  tag+kButtonTag;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:[NSString stringWithFormat:@"%@",titleName]forState:UIControlStateNormal];
    
    return button;
}
- (UIButton *)hd_bttonWithTag:(NSInteger)tag withArray:(NSArray *)array{
    
    UIButton * btn;
    if (array.count> 0) {
        
        if (array.count == 3) {
            
            btn = [self viewWithTag:kButtonTag + 2];
        }else {
            
            btn = [self viewWithTag:kButtonTag + 1];
        }
        
    }
    
    return btn;
    
}




- (UIButton *)hd_bttonMuteWithTag {
    
    UIButton * btn;
      btn = [self viewWithTag:kButtonTag + 0];
      
    
    return btn;
    
}


#pragma mark - event

- (void)buttonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    NSLog(@"buttonClickButtonTag = %ld",sender.tag);
    NSInteger index = sender.tag - kButtonTag;
    NSLog(@"buttonClickTagindex = %ld",index);
    if (index >= _barArray.count || index < 0) {
        
        return;
    }
    HDControlBarModel * barModel = [_barArray objectAtIndex:index];
    
    if (self.clickControlBarItemBlock) {
        self.clickControlBarItemBlock(barModel,sender);
    }
    
}

#pragma mark - 新版界面固定5个bar
- (NSMutableArray *)hd_dynamicSwitcheBarLayoutArrayBaseNew:(NSArray<HDControlBarModel *> *)barModelArr view:(UIView *)view{
    
    //数据做一下重新排列
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:barModelArr];
    NSMutableArray * sortArray =  [self  hd_soreBarModelArray:tmpArray withStyle:HDControlBarButtonHangUpLocationMiddle];

    // 挂断宽度 固定
    CGFloat hangUpWith =80;
    
        NSLog(@"===%@",sortArray);
        CGFloat viewWith =view.frame.size.width;
        CGFloat space = 2;
        CGFloat y = 0;
        CGFloat w = ( viewWith - hangUpWith - space * ( barModelArr.count + 1 ) ) /( barModelArr.count-1);
        CGFloat h = w;
        
        NSMutableArray *lastArr= [NSMutableArray array];
        for (int i =0; i < sortArray.count; i++)
        {
            HDControlBarModel * model =sortArray[i];
            CGFloat x = i * (w + space) + space;
            CGRect fram = CGRectMake(x , y, w, h);
            UIButton *button;
            
            if (i < 2) {
               
                button = [self hd_createButtonWithTag:i withFrame:fram withTitleName:model.name];
                
                [self hd_setButton:button withBackground:HDControlBarButtonBackgroundBlue withSize:button.width/2.5 withImageName:model.imageStr withSelectImage:model.selImageStr];
                    
              
            }else if (i== 2) {
                    CGRect fram = CGRectMake(x , y, hangUpWith, hangUpWith);
                
                    button = [self hd_createButtonWithTag:i withFrame:fram withTitleName:model.name];
                    // 设置button
//                    [self hd_setButton:button withBackground:HDControlBarButtonBackgroundRed withSize:button.width*0.9 withImageName:model.imageStr withSelectImage:model.selImageStr];
            
                
                UIImage *imgSel  = [UIImage imageWithIcon2:model.imageStr inFont:kfontName size:button.width*0.8 color:[[HDAppSkin mainSkin] contentColorRed] withbackgroundColor:[[HDAppSkin mainSkin] contentColorWhitealpha:1]  ] ;
                
                [button setImage:imgSel forState:UIControlStateNormal];
                
                button.backgroundColor = [UIColor blackColor];
                
                CGRect frame = button.frame;
                frame.origin.y = -30;
                
                button.frame = frame;
                
                button.layer.cornerRadius =button.height/2;
                button.layer.masksToBounds = YES;
                
               
            
            }else if (i== 3) {
                CGFloat x = 2 * (w + space) + space + hangUpWith;
                CGRect fram = CGRectMake(x , y, w, h);
                button = [self hd_createButtonWithTag:i withFrame:fram withTitleName:model.name];
                    //消息 需要角标
                _tipView = [[DXTipView alloc] initWithFrame:CGRectMake(x + w/1.5 , 10, 20, 20)];
                _tipView.tipNumber = @"";
                [self addSubview:_tipView];
            
//                [self hd_setButton:button withBackground:HDControlBarButtonBackgroundBlue withSize:button.width/2.5 withImageName:model.imageStr withSelectImage:model.selImageStr];
//
                [button setImage:[UIImage imageWithIcon:model.imageStr inFont:kfontName size:button.width/2.5 color:[[HDAppSkin mainSkin] contentColorBlue] ] forState:UIControlStateNormal];
                
            }else {
                CGFloat x = 3 * (w + space) + space + hangUpWith;
                CGRect fram = CGRectMake(x , y, w, h);
                button = [self hd_createButtonWithTag:i withFrame:fram withTitleName:model.name];
                    //更多
                [button setImage:[UIImage imageWithIcon:model.imageStr inFont:kfontName size:button.width/2.5 color:[[HDAppSkin mainSkin] contentColorBlue] ] forState:UIControlStateNormal];
                }
    
            [view addSubview:button];
            [lastArr addObject:button];
            [self bringSubviewToFront:_tipView];
        }
        _barArrayBtn= lastArr;
        return lastArr;
}
- (void)setModel:(HDConversation *)model{
    
    
    if (model) {
        
    }else{
        
        
        _tipView.tipNumber = @"";
        
    }
    
    
}


@end
