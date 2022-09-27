

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "HDRefreshTableViewController.h"
#import "HDIMessageModel.h"
#import "HDMessageModel.h"
#import "HDBaseMessageCell.h"
#import "HDMessageTimeCell.h"
#import "HDVideoChatToolbar.h"
#import "HDLocationViewController.h"
#import "HDCDDeviceManager+Media.h"
#import "HDCDDeviceManager+ProximitySensor.h"
#import "UIViewController+HDHUD.h"
#import "HDSDKHelper.h"
#import "SatisfactionViewController.h"
#import "HDRecordView.h"
#import "HDVideoRefreshTableViewController.h"
typedef NS_ENUM(NSInteger, HDVideoemoSaleType){
    HDVideohPreSaleType=100,   //售前
    HDVideohAfterSaleType, //售后
    HDVideohSaleTypeNone   //其他
};


@class HDVideoChatMessageViewController;

@protocol HDVideoChatMessageViewControllerDelegate <NSObject>

@optional

//点击文件
- (void)messageViewController:(HDVideoChatMessageViewController *)viewController fileMessageCellSelected:(id<HDIMessageModel>)model;

- (UITableViewCell *)messageViewController:(UITableView *)tableView
                       cellForMessageModel:(id<HDIMessageModel>)messageModel;

- (CGFloat)messageViewController:(HDVideoChatMessageViewController *)viewController
           heightForMessageModel:(id<HDIMessageModel>)messageModel
                   withCellWidth:(CGFloat)cellWidth;

- (void)messageViewController:(HDVideoChatMessageViewController *)viewController
          didSendMessageModel:(id<HDIMessageModel>)messageModel;

- (void)messageViewController:(HDVideoChatMessageViewController *)viewController
   didFailSendingMessageModel:(id<HDIMessageModel>)messageModel
                        error:(HDError *)error;

- (void)messageViewController:(HDVideoChatMessageViewController *)viewController
    didSelectAvatarMessageModel:(id<HDIMessageModel>)messageModel;

- (void)messageViewController:(HDVideoChatMessageViewController *)viewController
            didSelectMoreView:(HDChatBarMoreView *)moreView
                      AtIndex:(NSInteger)index;

- (void)messageViewController:(HDVideoChatMessageViewController *)viewController
              didSelectRecordView:(UIView *)recordView
                withEvenType:(HDRecordViewType)type;

@end


@protocol HDVideoChatMessageViewControllerDataSource <NSObject>

@optional

- (id)messageViewController:(HDVideoChatMessageViewController *)viewController
                  progressDelegateForMessageBodyType:(EMMessageBodyType)messageBodyType;

- (void)messageViewController:(HDVideoChatMessageViewController *)viewController
               updateProgress:(float)progress
                 messageModel:(id<HDIMessageModel>)messageModel
                  messageBody:(EMMessageBody*)messageBody;

- (NSString *)messageViewController:(HDVideoChatMessageViewController *)viewController
                      stringForDate:(NSDate *)date;

- (NSArray *)messageViewController:(HDMessageViewController *)viewController
          loadMessageFromTimestamp:(long long)timestamp
                             count:(NSInteger)count;

- (id<HDIMessageModel>)messageViewController:(HDVideoChatMessageViewController *)viewController
                           modelForMessage:(HDMessage *)message;

- (BOOL)messageViewController:(HDVideoChatMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)messageViewController:(HDVideoChatMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath;


- (BOOL)isEmotionMessageFormessageViewController:(HDVideoChatMessageViewController *)viewController
                                    messageModel:(id<HDIMessageModel>)messageModel;

- (HDEmotion*)emotionURLFormessageViewController:(HDVideoChatMessageViewController *)viewController
                                   messageModel:(id<HDIMessageModel>)messageModel;

- (NSArray*)emotionFormessageViewController:(HDVideoChatMessageViewController *)viewController;

- (NSDictionary*)emotionExtFormessageViewController:(HDVideoChatMessageViewController *)viewController
                                        easeEmotion:(HDEmotion*)easeEmotion;

@end

@interface HDVideoChatMessageViewController : HDVideoRefreshTableViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, HDCDDeviceManagerDelegate, HDVideoChatToolbarDelegate, HDChatBarMoreViewDelegate, EMLocationViewDelegate, HDMessageCellDelegate, SatisfactionDelegate, HDRecordViewDelegate>

@property (nonatomic, assign) id<HDVideoChatMessageViewControllerDelegate> delegate;

@property (nonatomic, assign) id<HDVideoChatMessageViewControllerDataSource> dataSource;

@property (nonatomic, strong) HDConversation *conversation;

@property (nonatomic) NSTimeInterval messageTimeIntervalTag;

@property (nonatomic) NSInteger messageCountOfPage; //default 10

@property (nonatomic) CGFloat timeCellHeight;

@property (nonatomic, strong) NSMutableArray *messsagesSource;

@property (nonatomic, strong) UIView *videoChatToolbar;

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
