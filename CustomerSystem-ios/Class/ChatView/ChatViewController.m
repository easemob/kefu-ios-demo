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

#import "ChatViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "EMCDDeviceManager.h"
#import "SRRefreshView.h"
#import "DXChatBarMoreView.h"
#import "DXFaceView.h"
#import "DXMessageToolBar.h"
#import "DXChatBarMoreView.h"
#import "EMChatViewCell.h"
#import "EMChatTimeCell.h"
#import "ChatSendHelper.h"
#import "MessageReadManager.h"
#import "MessageModelManager.h"
#import "LocationViewController.h"
#import "UIViewController+HUD.h"
#import "NSDate+Category.h"
#import "ChatViewController+Category.h"
#import "EMIMHelper.h"
#import "SatisfactionViewController.h"
#import "ConvertToCommonEmoticonsHelper.h"

#define KPageCount 20
#define kafterSale @"shouhou"
#define kpreSale @"shouqian"

@interface ChatViewController ()<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SRRefreshDelegate, IChatManagerDelegate, DXChatBarMoreViewDelegate, DXMessageToolBarDelegate, LocationViewDelegate, IDeviceManagerDelegate,SatisfactionDelegate>
{
    UIMenuController *_menuController;
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    NSIndexPath *_longPressIndexPath;
    
    NSInteger _recordingCount;
    
    NSMutableArray *_messages;
    BOOL _isScrollToBottom;
}

@property (nonatomic) BOOL isChatGroup;

@property (strong, nonatomic) NSMutableArray *dataSource;//tableView数据源
@property (strong, nonatomic) SRRefreshView *slimeView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) DXMessageToolBar *chatToolBar;

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (strong, nonatomic) MessageReadManager *messageReadManager;//message阅读的管理者
@property (strong, nonatomic) EMConversation *conversation;//会话管理者
@property (strong, nonatomic) NSDate *chatTagDate;

@property (strong, nonatomic) NSMutableArray *messages;
@property (nonatomic) BOOL isScrollToBottom;
@property (nonatomic) BOOL isPlayingAudio;
@property (nonatomic) EMDemoSaleType saleType;


@end

@implementation ChatViewController

@synthesize commodityInfo = _commodityInfo;

- (instancetype)initWithChatter:(NSString *)chatter isGroup:(BOOL)isGroup
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _isPlayingAudio = NO;
        _chatter = chatter;
        _isChatGroup = isGroup;
        _messages = [NSMutableArray array];
        
        //根据接收者的username获取当前会话的管理者
        _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:chatter isGroup:_isChatGroup];
        [_conversation markAllMessagesAsRead:YES];
    }
    
    return self;
}

- (instancetype)initWithChatter:(NSString *)chatter type:(EMDemoSaleType)type
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _isPlayingAudio = NO;
        _chatter = chatter;
        _isChatGroup = NO;
        _messages = [NSMutableArray array];
        _saleType = type;
        
        //根据接收者的username获取当前会话的管理者
        _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:chatter isGroup:_isChatGroup];
        [_conversation markAllMessagesAsRead:YES];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerBecomeActive];
    // Do any additional setup after loading the view.
//    self.title = NSLocalizedString(@"title.customer", @"Customer");
    self.view.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1.0];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    
    #warning 以下三行代码必须写，注册为SDK的ChatManager的delegate
    [EMCDDeviceManager sharedInstance].delegate = self;
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    //注册为SDK的ChatManager的delegate
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllMessages:) name:@"RemoveAllMessages" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:@"applicationDidEnterBackground" object:nil];
    
    _isScrollToBottom = YES;
    
    [self setupBarButtonItem];
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.slimeView];
    [self.view addSubview:self.chatToolBar];
    
    //将self注册为chatToolBar的moreView的代理
    if ([self.chatToolBar.moreView isKindOfClass:[DXChatBarMoreView class]]) {
        [(DXChatBarMoreView *)self.chatToolBar.moreView setDelegate:self];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)];
    [self.view addGestureRecognizer:tap];
    
    //通过会话管理者获取已收发消息
    [self loadMoreMessages];
    
    if ([_commodityInfo count] > 0) {
        [self sendCommodityMessageWithInfo:_commodityInfo];
        _commodityInfo = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_isScrollToBottom) {
        [self scrollViewToBottom:YES];
    }
    else{
        _isScrollToBottom = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 设置当前conversation的所有message为已读
    [_conversation markAllMessagesAsRead:YES];
    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
}

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _tableView = nil;
    
    _slimeView.delegate = nil;
    _slimeView = nil;
    
    _chatToolBar.delegate = nil;
    _chatToolBar = nil;
    
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    [EMCDDeviceManager sharedInstance].delegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#warning 以下第一行代码必须写，将self从ChatManager的代理中移除
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

