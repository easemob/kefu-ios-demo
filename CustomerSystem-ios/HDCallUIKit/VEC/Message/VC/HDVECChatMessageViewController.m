
#import "HDVECChatMessageViewController.h"
#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "NSDate+Category.h"
#import "HDMessageReadManager.h"
#import "HDEmotionManager.h"
#import "HDEmoji.h"
#import "HDEmotionEscape.h"
#import "HDCustomMessageCell.h"
#import "UIImage+HDGIF.h"
#import "HDLocalDefine.h"
#import "HDSDKHelper.h"
#import "HDBubbleView+Transform.h"
#import "HDBubbleView+Evaluate.h"
#import "SatisfactionViewController.h"
#import "HArticleWebViewController.h"
#import "HDFormWebViewController.h"
#import "UIViewController+HDHUD.h"
#import "UIViewController+AlertController.h"
#import "HRobotUnsolveItemView.h"
#import "HDCustomEmojiManager.h"
#import "CSDemoAccountManager.h"
#import "HDVECAgoraCallManager.h"
typedef enum : NSUInteger {
    HDRequestRecord,
    HDCanRecord,
    HDCanNotRecord,
} HDRecordResponse;

@interface HDVECChatMessageViewController ()<HDMessageCellDelegate,HDChatManagerDelegate,TransmitDeleteTrackMsgDelegate, UIGestureRecognizerDelegate,HRobotUnsolveItemViewDelegate>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    BOOL _isRecording;
    dispatch_queue_t _messageQueue;
    BOOL _isSendingTransformMessage; //正在发送转人工消息
}

@property (nonatomic, assign) HDemoSaleType saleType;


@end

@implementation HDVECChatMessageViewController
{
    NSString *_title;
}

@synthesize conversation = _conversation;
@synthesize messageCountOfPage = _messageCountOfPage;
@synthesize timeCellHeight = _timeCellHeight;
@synthesize messageTimeIntervalTag = _messageTimeIntervalTag;

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter {
    if ([conversationChatter length] == 0) {
        return nil;
    }
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _conversation = [[HDClient sharedClient].chatManager getConversation:conversationChatter];
        _title = conversationChatter;
        _messageCountOfPage = 10;
        _timeCellHeight = 30;
        _messsagesSource = [NSMutableArray array];
        [_conversation markAllMessagesAsRead:nil];
    }
    
    return self;
}

- (void)agentInputStateChange:(NSString *)content {
    if (content!=nil) {
        self.title = content;
    } else {
        self.title = _title;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_conversation.officialAccount.name) {
        _title = _conversation.officialAccount.name;
    }
    self.title = _title;
    [[HDClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    self.view.backgroundColor = UIColor.whiteColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatToolbarState) name:@"chatToolbarState" object:nil];
    
    //Initialization
    CGFloat chatbarHeight = [HDVECChatToolbar defaultHeight];
    
    self.videoChatToolbar = [[HDVECChatToolbar alloc] initWithFrame:CGRectMake(0, self.view.hd_height - chatbarHeight - iPhoneXBottomHeight, self.view.hd_width, chatbarHeight)];
    self.videoChatToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    //Initializa the gesture recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(keyBoardHidden:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5;
    [self.tableView addGestureRecognizer:lpgr];
    
    _messageQueue = dispatch_queue_create("com.helpdesk.message.queue", NULL);
    
    //Register the delegate
    [HDCDDeviceManager sharedInstance].delegate = self;
    
//    [self setLeftBarBtnItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [self setupCell];

    
    // 获取之前的消息记录，目前该方法放在了ChatViewController中调用，如果您没有使用，需要打开该方法
    //    [self tableViewDidTriggerHeaderRefresh];
    
    
    [HDClient.sharedClient.leaveMsgManager getWorkStatusWithToUser:_conversation.conversationId
                                                        completion:^(BOOL isOn, NSError *aError)
    {
            
    }];
}

- (void)setupCell {
    
    [[HDBaseMessageCell appearance] setSendBubbleBackgroundImage:[[UIImage imageNamed:@"HelpDeskUIResource.bundle/chat_sender_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:35]];
    [[HDBaseMessageCell appearance] setRecvBubbleBackgroundImage:[[UIImage imageNamed:@"HelpDeskUIResource.bundle/chat_receiver_bg"] stretchableImageWithLeftCapWidth:35 topCapHeight:35]];
    [[HDBaseMessageCell appearance] setAvatarSize:40.f];
    [[HDBaseMessageCell appearance] setAvatarCornerRadius:20.f];
    [[HDChatBarMoreView appearance] setMoreViewBackgroundColor:[UIColor colorWithRed:240 / 255.0 green:242 / 255.0 blue:247 / 255.0 alpha:1.0]];
}

- (void)chatToolbarState
{
    [self.videoChatToolbar endEditing:YES];
}

- (void)setLeftBarBtnItem {
    CustomButton * backButton = [CustomButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"Shape"] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:RGBACOLOR(184, 22, 22, 1) forState:UIControlStateHighlighted];
    backButton.imageRect = CGRectMake(-10, 6.5, 16, 16);
    backButton.titleRect = CGRectMake(10, 0, 60, 29);
    [self.view addSubview:backButton];
    backButton.frame = CGRectMake(0, 0, 60, 29);
    
    [backButton addTarget:self action:@selector(backItemClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer.width = - 16;
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer,backItem];
}

- (void)backItemClicked {
    [[HDCDDeviceManager sharedInstance] disableProximitySensor];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[HDClient sharedClient].chatManager removeDelegate:self];
    [self.navigationController popViewControllerAnimated:YES];
    [self backItemDidClicked];
}

- (void)backItemDidClicked {
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        if (touch.view.hd_width == 200 || touch.view.tag == 1990) {
            return NO;
        }
    }
    
    if ([touch.view isKindOfClass:HDRecordView.class]) {
        return NO;
    }
    
    if(touch.view.tag == 1991){
        return NO; //tag in Cell+Form.h
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [HDCDDeviceManager sharedInstance].delegate = nil;
    
    if (_imagePicker){
        [_imagePicker dismissViewControllerAnimated:NO completion:nil];
        _imagePicker = nil;
    }
    [HDLog logD:@"HD===%s dealloc",__func__];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - getter

- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle= UIModalPresentationOverFullScreen;
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}

#pragma mark - setter

- (void)setVideoChatToolbar:(HDVECChatToolbar *)videoChatToolbar
{
    [_videoChatToolbar removeFromSuperview];
    
    _videoChatToolbar = videoChatToolbar;
    if (videoChatToolbar) {
        [self.view addSubview:_videoChatToolbar];
        _visitorWaitCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -20, kScreenWidth, 20)];
        _visitorWaitCountLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _visitorWaitCountLabel.font = [UIFont systemFontOfSize:12];
        _visitorWaitCountLabel.textColor = [UIColor whiteColor];
        _visitorWaitCountLabel.hidden = YES;
        [_videoChatToolbar addSubview:_visitorWaitCountLabel];
    }
    
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = self.view.frame.size.height - _videoChatToolbar.frame.size.height-iPhoneXBottomHeight;
    self.tableView.frame = tableFrame;
    if ([videoChatToolbar isKindOfClass:[HDVECChatToolbar class]]) {
        [(HDVECChatToolbar *)self.videoChatToolbar setDelegate:self];
        self.chatBarMoreView = (HDChatBarMoreView*)[(HDVECChatToolbar *)self.videoChatToolbar moreView];
        self.faceView = (HDFaceView*)[(HDVECChatToolbar *)self.videoChatToolbar faceView];
        // 初始化录音按钮所在的view
        self.recordView = (HDRecordView *)[(HDVECChatToolbar *)self.videoChatToolbar recordView];
        // 添加代理
        self.recordView.delegate = self;
    }
}

