//
//  HEvaluationDegreeModel.h
//  CustomerSystem-ios
//
//  Created by EaseMob on 17/8/25.
//  Copyright © 2017年 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HEvaluationDegreeModel : NSObject

@property (nonatomic, strong) NSArray *appraiseTags;

@property (nonatomic, assign) NSNumber *evaluationDegreeId;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) NSInteger score;

+ (instancetype)evaluationDegreeWithDict:(NSDictionary *)dict;

@end
