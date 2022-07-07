//
//  HDVideoAnswerView.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/5/12.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDVideoLayoutModel.h"
#import "HDVideoVerticalAlignmentLabel.h"
#import "HDVideoAnswerCallBackView.h"
/*
 *
 */
typedef NS_ENUM (NSInteger, HDVideoType) {
    HDVideoDirectionSend    = 0,    /**  发送视频邀请   */
    HDVideoDirectionReceive,           /**接受视频邀请  */
};

typedef NS_ENUM (NSInteger, HDVideoProcessType) {
    HDVideoProcessWaiting    = 0,    /**  等待页面   */
    HDVideoProcessInitiate,          /**发起页面  */
    HDVideoProcessLineUp,            /**排队页面  */
    HDVideoProcessConnection,        /**接通中  */
    HDVideoProcessEnd,               /**结束页面  */
};


NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickVideoOnBlock)(UIButton *btn);
typedef void(^ClickVideoOffBlock)(UIButton *btn);
typedef void(^ClickVideoOnCallBlock)(UIButton *btn);
typedef void(^ClickCloseCallBlock)(UIButton *btn);
@interface HDVideoAnswerView : UIView
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
@property (nonatomic, copy) ClickVideoOnBlock clickOnBlock;
@property (nonatomic, copy) ClickVideoOffBlock clickOffBlock;
@property (nonatomic, copy) ClickVideoOnCallBlock clickVideoOnCallBlock;
@property (nonatomic, copy) ClickCloseCallBlock clickCloseCallBlock;
@property (nonatomic, assign) HDVideoType callType;
@property (nonatomic, assign) BOOL isAnswerCallBack;
@property (nonatomic, assign) HDVideoProcessType processType;
@property (nonatomic, strong) HDVideoAnswerCallBackView *answerCallBackView;

-(void) hd_createUIWithCallType:(HDVideoType )callType;
- (void)updateServiceLayoutConfig:(HDVideoLayoutModel *)model;
- (void)endCallLayout;
- (HDVideoLayoutModel*)getSettingModel;




@end

NS_ASSUME_NONNULL_END
