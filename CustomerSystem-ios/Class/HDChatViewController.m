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
#import "AppDelegate+HelpDesk.h"
#import "CSDemoAccountManager.h"
#import "HDCustomEmojiManager.h"
#import "HDLeaveMsgViewController.h"
#import "HFileViewController.h"
#import "HDMessageReadManager.h"
#import "KFICloudManager.h"
@interface HDChatViewController ()<UIAlertViewDelegate,HDClientDelegate,UIDocumentPickerDelegate>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
}

@property (nonatomic) NSMutableDictionary *emotionDic;
@property (nonatomic, strong) UIDocumentPickerViewController *documentPickerVC;

@end

@implementation HDChatViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [CSDemoAccountManager shareLoginManager].curChat = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [CSDemoAccountManager shareLoginManager].curChat = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    [[HDClient sharedClient].chatManager bindChatWithConversationId:self.conversation.conversationId];
    [self _setupBarButtonItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAllMessages:) name:KNOTIFICATIONNAME_DELETEALLMESSAGE object:nil];
    if ([_commodityInfo count] > 1) {
        [self sendCommodityMessageWithInfo:_commodityInfo];
        _commodityInfo = nil;
    }
    
    [self tableViewDidTriggerHeaderRefresh];
    
    
    [HDClient.sharedClient.leaveMsgManager getWorkStatusWithToUser:self.conversation.conversationId
                                                        completion:^(BOOL isOn, NSError *aError)
    {
        
    }];

}

//请求视频通话
- (void)moreViewVideoCallAction:(HDChatBarMoreView *)moreView {
    [self stopAudioPlayingWithChangeCategory:YES];
    HDMessage *message = [HDClient.sharedClient.callManager creteVideoInviteMessageWithImId:self.conversation.conversationId content:@"邀请客服进行实时视频"];
    [message addContent:[self visitorInfo]];
    [self _sendMessage:message];
    
    
    //发送im 消息
//    // 调用:
//    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:@"要发送的消息"];
//    // 获取当前登录的环信id
//    NSString *from = [[EMClient sharedClient] currentUsername];
//
//    //生成Message
//    EMMessage *message = [[EMMessage alloc] initWithConversationID:@"c2" from:from to:@"c2" body:body ext:nil];
//    message.chatType = EMChatTypeChat;// 设置为单聊消息
//
//    [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
//
//        } completion:^(EMMessage *message, EMError *error) {
//
//            NSLog(@"====%@ ===%u",message,error.code);
//
//        }];
  
    
}
//发送文件消息
- (void)moreViewFileAction:(HDChatBarMoreView *)moreView {
    
    [self presentDocumentPicker];
    
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"doc"];
//
//    HDMessage *message = [HDMessage createFileSendMessageWithLocalPath:filePath displayName:@"123" to:self.conversation.conversationId];
//
//    [message addContent:[self visitorInfo]];
//    [self _sendMessage:message];
}


// 留言
- (void)moreViewLeaveMessageAction:(HDChatBarMoreView *)moreView
{
    [super moreViewLeaveMessageAction:moreView];
    [self.chatToolbar endEditing:YES];
    [self stopAudioPlayingWithChangeCategory:YES];
    HDLeaveMsgViewController *leaveMsgVC = [[HDLeaveMsgViewController alloc] init];
    [self.navigationController pushViewController:leaveMsgVC animated:YES];
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
        HDOrderInfo *ord = [HDOrderInfo new];
        ord.title = title;
        ord.orderTitle = orderTitle;
        ord.price = price;
        ord.desc = desc;
        ord.imageUrl = imageUrl;
        ord.itemUrl = itemUrl;
        return ord;
    } else {
        HDVisitorTrack *vst = [HDVisitorTrack new];
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
    HDMessage *message = [HDSDKHelper textHMessageFormatWithText:@"" to:self.conversation.conversationId];
    if ([self isOrder]) {
        HDOrderInfo *od  = (HDOrderInfo *)[self trackOrOrder];
        [message addContent:od];
        
        [message addContent:self.visitorInfo];
        NSString *imageName = [info objectForKey:@"imageName"];
        NSMutableDictionary *ext = [message.ext mutableCopy];
        [ext setValue:imageName forKey:@"imageName"];
        message.ext = [ext copy];
        [self _sendMessage:message];
        
    } else {
        HDVisitorTrack *vt = (HDVisitorTrack *)[self trackOrOrder];
        [message addContent:vt];
        
        [message addContent:self.visitorInfo];
        NSString *imageName = [info objectForKey:@"imageName"];
        NSMutableDictionary *ext = [message.ext mutableCopy];
        [ext setValue:imageName forKey:@"imageName"];
        message.ext = [ext copy];
        [self _insertTrackMessage:message];
    }
}