- (void)setDataSource:(id<HDVECChatMessageViewControllerDataSource>)dataSource
{
    _dataSource = dataSource;
    
   
}

- (void)setDelegate:(id<HDVECChatMessageViewControllerDelegate>)delegate
{
    _delegate = delegate;
}

#pragma mark - private helper

- (void)_scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
    }
}



- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType
{
    if (_menuController == nil) {
        _menuController = [UIMenuController sharedMenuController];
    }
    
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:NSEaseLocalizedString(@"delete", @"Delete") action:@selector(deleteMenuAction:)];
    }
    
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:NSEaseLocalizedString(@"copy", @"Copy") action:@selector(copyMenuAction:)];
    }
    
    if (messageType == EMMessageBodyTypeText) {
        [_menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem]];
    } else {
        [_menuController setMenuItems:@[_deleteMenuItem]];
    }
    [_menuController setTargetRect:showInView.frame inView:showInView.superview];
    [_menuController setMenuVisible:YES animated:YES];
}



- (NSURL *)_convert2Mp4:(NSURL *)movUrl
{
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetHighestQuality];
        NSString *mp4Path = [NSString stringWithFormat:@"%@/%d%d.mp4", [HDCDDeviceManager dataPath], (int)[[NSDate date] timeIntervalSince1970], arc4random() % 100000];
        mp4Url = [NSURL fileURLWithPath:mp4Path];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    [HDLog logE:@"HD===%s failed, error:%@",__func__,exportSession.error];
                } break;
                case AVAssetExportSessionStatusCancelled: {
        
                    [HDLog logD:@"HD===%s cancelled",__func__];
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    
                    [HDLog logD:@"HD===%s completed",__func__];
                } break;
                default: {
                    
                    [HDLog logD:@"HD===%s others",__func__];
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
        
            [HDLog logD:@"HD===%s timeout",__func__];
        }
        if (wait) {
            //dispatch_release(wait);
            wait = nil;
        }
    }
    
    return mp4Url;
}


- (void)_downloadMessageAttachments:(HDMessage *)message
{
    __weak typeof(self) weakSelf = self;
    void (^completion)(HDMessage *, HDError *) = ^(HDMessage *aMessage, HDError *error) {
        if (!error)
        {
            [weakSelf _reloadTableViewDataWithMessage:message];
        }
        else
        {
            [weakSelf showHint:NSEaseLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
        }
    };
    
    EMMessageBody *messageBody = message.body;
    if ([messageBody type] == EMMessageBodyTypeImage) {
        EMImageMessageBody *imageBody = (EMImageMessageBody *)messageBody;
        if (imageBody.thumbnailDownloadStatus > EMDownloadStatusSuccessed) {
            //download the message thumbnail
            [[HDClient sharedClient].chatManager downloadAttachment:message progress:nil completion:completion];
        }
    }else if ([messageBody type] == EMMessageBodyTypeVideo) {
        
         EMVideoMessageBody *videoBody = (EMVideoMessageBody *)messageBody;

        UIImage * img = [UIImage imageWithContentsOfFile:videoBody.thumbnailLocalPath];
        [HDLog logD:@"HD===%s 获取图片的尺寸 with==%f height===%f",__func__,img.size.width,img.size.height];
         if (videoBody.thumbnailDownloadStatus > EMDownloadStatusSuccessed) {
         //download the message thumbnail
         [[HDClient sharedClient].chatManager hd_downloadThumbnail:message progress:nil completion:completion];
         }
         
    }else if ([messageBody type] == EMMessageBodyTypeVoice)
    {
        EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody*)messageBody;
        if (voiceBody.downloadStatus > EMDownloadStatusSuccessed) {
            //download the message attachment
            [[HDClient sharedClient].chatManager downloadAttachment:message progress:nil completion:^(HDMessage *message, HDError *error) {
                if (!error) {
                    [weakSelf _reloadTableViewDataWithMessage:message];
                }
                else {
                    [weakSelf showHint:NSEaseLocalizedString(@"message.voiceFail", @"voice for failure!")];
                }
            }];
        }
    }
}

- (void)_locationMessageCellSelected:(id<HDIMessageModel>)model
{
    HDLocationViewController *locationController = [[HDLocationViewController alloc] initWithLocation:CLLocationCoordinate2DMake(model.latitude, model.longitude)];
    [self.navigationController pushViewController:locationController animated:YES];
}

- (void)_fileMessageCellSelected:(id<HDIMessageModel>)model{
    if (_delegate && [_delegate respondsToSelector:@selector(messageViewController:fileMessageCellSelected:)]) {
        [_delegate messageViewController:self fileMessageCellSelected:model];
    }
}

- (void)_videoMessageCellSelected:(id<HDIMessageModel>)model
{
    
    EMVideoMessageBody *videoBody = (EMVideoMessageBody*)model.message.body;
    NSString *localPath = [model.fileLocalPath length] > 0 ? model.fileLocalPath : videoBody.localPath;
    if ([localPath length] == 0) {
        [self showHint:NSEaseLocalizedString(@"message.videoFail", @"video for failure!")];
        return;
    }
    
    dispatch_block_t block = ^{
        //send the acknowledgement
        
//        NSString * p = [NSString stringWithFormat:@"%@.mp4",localPath];
        
        NSURL *videoURL = [NSURL fileURLWithPath:localPath];
        AVPlayerViewController * pVC = [AVPlayerViewController new];
        pVC.player = [AVPlayer playerWithURL:videoURL];
        [pVC.player play];
        pVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:pVC animated:YES completion:nil];
    };
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
        block();
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    [self showHudInView:self.view hint:NSEaseLocalizedString(@"message.downloadingVideo", @"downloading video...")];
    [[HDClient sharedClient].chatManager downloadAttachment:model.message progress:nil completion:^(HDMessage *message, HDError *error) {
        [weakSelf hideHud];
        if (!error) {
            block();
        }else{
            [weakSelf showHint:NSEaseLocalizedString(@"message.videoFail", @"video for failure!")];
        }
    }];
}