#pragma mark - 

- (void)setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [clearButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(removeAllMessages:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
}

- (void)back
{
    //判断当前会话是否为空，若符合则删除该会话
    EMMessage *message = [_conversation latestMessage];
    if (message == nil) {
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:_conversation.chatter deleteMessages:NO append2Chat:YES];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - helper

- (NSURL *)convert2Mp4:(NSURL *)movUrl {
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetHighestQuality];
        mp4Url = [movUrl copy];
        mp4Url = [mp4Url URLByDeletingPathExtension];
        mp4Url = [mp4Url URLByAppendingPathExtension:@"mp4"];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"completed.");
                } break;
                default: {
                    NSLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            NSLog(@"timeout.");
        }
        if (wait) {
            //dispatch_release(wait);
            wait = nil;
        }
    }
    
    return mp4Url;
}

#pragma mark - getter

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (SRRefreshView *)slimeView
{
    if (_slimeView == nil) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
    }
    
    return _slimeView;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.chatToolBar.frame.size.height) style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1.0];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        lpgr.minimumPressDuration = .5;
        [_tableView addGestureRecognizer:lpgr];
    }
    
    return _tableView;
}

- (DXMessageToolBar *)chatToolBar
{
    if (_chatToolBar == nil) {
        _chatToolBar = [[DXMessageToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [DXMessageToolBar defaultHeight], self.view.frame.size.width, [DXMessageToolBar defaultHeight])];
        _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _chatToolBar.delegate = self;
    }
    
    return _chatToolBar;
}

- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}

- (MessageReadManager *)messageReadManager
{
    if (_messageReadManager == nil) {
        _messageReadManager = [MessageReadManager defaultManager];
    }
    
    return _messageReadManager;
}

- (NSDate *)chatTagDate
{
    if (_chatTagDate == nil) {
        _chatTagDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:0];
    }
    
    return _chatTagDate;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.dataSource count]) {
        id obj = [self.dataSource objectAtIndex:indexPath.row];
        if ([obj isKindOfClass:[NSString class]]) {
            EMChatTimeCell *timeCell = (EMChatTimeCell *)[tableView dequeueReusableCellWithIdentifier:@"MessageCellTime"];
            if (timeCell == nil) {
                timeCell = [[EMChatTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageCellTime"];
                timeCell.backgroundColor = [UIColor clearColor];
                timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            timeCell.textLabel.text = (NSString *)obj;
            
            return timeCell;
        }
        else{
            MessageModel *model = (MessageModel *)obj;
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
        }
    }
    
    return nil;
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *obj = [self.dataSource objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        return 40;
    }
    else{
        return [EMChatViewCell tableView:tableView heightForRowAtIndexPath:indexPath withObject:(MessageModel *)obj];
    }
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_slimeView) {
        [_slimeView scrollViewDidScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_slimeView) {
        [_slimeView scrollViewDidEndDraging];
    }
}

#pragma mark - slimeRefresh delegate
//加载更多
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self loadMoreMessages];
    [_slimeView endRefresh];
}

#pragma mark - GestureRecognizer

// 点击背景隐藏
-(void)keyBoardHidden
{
    [self.chatToolBar endEditing:YES];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
	if (recognizer.state == UIGestureRecognizerStateBegan && [self.dataSource count] > 0) {
        CGPoint location = [recognizer locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:location];
        id object = [self.dataSource objectAtIndex:indexPath.row];
        if ([object isKindOfClass:[MessageModel class]]) {
            EMChatViewCell *cell = (EMChatViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell becomeFirstResponder];
            _longPressIndexPath = indexPath;
            [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.messageModel.type];
        }
    }
}

