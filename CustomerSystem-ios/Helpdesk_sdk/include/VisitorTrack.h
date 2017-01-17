//
//  VisitorTrack.h
//  helpdesk_sdk
//
//  Created by 赵 蕾 on 16/5/5.
//  Copyright © 2016年 hyphenate. All rights reserved.
//  用户轨迹消息

#import "HContent.h"

@interface VisitorTrack : HContent
@property (nonatomic) NSString* title;
@property (nonatomic) NSString* price;  //价格
@property (nonatomic) NSString* imageUrl; //商品图片
@property (nonatomic) NSString* itemUrl; //商品链接
@property (nonatomic) NSString* desc;
@end