- (void) _formMessageCellSelected:(id<HDIMessageModel>)model
{
    HDFormWebViewController *formVC = [[HDFormWebViewController alloc]init];
    NSDictionary *htmlDic = [[model.message.ext objectForKey:@"msgtype"] objectForKey:@"html"];
    NSString *strUrl = [htmlDic objectForKey:@"url"];
    formVC.url = strUrl;
    formVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:formVC animated:YES completion:nil];
    
}

- (void)_imageMessageCellSelected:(id<HDIMessageModel>)model
{
    kWeakSelf
    EMImageMessageBody *imageBody = (EMImageMessageBody*)[model.message body];
    if ([imageBody type] == EMMessageBodyTypeImage) {
        if (imageBody.thumbnailDownloadStatus == EMDownloadStatusSuccessed) {
            if (imageBody.downloadStatus == EMDownloadStatusSuccessed)
            {
                NSString *localPath = model.message == nil ? model.fileLocalPath : [imageBody localPath];
                if (localPath && localPath.length > 0) {
                    UIImage *image = [UIImage imageWithContentsOfFile:localPath];
                    
                    if (image)
                    {
                        [[HDMessageReadManager defaultManager] showBrowserWithImages:@[image]];
                    }
                    else
                    {
                        [HDLog logD:@"HD===%s Read %@ failed!",__func__,localPath];
                    }
                    return;
                }
            }
            [weakSelf showHudInView:weakSelf.view hint:NSEaseLocalizedString(@"message.downloadingImage", @"downloading a image...")];
            [[HDClient sharedClient].chatManager downloadAttachment:model.message progress:nil completion:^(HDMessage *message, HDError *error) {
                [weakSelf hideHud];
                if (!error) {
                    //send the acknowledgement
                    NSString *localPath = message == nil ? model.fileLocalPath : [(EMImageMessageBody*)message.body localPath];
                    if (localPath && localPath.length > 0) {
                        UIImage *image = [UIImage imageWithContentsOfFile:localPath];
                        //                                weakSelf.isScrollToBottom = NO;
                        if (image)
                        {
                            [[HDMessageReadManager defaultManager] showBrowserWithImages:@[image]];
                        }
                        else
                        {
                          
                            [HDLog logD:@"HD===%s Read %@ failed!",__func__,localPath];
                        }
                        return ;
                    }
                }
                [weakSelf showHint:NSEaseLocalizedString(@"message.imageFail", @"image for failure!")];
            }];
        }else{
            //get the message thumbnail
            [[HDClient sharedClient].chatManager downloadAttachment:model.message progress:nil completion:^(HDMessage *message, HDError *error) {
                if (!error) {
                    [weakSelf _reloadTableViewDataWithMessage:model.message];
                }else{
                    [weakSelf showHint:NSEaseLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
                }
            }];
            
            [[HDClient sharedClient].chatManager downloadThumbnail:model.message progress:nil completion:^(HDMessage *message, HDError *error) {
                if (!error) {
                    [weakSelf _reloadTableViewDataWithMessage:model.message];
                }else{
                    [weakSelf showHint:NSEaseLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
                }
            }];
        }
    }
}

#pragma mark - pivate data

- (void)_loadMessagesBefore:(NSString*)messageId
                      count:(NSInteger)count
                     append:(BOOL)isAppend
{
    __weak typeof(self) weakSelf = self;
    void (^refresh)(NSArray *messages) = ^(NSArray *messages) {
        dispatch_async(_messageQueue, ^{
            //Format the message
            NSArray *formattedMessages = [weakSelf formatMessages:messages];
            //Refresh the page
            hd_dispatch_main_async_safe(^(){
                HDVECChatMessageViewController *strongSelf = weakSelf;
                if (strongSelf) {
                    NSInteger scrollToIndex = 0;
                    if (isAppend) {
                        [strongSelf.messsagesSource insertObjects:messages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [messages count])]];
                        //Combine the message
                        id object = [strongSelf.dataArray firstObject];
                        if ([object isKindOfClass:[NSString class]]) {
                            NSString *timestamp = object;
                            [formattedMessages enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id model, NSUInteger idx, BOOL *stop) {
                                if ([model isKindOfClass:[NSString class]] && [timestamp isEqualToString:model]) {
                                    [strongSelf.dataArray removeObjectAtIndex:0];
                                    *stop = YES;
                                }
                            }];
                        }
                        scrollToIndex = [strongSelf.dataArray count];
                        [strongSelf.dataArray insertObjects:formattedMessages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [formattedMessages count])]];
                    }
                    else {
                        [strongSelf.messsagesSource removeAllObjects];
                        [strongSelf.messsagesSource addObjectsFromArray:messages];
                        
                        [strongSelf.dataArray removeAllObjects];
                        [strongSelf.dataArray addObjectsFromArray:formattedMessages];
                    }
                    
                    HDMessage *latest = [strongSelf.messsagesSource lastObject];
                    strongSelf.messageTimeIntervalTag = latest.messageTime;
                    
                    [strongSelf.tableView reloadData];
                    
                    [strongSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count] - scrollToIndex - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            });
            //re-download all messages that are not successfully downloaded
            for (HDMessage *message in messages)
            {
                [weakSelf _downloadMessageAttachments:message];
            }
        });
    };
    
    [self.conversation loadMessagesStartFromId:messageId
                                         count:(int)count
                               searchDirection:HDMessageSearchDirectionUp
                                    completion:^(NSArray *aMessages, HDError *aError)
     {
        if (!aError && [aMessages count]) {
            refresh(aMessages);
        }
    }];
}

#pragma mark - GestureRecognizer

