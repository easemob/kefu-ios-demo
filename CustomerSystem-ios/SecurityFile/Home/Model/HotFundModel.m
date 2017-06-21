//
//  HotFundModel.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 17/6/20.
//  Copyright © 2017年 easemob. All rights reserved.
//

#import "HotFundModel.h"

@implementation HotFundModel

+ (instancetype)hotFundWithDict:(NSDictionary *)dict
{
    HotFundModel *hotFund = [[HotFundModel alloc] init];
    [hotFund setValuesForKeysWithDictionary:dict];
    return hotFund;
}

@end
