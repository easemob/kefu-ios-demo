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

extern CGFloat const EaseMessageCellPadding;

extern NSString *const EaseMessageCellIdentifierSendText;
extern NSString *const EaseMessageCellIdentifierSendLocation;
extern NSString *const EaseMessageCellIdentifierSendVoice;
extern NSString *const EaseMessageCellIdentifierSendVideo;
extern NSString *const EaseMessageCellIdentifierSendImage;
extern NSString *const EaseMessageCellIdentifierSendFile;

extern NSString *const EaseMessageCellIdentifierRecvText;
extern NSString *const EaseMessageCellIdentifierRecvLocation;
extern NSString *const EaseMessageCellIdentifierRecvVoice;
extern NSString *const EaseMessageCellIdentifierRecvVideo;
extern NSString *const EaseMessageCellIdentifierRecvImage;
extern NSString *const EaseMessageCellIdentifierRecvFile;

@interface EaseBubbleView : UIView
{
    UIEdgeInsets _margin;
    CGFloat _fileIconSize;
}

@property (nonatomic) BOOL isSender;

@property (nonatomic, readonly) UIEdgeInsets margin;

@property (strong, nonatomic) NSMutableArray *marginConstraints;

@property (strong, nonatomic) UIImageView *backgroundImageView;

//------text views
@property (strong, nonatomic) UILabel *textLabel;

//track views 【track 属于text消息，包含在消息扩展中的msgtype -> track 键】
@property (strong, nonatomic) UILabel *trackTitleLabel;          //标题
@property (strong, nonatomic) UIImageView *cusImageView;    //图片
@property (strong, nonatomic) UILabel *cusDescLabel;             //商品描述
@property (strong, nonatomic) UILabel *cusPriceLabel;            //商品价格
//order views 【order 属于text消息，包含在消息扩展中的msgtype -> order 键】
@property(nonatomic,strong) UILabel *orderTitleLabel;        //订单
@property(nonatomic,strong) UILabel *orderNoLabel;      //订单号
@property(nonatomic,strong) UIImageView *orderImageView;//订单展示图
@property(nonatomic,strong) UILabel *orderDescLabel;         //订单描述
@property(nonatomic,strong) UILabel *orderPriceLabel;        //订单价格

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

- (instancetype)initWithMargin:(UIEdgeInsets)margin
                      isSender:(BOOL)isSender;

@end