// 要解决这里点击背景的问题，键盘不编辑的问题
-(void)keyBoardHidden:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        // 解决还在录音的问题
        [self.videoChatToolbar endEditing:YES];
        
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan && [self.dataArray count] > 0)
    {
        CGPoint location = [recognizer locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:location];
        
        BOOL canLongPress = NO;
        if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:canLongPressRowAtIndexPath:)]) {
            canLongPress = [_dataSource messageViewController:self
                                   canLongPressRowAtIndexPath:indexPath];
        }
        
        if (!canLongPress) {
            return;
        }
        
        if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:didLongPressRowAtIndexPath:)]) {
            [_dataSource messageViewController:self
                    didLongPressRowAtIndexPath:indexPath];
        }
        else{
            id object = [self.dataArray objectAtIndex:indexPath.row];
            if (![object isKindOfClass:[NSString class]]) {
                HDMessageCell *cell = (HDMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                [cell becomeFirstResponder];
                _menuIndexPath = indexPath;
                [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    //time cell
    if ([object isKindOfClass:[NSString class]]) {
        NSString *TimeCellIdentifier = [HDMessageTimeCell cellIdentifier];
        HDMessageTimeCell *timeCell = (HDMessageTimeCell *)[tableView dequeueReusableCellWithIdentifier:TimeCellIdentifier];
        
        if (timeCell == nil) {
            timeCell = [[HDMessageTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TimeCellIdentifier];
            timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        timeCell.title = object;
        return timeCell;
    }
    else{
        id<HDIMessageModel> model = object;
        if (_delegate && [_delegate respondsToSelector:@selector(messageViewController:cellForMessageModel:)]) {
            UITableViewCell *cell = [_delegate messageViewController:tableView cellForMessageModel:model];
            if (cell) {
                if ([cell isKindOfClass:[HDMessageCell class]]) {
                    HDMessageCell *emcell= (HDMessageCell*)cell;
                    if (emcell.delegate == nil) {
                        emcell.delegate = self;
                    }
                }
                return cell;
            }
        }
        
        if (_dataSource && [_dataSource respondsToSelector:@selector(isEmotionMessageFormessageViewController:messageModel:)]) {
            BOOL flag = [_dataSource isEmotionMessageFormessageViewController:self messageModel:model];
            if (flag) {
                NSString *CellIdentifier = [HDCustomMessageCell cellIdentifierWithModel:model];
                //send cell
                HDCustomMessageCell *sendCell = (HDCustomMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                // Configure the cell...
                if (sendCell == nil) {
                    sendCell = [[HDCustomMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier model:model];
                    sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                if (_dataSource && [_dataSource respondsToSelector:@selector(emotionURLFormessageViewController:messageModel:)]) {
                    HDEmotion *emotion = [_dataSource emotionURLFormessageViewController:self messageModel:model];
                    if (emotion) {
                        model.image = [UIImage hdSD_animatedGIFNamed:emotion.emotionOriginal];
                        model.fileURLPath = emotion.emotionOriginalURL;
                    }
                }
                sendCell.model = model;
                sendCell.delegate = self;
                return sendCell;
            }
        }
        
        NSString *CellIdentifier = [HDMessageCell cellIdentifierWithModel:model];
        
        HDBaseMessageCell *sendCell = (HDBaseMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (sendCell == nil) {
            sendCell = [[HDBaseMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier model:model];
            sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
            sendCell.delegate = self;
            // 删除轨迹消息代理
            sendCell.deleteTrackMsgdelegate = self;
        }
        sendCell.model = model;
        return sendCell;
    }
}

- (void)messageStatusDidChange:(HDMessage *)aMessage error:(HDError *)aError {
    //    [self _refreshAfterSentMessage:aMessage];
}


// 删除轨迹消息代理方法
- (void)transmitDelegateTrackMessage:(id<HDIMessageModel>)model sendButton:(UIButton *)sendButton
{
    // 取出父类，找到按钮所在的cell
    UIView *view = [[[sendButton superview] superview] superview];
    HDBaseMessageCell *cell = (HDBaseMessageCell *)[view superview];
    // 取到cell所对应的indePath
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // 传给全局变量，根据indexPath移除cell
    self.snedButtonIndexPath = indexPath;
    // 发送轨迹消息
    [self _sendTrackMessage:model];
}

- (void)_sendTrackMessage:(id<HDIMessageModel>)trackModel
{
    
    __weak typeof(self) weakself = self;
    
    [[HDClient sharedClient].chatManager sendMessage:trackModel.message progress:nil completion:^(HDMessage *message, HDError *error) {
        if (!error) {
            // 删除对应的消息
            [weakself deleteTrackMessage:trackModel];
        }
        else {
            [weakself.tableView reloadData];
        }
    }];
    
}

- (void)deleteTrackMessage:(id<HDIMessageModel>)trackModel
{
    if (self.snedButtonIndexPath && self.snedButtonIndexPath.row > 0) {
        id<HDIMessageModel> model = trackModel;
        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:self.snedButtonIndexPath.row];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:self.snedButtonIndexPath, nil];
        
        [self.conversation removeMessageWithMessageId:model.message.messageId error:nil];
        [self.messsagesSource removeObject:model.message];
        
        if (self.snedButtonIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataArray objectAtIndex:(self.snedButtonIndexPath.row - 1)];
            if (self.snedButtonIndexPath.row + 1 < [self.dataArray count]) {
                nextMessage = [self.dataArray objectAtIndex:(self.snedButtonIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:self.snedButtonIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(self.snedButtonIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataArray removeObjectsAtIndexes:indexs];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
    
    self.snedButtonIndexPath = nil;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[NSString class]]) {
        return self.timeCellHeight;
    }
    else{
        id<HDIMessageModel> model = object;
        if (_delegate && [_delegate respondsToSelector:@selector(messageViewController:heightForMessageModel:withCellWidth:)]) {
            CGFloat height = [_delegate messageViewController:self heightForMessageModel:model withCellWidth:tableView.frame.size.width];
            if (height) {
                return height;
            }
        }
        
        if (_dataSource && [_dataSource respondsToSelector:@selector(isEmotionMessageFormessageViewController:messageModel:)]) {
            BOOL flag = [_dataSource isEmotionMessageFormessageViewController:self messageModel:model];
            if (flag) {
                return [HDCustomMessageCell cellHeightWithModel:model];
            }
        }
        
        return [HDBaseMessageCell cellHeightWithModel:model];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        // video url:
        // file:///private/var/mobile/Applications/B3CDD0B2-2F19-432B-9CFA-158700F4DE8F/tmp/capture-T0x16e39100.tmp.9R8weF/capturedvideo.mp4
        // we will convert it to mp4 format
        NSURL *mp4 = [self _convert2Mp4:videoURL];
        NSFileManager *fileman = [NSFileManager defaultManager];
        if ([fileman fileExistsAtPath:videoURL.path]) {
            NSError *error = nil;
            [fileman removeItemAtURL:videoURL error:&error];
            if (error) {
                [HDLog logE:@"HD===%s failed to remove file, error:%@.",__func__,error];
            }
        }
        
        [self sendVideoMessageWithURL:mp4];
        
    }else{
        
        NSURL *url = info[UIImagePickerControllerReferenceURL];
        if (url == nil) {
            UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
            [self sendImageMessage:orgImage];
        } else {
            if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0f) {
                PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[url] options:nil];
                [result enumerateObjectsUsingBlock:^(PHAsset *asset , NSUInteger idx, BOOL *stop){
                    if (asset) {
                        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData *data, NSString *uti, UIImageOrientation orientation, NSDictionary *dic){
                            if (data.length > 10 * 1000 * 1000) {
                                [self showHint:NSEaseLocalizedString(@"message.smallerImage", @"The image size is too large, please choose another one")];
                                return;
                            }
                            if (data != nil) {
                                [self sendImageMessageWithData:data];
                            } else {
                                [self showHint:NSEaseLocalizedString(@"message.smallerImage", @"The image size is too large, please choose another one")];
                            }
                        }];
                    }
                }];
            } else {
                ALAssetsLibrary *alasset = [[ALAssetsLibrary alloc] init];
                [alasset assetForURL:url resultBlock:^(ALAsset *asset) {
                    if (asset) {
                        ALAssetRepresentation* assetRepresentation = [asset defaultRepresentation];
                        Byte* buffer = (Byte*)malloc((size_t)[assetRepresentation size]);
                        NSUInteger bufferSize = [assetRepresentation getBytes:buffer fromOffset:0.0 length:(NSUInteger)[assetRepresentation size] error:nil];
                        NSData* fileData = [NSData dataWithBytesNoCopy:buffer length:bufferSize freeWhenDone:YES];
                        if (fileData.length > 10 * 1000 * 1000) {
                            [self showHint:NSEaseLocalizedString(@"message.smallerImage", @"The image size is too large, please choose another one")];
                            return;
                        }
                        [self sendImageMessageWithData:fileData];
                    }
                } failureBlock:NULL];
            }
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [[HDSDKHelper shareHelper] setIsShowingimagePicker:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    
    [[HDSDKHelper shareHelper] setIsShowingimagePicker:NO];
}

#pragma mark - HDMessageCellDelegate

- (void)messageCellSelected:(id<HDIMessageModel>)model {
    
    switch (model.bodyType) {
        case EMMessageBodyTypeText: {
            if([HDMessageHelper getMessageExtType:model.message] == HDExtFormMsg){
                [self _formMessageCellSelected:model];
            }
        }
            break;
        case EMMessageBodyTypeImage: {
            [self _imageMessageCellSelected:model];
        }
            break;
        case EMMessageBodyTypeLocation: {
            [self _locationMessageCellSelected:model];
        }
            break;
        case EMMessageBodyTypeVoice: {
//            [self _audioMessageCellSelected:model];
        }
            break;
        case EMMessageBodyTypeVideo: {
            [self _videoMessageCellSelected:model];
        }
            break;
        case EMMessageBodyTypeFile: {
            [self _fileMessageCellSelected:model];
        }
            break;
        default:
            break;
    }
}

- (void)statusButtonSelcted:(id<HDIMessageModel>)model withMessageCell:(HDMessageCell*)messageCell
{
    if ((model.messageStatus != HDMessageStatusFailed) && (model.messageStatus != HDMessageStatusPending))
    {
        return;
    }
    __weak typeof(self) weakself = self;
    
    [[HDClient sharedClient].chatManager resendMessage:model.message progress:nil completion:^(HDMessage *message, HDError *error) {
        if (!error) {
            [weakself _refreshAfterSentMessage:message];
        }
        else {
            [weakself.tableView reloadData];
        }
    }];
}

- (void)avatarViewSelcted:(id<HDIMessageModel>)model
{
    if (_delegate && [_delegate respondsToSelector:@selector(messageViewController:didSelectAvatarMessageModel:)]) {
        [_delegate messageViewController:self didSelectAvatarMessageModel:model];
        
        return;
    }
}

#pragma mark - HDVideoChatToolbarDelegate

- (void)chatToolbarDidChangeFrameToHeight:(CGFloat)toHeight
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.tableView.frame;
        rect.origin.y = 0;
        rect.size.height = self.view.frame.size.height - toHeight - iPhoneXBottomHeight;
        self.tableView.frame = rect;
    }];
    
    [self _scrollViewToBottom:NO];
}

- (void)inputTextViewWillBeginEditing:(HDTextView *)inputTextView
{
    if (_menuController == nil) {
        _menuController = [UIMenuController sharedMenuController];
    }
    [_menuController setMenuItems:nil];
}

- (void)inputTextViewDidChange:(HDTextView *)inputTextView {
    
    [[HDClient sharedClient].chatManager postContent:inputTextView.text
                                      conversationId:_conversation.conversationId
                                          completion:^(id responseObject, HDError *error)
     {
    }];
}

- (void)didSendMessageAction:(NSString *)text{
    
    if (text && text.length > 0) {
        [self sendTextMessage:text];
    }
    
}

- (void)didSelectTakePicAction:(UIButton *)imageButton{
    
    [self.videoChatToolbar endEditing:YES];
    
    
    // Pop image picker
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    self.imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
   
    [[HDVECAgoraCallManager shareInstance].currentVC presentViewController:self.imagePicker animated:YES completion:NULL];
   
    
    [[HDSDKHelper shareHelper] setIsShowingimagePicker:YES];
    
}

- (void)didSendText:(NSString *)text
{
    if (text && text.length > 0) {
        [self sendTextMessage:text];
    }
}

- (void)didSendText:(NSString *)text withExt:(NSDictionary*)ext
{
    if ([ext objectForKey:EASEUI_EMOTION_DEFAULT_EXT]) {
        HDEmotion *emotion = [ext objectForKey:EASEUI_EMOTION_DEFAULT_EXT];
        [self sendCustomMagicEmojiWithOriginUrl:emotion.emotionOriginalURL];
        
        return;
    }
    if (text && text.length > 0) {
        [self sendTextMessage:text withExt:ext];
    }
}





// 当一次触摸从控件窗口内部拖动到外部时的代理方法
- (void)didHDDragOutsideAction:(UIView *)micView
{
    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectRecordView:withEvenType:)]) {
        [self.delegate messageViewController:self didSelectRecordView:micView withEvenType:HDRecordViewTypeDragInside];
    } else {
        if ([micView isKindOfClass:[HDMicView class]]) {
            [(HDMicView *)micView recordButtonDragInside];
        }
    }
}
// 当一次触摸从控件窗口之外拖动到内部时的代理方法
- (void)didHDDragInsideAction:(UIView *)micView
{
    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectRecordView:withEvenType:)]) {
        [self.delegate messageViewController:self didSelectRecordView:micView withEvenType:HDRecordViewTypeDragOutside];
    } else {
        if ([micView isKindOfClass:[HDMicView class]]) {
            [(HDMicView *)micView recordButtonDragOutside];
        }
    }
}

