//
//  QRCodeViewController.h
//  CustomerSystem-ios
//
//  Created by afanda on 16/12/13.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCodeViewController : UIViewController

@property (nonatomic,copy) void (^qrBlock)(NSDictionary *dic);

@end
