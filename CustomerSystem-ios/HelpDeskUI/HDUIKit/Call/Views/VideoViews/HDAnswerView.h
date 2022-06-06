//
//  HDAnswerView.h
//  HLtest
//
//  Created by houli on 2022/3/15.
//

#import <UIKit/UIKit.h>
/*
 *
 */
typedef NS_ENUM (NSInteger, HDVideoCallType) {
    HDVideoCallDirectionSend    = 0,    /**  发送视频邀请   */
    HDVideoCallDirectionReceive,           /**接受视频邀请  */
};

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickOnBlock)(UIButton *btn);
typedef void(^ClickOffBlock)(UIButton *btn);
typedef void(^ClickHangUpBlock)(UIButton *btn);
@interface HDAnswerView : UIView
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIButton *onBtn;
@property (nonatomic, strong) UIButton *offBtn;
@property (nonatomic, strong) UIButton *hangUpBtn;
@property (nonatomic, strong) UILabel *answerLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, copy) ClickOnBlock clickOnBlock;
@property (nonatomic, copy) ClickOffBlock clickOffBlock;
@property (nonatomic, copy) ClickHangUpBlock clickHangUpBlock;
@property (nonatomic, assign) HDVideoCallType callType;


@end

NS_ASSUME_NONNULL_END