#pragma mark - EaseChatBarMoreViewDelegate

- (void)moreView:(HDChatBarMoreView *)moreView didItemInMoreViewAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectMoreView:AtIndex:)]) {
        [self.delegate messageViewController:self didSelectMoreView:moreView AtIndex:index];
        return;
    }
}

#pragma mark - Hyphenate

#pragma mark - HDChatManagerDelegate

- (void)messagesDidReceive:(NSArray *)aMessages {
    for (HDMessage *message in aMessages) {
        if ([self.conversation.conversationId isEqualToString:message.conversationId]) {
            [_conversation markAllMessagesAsRead:nil];
            //收到消息以后 判断 最新消息都时间 如果 是之前 的消息 进行排序。否则 走一下方法
            HDMessageModel * lastMessageModel = [self.dataArray lastObject];
            if (lastMessageModel &&[lastMessageModel isKindOfClass:[HDMessageModel class]]) {
                if( lastMessageModel.message.messageTime - message.messageTime > 0){
                    //lastMessageModel.message.messageTime 大
                    [self  _loadMessagesBefore:nil count:self.messageCountOfPage append:YES];
                           
                }else{
                    //message.messageTime 大
                    [self addMessageToDataSource:message progress:nil];
                }
            }else{
            
                [self addMessageToDataSource:message progress:nil];
                
            }
        }
    }
}

