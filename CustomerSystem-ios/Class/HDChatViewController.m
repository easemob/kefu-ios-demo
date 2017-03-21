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

#import "HDChatViewController.h"
#import "HVisitorTrack.h"
#import "HDLeaveMsgViewController.h"
#import "HFileViewController.h"
@interface HDChatViewController ()<UIAlertViewDelegate,HChatClientDelegate>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UIMenuItem *_transpondMenuItem;
}

@property (nonatomic) BOOL isPlayingAudio;

@property (nonatomic) NSMutableDictionary *emotionDic;
@property (nonatomic, copy) HDSelectAtTargetCallback selectedCallback;

@end

@implementation HDChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    self.visitorInfo = [self visitorInfo];
//    [[HChatClient sharedClient].chat startPollingCname:self.conversation.conversationId];
    [self _setupBarButtonItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAllMessages:) name:KNOTIFICATIONNAME_DELETEALLMESSAGE object:nil];
    if ([_commodityInfo count] > 1) {
        [self sendCommodityMessageWithInfo:_commodityInfo];
        _commodityInfo = nil;
    }
}

//请求视频通话
- (void)moreViewVideoCallAction:(HDChatBarMoreView *)moreView {
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:@"邀请客服进行实时视频"];
    HMessage *callMessage = [[HMessage alloc] initWithConversationID:[HChatClient sharedClient].chat.currentConversationId from:[HChatClient sharedClient].currentUsername to:[HChatClient sharedClient].chat.currentConversationId body:body];
    [callMessage addAttributeDictionary:[self callExt]];
    [callMessage addContent:[self visitorInfo]];
    [self _sendMessage:callMessage];

}

- (NSDictionary *)callExt {
    NSArray *appkeys = [[SCLoginManager shareLoginManager].appkey componentsSeparatedByString:@"#"];
    NSDictionary *dic = @{
                          @"type":@"rtcmedia/video",
                          @"msgtype":@{
                                  @"liveStreamInvitation":@{
                                          @"msg": @"邀请客服进行实时视频",
                                          @"orgName": appkeys[0],
                                          @"appName": appkeys[1],
                                          @"userName": [HChatClient sharedClient].currentUsername,
                                          @"resource": @"mobile_mobile"
                                          }
                                  
                                  },
                          };
    return dic;
}

- (HVisitorInfo *)visitorInfo {
    HVisitorInfo *visitor = [[HVisitorInfo alloc] init];
    visitor.name = @"小明儿";
    visitor.qq = @"12345678";
    visitor.phone = @"13636362637";
    visitor.companyName = @"环信";
    visitor.nickName = [SCLoginManager shareLoginManager].nickname;
    visitor.email = @"abv@126.com";
    visitor.desc = @"环信移动客服";
    return visitor;
}

- (BOOL)isOrder {
    if (_commodityInfo == nil) {
        return NO;
    }
    NSString *type = [_commodityInfo objectForKey:@"type"];
    return [type isEqualToString:@"order"];
}

- (id)trackOrOrder {
    if (_commodityInfo == nil) {
        return nil;
    }
    NSDictionary *info = _commodityInfo;
    NSString *title = [info objectForKey:@"title"];
    NSString *orderTitle = [info objectForKey:@"order_title"];
    NSString *price = [info objectForKey:@"price"];
    NSString *desc = [info objectForKey:@"desc"];
    NSString *imageUrl = [info objectForKey:@"img_url"];
    NSString *itemUrl = [info objectForKey:@"item_url"];
    if ([self isOrder]) { //发送订单消息
        HOrderInfo *ord = [HOrderInfo new];
        ord.title = title;
        ord.orderTitle = orderTitle;
        ord.price = price;
        ord.desc = desc;
        ord.imageUrl = imageUrl;
        ord.itemUrl = itemUrl;
        return ord;
    } else {
        HVisitorTrack *vst = [HVisitorTrack new];
        vst.title = title;
        vst.price = price;
        vst.desc = desc;
        vst.imageUrl = imageUrl;
        vst.itemUrl = itemUrl;
        return vst;
    }
    
    return nil;
}


- (void)sendCommodityMessageWithInfo:(NSDictionary *)info
{
    HMessage *message = [HDSDKHelper textHMessageFormatWithText:@"" to:self.conversation.conversationId];
    if ([self isOrder]) {
        HOrderInfo *od  = (HOrderInfo *)[self trackOrOrder];
        [message addContent:od];
    } else {
        HVisitorTrack *vt = (HVisitorTrack *)[self trackOrOrder];
        [message addContent:vt];
    }
    [message addContent:self.visitorInfo];
    NSString *imageName = [info objectForKey:@"imageName"];
    NSMutableDictionary *ext = [message.ext mutableCopy];
    [ext setValue:imageName forKey:@"imageName"];
    message.ext = [ext copy];
    [self _sendMessage:message];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[HChatClient sharedClient].chat endPolling];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - setup subviews

