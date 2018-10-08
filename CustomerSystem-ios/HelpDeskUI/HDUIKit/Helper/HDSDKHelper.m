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
    [[HDClient sharedClient] applicationDidEnterBackground:notif.object];
}

- (void)appWillEnterForeground:(NSNotification*)notif
{
    [[HDClient sharedClient] applicationWillEnterForeground:notif.object];
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
+ (HDMessage *)cmdMessageFormatTo:(NSString *)to{
    EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:@"TransferToKf"];
    NSString *from = [[HDClient sharedClient] currentUsername];
    HDMessage *message = [[HDMessage alloc] initWithConversationID:to from:from to:to body:body];
    return message;
}

//构造text消息体
+ (HDMessage *)textHMessageFormatWithText:(NSString *)text
                                      to:(NSString *)toUser{
    HDMessage *message = [HDMessage createTxtSendMessageWithContent:text to:toUser];
    return message;
}

+ (HDMessage *)customMagicEmojiMessageWithOriginUrl:(NSString *)url to:(NSString *)toUser {
    HDMessage *message = [HDMessage createBigExpressionSendMessageWithUrl:url to:toUser];
    return message;
}

//构造image消息体
+ (HDMessage *)imageMessageWithImageData:(NSData *)imageData
                                          to:(NSString *)to
                                  messageExt:(NSDictionary *)messageExt
{
    HDMessage *message = [HDMessage createImageSendMessageWithData:imageData displayName:@"image.jpg" to:to];
    if(messageExt){
        [message addAttributeDictionary:messageExt];
    }
    return message;
}

//构造image
+ (HDMessage *)imageMessageWithImage:(UIImage *)image
                                      to:(NSString *)to
                              messageExt:(NSDictionary *)messageExt
{
    HDMessage *message = [HDMessage createImageSendMessageWithImage:image
                                                      displayName:@"image.jpg"
                                                               to:to];
    if (messageExt) {
        [message addAttributeDictionary:messageExt];
    }
    return message;
}
//构造语音消息
+ (HDMessage *)voiceMessageWithLocalPath:(NSString *)localPath
                               duration:(int)duration
                                     to:(NSString *)to
                             messageExt:(NSDictionary *)messageExt
{
    HDMessage *message = [HDMessage createVoiceSendMessageWithLocalPath:localPath duration:duration to:to];
    return message;
}

//构造地理位置消息
+ (HDMessage *)locationHMessageWithLatitude:(double)latitude
                                     longitude:(double)longitude
                                       address:(NSString *)address
                                            to:(NSString *)to
                                    messageExt:(NSDictionary *)messageExt
{
    HDMessage *message = [HDMessage createLocationSendMessageWithLatitude:latitude longitude:longitude address:address to:to];
    if (messageExt) {
        [message addAttributeDictionary:messageExt];
    }
    return message;
}

@end