- (void)messagesDidRecall:(NSArray *)recallMessageIds {
    for (NSString *recallMsgId in recallMessageIds) {
        __block NSUInteger sourceIndex = NSNotFound;
        [self.messsagesSource enumerateObjectsUsingBlock:^(HDMessage *message, NSUInteger idx, BOOL *stop){
            if ([message isKindOfClass:[HDMessage class]]) {
                if ([recallMsgId isEqualToString:message.messageId])
                {
                    sourceIndex = idx;
                    *stop = YES;
                }
            }
        }];
        if (sourceIndex != NSNotFound) {
            [self.messsagesSource removeObjectAtIndex:sourceIndex];
        }
    }
    
    self.dataArray = [[self formatMessages:self.messsagesSource] mutableCopy];
    [self.tableView reloadData];
}

-(void)visitorWaitCount:(int)count{
    if (count > 0) {
        if (_visitorWaitCountLabel) {
            _visitorWaitCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"current_visitor_wait_count", @" The current queue number is ：%d"), count];
            _visitorWaitCountLabel.hidden = NO;
        }
    }else{
        if (_visitorWaitCountLabel) {
            _visitorWaitCountLabel.hidden = YES;
        }
    }
}


- (void)messageAttachmentStatusDidChange:(HDMessage *)aMessage error:(HDError *)aError {
    if (!aError) {
        EMFileMessageBody *fileBody = (EMFileMessageBody*)[aMessage body];
        if ([fileBody type] == EMMessageBodyTypeImage) {
            EMImageMessageBody *imageBody = (EMImageMessageBody *)fileBody;
            if ([imageBody thumbnailDownloadStatus] == EMDownloadStatusSuccessed)
            {
                [self _reloadTableViewDataWithMessage:aMessage];
            }
        }else if([fileBody type] == EMMessageBodyTypeVideo){
            EMVideoMessageBody *videoBody = (EMVideoMessageBody *)fileBody;
            if ([videoBody thumbnailDownloadStatus] == EMDownloadStatusSuccessed)
            {
                [self _reloadTableViewDataWithMessage:aMessage];
            }
        }else if([fileBody type] == EMMessageBodyTypeVoice){
            if ([fileBody downloadStatus] == EMDownloadStatusSuccessed)
            {
                [self _reloadTableViewDataWithMessage:aMessage];
            }
        }
        
    }else{
        
    }
}


#pragma mark - HDCDDeviceManagerProximitySensorDelegate

- (void)proximitySensorChanged:(BOOL)isCloseToUser
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (isCloseToUser)
    {
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    } else {
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[HDCDDeviceManager sharedInstance] disableProximitySensor];
    }
    [audioSession setActive:YES error:nil];
}

#pragma mark - action

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
    }
    
    self.menuIndexPath = nil;
}

#pragma mark - public

- (NSArray *)formatMessages:(NSArray *)messages
{
    NSMutableArray *formattedArray = [[NSMutableArray alloc] init];
    if ([messages count] == 0) {
        return formattedArray;
    }
    
    for (HDMessage *message in messages) {
        //Calculate time interval
        CGFloat interval = (self.messageTimeIntervalTag - message.messageTime) / 1000;
        if (self.messageTimeIntervalTag < 0 || interval > 60 || interval < -60) {
            NSDate *messageDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.messageTime];
            NSString *timeStr = @"";
            
            if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:stringForDate:)]) {
                timeStr = [_dataSource messageViewController:self stringForDate:messageDate];
            }
            else{
                timeStr = [messageDate formattedTime];
            }
            [formattedArray addObject:timeStr];
            self.messageTimeIntervalTag = message.messageTime;
        }
        
        //Construct message model
        id<HDIMessageModel> model = nil;
        //接收的消息不能设置头像
        BOOL isSender = message.direction == HDMessageDirectionSend;
        if (isSender && _dataSource && [_dataSource respondsToSelector:@selector(messageViewController:modelForMessage:)]) {
            model = [_dataSource messageViewController:self modelForMessage:message];
        }
        else{
            model = [[HDMessageModel alloc] initWithMessage:message];
        }
        
        if (model) {
            [formattedArray addObject:model];
        }
        
        // 根据是否需要评价决定是否添加“解决/未解决”
        if (message.isNeedToScore) {
            HDMessage *msg = [HDMessage createTxtSendMessageWithContent:@"" to:message.from];
            msg.messageId = message.messageId;
            NSMutableDictionary *extDic = [message.ext mutableCopy];
            [extDic removeObjectForKey:@"msgtype"];
            msg.ext = extDic;
            msg.status = HDMessageStatusSuccessed;
            msg.direction = HDMessageDirectionReceive;
            id<HDIMessageModel> solveModel = [[HDMessageModel alloc] initWithMessage:msg];
            solveModel.bodyType = EMMessageBodyTypeText;
            solveModel.isScoreMsg = YES;
            solveModel.text = @"这样回答有没有解决您的问题呢？  解决 / 未解决";
            [formattedArray addObject:solveModel];
        }
    }
    
    return formattedArray;
}

-(void)addMessageToDataSource:(HDMessage *)message
                     progress:(id)progress
{
    @synchronized (self.messsagesSource) {
        [self.messsagesSource addObject:message];
        NSArray *messageModels = [self formatMessages:@[message]];
        NSMutableArray  *mArr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < messageModels.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count + i inSection:0];
            [mArr addObject:indexPath];
        }
        [self.dataArray addObjectsFromArray:messageModels];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:mArr.copy withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableView endUpdates];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - public

- (void)tableViewDidTriggerHeaderRefresh
{
    self.messageTimeIntervalTag = -1;
    NSString *messageId = nil;
    if ([self.messsagesSource count] > 0) {
        messageId = [(HDMessage *)self.messsagesSource.firstObject messageId];
    }
    else {
        messageId = nil;
    }
    [self _loadMessagesBefore:messageId count:self.messageCountOfPage append:YES];
    
    [self tableViewDidFinishTriggerHeader:YES reload:YES];
}

#pragma mark - send message

