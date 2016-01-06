//
//  EaseChatViewController.h
//  CustomerSystem-ios
//
//  Created by EaseMob on 15/11/9.
//  Copyright © 2015年 easemob. All rights reserved.
//

#import "EaseMessageViewController.h"

typedef NS_ENUM(NSInteger, EMDemoSaleType){
    ePreSaleType,
    eAfterSaleType,
    eSaleTypeNone
};

@interface EaseChatViewController : EaseMessageViewController

@property (nonatomic, strong) NSDictionary *commodityInfo;

- (instancetype)initWithChatter:(NSString *)chatter
                           type:(EMDemoSaleType)type;

@end
