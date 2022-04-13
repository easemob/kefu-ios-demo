//
//  HDCallViewController.h
//  HLtest
//
//  Created by houli on 2022/3/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDCallViewController : UIViewController
typedef void (^HangUpCallback)(HDCallViewController *callVC, NSString *timeStr);
@property (nonatomic, copy) HangUpCallback hangUpCallback;
/*!
 *  \~chinese
 *  初始化被叫页面
 *
 *  @param aAgentName  主叫坐席名称
 *  @param aAvatarStr  被叫(自己)头像名称
 *  @param aNickname   被叫(自己)昵称
 *  @param callback    呼叫结束后回调
 */
+ (HDCallViewController *)hasReceivedCallWithKeyCenter:(HDKeyCenter *)keyCenter
                                             avatarStr:(NSString *)aAvatarStr
                                              nickName:(NSString *)aNickname
                                        hangUpCallBack:(HangUpCallback)callback;
@end

NS_ASSUME_NONNULL_END
