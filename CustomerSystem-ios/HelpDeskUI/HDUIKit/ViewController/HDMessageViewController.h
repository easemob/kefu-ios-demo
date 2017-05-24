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

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "HDRefreshTableViewController.h"
#import "HDIMessageModel.h"
#import "HDMessageModel.h"
#import "HDBaseMessageCell.h"
#import "HDMessageTimeCell.h"
#import "HDChatToolbar.h"
#import "HDLocationViewController.h"
#import "HDCDDeviceManager+Media.h"
#import "HDCDDeviceManager+ProximitySensor.h"
#import "UIViewController+HDHUD.h"
#import "HDSDKHelper.h"
#import "SatisfactionViewController.h"
typedef NS_ENUM(NSInteger, HDemoSaleType){
    hPreSaleType=100,   //售前
    hAfterSaleType, //售后
    hSaleTypeNone   //其他
};

@interface HDAtTarget : NSObject
@property (nonatomic, copy) NSString    *userId;
@property (nonatomic, copy) NSString    *nickname;

- (instancetype)initWithUserId:(NSString*)userId andNickname:(NSString*)nickname;
@end

typedef void(^HDSelectAtTargetCallback)(HDAtTarget*);

@class HDMessageViewController;

@protocol HDMessageViewControllerDelegate <NSObject>

@optional

//点击文件
- (void)messageViewController:(HDMessageViewController *)viewController fileMessageCellSelected:(id<HDIMessageModel>)model;

- (UITableViewCell *)messageViewController:(UITableView *)tableView
                       cellForMessageModel:(id<HDIMessageModel>)messageModel;

- (CGFloat)messageViewController:(HDMessageViewController *)viewController
           heightForMessageModel:(id<HDIMessageModel>)messageModel
                   withCellWidth:(CGFloat)cellWidth;

- (void)messageViewController:(HDMessageViewController *)viewController
          didSendMessageModel:(id<HDIMessageModel>)messageModel;

- (void)messageViewController:(HDMessageViewController *)viewController
   didFailSendingMessageModel:(id<HDIMessageModel>)messageModel
                        error:(HError *)error;

- (void)messageViewController:(HDMessageViewController *)viewController
    didSelectAvatarMessageModel:(id<HDIMessageModel>)messageModel;

- (void)messageViewController:(HDMessageViewController *)viewController
            didSelectMoreView:(HDChatBarMoreView *)moreView
                      AtIndex:(NSInteger)index;

- (void)messageViewController:(HDMessageViewController *)viewController
              didSelectRecordView:(UIView *)recordView
                withEvenType:(HDRecordViewType)type;

/*!
 @method
 @brief 获取要@的对象
 @discussion 用户输入了@，选择要@的对象
 @param selectedCallback 用于回调要@的对象的block
 @result
 */
- (void)messageViewController:(HDMessageViewController *)viewController
               selectAtTarget:(HDSelectAtTargetCallback)selectedCallback;

@end


@protocol HDMessageViewControllerDataSource <NSObject>

@optional

- (id)messageViewController:(HDMessageViewController *)viewController
                  progressDelegateForMessageBodyType:(EMMessageBodyType)messageBodyType;

- (void)messageViewController:(HDMessageViewController *)viewController
               updateProgress:(float)progress
                 messageModel:(id<HDIMessageModel>)messageModel
                  messageBody:(EMMessageBody*)messageBody;

- (NSString *)messageViewController:(HDMessageViewController *)viewController
                      stringForDate:(NSDate *)date;

- (NSArray *)messageViewController:(HDMessageViewController *)viewController
          loadMessageFromTimestamp:(long long)timestamp
                             count:(NSInteger)count;

- (id<HDIMessageModel>)messageViewController:(HDMessageViewController *)viewController
                           modelForMessage:(HMessage *)message;

- (BOOL)messageViewController:(HDMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)messageViewController:(HDMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath;


- (BOOL)isEmotionMessageFormessageViewController:(HDMessageViewController *)viewController
                                    messageModel:(id<HDIMessageModel>)messageModel;

- (HDEmotion*)emotionURLFormessageViewController:(HDMessageViewController *)viewController
                                   messageModel:(id<HDIMessageModel>)messageModel;

- (NSArray*)emotionFormessageViewController:(HDMessageViewController *)viewController;

- (NSDictionary*)emotionExtFormessageViewController:(HDMessageViewController *)viewController
                                        easeEmotion:(HDEmotion*)easeEmotion;

@end

@interface HDMessageViewController : HDRefreshTableViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, /*EMChatManagerDelegate, */HDCDDeviceManagerDelegate,HDChatToolbarDelegate, HDChatBarMoreViewDelegate, EMLocationViewDelegate, HDMessageCellDelegate,SatisfactionDelegate>

@property (weak, nonatomic) id<HDMessageViewControllerDelegate> delegate;

@property (weak, nonatomic) id<HDMessageViewControllerDataSource> dataSource;

@property(nonatomic,strong) HConversation *conversation;

@property (nonatomic) NSTimeInterval messageTimeIntervalTag;

@property (nonatomic) BOOL deleteConversationIfNull; //default YES;

@property (nonatomic) BOOL scrollToBottomWhenAppear; //default YES;


@property (nonatomic) NSInteger messageCountOfPage; //default 50

@property (nonatomic) CGFloat timeCellHeight;

@property (strong, nonatomic) NSMutableArray *messsagesSource;

@property (strong, nonatomic) UIView *chatToolbar;

@property(strong, nonatomic) HDChatBarMoreView *chatBarMoreView;

@property(strong, nonatomic) HDFaceView *faceView;

@property(strong, nonatomic) HDRecordView *recordView;

@property (strong, nonatomic) UIMenuController *menuController;

@property (strong, nonatomic) NSIndexPath *menuIndexPath;

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property(nonatomic,strong) HVisitorInfo *visitorInfo; //访客信息

@property(nonatomic,strong) HAgentIdentityInfo *agent; //指定客服

@property(nonatomic,strong) HQueueIdentityInfo *queueInfo; //指定技能组

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter;

- (void)tableViewDidTriggerHeaderRefresh;

- (void)sendTextMessage:(NSString *)text;

- (void)_sendMessage:(HMessage *)message;

- (void)sendTextMessage:(NSString *)text withExt:(NSDictionary*)ext;

- (void)sendImageMessage:(UIImage *)image;

- (void)sendLocationMessageLatitude:(double)latitude
                          longitude:(double)longitude
                         andAddress:(NSString *)address;

- (void)sendVoiceMessageWithLocalPath:(NSString *)localPath
                             duration:(NSInteger)duration;

- (void)sendVideoMessageWithURL:(NSURL *)url;

-(void)addMessageToDataSource:(HMessage *)message
                     progress:(id)progress;

-(void)showMenuViewController:(UIView *)showInView
                 andIndexPath:(NSIndexPath *)indexPath
                  messageType:(EMMessageBodyType)messageType;

#warning 在继承这个方法的时候确保不要执行可能引起父类方法不能dealloc的代码
- (void)backItemDidClicked;

@end
