//
//  EaseChatViewController.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 15/11/9.
//  Copyright © 2015年 easemob. All rights reserved.
//

#import "EaseChatViewController.h"

#import "EMIMHelper.h"
#import "MessageModelManager.h"
#import "MessageModel.h"

#import "EMChatViewCell.h"
#import "EMChatTextMenuBubbleView.h"
#import "EMChatSatisfactionBubbleView.h"
#import "SatisfactionViewController.h"
#import "EaseMessageToolBar.h"

#define kafterSale @"shouhou"
#define kpreSale @"shouqian"

@interface EaseChatViewController () <EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource,SatisfactionDelegate>

@property (nonatomic) EMDemoSaleType saleType;

@end

@implementation EaseChatViewController

- (instancetype)initWithChatter:(NSString *)chatter
                           type:(EMDemoSaleType)type
{
    self = [super initWithConversationChatter:chatter conversationType:eConversationTypeChat];
    if (self) {
        _saleType = type;
    }
    return self;
}

@synthesize commodityInfo = _commodityInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat chatbarHeight = [EaseMessageToolBar defaultHeight];
    EMChatToolbarType barType = self.conversation.conversationType == eConversationTypeChat ? EMChatToolbarTypeChat : EMChatToolbarTypeGroup;
    self.chatToolbar = [[EaseMessageToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - chatbarHeight, self.view.frame.size.width, chatbarHeight) type:barType];
    self.chatToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    [[EaseBaseMessageCell appearance] setSendBubbleBackgroundImage:[[UIImage imageNamed:@"chat_sender_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:35]];
    [[EaseBaseMessageCell appearance] setRecvBubbleBackgroundImage:[[UIImage imageNamed:@"chat_receiver_bg"] stretchableImageWithLeftCapWidth:35 topCapHeight:35]];
    
    [[EaseBaseMessageCell appearance] setAvatarSize:40.f];
    [[EaseBaseMessageCell appearance] setAvatarCornerRadius:20.f];
    
    [[EaseBaseMessageCell appearance] setSendMessageVoiceAnimationImages:@[[UIImage imageNamed:@"chat_sender_audio_playing_full"], [UIImage imageNamed:@"chat_sender_audio_playing_000"], [UIImage imageNamed:@"chat_sender_audio_playing_001"], [UIImage imageNamed:@"chat_sender_audio_playing_002"], [UIImage imageNamed:@"chat_sender_audio_playing_003"]]];
    [[EaseBaseMessageCell appearance] setRecvMessageVoiceAnimationImages:@[[UIImage imageNamed:@"chat_receiver_audio_playing_full"],[UIImage imageNamed:@"chat_receiver_audio_playing000"], [UIImage imageNamed:@"chat_receiver_audio_playing001"], [UIImage imageNamed:@"chat_receiver_audio_playing002"], [UIImage imageNamed:@"chat_receiver_audio_playing003"]]];
    
    [[EaseBaseMessageCell appearance] setMessageNameIsHidden:YES];
    
    [self.chatBarMoreView removeItematIndex:4];
    [self.chatBarMoreView removeItematIndex:3];
    
    [self _setupBarButtonItem];
    
    [self tableViewDidTriggerHeaderRefresh];
    
    if ([_commodityInfo count] > 0) {
        [self sendCommodityMessageWithInfo:_commodityInfo];
        _commodityInfo = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    //单聊
    if (self.conversation.conversationType == eConversationTypeChat) {
        UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [clearButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(deleteAllMessages:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
    }
}

#pragma mark - UIResponder actions

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    MessageModel *model = [userInfo objectForKey:KMESSAGEKEY];
    if ([eventName isEqualToString:kRouterEventTextURLTapEventName]) {
        [self chatTextCellUrlPressed:[userInfo objectForKey:@"url"]];
    } else if ([eventName isEqualToString:kRouterEventMenuTapEventName]) {
        [self sendTextMessage:[userInfo objectForKey:@"text"]];
    } else if ([eventName isEqualToString:kRouterEventSatisfactionBubbleTapEventName]) {
        [self chatTextCellSatisfactionPressed:model];
    }
}

//链接被点击
- (void)chatTextCellUrlPressed:(NSURL *)url
{
    if (url) {
        [self.chatToolbar endEditing:YES];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)chatTextCellSatisfactionPressed:(MessageModel*)model
{
    SatisfactionViewController *view = [[SatisfactionViewController alloc] init];
    view.messageModel = model;
    view.delegate = self;
    [self.navigationController pushViewController:view animated:YES];
    [self.chatToolbar endEditing:YES];
}

#pragma mark - EaseMessageViewControllerDelegate

- (UITableViewCell *)messageViewController:(UITableView *)tableView
                       cellForMessageModel:(id<IMessageModel>)messageModel
{
    BOOL flag = NO;
    if (messageModel.bodyType == eMessageBodyType_Text) {
        if ([EMChatTextMenuBubbleView isMenuMessage:messageModel.message]) {
            flag = YES;
        } else if ([messageModel.message.ext objectForKey:@"msgtype"]) {
            flag = YES;
        } else if ([EMChatSatisfactionBubbleView isSatisfactionMessage:messageModel.message]) {
            flag = YES;
        }
    }
    if (flag) {
        MessageModel *model = [MessageModelManager modelWithMessage:messageModel.message];
        
        NSString *cellIdentifier = [EMChatViewCell cellIdentifierForMessageModel:model];
        EMChatViewCell *cell = (EMChatViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[EMChatViewCell alloc] initWithMessageModel:model reuseIdentifier:cellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (model.isSender) {
                cell.headImageView.image = [UIImage imageNamed:@"people"];
            }
            else{
                cell.headImageView.image = [UIImage imageNamed:@"customer"];
            }
        }
        cell.messageModel = model;
        
        return cell;
    } else {
        return nil;
    }
}

- (CGFloat)messageViewController:(EaseMessageViewController *)viewController heightForMessageModel:(id<IMessageModel>)messageModel withCellWidth:(CGFloat)cellWidth
{
    BOOL flag = NO;
    if (messageModel.bodyType == eMessageBodyType_Text) {
        if ([EMChatTextMenuBubbleView isMenuMessage:messageModel.message]) {
            flag = YES;
        } else if ([messageModel.message.ext objectForKey:@"msgtype"]) {
            flag = YES;
        } else if ([EMChatSatisfactionBubbleView isSatisfactionMessage:messageModel.message]) {
            flag = YES;
        }
    }
    if (flag) {
        MessageModel *model = [MessageModelManager modelWithMessage:messageModel.message];
        return [EMChatViewCell tableView:viewController.tableView heightForRowAtIndexPath:nil withObject:model];
    } else {
        return 0;
    }
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - EaseMessageViewControllerDataSource

- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message
{
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    if (model.isSender) {
        model.avatarImage = [UIImage imageNamed:@"people"];
    } else {
        model.avatarImage = [UIImage imageNamed:@"customer"];
    }
    model.failImageName = @"imageDownloadFail";
    return model;
}

#pragma mark - SatisfactionDelegate

- (void)commitSatisfactionWithExt:(NSDictionary*)ext messageModel:(MessageModel*)model
{
    NSString *willSendText = [EaseConvertToCommonEmoticonsHelper convertToCommonEmoticons:@""];
    EMChatText *text = [[EMChatText alloc] initWithText:willSendText];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:text];
    
    EMMessage *retureMsg = [[EMMessage alloc] initWithReceiver:self.conversation.chatter bodies:[NSArray arrayWithObject:body]];
    retureMsg.requireEncryption = NO;
    retureMsg.ext = @{kMesssageExtWeChat:ext};
    [[EaseMob sharedInstance].chatManager asyncSendMessage:retureMsg progress:nil prepare:^(EMMessage *message, EMError *error) {} onQueue:dispatch_get_main_queue() completion:^(EMMessage *message, EMError *error) {
        if (!error) {
            [self.tableView reloadData];
            [self showHint:NSLocalizedString(@"satisfaction.success", @"satisfaction success")];
        } else {
            [self showHint:NSLocalizedString(@"satisfaction.failed", @"satisfaction failed")];
        }
        [self.conversation removeMessage:retureMsg];
    } onQueue:dispatch_get_main_queue()];
}

#pragma mark - action

- (void)backAction
{
    if (self.deleteConversationIfNull) {
        //判断当前会话是否为空，若符合则删除该会话
        EMMessage *message = [self.conversation latestMessage];
        if (message == nil) {
            [[EaseMob sharedInstance].chatManager removeConversationByChatter:self.conversation.chatter deleteMessages:NO append2Chat:YES];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteAllMessages:(id)sender
{
    if (self.dataArray.count == 0) {
        [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        return;
    }
    
    if ([sender isKindOfClass:[NSNotification class]]) {
        NSString *groupId = (NSString *)[(NSNotification *)sender object];
        BOOL isDelete = [groupId isEqualToString:self.conversation.chatter];
        if (self.conversation.conversationType != eConversationTypeChat && isDelete) {
            self.messageTimeIntervalTag = -1;
            [self.conversation removeAllMessages];
            [self.messsagesSource removeAllObjects];
            [self.dataArray removeAllObjects];
            
            [self.tableView reloadData];
            [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        }
    }
    else if ([sender isKindOfClass:[UIButton class]]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"sureToDelete", @"please make sure to delete") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
        [alertView show];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        self.messageTimeIntervalTag = -1;
        [self.conversation removeAllMessages];
        [self.dataArray removeAllObjects];
        [self.messsagesSource removeAllObjects];
        
        [self.tableView reloadData];
    }
}

#pragma mark - override
- (void)sendTextMessage:(NSString *)text
{
    NSDictionary *ext = nil;
    ext = [self getWeiChat];
    EMMessage *message = [EaseSDKHelper sendTextMessage:text
                                                     to:self.conversation.chatter
                                            messageType:[self _messageTypeFromConversationType]
                                      requireEncryption:NO
                                             messageExt:ext];
    [self addMessageToDataSource:message
                        progress:nil];
}

- (void)sendImageMessage:(UIImage *)image
{
    NSDictionary *ext = nil;
    ext = [self getWeiChat];
    id<IEMChatProgressDelegate> progress = nil;
    EMMessage *message = [EaseSDKHelper sendImageMessageWithImage:image
                                                               to:self.conversation.chatter
                                                      messageType:[self _messageTypeFromConversationType]
                                                requireEncryption:NO
                                                       messageExt:ext
                                                         progress:progress];
    [self addMessageToDataSource:message
                        progress:progress];
}

- (void)sendVoiceMessageWithLocalPath:(NSString *)localPath duration:(NSInteger)duration
{
    NSDictionary *ext = nil;
    ext = [self getWeiChat];
    id<IEMChatProgressDelegate> progress = nil;
    EMMessage *message = [EaseSDKHelper sendVoiceMessageWithLocalPath:localPath
                                                             duration:duration
                                                                   to:self.conversation.chatter
                                                          messageType:[self _messageTypeFromConversationType]
                                                    requireEncryption:NO
                                                           messageExt:ext
                                                             progress:progress];
    [self addMessageToDataSource:message
                        progress:progress];
}

- (void)sendVideoMessageWithURL:(NSURL *)url
{
    NSDictionary *ext = nil;
    ext = [self getWeiChat];
    id<IEMChatProgressDelegate> progress = nil;
    EMMessage *message = [EaseSDKHelper sendVideoMessageWithURL:url
                                                             to:self.conversation.chatter
                                                    messageType:[self _messageTypeFromConversationType]
                                              requireEncryption:NO
                                                     messageExt:ext
                                                       progress:progress];
    [self addMessageToDataSource:message
                        progress:progress];
}

- (void)sendLocationMessageLatitude:(double)latitude
                          longitude:(double)longitude
                         andAddress:(NSString *)address
{
    NSDictionary *ext = nil;
    ext = [self getWeiChat];
    EMMessage *message = [EaseSDKHelper sendLocationMessageWithLatitude:latitude
                                                              longitude:longitude
                                                                address:address
                                                                     to:self.conversation.chatter
                                                            messageType:[self _messageTypeFromConversationType]
                                                      requireEncryption:NO
                                                             messageExt:ext];
    [self addMessageToDataSource:message
                        progress:nil];
}

- (EMMessageType)_messageTypeFromConversationType
{
    EMMessageType type = eMessageTypeChat;
    switch (self.conversation.conversationType) {
        case eConversationTypeChat:
            type = eMessageTypeChat;
            break;
        case eConversationTypeGroupChat:
            type = eMessageTypeGroupChat;
            break;
        case eConversationTypeChatRoom:
            type = eMessageTypeChatRoom;
            break;
        default:
            break;
    }
    return type;
}

#pragma mark - Ext

- (void)sendCommodityMessageWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:@"type"];
    NSString *title = [info objectForKey:@"title"];
    NSString *desc = [info objectForKey:@"desc"];
    NSString *price = [info objectForKey:@"price"];
    NSString *imageUrl = [info objectForKey:@"img_url"];
    NSString *itemUrl = [info objectForKey:@"item_url"];
    
    NSMutableDictionary *itemDic = [NSMutableDictionary dictionary];
    if (title) {
        [itemDic setObject:title forKey:@"title"];
    }
    if (desc) {
        [itemDic setObject:desc forKey:@"desc"];
    }
    if (price) {
        [itemDic setObject:price forKey:@"price"];
    }
    if (imageUrl) {
        [itemDic setObject:imageUrl forKey:@"img_url"];
    }
    if (itemUrl) {
        [itemDic setObject:itemUrl forKey:@"item_url"];
    }
    
    if ([type isEqualToString:@"order"]) {
        NSString *orderTitle = [info objectForKey:@"order_title"];
        if (orderTitle) {
            [itemDic setObject:orderTitle forKey:@"order_title"];
        }
    }
    
    NSString *imageName = [info objectForKey:@"imageName"];
    NSMutableDictionary *extDic = [NSMutableDictionary dictionaryWithDictionary:[self getWeiChat]];
    [extDic setObject:@{type:itemDic} forKey:@"msgtype"];
    [extDic setObject:imageName forKey:@"imageName"];
    [extDic setObject:@"custom" forKey:@"type"];

    EMMessage *tempMessage = [EaseSDKHelper sendTextMessage:@"客服图文混排消息" to:self.conversation.chatter messageType:eMessageTypeChat requireEncryption:NO messageExt:extDic];
    [self addMessageToDataSource:tempMessage progress:nil];
}

- (NSDictionary*)getUserInfoAttribute
{
    NSDictionary *ext = nil;
    NSMutableDictionary *visitor = [NSMutableDictionary dictionary];
    [visitor setObject:@"李明" forKey:@"trueName"];
    [visitor setObject:@"10000" forKey:@"qq"];
    [visitor setObject:@"13512345678" forKey:@"phone"];
    [visitor setObject:@"环信" forKey:@"companyName"];
    NSString *nickname = [[EMIMHelper defaultHelper] nickname];
    [visitor setObject:nickname.length==0?@"李明":nickname forKey:@"userNickname"];
    [visitor setObject:@"abc@123.com" forKey:@"email"];
    switch (_saleType) {
        case ePreSaleType:
            ext = @{@"visitor":visitor,@"queueName":kpreSale};
            break;
        case eAfterSaleType:
            ext = @{@"visitor":visitor,@"queueName":kafterSale};
            break;
        case eSaleTypeNone:
            ext = @{@"visitor":visitor};
            break;
        default:
            break;
    }
    return ext;
}

- (NSDictionary*)getWeiChat
{
    NSDictionary *ext = nil;
    NSDictionary* weichat = [self getUserInfoAttribute];
    ext = @{kMesssageExtWeChat:weichat};
    return ext;
}

- (NSDictionary*)getCmdUpdateVisitorInfoSrc
{
    NSDictionary *ext = nil;
    NSMutableDictionary *visitor = [NSMutableDictionary dictionary];
    [visitor setObject:[NSString stringWithFormat:@"name-test from hxid:%@",[EMIMHelper defaultHelper].username] forKey:@"name"];
    NSDictionary* weichat = [self getUserInfoAttribute];
    ext = @{@"cmd":@{@"updateVisitorInfoSrc":@{@"params":visitor}},kMesssageExtWeChat:weichat};
    return ext;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