- (void)_refreshAfterSentMessage:(HDMessage*)aMessage
{
    if ([self.messsagesSource count]) {
        NSString *msgId = aMessage.messageId;
        __block NSUInteger index = NSNotFound;
        [self.messsagesSource enumerateObjectsWithOptions:NSEnumerationReverse
                                               usingBlock:^(HDMessage *obj, NSUInteger idx, BOOL *stop)
         {
            if ([obj isKindOfClass:[HDMessage class]] && [obj.messageId isEqualToString:msgId]) {
                index = idx;
                *stop = YES;
            }
        }];
        if (index != NSNotFound) {
            [self.messsagesSource removeObjectAtIndex:index];
            [self.messsagesSource addObject:aMessage];
            
            //格式化消息
            self.messageTimeIntervalTag = -1;
            NSArray *formattedMessages = [self formatMessages:self.messsagesSource];
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:formattedMessages];
            [self.tableView reloadData];
            return;
        }
    }
}

- (void)_sendMessage:(HDMessage *)aMessage
{
    
    [self addMessageToDataSource:aMessage
                        progress:nil];
    
    __weak typeof(self) weakself = self;
    
    [[HDClient sharedClient].chatManager sendMessage:aMessage
                                            progress:nil
                                          completion:^(HDMessage *message, HDError *error)
     {
        if (!error) {
            [weakself _refreshAfterSentMessage:message];
        }
        else {
            [weakself.tableView reloadData];
        }
    }];
    
}

- (void)sendTextMessage:(NSString *)text
{
    
    [self sendTextMessage:text withExt:nil];
}

// cell点击
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    
    if ([eventName isEqualToString:HRouterEventTapMenu]) {
        id info = [userInfo objectForKey:@"clickItem"];
        if ([info isKindOfClass:[HDMenuItem class]]) { // 判断是否是item
            HDMenuItem *item = (HDMenuItem *)info;
            if (item.isTransferNoteItem) {
                [self moreViewLeaveMessageAction:nil];
                return;
            }
            HDMessage *msg = [HDMessage createSendMessageWithMenuItem:item to:self.conversation.conversationId];
            [self _sendMessage:msg];
            return;
        }else {
            NSString *text = (NSString *)info;
            [self sendTextMessage:text withExt:nil];
        }
    }
    if ([eventName isEqualToString:HRouterEventTapArticle]) { //图文消息
        if (_menuController.menuVisible) {
            [_menuController setMenuVisible:NO animated:YES];
            return;
        }
        HArticleWebViewController *articleVC = [[HArticleWebViewController alloc] init];
        articleVC.url = [userInfo objectForKey:@"url"];
        [self.navigationController pushViewController:articleVC animated:YES];
    }
  
    if ([eventName isEqualToString:HRouterEventTextURLTapEventName]) {
        [self chatTextCellUrlPressed:[userInfo objectForKey:@"url"]];
    }
    
    if ([eventName isEqualToString:HRouterEventTransformURLTapEventName]) {
        [self showTransformURL:[userInfo objectForKey:@"url"]];
    }
    

}

- (void)showUnsolveTags:(NSArray *)aTags message:(HDMessage *)aMsg {
    HRobotUnsolveItemView *itemView = [[HRobotUnsolveItemView alloc] initWithList:aTags
                                                                          message:aMsg];
    itemView.delegate = self;
    [self.view addSubview:itemView];
}

#pragma mark - HRobotUnsolveItemViewDelegate
- (void)submitView:(HRobotUnsolveItemView *)aView list:(NSArray *)tags message:(HDMessage *)aMsg {
    [aView removeFromSuperview];
    __block HDMessage *msg = aMsg;
    [self showHudInView:self.view hint:@"提交中..."];
    [self.view endEditing:YES];
    [HDClient.sharedClient.chatManager asyncPostRobotQuality:aMsg
                                                       solve:NO
                                                        tags:tags
                                                  completion:^(NSDictionary *info, HDError *error)
     {
        
        hd_dispatch_main_async_safe(^(){
            [self hideHud];
            if (!error) {
                HDMessage *needUpdateMessage = [_conversation loadMessageWithId:msg.messageId error:nil];
                needUpdateMessage.isNeedToScore = NO;
                [HDClient.sharedClient.chatManager updateMessage:needUpdateMessage
                                                      completion:^(HDMessage *aMessage, HDError *aError)
                 {
                    [self _loadMessagesBefore:nil count:self.messageCountOfPage append:NO];
                }];                [self showHint:@"感谢您的提交"];
            }else {
                [self showHint:@"提交失败，请稍后再试"];
            }
        });
    }];
}

- (void)dismissView:(HRobotUnsolveItemView *)aView {
    [aView removeFromSuperview];
}

- (void)showTransformURL:(NSString *)str {
    NSArray *ary = [str getURLs];
    if (ary.count > 0) {
        __block NSMutableArray *titles = [NSMutableArray array];
        for (NSString * str in ary) {
            [titles addObject:str];
        }
        [self showAlertWithTitle:@"请选择跳转的URL"
                    actionTitles:titles
                     cancelTitle:@"取消"
                        callBack:^(NSInteger index)
         {
            NSString *path = [titles[index] lowercaseString];
            if (![path hasPrefix:@"http"]) {
                path = [@"http://" stringByAppendingString:path];
            }
            NSURL *url = [NSURL URLWithString:path];
            [[UIApplication sharedApplication] openURL:url
                                               options:@{}
                                     completionHandler:^(BOOL success) {
                
            }];
        }];
    }
}

//链接被点击
- (void)chatTextCellUrlPressed:(NSURL *)url {
    if (url) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)backFromSatisfactionViewController {
}


- (void)commitSatisfactionWithControlArguments:(ControlArguments *)arguments
                                          type:(ControlType *)type
                           evaluationTagsArray:(NSMutableArray *)tags
                            evaluationDegreeId:(NSNumber *)evaluationDegreeId{
    HDMessage *message = [HDSDKHelper textHMessageFormatWithText:@"" to:self.conversation.conversationId];
    HDControlMessage *hCtrl = [HDControlMessage new];
    hCtrl.type = type;
    hCtrl.arguments = arguments;
    [message addCompositeContent:hCtrl];
    // 将会话标签加到消息的ext中
    NSMutableDictionary *ext = [message.ext mutableCopy];
    NSMutableDictionary *ctrlArgs = [[ext objectForKey:@"weichat"] objectForKey:@"ctrlArgs"];
    NSArray *tagsArray = [NSArray arrayWithArray:tags];
    [ctrlArgs setObject:tagsArray forKey:@"appraiseTags"];
    [ctrlArgs setValue:evaluationDegreeId forKey:@"evaluationDegreeId"];
    [ctrlArgs setValue:@"0" forKey:@"inviteId"];
    message.ext = [ext copy];
    
    __weak typeof(self) weakself = self;
    [self showHudInView:self.view hint:NSLocalizedString(@"comment_submit", @"Comment Submit.")];
    [[HDClient sharedClient].chatManager sendMessage:message
                                            progress:nil
                                          completion:^(HDMessage *aMessage, HDError *aError)
     {
        [self hideHud];
        if (!aError) {
            [weakself showHint:NSLocalizedString(@"comment_suc", @"send comment successful.")];
        } else {
            [weakself showHint:NSLocalizedString(@"comment_fail", @"send comment fail.")];
        }
    }];
}

