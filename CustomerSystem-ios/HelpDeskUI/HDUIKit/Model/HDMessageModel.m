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

#import "HDMessageModel.h"
#import "HDMessageCell.h"
#import "HDEmotionEscape.h"
#import "HDConvertToCommonEmoticonsHelper.h"
#import "HDEmotionEscape.h"

@implementation HDMessageModel
@synthesize body;
@synthesize from;
@synthesize isScoreMsg;

- (instancetype)initWithMessage:(HDMessage *)message
{
    self = [super init];
    if (self) {
        _cellHeight = -1;
        _message = message;
        _firstMessageBody = message.body;
        _isMediaPlaying = NO;
        _isSender = message.direction == HDMessageDirectionSend ? YES : NO;
        _bodyType = _firstMessageBody.type;
        if (!_isSender) {
            NSDictionary *weichat = [message.ext objectForKey:@"weichat"];
            if (weichat) {
                NSDictionary *agent = [weichat valueForKey:@"agent"];
                NSString *agentNickname = @"";
                NSString *agentAvatarUrl = @"";
                if (![[agent objectForKey:@"avatar"] isKindOfClass:[NSNull class]]) {
                    agentAvatarUrl = [agent objectForKey:@"avatar"];
                }
                if (![[agent objectForKey:@"userNickname"] isKindOfClass:[NSNull class]]) {
                    agentNickname = [agent objectForKey:@"userNickname"];
                }
                
                self.avatarURLPath = agentAvatarUrl;
                self.nickname = agentNickname;
                // 获取会话id
                if ([[weichat allKeys] containsObject:@"service_session"]) {
                    
                    if ([[weichat valueForKey:@"service_session"] isKindOfClass:[NSDictionary class]]) {
                        
                        NSDictionary *service_session = [weichat valueForKey:@"service_session"];
                        
                        NSString *serviceSessionId = [service_session valueForKey:@"serviceSessionId"];
                        
                        self.serviceSessionId = serviceSessionId;
                    }
                }
            }
            self.avatarImage = [UIImage imageNamed:@"HelpDeskUIResource.bundle/user"];
        } else {
            if (message.ext) {
                NSDictionary *weichat = [message.ext objectForKey:@"weichat"];
                if (weichat) {
                    if (![[weichat objectForKey:@"visitor"] isKindOfClass:[NSNull class]] && [weichat objectForKey:@"visitor"]) {
                        _nickname = [[weichat objectForKey:@"visitor"] objectForKey:@"userNickname"];
                    }
                }
            } else {
                _nickname = message.from;
            }
        }
        
        switch (_firstMessageBody.type) {
            case EMMessageBodyTypeText:
            {   EMTextMessageBody *textBody = (EMTextMessageBody *)_firstMessageBody;
                NSString *didReceiveText = [HDConvertToCommonEmoticonsHelper convertToSystemEmoticons:textBody.text];
                if ([HDMessageHelper getMessageExtType:self.message] == HDExtRobotMenuMsg) {
                    didReceiveText = [HDMessageCell _getMessageContent:self.message];
                }
                self.text = didReceiveText;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                EMImageMessageBody *imgMessageBody = (EMImageMessageBody *)_firstMessageBody;
                NSData *imageData = [NSData dataWithContentsOfFile:imgMessageBody.localPath];
                if (imageData.length) {
                    self.image = [UIImage imageWithData:imageData];
                }
                if ([imgMessageBody.thumbnailLocalPath length] > 0) {
                    self.thumbnailImage = [UIImage imageWithContentsOfFile:imgMessageBody.thumbnailLocalPath];
                }else{
                    CGSize size = self.image.size;
                    self.thumbnailImage = size.width * size.height > 200 * 200 ? [self scaleImage:self.image toScale:sqrt((200 * 200) / (size.width * size.height))] : self.image;
                }
                
                self.thumbnailImageSize = self.thumbnailImage.size;
                self.imageSize = imgMessageBody.size;
                if (!_isSender) {
                    self.fileURLPath = imgMessageBody.remotePath;
                }
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                EMLocationMessageBody *locationBody = (EMLocationMessageBody *)_firstMessageBody;
                self.address = locationBody.address;
                self.latitude = locationBody.latitude;
                self.longitude = locationBody.longitude;
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody *)_firstMessageBody;
                self.mediaDuration = voiceBody.duration;
                // audio file path
                self.fileURLPath = voiceBody.remotePath;
            }
                break;
            case EMMessageBodyTypeVideo:
            {
                EMVideoMessageBody *videoBody = (EMVideoMessageBody *)message.body;
                self.fileIconName = @"messageVideo";
                self.fileName = videoBody.displayName;
                self.fileSize = videoBody.fileLength;
                self.thumbnailFileURLPath = videoBody.thumbnailRemotePath;
                NSData *imageData = [NSData dataWithContentsOfFile:videoBody.thumbnailLocalPath];
                if (imageData.length) {
                    self.thumbnailImage = [UIImage imageWithData:imageData];
                }
                if (self.fileSize < 1024) {
                    self.fileSizeDes = [NSString    stringWithFormat:@"%.2fB", self.fileSize];
                }
                else if(self.fileSize < 1024 * 1024){
                    self.fileSizeDes = [NSString stringWithFormat:@"%.2fkB", self.fileSize / 1024];
                }
                else if (self.fileSize < 2014 * 1024 * 1024){
                    self.fileSizeDes = [NSString stringWithFormat:@"%.2fMB", self.fileSize / (1024 * 1024)];
                }
            }
                break;
            case EMMessageBodyTypeFile:
            {
                EMFileMessageBody *fileMessageBody = (EMFileMessageBody *)_firstMessageBody;
                self.fileIconName = @"chat_item_file";
                self.fileName = fileMessageBody.displayName;
                self.fileSize = fileMessageBody.fileLength;
                
                if (self.fileSize < 1024) {
                    self.fileSizeDes = [NSString stringWithFormat:@"%.2fB", self.fileSize];
                }
                else if(self.fileSize < 1024 * 1024){
                    self.fileSizeDes = [NSString stringWithFormat:@"%.2fkB", self.fileSize / 1024];
                }
                else if (self.fileSize < 2014 * 1024 * 1024){
                    self.fileSizeDes = [NSString stringWithFormat:@"%.2fMB", self.fileSize / (1024 * 1024)];
                }
            }
                break;
            default:
                break;
        }
    }
    
    return self;
}

- (UIImage*) thumbnailImageForVideo:(NSString *)videoRemotePath atTime:(NSTimeInterval)time {
    if (!videoRemotePath) {
        return nil;
    }
    NSURL *videoURL = [NSURL URLWithString:videoRemotePath];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil] ;
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    return thumbnailImage;
}


- (NSString *)messageId
{
    return _message.messageId;
}

- (HDMessageStatus)messageStatus
{
    return _message.status;
}

- (NSString *)fileLocalPath
{
    if (_firstMessageBody) {
        switch (_firstMessageBody.type) {
            case EMMessageBodyTypeVideo:
            case EMMessageBodyTypeImage:
            case EMMessageBodyTypeVoice:
            case EMMessageBodyTypeFile:
            {
                EMFileMessageBody *fileBody = (EMFileMessageBody *)_firstMessageBody;
                return fileBody.localPath;
            }
                break;
            default:
                break;
        }
    }
    return nil;
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
