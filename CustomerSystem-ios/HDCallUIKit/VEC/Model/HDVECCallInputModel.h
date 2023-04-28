//
//  HDVECGuidanceModel.h
//  CustomerSystem-ios
//
//  Created by easemob on 2023/4/11.
//  Copyright © 2023 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, HDCallVideoInputType){
    HDCallVideoInputDefault=100,   // 默认入口 正常视频邀请洁面
    HDCallVideoInputGuidance //   询前引导 入口


};
NS_ASSUME_NONNULL_BEGIN

@interface HDVECCallInputModel : NSObject
@property (nonatomic, assign) HDCallVideoInputType videoInputType;
@property (nonatomic, strong) NSString *vec_configid;
@property (nonatomic, strong) NSString *vec_imServiceNum;
@property (nonatomic, strong) NSString *vec_cecSessionId; // cec的会话id  会话跳转到 vec 使用
@property (nonatomic, strong) NSString *vec_cecVisitorId; // cec的访客id  会话跳转到 vec 使用
@property (nonatomic, strong) HDVisitorInfo *visitorInfo; //访客信息
@property (nonatomic, strong) NSString *cec_imServiceNum; // 会话的im服务号
@end

NS_ASSUME_NONNULL_END
