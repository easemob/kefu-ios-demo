//
//  HDCallAppManger.h
//  CustomerSystem-ios
//
//  Created by easemob on 2023/3/24.
//  Copyright © 2023 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KNOTIFICATION_VEC @"hd_easemob_vec_call"
NS_ASSUME_NONNULL_BEGIN

@interface HDCallAppManger : NSObject

+ (instancetype _Nullable )shareInstance;

///视频界面 监听通知进行界面处理 ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️ 参考商城demo 发送通知格式及要求 在任何您想要弹VEC视频的界面添加此方法即可
///需要注意 一定是先监听 然后 在发通知
-(void)initAddCallObserver;



- (NSDictionary *)dictWithString:(NSString *)string;





@end

NS_ASSUME_NONNULL_END