//更新转人工消息的ext
- (void)updateTransferMessageExt:(HDMessage *)message {
    HDMessage *_message = message;
    NSMutableDictionary *_ext = [NSMutableDictionary dictionaryWithDictionary:message.ext];
    
    [_ext setValue:@YES forKey:kMessageExtWeChat_ctrlType_transferToKf_HasTransfer];
    _message.ext = [_ext copy];
    __weak typeof(self) weakSelf = self;
    [[HDClient sharedClient].chatManager updateMessage:_message completion:^(HDMessage *aMessage, HDError *aError) {
        if (!aError) {
            hd_dispatch_main_async_safe(^(){
                [weakSelf.tableView reloadData];
            });
        }
    }];
}

- (void)sendTextMessage:(NSString *)text withExt:(NSDictionary*)ext
{
    //这个写法对应文档https://docs.easemob.com/cs/400systemintegration/10crmintegration?s[]=自定义查询参数 ifrme
//    NSDictionary *dic = @{@"name":@"Jack",@"age":@"40",@"sex": @"man"};
//    NSDictionary *dic1 = @{@"params":dic};
//    NSDictionary *dic2 = @{@"updateVisitorInfoSrc":dic1};
//    NSDictionary *dic3 = @{@"cmd":dic2};
//    ext = dic3;
    HDMessage *message = [HDSDKHelper textHMessageFormatWithText:text to:self.conversation.conversationId];
    if (_visitorInfo) {
        [message addContent:_visitorInfo];
    }
    if (_agent) {
        [message addContent:_agent];
    }
    if (_queueInfo) {
        [message addContent:_queueInfo];
    }
    if (ext) {
        [message addAttributeDictionary:ext];
    }
    CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
   
    [message addContent:lgM.visitorInfo];
    

//    NSMutableDictionary * dic1 =[message.ext valueForKey:@"weichat"];
//    [dic1 setValue:@"routingRuleFlag" forKey:@"routingRuleFlag"];
   
    [self _sendMessage:message];
}

- (void)sendCustomMagicEmojiWithOriginUrl:(NSString *)url {
    HDMessage *message = [HDSDKHelper customMagicEmojiMessageWithOriginUrl:url to:self.conversation.conversationId];
    [self _sendMessage:message];
}

- (void)sendLocationMessageLatitude:(double)latitude
                          longitude:(double)longitude
                         andAddress:(NSString *)address
{
    HDMessage *message = [HDSDKHelper locationHMessageWithLatitude:latitude
                                                         longitude:longitude
                                                           address:address
                                                                to:self.conversation.conversationId
                                                        messageExt:nil];
    [self _sendMessage:message];
}

- (void)sendImageMessageWithData:(NSData *)imageData
{
    id progress = nil;
    if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:progressDelegateForMessageBodyType:)]) {
        progress = [_dataSource messageViewController:self progressDelegateForMessageBodyType:EMMessageBodyTypeImage];
    }
    else{
        progress = self;
    }
    
    HDMessage *message = [HDSDKHelper imageMessageWithImageData:imageData to:self.conversation.conversationId messageExt:nil];
    EMImageMessageBody *body = (EMImageMessageBody *)message.body;
//    body.thumbnailLocalPath = @"11111111222";
    [HDLog logD:@"HD===%s body.localPathbody.localPath:%@",__func__,body.localPath];
    [self _sendMessage:message];
}

- (void)sendImageMessage:(UIImage *)image
{
    id progress = nil;
    if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:progressDelegateForMessageBodyType:)]) {
        progress = [_dataSource messageViewController:self progressDelegateForMessageBodyType:EMMessageBodyTypeImage];
    }
    else{
        progress = self;
    }
    HDMessage *message = [HDSDKHelper imageMessageWithImage:image to:self.conversation.conversationId messageExt:nil];
    [self _sendMessage:message];
}

- (void)sendVoiceMessageWithLocalPath:(NSString *)localPath
                             duration:(int)duration
{
    id progress = nil;
    if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:progressDelegateForMessageBodyType:)]) {
        progress = [_dataSource messageViewController:self progressDelegateForMessageBodyType:EMMessageBodyTypeVoice];
    }
    else{
        progress = self;
    }
    
    HDMessage *message = [HDSDKHelper voiceMessageWithLocalPath:localPath duration:duration to:self.conversation.conversationId messageExt:nil];
    [self _sendMessage:message];
}

- (void)sendVideoMessageWithURL:(NSURL *)url
{
    id progress = nil;
    if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:progressDelegateForMessageBodyType:)]) {
        progress = [_dataSource messageViewController:self progressDelegateForMessageBodyType:EMMessageBodyTypeVideo];
    }
    else{
        progress = self;
    }
    
//    NSString * str = [[NSBundle mainBundle] pathForResource:@"111" ofType:@"mov"];
    
    HDMessage *message = [HDSDKHelper videoMessageWithLocalPath:[url path]
                                                             to:self.conversation.conversationId
                                                     messageExt:nil];
    EMVideoMessageBody *body = (EMVideoMessageBody *)message.body;
//    body.thumbnailLocalPath = @"11111/22222222";
//    HDMessage *message = [HDSDKHelper videoMessageWithLocalPath:str
//                                                             to:self.conversation.conversationId
//                                                     messageExt:nil];
    [self _sendMessage:message];
}

#pragma mark - notifycation
- (void)didBecomeActive
{
    self.messageTimeIntervalTag = -1;
    self.dataArray = [[self formatMessages:self.messsagesSource] mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - private
- (void)_reloadTableViewDataWithMessage:(HDMessage *)message
{
    if ([self.conversation.conversationId isEqualToString:message.conversationId])
    {
        for (int i = 0; i < self.dataArray.count; i ++) {
            id object = [self.dataArray objectAtIndex:i];
            if ([object isKindOfClass:[HDMessageModel class]]) {
                id<HDIMessageModel> model = object;
                if ([message.messageId isEqualToString:model.messageId]) {
                    BOOL isSender = message.direction == HDMessageDirectionSend;
                    id<HDIMessageModel> newModel = nil;
                    if (isSender && _dataSource && [_dataSource respondsToSelector:@selector(messageViewController:modelForMessage:)])
                    {
                        newModel = [self.dataSource messageViewController:self modelForMessage:message];
                    }
                    else
                    {
                        newModel = [[HDMessageModel alloc] initWithMessage:message];
                    }
                        [self.tableView beginUpdates];
                        [self.dataArray replaceObjectAtIndex:i withObject:newModel];
                        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        [self.tableView endUpdates];
                    break;
                }
            }
        }
    }
}

@end
