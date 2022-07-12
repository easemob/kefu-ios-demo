//
//  HDCallViewController.h
//  HLtest
//
//  Created by houli on 2022/3/4.
//

#import <UIKit/UIKit.h>
#import "HDVideoAnswerView.h"
#import "HDSuspendCustomView.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, HDVideoCallAlertType) {
    HDVideoCallAlertTypeVideo, //  视频界面
};
@interface HDVideoCallViewController : UIViewController
typedef void (^HangUpVideoCallback)(HDVideoCallViewController *callVC, NSString *timeStr);
@property (nonatomic, copy) HangUpVideoCallback hangUpVideoCallback;
@property (nonatomic, assign) BOOL  isShow;//是否已经调用过show方法
@property (nonatomic, strong) HDVideoAnswerView *hdVideoAnswerView;
@property (nonatomic, assign) BOOL isVisitorSend;
@property (nonatomic, assign) SuspendType suspendType;
@property (strong, nonatomic) UIWindow *alertWindow;

/** 单利创建 - Method
*/
 
+ (instancetype)sharedManager;
 
/** 单利销毁 - Method
*/
 
- (void)removeSharedManager;


/**
 *  视频通话界面
 */
+(id)alertCallWithView:(UIView *)view ;
/**
 *  界面展示
 */
- (void)showViewWithKeyCenter:(HDKeyCenter *)keyCenter withType:(HDVideoType)type withVisitornickName:(NSString *)aNickname;
/**
 *  界面隐藏
 */
-(void)hideView;

/**
 *  界面移除
 */
- (void)removeView;
/*!
 *  \~chinese
 *  初始化被叫页面
 *
 *  @param aAgentName  主叫坐席名称
 *  @param aAvatarStr  被叫(自己)头像名称
 *  @param aNickname   被叫(自己)昵称
 *  @param callback    呼叫结束后回调
 */
+ (HDVideoCallViewController *)hasReceivedCallWithKeyCenter:(HDKeyCenter *)keyCenter
                                             avatarStr:(NSString *)aAvatarStr
                                              nickName:(NSString *)aNickname
                                        hangUpCallBack:(HangUpVideoCallback)callback;
@end

NS_ASSUME_NONNULL_END
