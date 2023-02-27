//
//  HDCallViewController.h
//  HLtest
//
//  Created by houli on 2022/3/4.
//

#import <UIKit/UIKit.h>
#import "HDVECAnswerView.h"
#import "HDVECSuspendCustomView.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, HDVECCallAlertType) {
    HDVECCallAlertTypeVideo, //  视频界面
};
@interface HDVECCallViewController : UIViewController
typedef void (^HDVECHangUpVideoCallback)(HDVECCallViewController *callVC, NSString *timeStr);
@property (nonatomic, copy) HDVECHangUpVideoCallback hangUpVideoCallback;
@property (nonatomic, assign) BOOL  isShow;//是否已经调用过show方法
@property (nonatomic, strong) HDVECAnswerView *hdVideoAnswerView;
@property (nonatomic, assign) BOOL isVisitorSend;
@property (nonatomic, assign) HDVECSuspendType suspendType;
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
- (void)showViewWithKeyCenter:(HDKeyCenter *)keyCenter withType:(HDVECCallType)type withVisitornickName:(NSString *)aNickname;
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
+ (HDVECCallViewController *)hasReceivedCallWithKeyCenter:(HDKeyCenter *)keyCenter
                                             avatarStr:(NSString *)aAvatarStr
                                              nickName:(NSString *)aNickname
                                        hangUpCallBack:(HDVECHangUpVideoCallback)callback;
@end

NS_ASSUME_NONNULL_END