- (void)reloadData{
    self.dataSource = [[self formatMessages:self.messages] mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - UIResponder actions

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    MessageModel *model = [userInfo objectForKey:KMESSAGEKEY];
    if ([eventName isEqualToString:kRouterEventTextURLTapEventName]) {
        [self chatTextCellUrlPressed:[userInfo objectForKey:@"url"]];
    }
    else if ([eventName isEqualToString:kRouterEventAudioBubbleTapEventName]) {
        [self chatAudioCellBubblePressed:model];
    }
    else if ([eventName isEqualToString:kRouterEventImageBubbleTapEventName]){
        [self chatImageCellBubblePressed:model];
    }
    else if ([eventName isEqualToString:kRouterEventLocationBubbleTapEventName]){
        [self chatLocationCellBubblePressed:model];
    }
    else if([eventName isEqualToString:kResendButtonTapEventName]){
        EMChatViewCell *resendCell = [userInfo objectForKey:kShouldResendCell];
        MessageModel *messageModel = resendCell.messageModel;
        messageModel.status = eMessageDeliveryState_Delivering;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:resendCell];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
        [chatManager asyncResendMessage:messageModel.message progress:nil];
    }else if([eventName isEqualToString:kRouterEventChatCellVideoTapEventName]){
        [self chatVideoCellPressed:model];
    }else if ([eventName isEqualToString:kRouterEventMenuTapEventName]) {
        [self sendTextMessage:[userInfo objectForKey:@"text"]];
    } else if ([eventName isEqualToString:kRouterEventSatisfactionBubbleTapEventName]) {
        SatisfactionViewController *view = [[SatisfactionViewController alloc] init];
        view.messageModel = model;
        view.delegate = self;
        [self.navigationController pushViewController:view animated:YES];
    }
}

//链接被点击
- (void)chatTextCellUrlPressed:(NSURL *)url
{
    if (url) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

// 语音的bubble被点击
-(void)chatAudioCellBubblePressed:(MessageModel *)model
{
    id <IEMFileMessageBody> body = [model.message.messageBodies firstObject];
    EMAttachmentDownloadStatus downloadStatus = [body attachmentDownloadStatus];
    if (downloadStatus == EMAttachmentDownloading) {
        [self showHint:NSLocalizedString(@"message.downloadingAudio", @"downloading voice, click later")];
        return;
    }
    else if (downloadStatus == EMAttachmentDownloadFailure)
    {
        [self showHint:NSLocalizedString(@"message.downloadingAudio", @"downloading voice, click later")];
        [[EaseMob sharedInstance].chatManager asyncFetchMessage:model.message progress:nil];
        
        return;
    }
    
    // 播放音频
    if (model.type == eMessageBodyType_Voice) {
        __weak ChatViewController *weakSelf = self;
        BOOL isPrepare = [self.messageReadManager prepareMessageAudioModel:model updateViewCompletion:^(MessageModel *prevAudioModel, MessageModel *currentAudioModel) {
            if (prevAudioModel || currentAudioModel) {
                [weakSelf.tableView reloadData];
            }
        }];
        
        if (isPrepare) {
            _isPlayingAudio = YES;
            __weak ChatViewController *weakSelf = self;
            [[EMCDDeviceManager sharedInstance] enableProximitySensor];
            [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:model.chatVoice.localPath completion:^(NSError *error) {
                [weakSelf.messageReadManager stopMessageAudioModel];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                    weakSelf.isPlayingAudio = NO;
                    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
                });
            }];
        }
        else{
            _isPlayingAudio = NO;
        }
    }
}

// 位置的bubble被点击
-(void)chatLocationCellBubblePressed:(MessageModel *)model
{
    _isScrollToBottom = NO;
    LocationViewController *locationController = [[LocationViewController alloc] initWithLocation:CLLocationCoordinate2DMake(model.latitude, model.longitude)];
    [self.navigationController pushViewController:locationController animated:YES];
}

- (void)chatVideoCellPressed:(MessageModel *)model{
    __weak ChatViewController *weakSelf = self;
    id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
    [weakSelf showHudInView:weakSelf.view hint:NSLocalizedString(@"message.downloadingVideo", @"downloading video...")];
    [chatManager asyncFetchMessage:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
        [weakSelf hideHud];
        if (!error) {
            NSString *localPath = aMessage == nil ? model.localPath : [[aMessage.messageBodies firstObject] localPath];
            if (localPath && localPath.length > 0) {
                [weakSelf playVideoWithVideoPath:localPath];
            }
        }else{
            [weakSelf showHint:NSLocalizedString(@"message.videoFail", @"video for failure!")];
        }
    } onQueue:nil];
}

