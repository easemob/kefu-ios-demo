//
//  HAppraiseTagsModel.h
//  CustomerSystem-ios
//
//  Created by EaseMob on 17/8/25.
//  Copyright © 2017年 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HAppraiseTagsModel : NSObject

@property (nonatomic, assign) NSInteger evaluationDegreeId;

@property (nonatomic, assign) NSNumber *appraiseTagsId;

@property (nonatomic, strong) NSString *name;

+ (instancetype)appraiseTagsWithDict:(NSDictionary *)dict;

@end
