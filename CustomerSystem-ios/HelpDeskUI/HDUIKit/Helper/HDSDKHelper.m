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

#import <UserNotifications/UserNotifications.h>
#import "HDSDKHelper.h"

#import "HDConvertToCommonEmoticonsHelper.h"

//@interface EMChatImageOptions : NSObject<IChatImageOptions>
//
//@property (assign, nonatomic) CGFloat compressionQuality;
//
//@end

static HDSDKHelper *helper = nil;

@implementation HDSDKHelper

@synthesize isShowingimagePicker = _isShowingimagePicker;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

+(instancetype)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[HDSDKHelper alloc] init];
    });
    
    return helper;
}

#pragma mark - private

- (void)commonInit
{
    
}

#pragma mark - app delegate notifications

- (void)_setupAppDelegateNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackgroundNotif:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)appDidEnterBackgroundNotif:(NSNotification*)notif
{
    [[HChatClient sharedClient] applicationDidEnterBackground:notif.object];
}

- (void)appWillEnterForeground:(NSNotification*)notif
{
    [[HChatClient sharedClient] applicationWillEnterForeground:notif.object];
}

#pragma mark - register apns

- (void)_registerRemoteNotification
{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;

    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError *error) {
            if (granted) {
#if !TARGET_IPHONE_SIMULATOR
                [application registerForRemoteNotifications];
#endif
            }
        }];
        return;
    }

    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}

#pragma mark - init Hyphenate
- (void)dealloc
{
    
}

#pragma mark - send message new

//构造cmd消息
+ (HMessage *)cmdMessageFormatTo:(NSString *)to{
    EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:@"TransferToKf"];
    NSString *from = [[HChatClient sharedClient] currentUsername];
    HMessage *message = [[HMessage alloc] initWithConversationID:to from:from to:to body:body];
    return message;
}

//构造text消息体
+ (HMessage *)textHMessageFormatWithText:(NSString *)text
                                      to:(NSString *)toUser{
    HMessage *message = [HMessage createTxtSendMessageWithContent:text to:toUser];
    return message;
}

+ (HMessage *)customMagicEmojiMessageWithOriginUrl:(NSString *)url to:(NSString *)toUser {
    HMessage *message = [HMessage createBigExpressionSendMessageWithUrl:url to:toUser];
    return message;
}


+ (HMessage *)videoInvitedMessageFormatWithText:(NSString *)text toUser:(NSString *)toUser {
    HMessage *message = [HMessage createVideoInviteSendMessageWithContent:text to:toUser];
    return message;
}

//构造image消息体
+ (HMessage *)imageMessageWithImageData:(NSData *)imageData
                                          to:(NSString *)to
                                  messageExt:(NSDictionary *)messageExt
{
    HMessage *message = [HMessage createImageSendMessageWithData:imageData displayName:@"image" to:to];
    if(messageExt){
        [message addAttributeDictionary:messageExt];
    }
    return message;
}

//构造image
+ (HMessage *)imageMessageWithImage:(UIImage *)image
                                      to:(NSString *)to
                              messageExt:(NSDictionary *)messageExt
{
    HMessage *message = [HMessage createImageSendMessageWithImage:image to:to];
    if (messageExt) {
        [message addAttributeDictionary:messageExt];
    }
    return message;
}
//构造语音消息
+ (HMessage *)voiceMessageWithLocalPath:(NSString *)localPath
                               duration:(int)duration
                                     to:(NSString *)to
                             messageExt:(NSDictionary *)messageExt
{
    HMessage *message = [HMessage createVoiceSendMessageWithLocalPath:localPath duration:duration to:to];
    return message;
}

//构造地理位置消息
+ (HMessage *)locationHMessageWithLatitude:(double)latitude
                                     longitude:(double)longitude
                                       address:(NSString *)address
                                            to:(NSString *)to
                                    messageExt:(NSDictionary *)messageExt
{
    HMessage *message = [HMessage createLocationSendMessageWithLatitude:latitude longitude:longitude address:address to:to];
    if (messageExt) {
        [message addAttributeDictionary:messageExt];
    }
    return message;
}

@end