- (void)playVideoWithVideoPath:(NSString *)videoPath
{
    _isScrollToBottom = NO;
    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
    MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    [moviePlayerController.moviePlayer prepareToPlay];
    moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
}

// 图片的bubble被点击
-(void)chatImageCellBubblePressed:(MessageModel *)model
{
    __weak ChatViewController *weakSelf = self;
    id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
    if ([model.messageBody messageBodyType] == eMessageBodyType_Image) {
        EMImageMessageBody *imageBody = (EMImageMessageBody *)model.messageBody;
        if (imageBody.thumbnailDownloadStatus == EMAttachmentDownloadSuccessed) {
            [weakSelf showHudInView:weakSelf.view hint:NSLocalizedString(@"message.downloadingImage", @"downloading a image...")];
            [chatManager asyncFetchMessage:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
                [weakSelf hideHud];
                if (!error) {
                    NSString *localPath = aMessage == nil ? model.localPath : [[aMessage.messageBodies firstObject] localPath];
                    if (localPath && localPath.length > 0) {
                        NSURL *url = [NSURL fileURLWithPath:localPath];
                        weakSelf.isScrollToBottom = NO;
                        [weakSelf.messageReadManager showBrowserWithImages:@[url]];
                        return ;
                    }
                }
                [weakSelf showHint:NSLocalizedString(@"message.imageFail", @"image for failure!")];
            } onQueue:nil];
        }else{
            //获取缩略图
            [chatManager asyncFetchMessageThumbnail:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
                if (!error) {
                    [weakSelf reloadTableViewDataWithMessage:model.message];
                }else{
                    [weakSelf showHint:NSLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
                }
                
            } onQueue:nil];
        }
    }else if ([model.messageBody messageBodyType] == eMessageBodyType_Video) {
        //获取缩略图
        EMVideoMessageBody *videoBody = (EMVideoMessageBody *)model.messageBody;
        if (videoBody.thumbnailDownloadStatus != EMAttachmentDownloadSuccessed) {
            [chatManager asyncFetchMessageThumbnail:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
                if (!error) {
                    [weakSelf reloadTableViewDataWithMessage:model.message];
                }else{
                    [weakSelf showHint:NSLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
                }
            } onQueue:nil];
        }
    }
}

#pragma mark - IChatManagerDelegate

-(void)didSendMessage:(EMMessage *)message error:(EMError *)error;
{
    [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ([obj isKindOfClass:[MessageModel class]])
         {
             MessageModel *model = (MessageModel*)obj;
             if ([model.messageId isEqualToString:message.messageId])
             {
                 model.message.deliveryState = message.deliveryState;
                 *stop = YES;
             }
         }
     }];
    [self.tableView reloadData];
}

- (void)reloadTableViewDataWithMessage:(EMMessage *)message
{
    if ([self.conversation.chatter isEqualToString:message.conversationChatter])
    {
        for (int i = 0; i < self.dataSource.count; i ++) {
            id object = [self.dataSource objectAtIndex:i];
            if ([object isKindOfClass:[MessageModel class]]) {
                MessageModel *model = (MessageModel *)object;
                EMMessage *currMsg = model.message;
                if ([message.messageId isEqualToString:currMsg.messageId]) {
                    MessageModel *cellModel = [MessageModelManager modelWithMessage:message];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView beginUpdates];
                        [self.dataSource replaceObjectAtIndex:i withObject:cellModel];
                        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        [self.tableView endUpdates];
                    });
                    
                    break;
                }
            }
        }
    }
}

