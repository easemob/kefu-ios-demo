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

#define KNOTIFICATIONNAME_DELETEALLMESSAGE @"RemoveAllMessages"
#import "HDMessageViewController.h"

@protocol HDChatViewControllerDelegate <NSObject>

//在聊天界面点击返回按钮回到会话列表界面
- (void)backToConversationListWithConversation:(HConversation *)conversation;

@end

@interface HDChatViewController : HDMessageViewController <HDMessageViewControllerDelegate, HDMessageViewControllerDataSource>

@property (strong, nonatomic) NSDictionary *commodityInfo; //商品信息
@property(nonatomic,weak) id<HDChatViewControllerDelegate> backDelegate; //


- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType;

@end