- (void)_setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backButton.accessibilityIdentifier = @"back";
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    clearButton.accessibilityIdentifier = @"clear_message";
    [clearButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(deleteAllMessages:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *clearItem = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
    
    UIButton *leaveMsgButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leaveMsgButton setImage:[UIImage imageNamed:@"chatBar_comment"]forState:UIControlStateNormal];
    [leaveMsgButton addTarget:self action:@selector(didPressedLeaveMsgButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leaveItem = [[UIBarButtonItem alloc] initWithCustomView:leaveMsgButton];
    
    self.navigationItem.rightBarButtonItems = @[clearItem,leaveItem];
}

- (void)didPressedLeaveMsgButton {
    HDLeaveMsgViewController *leaveMsgVC = [[HDLeaveMsgViewController alloc] init];
    [self.navigationController pushViewController:leaveMsgVC animated:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        self.messageTimeIntervalTag = -1;
        [self.conversation deleteAllMessages:nil];
        [self.dataArray removeAllObjects];
        [self.messsagesSource removeAllObjects];
        [self.tableView reloadData];
    }
}

#pragma mark - HDMessageViewControllerDelegate

- (BOOL)messageViewController:(HDMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)messageViewController:(HDMessageViewController *)viewController fileMessageCellSelected:(id<HDIMessageModel>)model {
    HFileViewController *fileVC = [[HFileViewController alloc] init];
    fileVC.model = model;
    [self.navigationController pushViewController:fileVC animated:YES];
}

- (BOOL)messageViewController:(HDMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if (![object isKindOfClass:[NSString class]]) {
        HDMessageCell *cell = (HDMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        self.menuIndexPath = indexPath;
        [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
    }
    return YES;
}

- (void)messageViewController:(HDMessageViewController *)viewController
  didSelectAvatarMessageModel:(id<HDIMessageModel>)messageModel
{

}


#pragma mark - HDMessageViewControllerDataSource

- (id<HDIMessageModel>)messageViewController:(HDMessageViewController *)viewController
                           modelForMessage:(HMessage *)message
{
    id<HDIMessageModel> model = nil;
    model = [[HDMessageModel alloc] initWithMessage:message];
    model.avatarImage = [UIImage imageNamed:@"HelpDeskUIResource.bundle/user"];
    model.avatarURLPath = @"";
    model.failImageName = @"imageDownloadFail";
    return model;
}

- (NSArray*)emotionFormessageViewController:(HDMessageViewController *)viewController
{
    NSMutableArray *emotions = [NSMutableArray array];
    for (NSString *name in [HDEmoji allEmoji]) {
        HDEmotion *emotion = [[HDEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:HDEmotionDefault];
        [emotions addObject:emotion];
    }
    HDEmotion *temp = [emotions objectAtIndex:0];
    HDEmotionManager *managerDefault = [[HDEmotionManager alloc] initWithType:HDEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed:temp.emotionId]];
    
    return @[managerDefault];
}

- (BOOL)isEmotionMessageFormessageViewController:(HDMessageViewController *)viewController
                                    messageModel:(id<HDIMessageModel>)messageModel
{
    BOOL flag = NO;
    if ([messageModel.message.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
        return YES;
    }
    return flag;
}

- (HDEmotion*)emotionURLFormessageViewController:(HDMessageViewController *)viewController
                                      messageModel:(id<HDIMessageModel>)messageModel
{
    NSString *emotionId = [messageModel.message.ext objectForKey:MESSAGE_ATTR_EXPRESSION_ID];
    HDEmotion *emotion = [_emotionDic objectForKey:emotionId];
    if (emotion == nil) {
        emotion = [[HDEmotion alloc] initWithName:@"" emotionId:emotionId emotionThumbnail:@"" emotionOriginal:@"" emotionOriginalURL:@"" emotionType:HDEmotionGif];
    }
    return emotion;
}

- (NSDictionary*)emotionExtFormessageViewController:(HDMessageViewController *)viewController
                                        easeEmotion:(HDEmotion*)easeEmotion
{
    return @{MESSAGE_ATTR_EXPRESSION_ID:easeEmotion.emotionId,MESSAGE_ATTR_IS_BIG_EXPRESSION:@(YES)};
}

- (void)messageViewControllerMarkAllMessagesAsRead:(HDMessageViewController *)viewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
}

#pragma mark - HelpDesk

#pragma mark - HClientDelegate

- (void)userAccountDidLoginFromOtherDevice
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)userAccountDidRemoveFromServer
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)userDidForbidByServer
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

#pragma mark - action

- (void)backAction
{
    if (self.deleteConversationIfNull) {
        //判断当前会话是否为空，若符合则删除该会话
        HMessage *message = [self.conversation latestMessage];
        if (message == nil) {
            [[HChatClient sharedClient].chat deleteConversation:self.conversation.conversationId deleteMessages:NO];
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
        NSString *chattingID = (NSString *)[(NSNotification *)sender object];
        BOOL isDelete = [chattingID isEqualToString:self.conversation.conversationId];
        if (isDelete) {
            self.messageTimeIntervalTag = -1;
            [self.conversation deleteAllMessages:nil];
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

- (void)copyMenuAction:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<HDIMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        pasteboard.string = model.text;
    }
    self.menuIndexPath = nil;
}

- (void)deleteMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<HDIMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:self.menuIndexPath.row];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:self.menuIndexPath, nil];
        
        [self.conversation deleteMessageWithId:model.message.messageId error:nil];
        [self.messsagesSource removeObject:model.message];
        
        if (self.menuIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row - 1)];
            if (self.menuIndexPath.row + 1 < [self.dataArray count]) {
                nextMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:self.menuIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(self.menuIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataArray removeObjectsAtIndexes:indexs];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        if ([self.dataArray count] == 0) {
            self.messageTimeIntervalTag = -1;
        }
    }
    self.menuIndexPath = nil;
}

#pragma mark - private
- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType
{
    if (self.menuController == nil) {
        self.menuController = [UIMenuController sharedMenuController];
    }
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"delete", @"Delete") action:@selector(deleteMenuAction:)];
    }
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"copy", @"Copy") action:@selector(copyMenuAction:)];
    }
    if (messageType == EMMessageBodyTypeText) {
        [self.menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem]];
    } else if (messageType == EMMessageBodyTypeImage){
        [self.menuController setMenuItems:@[_deleteMenuItem]];
    } else {
        [self.menuController setMenuItems:@[_deleteMenuItem]];
    }
    [self.menuController setTargetRect:showInView.frame inView:showInView.superview];
    [self.menuController setMenuVisible:YES animated:YES];
}
@end