- (void)didMessageAttachmentsStatusChanged:(EMMessage *)message error:(EMError *)error{
    if (!error) {
        id<IEMFileMessageBody>fileBody = (id<IEMFileMessageBody>)[message.messageBodies firstObject];
        if ([fileBody messageBodyType] == eMessageBodyType_Image) {
            EMImageMessageBody *imageBody = (EMImageMessageBody *)fileBody;
            if ([imageBody thumbnailDownloadStatus] == EMAttachmentDownloadSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }else if([fileBody messageBodyType] == eMessageBodyType_Video){
            EMVideoMessageBody *videoBody = (EMVideoMessageBody *)fileBody;
            if ([videoBody thumbnailDownloadStatus] == EMAttachmentDownloadSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }else if([fileBody messageBodyType] == eMessageBodyType_Voice){
            if ([fileBody attachmentDownloadStatus] == EMAttachmentDownloadSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }
        
    }else{
        
    }
}

- (void)didFetchingMessageAttachments:(EMMessage *)message progress:(float)progress{
    NSLog(@"didFetchingMessageAttachment: %f", progress);
}

-(void)didReceiveMessage:(EMMessage *)message
{
    if ([_conversation.chatter isEqualToString:message.conversationChatter]) {
        [self addMessage:message];
    }
}

-(void)didReceiveCmdMessage:(EMMessage *)message
{
    if ([_conversation.chatter isEqualToString:message.conversationChatter]) {
        [self showHint:NSLocalizedString(@"receiveCmd", @"receive cmd message")];
    }
}

- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages
{
    [self loadMoreMessages];
}

- (void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error
{
    if (_isChatGroup && [group.groupId isEqualToString:_chatter]) {
        [self.navigationController popToViewController:self animated:NO];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)didInterruptionRecordAudio
{
    [_chatToolBar cancelTouchRecord];
    
    // 设置当前conversation的所有message为已读
    [_conversation markAllMessagesAsRead:YES];
}

#pragma mark - EMChatBarMoreViewDelegate

- (void)moreViewPhotoAction:(DXChatBarMoreView *)moreView
{
    // 隐藏键盘
    [self keyBoardHidden];
    
    // 弹出照片选择
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
}

- (void)moreViewTakePicAction:(DXChatBarMoreView *)moreView
{
    [self keyBoardHidden];
    
#if TARGET_IPHONE_SIMULATOR
    [self showHint:NSLocalizedString(@"message.simulatorNotSupportCamera", @"simulator does not support taking picture")];
#elif TARGET_OS_IPHONE
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
#endif
}

- (void)moreViewLocationAction:(DXChatBarMoreView *)moreView
{
    // 隐藏键盘
    [self keyBoardHidden];
    
    LocationViewController *locationController = [[LocationViewController alloc] initWithNibName:nil bundle:nil];
    locationController.delegate = self;
    [self.navigationController pushViewController:locationController animated:YES];
}

#pragma mark - LocationViewDelegate

-(void)sendLocationLatitude:(double)latitude longitude:(double)longitude andAddress:(NSString *)address
{
    EMMessage *locationMessage = [ChatSendHelper sendLocationLatitude:latitude longitude:longitude address:address toUsername:_conversation.chatter isChatGroup:_isChatGroup requireEncryption:NO ext:nil];
    [self addMessage:locationMessage];
}

#pragma mark - DXMessageToolBarDelegate

- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView
{
    [_menuController setMenuItems:nil];
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.tableView.frame;
        rect.origin.y = 0;
        rect.size.height = self.view.frame.size.height - toHeight;
        self.tableView.frame = rect;
    }];
    [self scrollViewToBottom:YES];
}

- (void)didSendText:(NSString *)text
{
    if (text && text.length > 0) {
        [self sendTextMessage:text];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        [picker dismissViewControllerAnimated:YES completion:nil];
        // video url:
        // file:///private/var/mobile/Applications/B3CDD0B2-2F19-432B-9CFA-158700F4DE8F/tmp/capture-T0x16e39100.tmp.9R8weF/capturedvideo.mp4
        // we will convert it to mp4 format
        NSURL *mp4 = [self convert2Mp4:videoURL];
        NSFileManager *fileman = [NSFileManager defaultManager];
        if ([fileman fileExistsAtPath:videoURL.path]) {
            NSError *error = nil;
            [fileman removeItemAtURL:videoURL error:&error];
            if (error) {
                NSLog(@"failed to remove file, error:%@.", error);
            }
        }
        EMChatVideo *chatVideo = [[EMChatVideo alloc] initWithFile:[mp4 relativePath] displayName:@"video.mp4"];
        [self sendVideoMessage:chatVideo];
        
    }else{
        UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self sendImageMessage:orgImage];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MenuItem actions

- (void)copyMenuAction:(id)sender
{
    // todo by du. 复制
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (_longPressIndexPath.row > 0) {
        MessageModel *model = [self.dataSource objectAtIndex:_longPressIndexPath.row];
        pasteboard.string = model.content;
    }
    
    _longPressIndexPath = nil;
}

- (void)deleteMenuAction:(id)sender
{
    if (_longPressIndexPath && _longPressIndexPath.row > 0) {
        MessageModel *model = [self.dataSource objectAtIndex:_longPressIndexPath.row];
        NSMutableArray *messages = [NSMutableArray arrayWithObjects:model, nil];
        [_conversation removeMessage:model.message];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:_longPressIndexPath, nil];;
        if (_longPressIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataSource objectAtIndex:(_longPressIndexPath.row - 1)];
            if (_longPressIndexPath.row + 1 < [self.dataSource count]) {
                nextMessage = [self.dataSource objectAtIndex:(_longPressIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [messages addObject:prevMessage];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(_longPressIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataSource removeObjectsInArray:messages];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
    
    _longPressIndexPath = nil;
}

#pragma mark - private

- (void)loadMoreMessages
{
    long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000 + 1;
    
    NSArray *messages = [self.conversation loadNumbersOfMessages:([self.messages count] + KPageCount) before:timestamp];
    if ([messages count] > 0) {
        self.messages = [messages mutableCopy];
        
        NSInteger currentCount = [self.dataSource count];
        self.dataSource = [[self formatMessages:messages] mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            NSInteger rowCount = self.dataSource count] - currentCount - 1;
            if (rowCount < 0) {
                rowCount = 0;
            }
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowCount inSection:0]
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:NO];
        });
        
        //从数据库导入时重新下载没有下载成功的附件
        for (NSInteger i = currentCount; i < [self.dataSource count]; i++)
        {
            id obj = self.dataSource[i];
            if ([obj isKindOfClass:[MessageModel class]])
            {
                [self downloadMessageAttachments:obj];
            }
        }
    }
}

- (void)downloadMessageAttachments:(MessageModel *)model
{
    void (^completion)(EMMessage *aMessage, EMError *error) = ^(EMMessage *aMessage, EMError *error) {
        if (!error)
        {
            [self reloadTableViewDataWithMessage:model.message];
        }
        else
        {
            [self showHint:NSLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
        }
    };
    
    if ([model.messageBody messageBodyType] == eMessageBodyType_Image) {
        EMImageMessageBody *imageBody = (EMImageMessageBody *)model.messageBody;
        if (imageBody.thumbnailDownloadStatus != EMAttachmentDownloadSuccessed)
        {
            //下载缩略图
            [[[EaseMob sharedInstance] chatManager] asyncFetchMessageThumbnail:model.message progress:nil completion:completion onQueue:nil];
        }
    }
    else if ([model.messageBody messageBodyType] == eMessageBodyType_Video)
    {
        EMVideoMessageBody *videoBody = (EMVideoMessageBody *)model.messageBody;
        if (videoBody.thumbnailDownloadStatus != EMAttachmentDownloadSuccessed)
        {
            //下载缩略图
            [[[EaseMob sharedInstance] chatManager] asyncFetchMessageThumbnail:model.message progress:nil completion:completion onQueue:nil];
        }
    }
    else if ([model.messageBody messageBodyType] == eMessageBodyType_Voice)
    {
        EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody*)model.messageBody;
        if (voiceBody.attachmentDownloadStatus != EMAttachmentDownloadSuccessed)
        {
            //下载语言
            [[EaseMob sharedInstance].chatManager asyncFetchMessage:model.message progress:nil];
        }
    }
}

- (NSArray *)formatMessages:(NSArray *)messagesArray
{
    NSMutableArray *formatArray = [[NSMutableArray alloc] init];
    if ([messagesArray count] > 0) {
        for (EMMessage *message in messagesArray) {
            NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
            NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
            if (tempDate > 60 || tempDate < -60 || (self.chatTagDate == nil)) {
                [formatArray addObject:[createDate formattedTime]];
                self.chatTagDate = createDate;
            }
            
            MessageModel *model = [MessageModelManager modelWithMessage:message];
            if (model) {
                [formatArray addObject:model];
            }
        }
    }
    
    return formatArray;
}

-(NSMutableArray *)formatMessage:(EMMessage *)message
{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
    NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
    if (tempDate > 60 || tempDate < -60 || (self.chatTagDate == nil)) {
        [ret addObject:[createDate formattedTime]];
        self.chatTagDate = createDate;
    }
    
    MessageModel *model = [MessageModelManager modelWithMessage:message];
    if (model) {
        [ret addObject:model];
    }
    
    return ret;
}

-(void)addMessage:(EMMessage *)message
{
    [_messages addObject:message];
    NSArray *messages = [self formatMessage:message];
    
    __weak ChatViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.dataSource addObjectsFromArray:messages];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.dataSource count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
}

- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:YES];
    }
}

