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

#import <Foundation/Foundation.h>

#import "MWPhotoBrowser.h"
#import "HDMessageModel.h"

typedef void (^FinishBlock)(BOOL success);
typedef void (^PlayBlock)(BOOL playing, HDMessageModel *messageModel);

@class EMChatFireBubbleView;
@interface HDMessageReadManager : NSObject<MWPhotoBrowserDelegate>

@property (strong, nonatomic) MWPhotoBrowser *photoBrowser;
@property (strong, nonatomic) FinishBlock finishBlock;

@property (strong, nonatomic) HDMessageModel *audioMessageModel;

+ (id)defaultManager;

//default
- (void)showBrowserWithImages:(NSArray *)imageArray;

- (BOOL)prepareMessageAudioModel:(HDMessageModel *)messageModel
            updateViewCompletion:(void (^)(HDMessageModel *prevAudioModel, HDMessageModel *currentAudioModel))updateCompletion;

- (HDMessageModel *)stopMessageAudioModel;

@end