- (void)_insertTrackMessage:(HDMessage *)message
{
    message.status = HDMessageStatusSuccessed;
    [self addMessageToDataSource:message progress:nil];
    [self.conversation addMessage:message error:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    NSLog(@"第二通道已经关闭");
    [[HDClient sharedClient].chatManager unbind];
}

#pragma mark - setup subviews

- (void)_setupBarButtonItem
{
    CustomButton *clearButton = [[CustomButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    clearButton.imageRect = CGRectMake(30, 8, 15, 20);
    clearButton.accessibilityIdentifier = @"clear_message";
    [clearButton setImage:[UIImage imageNamed:@"hd_chat_delete_icon"] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(deleteAllMessages:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *clearItem = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
    self.navigationItem.rightBarButtonItems = @[clearItem];
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
// 设置消息页面右侧显示的昵称和头像
- (id<HDIMessageModel>)messageViewController:(HDMessageViewController *)viewController
                           modelForMessage:(HDMessage *)message
{
    id<HDIMessageModel> model = nil;
    model = [[HDMessageModel alloc] initWithMessage:message];
    model.avatarImage = [UIImage imageNamed:@"HelpDeskUIResource.bundle/user"];
    model.avatarURLPath = [CSDemoAccountManager shareLoginManager].avatarStr;
    model.nickname = [CSDemoAccountManager shareLoginManager].nickname;
    return model;
}

- (NSArray*)emotionFormessageViewController:(HDMessageViewController *)viewController
{
    NSMutableArray *rst = [NSMutableArray arrayWithCapacity:0];
    //添加表情数据源
#pragma mark smallpngface
    NSMutableArray *customEmotions = [NSMutableArray array];
    NSMutableArray *customNameArr = [NSMutableArray arrayWithCapacity:0];
    NSString *customName = nil;
    for (int i=1; i<=35; i++) {
        // 把自定义表情图片加到数组中
        customName = [@"HelpDeskUIResource.bundle/e_e_" stringByAppendingString:[NSString stringWithFormat:@"%d",i]];
        [customNameArr addObject:customName];
    }
    int i = 0;
    // 取出表情字符
    for (NSString *name in [HDConvertToCommonEmoticonsHelper emotionsArray]) {
        //initWithName是表情底部的显示名，可以传空， emotionId传表情名称  emotionThumbnail和emotionOriginal  是传表情字符对应的图片 在UI上显示
        HDEmotion *emotion = [[HDEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:customNameArr[i] emotionOriginal:customNameArr[i] emotionOriginalURL:@"" emotionType:HDEmotionPng];
        [customEmotions addObject:emotion];
        i++;
    }
    HDEmotion *customTemp = [customEmotions objectAtIndex:0];
    HDEmotionManager *customManagerDefault = [[HDEmotionManager alloc] initWithType:HDEmotionPng emotionRow:4 emotionCol:9 emotions:customEmotions tagImage:[UIImage imageNamed:customTemp.emotionThumbnail]];
    customManagerDefault.emotionName = NSLocalizedString(@"default", @"default");
    [rst addObject:customManagerDefault];
    
    NSArray *emojiPackagesDics =[self emojiValueForKey:@"emojiPackages"];
    for (NSDictionary *dic in emojiPackagesDics) {
        HEmojiPackage *package = [[HEmojiPackage alloc] initWithDictionary:dic];
        if (![[CSDemoAccountManager shareLoginManager].tenantId isEqualToString:package.tenantId]) {
            continue;
        }
        NSMutableArray *marr = [NSMutableArray arrayWithCapacity:0];
        NSArray *emojis = [self emojiValueForKey:[NSString stringWithFormat:@"emojis%@",package.packageId]];
        for (NSDictionary *emojiDic in emojis) {
            HEmoji *hemoji = [[HEmoji alloc] initWithDictionary:emojiDic];
            HDEmotion *emotion = [[HDEmotion alloc] initWithName:hemoji.emojiName emotionId:@"123" emotionThumbnail:hemoji.thumbnailUrl emotionOriginal:hemoji.originUrl emotionOriginalURL:hemoji.originUrl emotionType:hemoji.emotionType];
            [marr addObject:emotion];
        }
        if (marr.count > 0) {
            HDEmotion *customTemp = [marr objectAtIndex:0];
            HDEmotionManager *manager = [[HDEmotionManager alloc] initWithType:HDEmotionGif emotionRow:2 emotionCol:4 emotions:marr tagImage:[UIImage imageNamed:customTemp.emotionThumbnail]];
            manager.emotionName = package.packageName;
            [rst addObject:manager];
        }
        
    }
    return rst;
}

- (id)emojiValueForKey:(NSString *)key {
    NSString *path=NSTemporaryDirectory();
    NSString *emojiPath =[path stringByAppendingPathComponent:@"emoji.plist"];
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithContentsOfFile:emojiPath];
    return [mDic valueForKey:key];
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

#pragma mark - action

/**
 继承于父类，点击左上箭头离开聊天界面时执行。本方法禁止执行可能引起父类方法不能释放的代码。
 */
- (void)backItemDidClicked
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
    NSLog(@"返回会话列表");
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompta", @"Prompt") message:NSLocalizedString(@"sureToDelete", @"please make sure to delete") delegate:self cancelButtonTitle:NSLocalizedString(@"cancela", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
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
        
        [self.conversation removeMessageWithMessageId:model.message.messageId error:nil];
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

- (void)stopAudioPlayingWithChangeCategory:(BOOL)isChange
{
    //停止音频播放及播放动画
    [[HDCDDeviceManager sharedInstance] stopPlaying];
    [[HDCDDeviceManager sharedInstance] disableProximitySensor];
    [HDCDDeviceManager sharedInstance].delegate = self;
    
    HDMessageModel *playingModel = [[HDMessageReadManager defaultManager] stopMessageAudioModel];
    NSIndexPath *indexPath = nil;
    if (playingModel) {
        indexPath = [NSIndexPath indexPathForRow:[self.dataArray indexOfObject:playingModel] inSection:0];
    }
    
    if (indexPath) {
        hd_dispatch_main_async_safe(^(){
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        });
    }
}
#pragma mark - 文件上传

- (void)presentDocumentPicker {

    [self presentViewController:self.documentPickerVC animated:YES completion:nil];
}
- (UIDocumentPickerViewController *)documentPickerVC {
    if (!_documentPickerVC) {
        NSArray *documentTypes = @[@"public.content", @"public.text", @"public.source-code ", @"public.image", @"public.audiovisual-content", @"com.adobe.pdf", @"com.apple.keynote.key", @"com.microsoft.word.doc", @"com.microsoft.excel.xls", @"com.microsoft.powerpoint.ppt"];
        self.documentPickerVC = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes inMode:UIDocumentPickerModeOpen];
        _documentPickerVC.delegate = self;
        _documentPickerVC.modalPresentationStyle = UIModalPresentationFormSheet; //设置模态弹出方式
    }
    return _documentPickerVC;
}

#pragma mark - UIDocumentPickerDelegate
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    //获取授权
    BOOL fileUrlAuthozied = [urls.firstObject startAccessingSecurityScopedResource];
    if (fileUrlAuthozied) {
        //通过文件协调工具来得到新的文件地址，以此得到文件保护功能
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
        NSError *error;
        
        [fileCoordinator coordinateReadingItemAtURL:urls.firstObject options:0 error:&error byAccessor:^(NSURL *newURL) {
            //读取文件
            if (error) {
                //读取出错
            } else {
                //文件 上传或者其它操作
//                [self uploadingWithFileData:fileData fileName:fileName fileURL:newURL];
                NSLog(@"------------->文件 上传或者其它操作");
                
                NSArray *array = [[newURL absoluteString] componentsSeparatedByString:@"/"];
                NSString *fileName = [array lastObject];
                fileName = [fileName stringByRemovingPercentEncoding];
                
//                if ([iCloudManager iCloudEnable]) {
                    [KFICloudManager downloadWithDocumentURL:newURL callBack:^(id obj) {
                        NSData *data = obj;
                        //写入沙盒Documents
                        NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",fileName]];
                        
                        [self writeToFile:docPath withData:data];
                        
                    }];
//                }
                
                
                
            }
            [self dismissViewControllerAnimated:YES completion:NULL];
        }];
        [urls.firstObject stopAccessingSecurityScopedResource];
    } else {
        //授权失败
    }
}

- (void)writeToFile:(NSString *)path withData:(NSData *)data{

    NSFileManager *fileManager = [NSFileManager defaultManager];

    //访问【沙盒的document】目录下的问题件，该目录下支持手动增加、修改、删除文件及目录

//    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/文档.docx"];

    if(![fileManager fileExistsAtPath:path]){
        //如果不存在
        BOOL success =   [data writeToFile:path atomically:YES];
        
        if (success) {
            //取出来
//            NSData *   datastr = [NSData dataWithContentsOfFile:path];
//            NSLog(@"------------->文件 上传或者其它操作==%@",datastr);
            HDMessage *message = [HDMessage createFileSendMessageWithLocalPath:path displayName:@"123" to:self.conversation.conversationId];
            [message addContent:[self visitorInfo]];
            [self _sendMessage:message];
        }
        
    }else{
        //取出来 发送
//        NSData *   datastr = [NSData dataWithContentsOfFile:path];
//        NSLog(@"------------->文件 上传或者其它操作==%@",datastr);
        HDMessage *message = [HDMessage createFileSendMessageWithLocalPath:path displayName:@"123" to:self.conversation.conversationId];
        [message addContent:[self visitorInfo]];
                        
        [self _sendMessage:message];
    }
    
    
  
}




@end
