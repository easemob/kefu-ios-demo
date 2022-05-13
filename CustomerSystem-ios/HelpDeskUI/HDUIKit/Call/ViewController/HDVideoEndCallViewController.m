//
//  HDVideoEndCallViewController.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/5/13.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDVideoEndCallViewController.h"
#import "HDAppSkin.h"
#import "CSDemoAccountManager.h"
@interface HDVideoEndCallViewController ()

@end
static dispatch_once_t onceToken;
 
static HDVideoEndCallViewController *_manger = nil;
@implementation HDVideoEndCallViewController
#pragma mark- 单利
 
/** 单利创建
 */
 
+ (instancetype)sharedManager
{
    dispatch_once(&onceToken, ^{
        _manger = [[HDVideoEndCallViewController alloc] init];
        UIWindow *window = [UIApplication sharedApplication].keyWindow ;
        window.windowLevel = UIWindowLevelAlert+3;
        _manger.view.frame = [UIScreen mainScreen].bounds;
        [window  addSubview:_manger.view];
    });
 
    return _manger;
 
}
 
/** 单利销毁
*/
 
- (void)removeSharedManager
{
    [self.view removeFromSuperview];
    self.view = nil;
    /**只有置成0，GCD才会认为它从未执行过。它默认为0。
     这样才能保证下次再次调用sharedManager的时候，再次创建对象。*/
    onceToken= 0;
    _manger=nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.hdVideoAnswerView];
    [self.hdVideoAnswerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset([UIScreen mainScreen].bounds.size.width * 0.8);
            make.height.offset([UIScreen mainScreen].bounds.size.width * 0.8 * 1.3);
            make.centerX.mas_equalTo(self.view);
            make.centerY.mas_equalTo(self.view);
        }];
}
- (void)createVideoCall{
    //这个地方是真正发消息邀请视频的代码
    CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
    HDMessage *message = [HDClient.sharedClient.callManager creteVideoInviteMessageWithImId:lgM.cname content: NSLocalizedString(@"em_chat_invite_video_call", @"em_chat_invite_video_call")];
    [message addContent:lgM.visitorInfo];
    
    [self _sendMessage:message];
    
}

- (void)_sendMessage:(HDMessage *)aMessage
{
    
//    __weak typeof(self) weakself = self;
    
    [[HDClient sharedClient].chatManager sendMessage:aMessage
                                            progress:nil
                                          completion:^(HDMessage *message, HDError *error)
     {
        if (!error) {
        
        }
        else {
        
        }
    }];
    
}

- (HDVideoAnswerView *)hdVideoAnswerView{
   if (!_hdVideoAnswerView) {
       _hdVideoAnswerView = [[HDVideoAnswerView alloc]init];
//       _hdVideoAnswerView.backgroundColor = [UIColor blackColor];
       _hdVideoAnswerView.layer.borderWidth = 1;
       _hdVideoAnswerView.layer.borderColor = [[HDAppSkin mainSkin] contentColorGrayWhithWite].CGColor;
       _hdVideoAnswerView.layer.cornerRadius = 10.0f;
       _hdVideoAnswerView.layer.masksToBounds = YES;

       __weak __typeof__(self) weakSelf = self;
       _hdVideoAnswerView.clickOnBlock = ^(UIButton * _Nonnull btn) {
//           [weakSelf anwersBtnClicked:btn];
       };
       _hdVideoAnswerView.clickOffBlock = ^(UIButton * _Nonnull btn) {
//           [weakSelf offBtnClicked:btn];
       };
       _hdVideoAnswerView.clickVideoOnCallBlock = ^(UIButton * _Nonnull btn) {
          //发送 视频邀请 参数
           [weakSelf createVideoCall];
       };
       _hdVideoAnswerView.clickCloseCallBlock = ^(UIButton * _Nonnull btn) {
          //真正关闭页面
           [[HDVideoEndCallViewController sharedManager] removeSharedManager];
       };
    }
    return _hdVideoAnswerView;
}

@end