- (void)removeAllMessages:(id)sender
{
    if (_dataSource.count == 0) {
        [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        return;
    }
    
    [self showHint:@"deleting..."];
    [self.conversation removeAllMessages];
    [self.dataSource removeAllObjects];
    [_messages removeAllObjects];
    [self.tableView reloadData];
    [self hideHud];
}

- (void)showMenuViewController:(UIView *)showInView andIndexPath:(NSIndexPath *)indexPath messageType:(MessageBodyType)messageType
{
    if (_menuController == nil) {
        _menuController = [UIMenuController sharedMenuController];
    }
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"copy", @"Copy") action:@selector(copyMenuAction:)];
    }
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"delete", @"Delete") action:@selector(deleteMenuAction:)];
    }
    
    if (messageType == eMessageBodyType_Text) {
        [_menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem]];
    }
    else{
        [_menuController setMenuItems:@[_deleteMenuItem]];
    }
    
    [_menuController setTargetRect:showInView.frame inView:showInView.superview];
    [_menuController setMenuVisible:YES animated:YES];
}

- (void)applicationDidEnterBackground
{
    [_chatToolBar cancelTouchRecord];
    
    // 设置当前conversation的所有message为已读
    [_conversation markAllMessagesAsRead:YES];
}

#pragma mark - send message

