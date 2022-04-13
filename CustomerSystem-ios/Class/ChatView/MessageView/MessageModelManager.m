/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "MessageModelManager.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "MessageModel.h"
#import "EaseMob.h"

@implementation MessageModelManager

+ (id)modelWithMessage:(EMMessage *)message
{
    id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
    NSDictionary *userInfo = [[EaseMob sharedInstance].chatManager loginInfo];
    NSString *login = [userInfo objectForKey:kSDKUsername];
    BOOL isSender = [login isEqualToString:message.from] ? YES : NO;
    
    MessageModel *model = [[MessageModel alloc] init];
    model.isRead = message.isRead;
    model.messageBody = messageBody;
    model.message = message;
    model.type = messageBody.messageBodyType;
    model.messageId = message.messageId;
    model.isSender = isSender;
    model.isPlaying = NO;
    model.isChatGroup = message.isGroup;
    if (model.isChatGroup) {
        model.username = message.groupSenderName;
    }
    else{
        model.username = message.from;
    }
    
    if (isSender) {
        model.headImageURL = nil;
        model.status = message.deliveryState;
    }
    else{
        model.headImageURL = nil;
        model.status = eMessageDeliveryState_Delivered;
    }
    
    switch (messageBody.messageBodyType) {
        case eMessageBodyType_Text:
        {
            // 表情映射。
            NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                        convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
            model.content = didReceiveText;
        }
            break;
        case eMessageBodyType_Image:
        {
            EMImageMessageBody *imgMessageBody = (EMImageMessageBody*)messageBody;
            model.thumbnailSize = imgMessageBody.thumbnailSize;
            model.size = imgMessageBody.size;
            model.localPath = imgMessageBody.localPath;
            model.thumbnailImage = [UIImage imageWithContentsOfFile:imgMessageBody.thumbnailLocalPath];
            if (isSender)
            {
                model.image = [UIImage imageWithContentsOfFile:imgMessageBody.thumbnailLocalPath];
            }else {
                model.imageRemoteURL = [NSURL URLWithString:imgMessageBody.remotePath];
            }
        }
            break;
        case eMessageBodyType_Location:
        {
            model.address = ((EMLocationMessageBody *)messageBody).address;
            model.latitude = ((EMLocationMessageBody *)messageBody).latitude;
            model.longitude = ((EMLocationMessageBody *)messageBody).longitude;
        }
            break;
        case eMessageBodyType_Voice:
        {
            model.time = ((EMVoiceMessageBody *)messageBody).duration;
            model.chatVoice = (EMChatVoice *)((EMVoiceMessageBody *)messageBody).chatObject;
            if (message.ext) {
                NSDictionary *dict = message.ext;
                BOOL isPlayed = [[dict objectForKey:@"isPlayed"] boolValue];
                model.isPlayed = isPlayed;
            }else {
                NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@NO,@"isPlayed", nil];
                message.ext = dict;
                [message updateMessageExtToDB];
            }
            // 本地音频路径
            model.localPath = ((EMVoiceMessageBody *)messageBody).localPath;
            model.remotePath = ((EMVoiceMessageBody *)messageBody).remotePath;
        }
            break;
        case eMessageBodyType_Video:{
            EMVideoMessageBody *videoMessageBody = (EMVideoMessageBody*)messageBody;
            model.thumbnailSize = videoMessageBody.size;
            model.size = videoMessageBody.size;
            model.localPath = videoMessageBody.thumbnailLocalPath;
            model.thumbnailImage = [UIImage imageWithContentsOfFile:videoMessageBody.thumbnailLocalPath];
            model.image = model.thumbnailImage;
        }
            break;
        default:
            break;
    }
    
    return model;
}

@end
