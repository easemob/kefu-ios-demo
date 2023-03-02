//
//  HDVideoAnswerView.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/5/12.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDVECInitLayoutModel.h"
#import "HDVideoVerticalAlignmentLabel.h"
#import "HDVECAnswerCallBackView.h"
/*
 *
 */
typedef NS_ENUM (NSInteger, HDVECCallType) {
    HDVECDirectionSend    = 0,    /**  发送视频邀请   */
    HDVECDirectionReceive,           /**接受视频邀请  */
};

typedef NS_ENUM (NSInteger, HDVECProcessType) {
    HDVECProcessWaiting    = 0,    /**  等待页面   */
    HDVECProcessInitiate,          /**发起页面  */
    HDVECProcessLineUp,            /**排队页面  */
    HDVECProcessConnection,        /**接通中  */
    HDVECProcessEnd,               /**结束页面  */
};


NS_ASSUME_NONNULL_BEGIN

typedef void(^HDVECClickVideoOnBlock)(UIButton *btn);
typedef void(^HDVECClickVideoOffBlock)(UIButton *btn);
typedef void(^HDVECClickVideoOnCallBlock)(UIButton *btn);
typedef void(^HDVECClickCloseCallBlock)(UIButton *btn);
@interface HDVECAnswerView : UIView
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIImageView *bgImageView;
//@property (nonatomic, strong) UIButton *onBtn;
//@property (nonatomic, strong) UIButton *offBtn;
@property (nonatomic, strong) UIButton *hangUpBtn;
@property (nonatomic, strong) UILabel *hangUpLabel;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) HDVideoVerticalAlignmentLabel *answerLabel;
@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, copy) HDVECClickVideoOnBlock clickOnBlock;
@property (nonatomic, copy) HDVECClickVideoOffBlock clickOffBlock;
@property (nonatomic, copy) HDVECClickVideoOnCallBlock clickVideoOnCallBlock;
@property (nonatomic, copy) HDVECClickCloseCallBlock clickCloseCallBlock;
@property (nonatomic, assign) HDVECCallType callType;
@property (nonatomic, assign) BOOL isAnswerCallBack;
@property (nonatomic, assign) HDVECProcessType processType;
@property (nonatomic, strong) HDVECAnswerCallBackView *answerCallBackView;

-(void) hd_createUIWithCallType:(HDVECCallType )callType;
- (void)updateServiceLayoutConfig:(HDVECInitLayoutModel *)model;
- (void)endCallLayout;
- (HDVECInitLayoutModel*)getSettingModel;




@end

NS_ASSUME_NONNULL_END
