//
//  HMessageHelper.h
//  helpdesk_sdk
//
//  Created by liyuzhao on 14/09/2017.
//  Copyright © 2017 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    HExtGeneralMsg,  // 默认选项，一般为正常的文本消息
    HExtEvaluationMsg, // 满意度评价消息
    HExtOrderMsg, // 订单消息
    HExtTrackMsg, // 轨迹消息
    HExtFormMsg, // 表单消息
    HExtRobotMenuMsg, // 机器人菜单消息
    HExtArticleMsg, // 图文混排消息
    HExtToCustomServiceMsg, // 转人工客服消息
    HExtBigExpressionMsg // 大表情消息
}HExtMsgType;



@interface HMessageHelper : NSObject

+ (HExtMsgType)getMessageExtType:(HMessage *)message; // 检测是哪种消息类型
+ (BOOL)isTrackMessage:(HMessage *)message;     //轨迹消息
+ (BOOL)isOrderMessage:(HMessage *)message;     //订单消息
+ (BOOL)isMenuMessage:(HMessage *)message;      //菜单消息
+ (BOOL)isToCustomServiceMessage:(HMessage *)message;  //转人工客服消息
+ (BOOL)isEvaluationMessage:(HMessage *)message;  //满意度评价消息
+ (BOOL)isFormMessage:(HMessage *)message; //机器人表单消息
+ (BOOL)isBigExpressionMessage:(HMessage *)message; //大表情消息




@end
