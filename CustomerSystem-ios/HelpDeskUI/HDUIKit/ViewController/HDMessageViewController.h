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
#import "HDRecordView.h"
typedef NS_ENUM(NSInteger, HDemoSaleType){
    hPreSaleType=100,   //售前
    hAfterSaleType, //售后
    hSaleTypeNone   //其他
};


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
                        error:(HDError *)error;

- (void)messageViewController:(HDMessageViewController *)viewController
    didSelectAvatarMessageModel:(id<HDIMessageModel>)messageModel;

- (void)messageViewController:(HDMessageViewController *)viewController
            didSelectMoreView:(HDChatBarMoreView *)moreView
                      AtIndex:(NSInteger)index;

- (void)messageViewController:(HDMessageViewController *)viewController
              didSelectRecordView:(UIView *)recordView
                withEvenType:(HDRecordViewType)type;

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
                           modelForMessage:(HDMessage *)message;

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

@interface HDMessageViewController : HDRefreshTableViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, HDCDDeviceManagerDelegate, HDChatToolbarDelegate, HDChatBarMoreViewDelegate, EMLocationViewDelegate, HDMessageCellDelegate, SatisfactionDelegate, HDRecordViewDelegate>

@property (nonatomic, assign) id<HDMessageViewControllerDelegate> delegate;

@property (nonatomic, assign) id<HDMessageViewControllerDataSource> dataSource;

@property (nonatomic, strong) HDConversation *conversation;

@property (nonatomic) NSTimeInterval messageTimeIntervalTag;

@property (nonatomic) NSInteger messageCountOfPage; //default 10

@property (nonatomic) CGFloat timeCellHeight;

@property (nonatomic, strong) NSMutableArray *messsagesSource;

@property (nonatomic, strong) UIView *chatToolbar;

@property (nonatomic, strong) HDChatBarMoreView *chatBarMoreView;

@property (nonatomic, strong) HDFaceView *faceView;

@property (nonatomic, strong) HDMicView *micView;

@property (nonatomic, strong) HDRecordView *recordView;

@property (nonatomic, strong) UIMenuController *menuController;

@property (nonatomic, strong) NSIndexPath *menuIndexPath;

@property (nonatomic, strong) NSIndexPath *snedButtonIndexPath;

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, strong) HDVisitorInfo *visitorInfo; //访客信息

@property (nonatomic, strong) HDAgentIdentityInfo *agent; //指定客服

@property (nonatomic, strong) HDQueueIdentityInfo *queueInfo; //指定技能组

@property (nonatomic, strong)UILabel *visitorWaitCountLabel;


- (instancetype)initWithConversationChatter:(NSString *)conversationChatter;

- (void)tableViewDidTriggerHeaderRefresh;

- (void)sendTextMessage:(NSString *)text;

- (void)_sendMessage:(HDMessage *)message;

- (void)sendTextMessage:(NSString *)text withExt:(NSDictionary*)ext;

- (void)sendImageMessage:(UIImage *)image;

- (void)sendLocationMessageLatitude:(double)latitude
                          longitude:(double)longitude
                         andAddress:(NSString *)address;

- (void)sendVoiceMessageWithLocalPath:(NSString *)localPath
                             duration:(int)duration;

- (void)sendVideoMessageWithURL:(NSURL *)url;

-(void)addMessageToDataSource:(HDMessage *)message
                     progress:(id)progress;

-(void)showMenuViewController:(UIView *)showInView
                 andIndexPath:(NSIndexPath *)indexPath
                  messageType:(EMMessageBodyType)messageType;

- (void)backItemClicked;

#warning 在继承这个方法的时候确保不要执行可能引起父类方法不能dealloc的代码
- (void)backItemDidClicked;

@end
