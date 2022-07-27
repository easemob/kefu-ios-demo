/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EMDemoSaleType){
    ePreSaleType,
    eAfterSaleType,
    eSaleTypeNone
};

@interface ChatViewController : UIViewController

@property (nonatomic, strong) NSString *chatter;
@property (nonatomic, strong) NSDictionary *commodityInfo;

- (instancetype)initWithChatter:(NSString *)chatter
                        isGroup:(BOOL)isGroup;

- (instancetype)initWithChatter:(NSString *)chatter
                        type:(EMDemoSaleType)type;

- (void)reloadData;

- (void)sendCommodityMessageWithImage:(UIImage *)image ext:(NSDictionary *)ext;

@end
