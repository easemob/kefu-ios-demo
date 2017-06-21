//
//  HotFundModel.h
//  CustomerSystem-ios
//
//  Created by EaseMob on 17/6/20.
//  Copyright © 2017年 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotFundModel : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *number;

@property (nonatomic, strong) NSString *netValue;

@property (nonatomic, strong) NSString *rise;

+ (instancetype)hotFundWithDict:(NSDictionary *)dict;

@end
