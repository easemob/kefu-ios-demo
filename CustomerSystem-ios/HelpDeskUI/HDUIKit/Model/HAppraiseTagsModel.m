//
//  HAppraiseTagsModel.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 17/8/25.
//  Copyright © 2017年 easemob. All rights reserved.
//

#import "HAppraiseTagsModel.h"

@implementation HAppraiseTagsModel

+ (instancetype)appraiseTagsWithDict:(NSDictionary *)dict
{
    HAppraiseTagsModel *appraiseTags = [[HAppraiseTagsModel alloc] init];
    [appraiseTags setValuesForKeysWithDictionary:dict];
    return appraiseTags;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.appraiseTagsId = value;
    }
}

@end