-(void)sendTextMessage:(NSString *)textMessage
{
    EMMessage *tempMessage = [ChatSendHelper sendTextMessageWithString:textMessage toUsername:_conversation.chatter isChatGroup:_isChatGroup requireEncryption:NO ext:[self getWeiChat]];
    [self addMessage:tempMessage];
}

-(void)sendImageMessage:(UIImage *)imageMessage
{
    EMMessage *tempMessage = [ChatSendHelper sendImageMessageWithImage:imageMessage toUsername:_conversation.chatter isChatGroup:_isChatGroup requireEncryption:NO ext:[self getWeiChat]];
    [self addMessage:tempMessage];
}

-(void)sendAudioMessage:(EMChatVoice *)voice
{
    EMMessage *tempMessage = [ChatSendHelper sendVoice:voice toUsername:_conversation.chatter isChatGroup:_isChatGroup requireEncryption:NO ext:[self getWeiChat]];
    [self addMessage:tempMessage];
}

-(void)sendVideoMessage:(EMChatVideo *)video
{
    EMMessage *tempMessage = [ChatSendHelper sendVideo:video toUsername:_conversation.chatter isChatGroup:_isChatGroup requireEncryption:NO ext:[self getWeiChat]];
    [self addMessage:tempMessage];
}

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
    
    EMMessage *tempMessage = [ChatSendHelper sendTextMessageWithString:@"客服图文混排消息" toUsername:_conversation.chatter isChatGroup:NO requireEncryption:NO ext:extDic];
    [self addMessage:tempMessage];
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

#pragma mark 
- (void)commitSatisfactionWithExt:(NSDictionary*)ext messageModel:(MessageModel*)model
{
    NSString *willSendText = [ConvertToCommonEmoticonsHelper convertToCommonEmoticons:@""];
    EMChatText *text = [[EMChatText alloc] initWithText:willSendText];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:text];
    
    EMMessage *retureMsg = [[EMMessage alloc] initWithReceiver:_conversation.chatter bodies:[NSArray arrayWithObject:body]];
    retureMsg.requireEncryption = NO;
    retureMsg.ext = @{kMesssageExtWeChat:ext};
    __weak typeof(self) weakself = self;
    [[EaseMob sharedInstance].chatManager asyncSendMessage:retureMsg progress:nil prepare:^(EMMessage *message, EMError *error) {} onQueue:dispatch_get_main_queue() completion:^(EMMessage *message, EMError *error) {
        if (!error) {
            [weakself.tableView reloadData];
        }
        [_conversation removeMessage:retureMsg];
    } onQueue:dispatch_get_main_queue()];
}

@end
