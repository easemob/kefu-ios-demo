/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import <UIKit/UIKit.h>
#import "HDArticleView.h"
#define kBigExpressionHW 100

extern CGFloat const HDMessageCellPadding;

extern NSString *const HRouterEventTapMenu; //选择菜单
extern NSString *const HRouterEventTapTransform; //转人工
extern NSString *const HRouterEventTapEvaluate ; //评价
extern NSString *const HRouterEventTapArticle; //图文消息

extern NSString *const HRouterEventTextURLTapEventName;

extern NSString *const HDMessageCellIdentifierSendText;
extern NSString *const HDMessageCellIdentifierSendLocation;
extern NSString *const HDMessageCellIdentifierSendVoice;
extern NSString *const HDMessageCellIdentifierSendVideo;
extern NSString *const HDMessageCellIdentifierSendImage;
extern NSString *const HDMessageCellIdentifierSendFile;

extern NSString *const HDMessageCellIdentifierRecvText;
extern NSString *const HDMessageCellIdentifierRecvLocation;
extern NSString *const HDMessageCellIdentifierRecvVoice;
extern NSString *const HDMessageCellIdentifierRecvVideo;
extern NSString *const HDMessageCellIdentifierRecvImage;
extern NSString *const HDMessageCellIdentifierRecvFile;

// 删除轨迹消息协议
@protocol SendDeleteTrackMsgDelegate <NSObject>

- (void)deleteTrackMessage:(UIButton *)sendButton;

@end

@interface HDBubbleView : UIView
{
    UIEdgeInsets _margin;
    CGFloat _fileIconSize;
}

@property (nonatomic, weak) id<SendDeleteTrackMsgDelegate> delegate;

@property (nonatomic) BOOL isSender;

@property (nonatomic, readonly) UIEdgeInsets margin;

@property (strong, nonatomic) NSMutableArray *marginConstraints;

@property (strong, nonatomic) UIImageView *backgroundImageView;

//------text views
@property (strong, nonatomic) UILabel *textLabel;

//track views 【track 属于text消息，包含在消息扩展中的msgtype -> track 键】
@property (strong, nonatomic) UIView *trackBgView;
@property (strong, nonatomic) UILabel *trackTitleLabel;          //标题
@property (strong, nonatomic) UIImageView *cusImageView;    //图片
@property (strong, nonatomic) UILabel *cusDescLabel;             //商品描述
@property (strong, nonatomic) UILabel *cusPriceLabel;            //商品价格
@property (strong, nonatomic) UIButton *sendButton;            //发送按钮
//order views 【order 属于text消息，包含在消息扩展中的msgtype -> order 键】
@property (strong, nonatomic) UIView *orderBgView;
@property(nonatomic,strong) UILabel *orderTitleLabel;        //订单
@property(nonatomic,strong) UILabel *orderNoLabel;      //订单号
@property(nonatomic,strong) UIImageView *orderImageView;//订单展示图
@property(nonatomic,strong) UILabel *orderDescLabel;         //订单描述
@property(nonatomic,strong) UILabel *orderPriceLabel;        //订单价格
//robotMenu
@property(nonatomic,strong) UITableView *tableView;     //菜单
@property(nonatomic,strong) NSArray *options;           //菜单选项
@property(nonatomic,strong) NSString *menuTitle;

//article Message
@property(nonatomic,strong) HDArticleView *articleView;
//@property(nonatomic,strong) id titleModel;  //第一个cell
@property(nonatomic,strong) NSArray *subModels; //子菜单的models


//transform
@property(nonatomic,strong) UILabel *transTitle; //机器人回复文字
@property(nonatomic,strong) UIButton *transformButton; //转人工客服button

//evaluate
@property(nonatomic,strong) UILabel *evaluateTitle; //评价title
@property(nonatomic,strong) UIButton *evaluateButton; //评价按钮

//------image views
@property (strong, nonatomic) UIImageView *imageView;

//------location views
@property (strong, nonatomic) UIImageView *locationImageView;
@property (strong, nonatomic) UILabel *locationLabel;

//------voice views
@property (strong, nonatomic) UIImageView *voiceImageView;
@property (strong, nonatomic) UILabel *voiceDurationLabel;
@property (strong, nonatomic) UIImageView *isReadView;

//------video views
@property (strong, nonatomic) UIImageView *videoImageView;
@property (strong, nonatomic) UIImageView *videoTagView;

//------file views
@property (strong, nonatomic) UIImageView *fileIconView;
@property (strong, nonatomic) UILabel *fileNameLabel;
@property (strong, nonatomic) UILabel *fileSizeLabel;

//form
@property (strong, nonatomic) UIImageView *formIconView;
@property (strong, nonatomic) UILabel *formTitleLabel;
@property (strong, nonatomic) UILabel *formDescLabel;

- (instancetype)initWithMargin:(UIEdgeInsets)margin
                      isSender:(BOOL)isSender;

- (void)sendDeleteTrackMsg:(UIButton *)button;
@end
