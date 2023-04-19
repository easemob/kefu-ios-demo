//
//  HDCallAppManger.m
//  CustomerSystem-ios
//
//  Created by easemob on 2023/3/24.
//  Copyright © 2023 easemob. All rights reserved.
//

#import "HDCallAppManger.h"
#import "HDVECCallViewController.h"
#import "HDCallViewController.h"
#import "HDAgoraCallManager.h"
#import "HDVECAgoraCallManager.h"
@interface HDCallAppManger()<HDCallManagerDelegate>

//online
@property (strong, nonatomic) HDCallViewController *callViewController;

@end

@implementation HDCallAppManger
static HDCallAppManger *shareCall = nil;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareCall = [[HDCallAppManger alloc] init];
       
    });
    return shareCall;
}

- (void)initAddCallObserver{
    
    // 用于添加语音呼入的监听 onCallReceivedNickName:
    [HDClient.sharedClient.callManager addDelegate:self delegateQueue:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vecAction:) name:KNOTIFICATION_VEC object:nil];
    
    
}
#pragma mark - HDCallManagerDelegate
- (void)onCallReceivedParameter:(HDKeyCenter *)keyCenter withMessage:(HDMessage *)message{
    
    if ([[HDClient sharedClient].chatManager isVECMessage:message]) {
        [HDLog logI:@"================vec1.2=====收到坐席回呼cmd消息: "];
        if (keyCenter && keyCenter.isAgentCancelCallbackReceive) {
            [[HDVECCallViewController sharedManager]  removeView];
            [[HDVECCallViewController sharedManager] removeSharedManager];
        }else{
        
        [[HDVECCallViewController sharedManager] showViewWithKeyCenter:keyCenter withType:HDVECDirectionReceive withVisitornickName:keyCenter.visitorNickName];
        [HDVECCallViewController sharedManager].hangUpVideoCallback = ^(HDVECCallViewController * _Nonnull callVC, NSString * _Nonnull timeStr) {
            [[HDVECCallViewController sharedManager]  removeView];

            [[HDVECCallViewController sharedManager] removeSharedManager];

        };
        }
    }else{
    
        //online
        [[HDCallViewController sharedManager] showViewWithKeyCenter:keyCenter withType:HDVideoCallDirectionReceive];
        [HDCallViewController sharedManager].hangUpCallback = ^(HDCallViewController * _Nonnull callVC, NSString * _Nonnull timeStr) {

            [[HDCallViewController sharedManager]  removeView];
            [[HDCallViewController sharedManager] removeSharedManager];

           };
    }
    
}
- (void)vecAction:(NSNotification *)notification{
    
    if ([notification.object isKindOfClass:[HDVECCallInputModel class]]) {
        
        HDVECCallInputModel *model =notification.object;
        
        switch (model.videoInputType) {
            case HDCallVideoInputDefault:
                
                [self vecCallDefaultWithInputModel:model];
                
                break;
            case HDCallVideoInputGuidance:
                // 询前引导 过来的视频邀请
                
            @try {
                   
                [self vecGuidanceParDic:notification.userInfo withModel:model];
                    
                    
                } @catch (NSException *exception) {
                    
                }
               
                break;
                
            default:
                break;
        }
        
      
       
       return;
    }
    

    
}
- (void)vecCallDefaultWithInputModel:(HDVECCallInputModel *)model{
    
    
    //调起vec 界面
    [[HDVECAgoraCallManager shareInstance] vec_showMainWindowWithVideoInputModel:model];
    
   
    
}

/// 询前引导 调用方法
/// @param userInfo  加入视频 需要的参数
- (void)vecGuidanceParDic:(NSDictionary *)par  withModel:(HDVECCallInputModel *)model{
  
    HDConversation * conversation = [par valueForKey:@"easemob_currentConversation"];
    HDMenuItem * item = [par valueForKey:@"easemob_currentHDMenuItem"];
        
    NSDictionary *pluginConfig = [HDMessage getIndependentVideoPluginConfig:item];
        //解析数据
    if (pluginConfig&&[pluginConfig isKindOfClass:[NSDictionary class]]&&[[pluginConfig allKeys] containsObject:@"appConfig"] ) {
            
            NSDictionary * appConfig = [pluginConfig valueForKey:@"appConfig"];
            
            NSString * configId = [appConfig valueForKey:@"configId"];
            
            NSDictionary * configJsonDic = [appConfig valueForKey:@"configJson"];
            
            NSString * imServiceNum = configJsonDic[@"channel"][@"to"];
            
            HDMessage * tmpMessage = [conversation latestMessage];
            
            NSString * sessionId=  [[HDClient sharedClient].chatManager getMessageServiceSessionId:tmpMessage];
            
            NSLog(@"======%@",sessionId);
            
            [[HDClient sharedClient].chatManager fetchCurrentVisitorId:conversation.conversationId completion:^(HDError *aError, NSString *visitorId) {
                
                [[HDClient sharedClient].chatManager cec_closeServiceSessionId:sessionId withImServiceNum:conversation.conversationId Completion:^(id responseObject, HDError *error) {
                    
                }];
                
                if (visitorId) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 创建vec 视频 这个地方可以传值 也可以在监听通知的时候
                
                        if (configId == nil || imServiceNum == nil) {
                            
                            return;
                        }
                        model.vec_cecSessionId = sessionId;
                        model.vec_cecVisitorId = visitorId;
                        model.vec_imServiceNum = imServiceNum;
                        model.vec_configid = configId;
                        //调起vec 界面
                        [[HDVECAgoraCallManager shareInstance] vec_showMainWindowWithVideoInputModel:model];
                        
                    });
                }
               
            }];
        }
}

//online
-(HDCallViewController *)callViewController{
    
    if (!_callViewController) {
        _callViewController = [HDCallViewController alertCallWithView:nil];
        _callViewController.hangUpCallback = ^(HDCallViewController * _Nonnull callVC, NSString * _Nonnull timeStr) {
            [callVC removeView];
            _callViewController = nil;
        };
    }
    
    return _callViewController;
    
}
- (NSDictionary *)dictWithString:(NSString *)string {
    if (string && 0 != string.length) {
        NSError *error;
        NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            return nil;
        }
        return jsonDict;
    }
    
    return nil;
}
@end
