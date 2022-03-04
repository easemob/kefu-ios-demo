//
//  HDControlBarView.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/3/4.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDControlBarView.h"

@implementation HDControlBarView

-(NSMutableArray *)buttonFromArrName:(NSArray <NSString *>*)nameArr
                            ImageArr:(NSArray <NSString *>*)ImageArr
                         selImageArr:(NSArray <NSString *>*)selImageArr
                                view:(UIView *)view
{
    CGFloat space = 20;
    CGFloat y = 15;
    CGFloat w = ( view.size.width - space * ( nameArr.count + 1 ) ) / nameArr.count;
    CGFloat h = 50;
    
    NSMutableArray *lastArr= [NSMutableArray array];
    
    for (int i =0; i < nameArr.count; i++)
    {
        CGFloat x = i * (w + space) + space;
        CGRect fram = CGRectMake(x , y, w, h);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = fram;
        button.layer.cornerRadius=5;
        button.layer.masksToBounds =YES;
        button.tag =  i+1;
        
        button.backgroundColor = [UIColor yellowColor];
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
    return lastArr;
}
 
- (void)buttonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
}



@end
