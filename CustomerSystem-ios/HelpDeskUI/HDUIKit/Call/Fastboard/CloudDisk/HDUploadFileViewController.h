//
//  HDUploadFileViewController.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/4/8.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDUploadFileViewController : UIViewController
typedef void (^HDUploadFileResultBlock)(NSDictionary *dic);
@property (nonatomic, copy) HDUploadFileResultBlock hdUploadFileResultBlock;
@end

NS_ASSUME_NONNULL_END
