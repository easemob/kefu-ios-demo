//
//  OrderInfo.h
//  helpdesk_sdk
//
//  Created by 赵 蕾 on 16/5/5.
//  Copyright © 2016年 hyphenate. All rights reserved.
//

#import "HContent.h"

@interface HOrderInfo : HContent
@property (nonatomic) NSString* title;
@property (nonatomic) NSString* orderTitle;
@property (nonatomic) NSString* price;
@property (nonatomic) NSString* imageUrl;
@property (nonatomic) NSString* itemUrl;
@property (nonatomic) NSString* desc;

@end
