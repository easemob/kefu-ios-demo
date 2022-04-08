//
//  HDControlBarView.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/3/4.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDControlBarView.h"
#define kButtonTag  110
@implementation HDControlBarModel


@end

@interface HDControlBarView (){
    
    NSArray *_barArray;// 传入的数组
    NSArray *_barArrayBtn;// view 添加的btn
}
@end
@implementation HDControlBarView

-(NSMutableArray *)buttonFromArrName:(NSArray <NSString *>*)nameArr
                            ImageArr:(NSArray <NSString *>*)ImageArr
                         selImageArr:(NSArray <NSString *>*)selImageArr
                                view:(UIView *)view
{
    CGFloat space = 20;
    CGFloat y = 15;
    CGFloat w = ( view.frame.size.width - space * ( nameArr.count + 1 ) ) / nameArr.count;
    CGFloat h = 60;
    
    NSMutableArray *lastArr= [NSMutableArray array];
    
    for (int i =0; i < nameArr.count; i++)
    {
        CGFloat x = i * (w + space) + space;
        CGRect fram = CGRectMake(x , y, w, h);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = fram;
        button.layer.cornerRadius=5;
        button.layer.masksToBounds =YES;
        button.tag =  i+kButtonTag;
        
//        button.backgroundColor = [UIColor yellowColor];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000]forState:UIControlStateNormal];
        
        //为button赋值
        [button setTitle:[NSString stringWithFormat:@"%@",nameArr[i]]forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:ImageArr[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selImageArr[i]] forState:UIControlStateSelected];
        [view addSubview:button];
        [lastArr addObject:button];
    }
    _barArrayBtn= lastArr;
    return lastArr;
}
- (NSMutableArray *)buttonFromArrBarModels:(NSArray<HDControlBarModel *> *)barModelArr view:(UIView *)view withButtonType:(HDControlBarButtonStyle)style{
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
        [button setTitleColor:[UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000]forState:UIControlStateNormal];
        
        //为button赋值
        [button setTitle:[NSString stringWithFormat:@"%@",barModelArr[i].name]forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        if (style == HDControlBarButtonStyleVideo) {
            if (i < 2) {
                [button setImage:[UIImage imageWithIcon:barModelArr[i].imageStr inFont:kfontName size:button.size.width/2 color:[UIColor colorWithRed:206.0/255.0 green:55.0/255.0 blue:56.0/255.0 alpha:1.000] ] forState:UIControlStateNormal];
                [button setImage:[UIImage imageWithIcon:barModelArr[i].selImageStr inFont:kfontName size:button.size.width/2 color:[UIColor colorWithRed:12.0/255.0 green:110.0/255.0 blue:253.0/255.0 alpha:1.000] ] forState:UIControlStateSelected];
            }else if (i==2) {
                [button setImage:[UIImage imageWithIcon:barModelArr[i].imageStr inFont:kfontName size:button.size.width color:[UIColor colorWithRed:206.0/255.0 green:55.0/255.0 blue:56.0/255.0 alpha:1.000]] forState:UIControlStateNormal];
            }else {
            [button setImage:[UIImage imageWithIcon:barModelArr[i].imageStr inFont:kfontName size:button.size.width/2 color:[UIColor colorWithRed:12.0/255.0 green:110.0/255.0 blue:254.0/255.0 alpha:1.000]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageWithIcon:barModelArr[i].selImageStr inFont:kfontName size:button.size.width/2 color:[UIColor colorWithRed:12.0/255.0 green:110.0/255.0 blue:254.0/255.0 alpha:1.000] ] forState:UIControlStateSelected];
            }
        }else if(style == HDControlBarButtonStyleUploadFile){
            
            //为button赋值
            [button setImage:[UIImage imageWithIcon:barModelArr[i].imageStr inFont:kfontName size:button.size.width/2 color:[UIColor colorWithRed:206.0/255.0 green:55.0/255.0 blue:56.0/255.0 alpha:1.000] ] forState:UIControlStateNormal];
            
        }
       
        [view addSubview:button];
        [lastArr addObject:button];
    }
    _barArrayBtn= lastArr;
    return lastArr;
}
//根据后台给的字符串 如果是url 就下载图片 如果不是 就使用图片
- (UIImage*)getImage:(NSString *)imageStr{
    
    if ([imageStr hasPrefix:@"http"]) {
        //下载图片后返回
        return [UIImage imageNamed:imageStr];
    }else{
        return [UIImage imageNamed:imageStr];
    }
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



@end
