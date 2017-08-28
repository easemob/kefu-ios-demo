//
//  HEvaluationDegreeModel.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 17/8/25.
//  Copyright © 2017年 easemob. All rights reserved.
//

#import "HEvaluationDegreeModel.h"

@implementation HEvaluationDegreeModel

+ (instancetype)evaluationDegreeWithDict:(NSDictionary *)dict
{
    HEvaluationDegreeModel *evaluationDegree = [[HEvaluationDegreeModel alloc] init];
    [evaluationDegree setValuesForKeysWithDictionary:dict];
    return evaluationDegree;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.evaluationDegreeId = value;
    }
}

@end
