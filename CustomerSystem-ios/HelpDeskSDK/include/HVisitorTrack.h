//
//  VisitorTrack.h
//  helpdesk_sdk
//
//  Created by 赵 蕾 on 16/5/5.
//  Copyright © 2016年 hyphenate. All rights reserved.
//  用户轨迹消息

#import "HContent.h"

@interface HVisitorTrack : HContent
@property (nonatomic) NSString* title;
@property (nonatomic) NSString* price;
@property (nonatomic) NSString* imageUrl;
@property (nonatomic) NSString* itemUrl;
@property (nonatomic) NSString* desc;
@end
