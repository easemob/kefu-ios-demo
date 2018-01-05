
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

#import "HDMessageViewController.h"
#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "NSDate+Category.h"
#import "HDMessageReadManager.h"
#import "HDEmotionManager.h"
#import "HDEmoji.h"
#import "HDEmotionEscape.h"
#import "HDCustomMessageCell.h"
#import "UIImage+GIF.h"
#import "HDLocalDefine.h"
#import "HDSDKHelper.h"
#import "HDBubbleView+Transform.h"
#import "HDBubbleView+Evaluate.h"
#import "SatisfactionViewController.h"
#import "HArticleWebViewController.h"
#import "HFormWebViewController.h"
#define KHintAdjustY    50
#define IOS_VERSION [[UIDevice currentDevice] systemVersion]>=9.0

@implementation HDAtTarget
- (instancetype)initWithUserId:(NSString*)userId andNickname:(NSString*)nickname
{
    if (self = [super init]) {
        _userId = [userId copy];
        _nickname = [nickname copy];
    }
    return self;
}
@end

@interface HDMessageViewController ()<HDMessageCellDelegate,HChatDelegate,TransmitDeleteTrackMsgDelegate>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UILongPressGestureRecognizer *_lpgr;
    UITapGestureRecognizer *_tpgr;
    NSMutableArray *_atTargets;
    
    HDRecordView *_tmpView;
    NSString *_isClickBackgroud;
    dispatch_queue_t _messageQueue;
    BOOL _isSendingTransformMessage; //正在发送转人工消息
    BOOL _isSendingEvaluateMessage;//点击立即评价按钮
    NSString *_converID;
}

@property (nonatomic,strong) UIView *maskingView; //遮罩

@property (strong, nonatomic) id<HDIMessageModel> playingVoiceModel;
@property (nonatomic) BOOL isKicked;
@property (nonatomic) BOOL isPlayingAudio;
@property (nonatomic, strong) NSMutableArray *atTargets;
@property(nonatomic,assign) HDemoSaleType saleType;

@end

@implementation HDMessageViewController
{
    NSString *_title;
}

@synthesize conversation = _conversation;
@synthesize deleteConversationIfNull = _deleteConversationIfNull;
@synthesize messageCountOfPage = _messageCountOfPage;
@synthesize timeCellHeight = _timeCellHeight;
@synthesize messageTimeIntervalTag = _messageTimeIntervalTag;

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter {
    if ([conversationChatter length] == 0) {
        return nil;
    }
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _conversation = [[HChatClient sharedClient].chatManager getConversation:conversationChatter];
        _converID = conversationChatter;
        _messageCountOfPage = 10;
        _timeCellHeight = 30;
        _deleteConversationIfNull = YES;
        _scrollToBottomWhenAppear = YES;
        _messsagesSource = [NSMutableArray array];
        HError *er = [HError new];
        [_conversation markAllMessagesAsRead:&er];
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
    _title = _converID;
    if (_conversation.officialAccount.name) {
        _title = _conversation.officialAccount.name;
    }
    self.title = _title;
    [[HChatClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[HDSDKHelper shareHelper] setIsShowingimagePicker:NO];
    if (self.scrollToBottomWhenAppear) {
        [self _scrollViewToBottom:NO];
    }
    
    _isClickBackgroud = nil;
    self.scrollToBottomWhenAppear = YES;
    
    self.view.backgroundColor = [UIColor colorWithRed:248 / 255.0 green:248 / 255.0 blue:248 / 255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideImagePicker) name:@"hideImagePicker" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChatToolbarState) name:@"ChatToolbarState" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeRecording) name:@"closeRecording" object:nil];
    
    //Initialization
    CGFloat chatbarHeight = [HDChatToolbar defaultHeight];
    self.chatToolbar = [[HDChatToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - chatbarHeight-iPhoneXBottomHeight, self.view.frame.size.width, chatbarHeight)];
    self.chatToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    //Initializa the gesture recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    _lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    _lpgr.minimumPressDuration = 0.5;
    [self.tableView addGestureRecognizer:_lpgr];
    
    _messageQueue = dispatch_queue_create("hyphenate.com", NULL);
    
    //Register the delegate
    [HDCDDeviceManager sharedInstance].delegate = self;
    
    [self setLeftBarBtnItem];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[HDBaseMessageCell appearance] setSendBubbleBackgroundImage:[[UIImage imageNamed:@"HelpDeskUIResource.bundle/chat_sender_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:35]];
    [[HDBaseMessageCell appearance] setRecvBubbleBackgroundImage:[[UIImage imageNamed:@"HelpDeskUIResource.bundle/chat_receiver_bg"] stretchableImageWithLeftCapWidth:35 topCapHeight:35]];
    
    [[HDBaseMessageCell appearance] setSendMessageVoiceAnimationImages:@[[UIImage imageNamed:@"HelpDeskUIResource.bundle/chat_sender_audio_playing_full"], [UIImage imageNamed:@"HelpDeskUIResource.bundle/chat_sender_audio_playing_000"], [UIImage imageNamed:@"HelpDeskUIResource.bundle/chat_sender_audio_playing_001"], [UIImage imageNamed:@"HelpDeskUIResource.bundle/chat_sender_audio_playing_002"], [UIImage imageNamed:@"HelpDeskUIResource.bundle/chat_sender_audio_playing_003"]]];
    [[HDBaseMessageCell appearance] setRecvMessageVoiceAnimationImages:@[[UIImage imageNamed:@"HelpDeskUIResource.bundle/chat_receiver_audio_playing_full"],[UIImage imageNamed:@"HelpDeskUIResource.bundle/chat_receiver_audio_playing000"], [UIImage imageNamed:@"HelpDeskUIResource.bundle/chat_receiver_audio_playing001"], [UIImage imageNamed:@"HelpDeskUIResource.bundle/chat_receiver_audio_playing002"], [UIImage imageNamed:@"HelpDeskUIResource.bundle/chat_receiver_audio_playing003"]]];
    
    [[HDBaseMessageCell appearance] setAvatarSize:40.f];
    [[HDBaseMessageCell appearance] setAvatarCornerRadius:20.f];
    
    [[HDChatBarMoreView appearance] setMoreViewBackgroundColor:[UIColor colorWithRed:240 / 255.0 green:242 / 255.0 blue:247 / 255.0 alpha:1.0]];
    [self setupEmotion];
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)ChatToolbarState
{
    [self.chatToolbar endEditing:YES];
}

- (void)setLeftBarBtnItem {
    CustomButton * backButton = [CustomButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"Shape"] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:RGBACOLOR(184, 22, 22, 1) forState:UIControlStateHighlighted];
    backButton.imageRect = CGRectMake(10, 6.5, 16, 16);
    backButton.titleRect = CGRectMake(28, 0, 60, 29);
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
    [[HChatClient sharedClient].chatManager removeDelegate:self];
    [self.navigationController popViewControllerAnimated:YES];
    [self backItemDidClicked];
}

- (void)backItemDidClicked {
    
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        if (touch.view.width == 200 || touch.view.tag == 1990) {
            return NO;
        }
    }
    
    if(touch.view.tag == 1991){
        return NO; //tag in Cell+Form.h
    }
    
    
    return YES;
}

- (void)setupEmotion
{
    // 如果子类中实现了代理方法，就显示子类中的，如果没有显示就显示父类中的
    if ([self.dataSource respondsToSelector:@selector(emotionFormessageViewController:)]) {
        NSArray* emotionManagers = [self.dataSource emotionFormessageViewController:self];
        [self.faceView setEmotionManagers:emotionManagers];
    } else {
        // 系统默认表情
//        NSMutableArray *emotions = [NSMutableArray array];
//        for (NSString *name in [HDEmoji allEmoji]) {
//            HDEmotion *emotion = [[HDEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:HDEmotionDefault];
//            [emotions addObject:emotion];
//        }
//        HDEmotion *emotion = [emotions objectAtIndex:0];
//        HDEmotionManager *manager= [[HDEmotionManager alloc] initWithType:HDEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed:emotion.emotionId]];
    
        // 添加自定义表情
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
        // 只添加自定义表情到数组中，UI上只显示自定义表情
        [self.faceView setEmotionManagers:@[customManagerDefault]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[HDCDDeviceManager sharedInstance] stopPlaying];
    [HDCDDeviceManager sharedInstance].delegate = nil;
    
    if (_imagePicker){
        [_imagePicker dismissViewControllerAnimated:NO completion:nil];
        _imagePicker = nil;
    }
    NSLog(@"dealloc :%s",__func__);
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

- (NSMutableArray*)atTargets
{
    if (!_atTargets) {
        _atTargets = [NSMutableArray array];
    }
    return _atTargets;
}

#pragma mark - setter

- (void)setChatToolbar:(HDChatToolbar *)chatToolbar
{
    [_chatToolbar removeFromSuperview];
    
    _chatToolbar = chatToolbar;
    if (_chatToolbar) {
        [self.view addSubview:_chatToolbar];
        _visitorWaitCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -20, kScreenWidth, 20)];
        _visitorWaitCountLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _visitorWaitCountLabel.font = [UIFont systemFontOfSize:12];
        _visitorWaitCountLabel.textColor = [UIColor whiteColor];
        _visitorWaitCountLabel.hidden = YES;
        [_chatToolbar addSubview:_visitorWaitCountLabel];
    }
    
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = self.view.frame.size.height - _chatToolbar.frame.size.height-iPhoneXBottomHeight;
    self.tableView.frame = tableFrame;
    if ([chatToolbar isKindOfClass:[HDChatToolbar class]]) {
        [(HDChatToolbar *)self.chatToolbar setDelegate:self];
        self.chatBarMoreView = (HDChatBarMoreView*)[(HDChatToolbar *)self.chatToolbar moreView];
        self.faceView = (HDFaceView*)[(HDChatToolbar *)self.chatToolbar faceView];
        // 初始化录音按钮所在的view
        self.hrecordView = (HRecordView *)[(HDChatToolbar *)self.chatToolbar newRecordView];
        // 添加代理
        self.hrecordView.delegate = self;
    }
}

- (void)setDataSource:(id<HDMessageViewControllerDataSource>)dataSource
{
    _dataSource = dataSource;
    
    [self setupEmotion];
}

- (void)setDelegate:(id<HDMessageViewControllerDelegate>)delegate
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

- (BOOL)_canRecord
{
    __block BOOL bCanRecord = NO;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    
    return bCanRecord;
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

- (void)_stopAudioPlayingWithChangeCategory:(BOOL)isChange
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
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView beginUpdates];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];
            });
        }
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


- (void)_downloadMessageAttachments:(HMessage *)message
{
    __weak typeof(self) weakSelf = self;
    void (^completion)(HMessage *, HError *) = ^(HMessage *aMessage, HError *error) {
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
            [[HChatClient sharedClient].chatManager downloadAttachment:message progress:nil completion:completion];
        }
    }else if ([messageBody type] == EMMessageBodyTypeVideo) {
        EMVideoMessageBody *videoBody = (EMVideoMessageBody *)messageBody;
        if (videoBody.thumbnailDownloadStatus > EMDownloadStatusSuccessed) {
            //download the message thumbnail
            [[HChatClient sharedClient].chatManager downloadThumbnail:message progress:nil completion:completion];
        }
    }else if ([messageBody type] == EMMessageBodyTypeVoice)
    {
        EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody*)messageBody;
        if (voiceBody.downloadStatus > EMDownloadStatusSuccessed) {
            //download the message attachment
            [[HChatClient sharedClient].chatManager downloadAttachment:message progress:nil completion:^(HMessage *message, HError *error) {
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
    _scrollToBottomWhenAppear = NO;
    
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
    _scrollToBottomWhenAppear = NO;
    
    EMVideoMessageBody *videoBody = (EMVideoMessageBody*)model.message.body;
    
    NSString *localPath = [model.fileLocalPath length] > 0 ? model.fileLocalPath : videoBody.localPath;
    if ([localPath length] == 0) {
        [self showHint:NSEaseLocalizedString(@"message.videoFail", @"video for failure!")];
        return;
    }
    
    dispatch_block_t block = ^{
        //send the acknowledgement
        
        NSURL *videoURL = [NSURL fileURLWithPath:localPath];
        MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
        [moviePlayerController.moviePlayer prepareToPlay];
        moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
    };
    
    __weak typeof(self) weakSelf = self;
    void (^completion)(HMessage *aMessage, HError *error) = ^(HMessage *aMessage, HError *error) {
        if (!error)
        {
            [weakSelf _reloadTableViewDataWithMessage:aMessage];
        }
        else
        {
            [weakSelf showHint:NSEaseLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
        }
    };
    
    if (videoBody.thumbnailDownloadStatus == EMDownloadStatusFailed || ![[NSFileManager defaultManager] fileExistsAtPath:videoBody.thumbnailLocalPath]) {
        [self showHint:@"begin downloading thumbnail image, click later"];
        [[HChatClient sharedClient].chatManager downloadThumbnail:model.message progress:nil completion:completion];
        return;
    }
    
    if (videoBody.downloadStatus == EMDownloadStatusSuccessed && [[NSFileManager defaultManager] fileExistsAtPath:localPath])
    {
        block();
        return;
    }
    
    [self showHudInView:self.view hint:NSEaseLocalizedString(@"message.downloadingVideo", @"downloading video...")];
    [[HChatClient sharedClient].chatManager downloadAttachment:model.message progress:nil completion:^(HMessage *message, HError *error) {
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
    HFormWebViewController *formVC = [[HFormWebViewController alloc]init];
    NSDictionary *htmlDic = [[model.message.ext objectForKey:@"msgtype"] objectForKey:@"html"];
    NSString *strUrl = [htmlDic objectForKey:@"url"];
    formVC.url = strUrl;
//    formVC.view.originY = kScreenHeight - 64;
    [self presentViewController:formVC animated:YES completion:nil];
    
//    [self.view addSubview:formVC.view];
//    [UIView animateWithDuration:0.25 animations:^{
//        formVC.view.originY = 0;
//    }];
    
}

- (void)_imageMessageCellSelected:(id<HDIMessageModel>)model
{
    __weak HDMessageViewController *weakSelf = self;
    EMImageMessageBody *imageBody = (EMImageMessageBody*)[model.message body];
    
    if ([imageBody type] == EMMessageBodyTypeImage) {
        if (imageBody.thumbnailDownloadStatus == EMDownloadStatusSuccessed) {
            if (imageBody.downloadStatus == EMDownloadStatusSuccessed)
            {
                //send the acknowledgementpo
                NSString *localPath = model.message == nil ? model.fileLocalPath : [imageBody localPath];
                if (localPath && localPath.length > 0) {
                    UIImage *image = [UIImage imageWithContentsOfFile:localPath];
                    
                    if (image)
                    {
                        [[HDMessageReadManager defaultManager] showBrowserWithImages:@[image]];
                    }
                    else
                    {
                        NSLog(@"Read %@ failed!", localPath);
                    }
                    return;
                }
            }
            [weakSelf showHudInView:weakSelf.view hint:NSEaseLocalizedString(@"message.downloadingImage", @"downloading a image...")];
            [[HChatClient sharedClient].chatManager downloadAttachment:model.message progress:nil completion:^(HMessage *message, HError *error) {
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
                            NSLog(@"Read %@ failed!", localPath);
                        }
                        return ;
                    }
                }
                [weakSelf showHint:NSEaseLocalizedString(@"message.imageFail", @"image for failure!")];
            }];
        }else{
            //get the message thumbnail
            [[HChatClient sharedClient].chatManager downloadAttachment:model.message progress:nil completion:^(HMessage *message, HError *error) {
                if (!error) {
                    [weakSelf _reloadTableViewDataWithMessage:model.message];
                }else{
                    [weakSelf showHint:NSEaseLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
                }
            }];
            
            [[HChatClient sharedClient].chatManager downloadThumbnail:model.message progress:nil completion:^(HMessage *message, HError *error) {
                if (!error) {
                    [weakSelf _reloadTableViewDataWithMessage:model.message];
                }else{
                    [weakSelf showHint:NSEaseLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
                }
            }];
        }
    }
}

- (void)_audioMessageCellSelected:(id<HDIMessageModel>)model
{

    _scrollToBottomWhenAppear = NO;
    EMVoiceMessageBody *body = (EMVoiceMessageBody*)model.message.body;
    EMDownloadStatus downloadStatus = [body downloadStatus];
    if (downloadStatus == EMDownloadStatusDownloading) {
        [self showHint:NSEaseLocalizedString(@"message.downloadingAudio", @"downloading voice, click later")];
        return;
    }
    else if (downloadStatus == EMDownloadStatusFailed)
    {
        [self showHint:NSEaseLocalizedString(@"message.downloadingAudio", @"downloading voice, click later")];
        [[HChatClient sharedClient].chatManager downloadAttachment:model.message progress:nil completion:nil];
        return;
    }
    
    // play the audio
    if (model.bodyType == EMMessageBodyTypeVoice) {
        //send the acknowledgement
        __weak HDMessageViewController *weakSelf = self;
        BOOL isPrepare = [[HDMessageReadManager defaultManager] prepareMessageAudioModel:model updateViewCompletion:^(HDMessageModel *prevAudioModel, HDMessageModel *currentAudioModel) {
            if (prevAudioModel || currentAudioModel) {
                [weakSelf.tableView reloadData];
            }
        }];
        
        if (isPrepare) {
            _isPlayingAudio = YES;
            __weak HDMessageViewController *weakSelf = self;
            [[HDCDDeviceManager sharedInstance] enableProximitySensor];
            [[HDCDDeviceManager sharedInstance] asyncPlayingWithPath:model.fileLocalPath completion:^(NSError *error) {
                [[HDMessageReadManager defaultManager] stopMessageAudioModel];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                    weakSelf.isPlayingAudio = NO;
                    [[HDCDDeviceManager sharedInstance] disableProximitySensor];
                });
            }];
        }
        else{
            _isPlayingAudio = NO;
        }
    }
}

// app进入后台停止语音播放
- (void)appDidEnterBackground
{
    [self _stopAudioPlayingWithChangeCategory:YES];
}

#pragma cancelRecording Animal
- (void)closeRecording
{
    if(self.recordView){
        [self didHdCancelRecordingVoiceAction:self.recordView];
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
            dispatch_async(dispatch_get_main_queue(), ^{
                HDMessageViewController *strongSelf = weakSelf;
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
                    
                    HMessage *latest = [strongSelf.messsagesSource lastObject];
                    strongSelf.messageTimeIntervalTag = latest.messageTime;
                    
                    [strongSelf.tableView reloadData];
                    
                    [strongSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count] - scrollToIndex - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            });
            //re-download all messages that are not successfully downloaded
            for (HMessage *message in messages)
            {
                [weakSelf _downloadMessageAttachments:message];
            }
        });
    };
    
    [self.conversation loadMessagesStartFromId:messageId count:(int)count searchDirection:HMessageSearchDirectionUp completion:^(NSArray *aMessages, HError *aError) {
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
        if(_isClickBackgroud){
            
        } else {
            [self.chatToolbar endEditing:YES];
        }
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
                        model.image = [UIImage sd_animatedGIFNamed:emotion.emotionOriginal];
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

- (void)messageStatusDidChange:(HMessage *)aMessage error:(HError *)aError {
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
    [self _sendTrackMessage:model.message];
    
    // 删除对应的消息
    [self deleteTrackMessage:model];

    
}

- (void)_sendTrackMessage:(HMessage *)message
{

    __weak typeof(self) weakself = self;
    
    [[HChatClient sharedClient].chatManager sendMessage:message progress:nil completion:^(HMessage *message, HError *error) {
        if (!error) {
            [weakself _refreshAfterSentMessage:message];
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
                NSLog(@"failed to remove file, error:%@.", error);
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
            if([HMessageHelper getMessageExtType:model.message] == HExtFormMsg){
                [self _formMessageCellSelected:model];
            }
        }
            break;
        case EMMessageBodyTypeImage: {
            _scrollToBottomWhenAppear = NO;
            [self _imageMessageCellSelected:model];
        }
            break;
        case EMMessageBodyTypeLocation: {
             [self _locationMessageCellSelected:model];
        }
            break;
        case EMMessageBodyTypeVoice: {
            [self _audioMessageCellSelected:model];
        }
            break;
        case EMMessageBodyTypeVideo: {
            [self _videoMessageCellSelected:model];
        }
            break;
        case EMMessageBodyTypeFile: {
            _scrollToBottomWhenAppear = NO;
            [self _fileMessageCellSelected:model];
        }
            break;
        default:
            break;
    }
}

- (void)statusButtonSelcted:(id<HDIMessageModel>)model withMessageCell:(HDMessageCell*)messageCell
{
    if ((model.messageStatus != HMessageStatusFailed) && (model.messageStatus != HMessageStatusPending))
    {
        return;
    }
    __weak typeof(self) weakself = self;
    
    [[HChatClient sharedClient].chatManager resendMessage:model.message progress:nil completion:^(HMessage *message, HError *error) {
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
    
    _scrollToBottomWhenAppear = NO;
}

#pragma mark - HDChatToolbarDelegate

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
    
    [[HChatClient sharedClient].chatManager postContent:inputTextView.text conversationId:_conversation.conversationId completion:^(id responseObject, HError *error) {
        
    }];
}

- (void)didSendText:(NSString *)text
{
    if (text && text.length > 0) {
        [self sendTextMessage:text];
        [self.atTargets removeAllObjects];
    }
}

- (BOOL)didInputAtInLocation:(NSUInteger)location
{
    if ([self.delegate respondsToSelector:@selector(messageViewController:selectAtTarget:)]) {
        location += 1;
        __weak typeof(self) weakSelf = self;
        [self.delegate messageViewController:self selectAtTarget:^(HDAtTarget *target) {
            __strong HDMessageViewController *strongSelf = weakSelf;
            if (strongSelf && target) {
                if ([target.userId length] || [target.nickname length]) {
                    [strongSelf.atTargets addObject:target];
                    NSString *insertStr = [NSString stringWithFormat:@"%@ ", target.nickname ? target.nickname : target.userId];
                    HDChatToolbar *toolbar = (HDChatToolbar*)strongSelf.chatToolbar;
                    NSMutableString *originStr = [toolbar.inputTextView.text mutableCopy];
                    NSUInteger insertLocation = location > originStr.length ? originStr.length : location;
                    [originStr insertString:insertStr atIndex:insertLocation];
                    toolbar.inputTextView.text = originStr;
                    toolbar.inputTextView.selectedRange = NSMakeRange(insertLocation + insertStr.length, 0);
                    [toolbar.inputTextView becomeFirstResponder];
                }
            }
            else if (strongSelf) {
                HDChatToolbar *toolbar = (HDChatToolbar*)strongSelf.chatToolbar;
                [toolbar.inputTextView becomeFirstResponder];
            }
        }];
        HDChatToolbar *toolbar = (HDChatToolbar*)self.chatToolbar;
        toolbar.inputTextView.text = [NSString stringWithFormat:@"%@@", toolbar.inputTextView.text];
        [toolbar.inputTextView resignFirstResponder];
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)didDeleteCharacterFromLocation:(NSUInteger)location
{
    HDChatToolbar *toolbar = (HDChatToolbar*)self.chatToolbar;
    if ([toolbar.inputTextView.text length] == location + 1) {
        //delete last character
        NSString *inputText = toolbar.inputTextView.text;
        NSRange range = [inputText rangeOfString:@"@" options:NSBackwardsSearch];
        if (range.location != NSNotFound) {
            if (location - range.location > 1) {
                NSString *sub = [inputText substringWithRange:NSMakeRange(range.location + 1, location - range.location - 1)];
                for (HDAtTarget *target in self.atTargets) {
                    if ([sub isEqualToString:target.userId] || [sub isEqualToString:target.nickname]) {
                        inputText = range.location > 0 ? [inputText substringToIndex:range.location] : @"";
                        toolbar.inputTextView.text = inputText;
                        toolbar.inputTextView.selectedRange = NSMakeRange(inputText.length, 0);
                        [self.atTargets removeObject:target];
                        return YES;
                    }
                }
            }
        }
    }
    return NO;
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

- (UIView *)maskingView {
    if (_maskingView == nil) {
        _maskingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _maskingView.backgroundColor = [UIColor clearColor];
        _maskingView.userInteractionEnabled = YES;
        _maskingView.tag = 33;
    }
    return _maskingView;
}

#pragma mark - HRecordViewDelegate
// 点触录音按钮开始录音的代理方法
- (void)didHdStartRecordingVoiceAction:(UIView *)recordView
{
    [self _stopAudioPlayingWithChangeCategory:YES];
    [self.view addSubview:self.maskingView];
    [self.view bringSubviewToFront:self.maskingView];
    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectRecordView:withEvenType:)]) {
        [self.delegate messageViewController:self didSelectRecordView:recordView withEvenType:HDRecordViewTypeTouchDown];
    } else {
        if ([recordView isKindOfClass:[HDRecordView class]]) {
            [(HDRecordView *)recordView recordButtonTouchDown];
        }
    }
    
    if ([self _canRecord]) {
        _tmpView = (HDRecordView *)recordView;
        _tmpView.center = self.view.center;
        [self.view addSubview:_tmpView];
        [self.view bringSubviewToFront:recordView];
        int x = arc4random() % 100000;
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
        
        [[HDCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName completion:^(NSError *error)
         {
             if (error) {
                 NSLog(@"%@",NSEaseLocalizedString(@"message.startRecordFail", @"failure to start recording"));
             }
         }];
    }
    _isClickBackgroud = @"Yes";
}
// 在控件之外触摸抬起事件的代理方法
- (void)didHdCancelRecordingVoiceAction:(UIView *)recordView
{
    [self.maskingView removeFromSuperview];
    [[HDCDDeviceManager sharedInstance] cancelCurrentRecording];
    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectRecordView:withEvenType:)]) {
        [self.delegate messageViewController:self didSelectRecordView:recordView withEvenType:HDRecordViewTypeTouchUpOutside];
    } else {
        if ([recordView isKindOfClass:[HDRecordView class]]) {
            [(HDRecordView *)recordView recordButtonTouchUpOutside];
        }
        [recordView removeFromSuperview];
        
    }
    
    _isClickBackgroud = nil;
    
}
// 在控件之内触摸抬起事件的代理方法
- (void)didHdFinishRecoingVoiceAction:(UIView *)recordView
{
    [self.maskingView removeFromSuperview];
    _isClickBackgroud = nil;
    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectRecordView:withEvenType:)]) {
        [self.delegate messageViewController:self didSelectRecordView:recordView withEvenType:HDRecordViewTypeTouchUpInside];
    } else {
        if ([recordView isKindOfClass:[HDRecordView class]]) {
            [(HDRecordView *)recordView recordButtonTouchUpInside];
        }
        [recordView removeFromSuperview];
        
    }
    __weak typeof(self) weakSelf = self;
    [[HDCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error) {
            [weakSelf sendVoiceMessageWithLocalPath:recordPath duration:(int)aDuration];
        }
        else {
            NSString *ers = error.domain;
            if (![self _canRecord]) {
                ers = @"未授权";
            }
            [weakSelf showHudInView:self.view hint:ers];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf hideHud];
            });
        }
    }];
    _isClickBackgroud = nil;
}

// 当一次触摸从控件窗口内部拖动到外部时的代理方法
- (void)didHdDragOutsideAction:(UIView *)recordView
{
    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectRecordView:withEvenType:)]) {
        [self.delegate messageViewController:self didSelectRecordView:recordView withEvenType:HDRecordViewTypeDragInside];
    } else {
        if ([recordView isKindOfClass:[HDRecordView class]]) {
            [(HDRecordView *)recordView recordButtonDragInside];
        }
    }
    _isClickBackgroud = @"Yes";
}
// 当一次触摸从控件窗口之外拖动到内部时的代理方法
- (void)didHdDragInsideAction:(UIView *)recordView
{
    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectRecordView:withEvenType:)]) {
        [self.delegate messageViewController:self didSelectRecordView:recordView withEvenType:HDRecordViewTypeDragOutside];
    } else {
        if ([recordView isKindOfClass:[HDRecordView class]]) {
            [(HDRecordView *)recordView recordButtonDragOutside];
        }
    }
    _isClickBackgroud = @"Yes";
}



#pragma mark - EaseChatBarMoreViewDelegate

- (void)moreView:(HDChatBarMoreView *)moreView didItemInMoreViewAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectMoreView:AtIndex:)]) {
        [self.delegate messageViewController:self didSelectMoreView:moreView AtIndex:index];
        return;
    }
}

- (void)moreViewPhotoAction:(HDChatBarMoreView *)moreView
{
    // Hide the keyboard
    [self.chatToolbar endEditing:YES];
    
    [self _stopAudioPlayingWithChangeCategory:YES];
    
    // Pop image picker
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
    
    [[HDSDKHelper shareHelper] setIsShowingimagePicker:YES];
}

- (void)moreViewTakePicAction:(HDChatBarMoreView *)moreView
{
    // Hide the keyboard
    [self.chatToolbar endEditing:YES];
    
    [self _stopAudioPlayingWithChangeCategory:YES];
    
#if TARGET_IPHONE_SIMULATOR
    [self showHint:NSEaseLocalizedString(@"message.simulatorNotSupportCamera", @"simulator does not support taking picture")];
#elif TARGET_OS_IPHONE
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];

    [[HDSDKHelper shareHelper] setIsShowingimagePicker:YES];
#endif
}

- (void)moreViewLocationAction:(HDChatBarMoreView *)moreView
{
    // Hide the keyboard
    [self.chatToolbar endEditing:YES];
    
    [self _stopAudioPlayingWithChangeCategory:YES];
    HDLocationViewController *locationController = [[HDLocationViewController alloc] init];
    locationController.delegate = self;
    [self.navigationController pushViewController:locationController animated:YES];
}

- (void)moreViewAudioCallAction:(HDChatBarMoreView *)moreView
{
    // Hide the keyboard
    [self.chatToolbar endEditing:YES];
    
    [self _stopAudioPlayingWithChangeCategory:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CALL object:@{@"chatter":self.conversation.conversationId, @"type":[NSNumber numberWithInt:0]}];
}

- (void)moreViewVideoCallAction:(HDChatBarMoreView *)moreView
{
    // Hide the keyboard
    [self.chatToolbar endEditing:YES];
    
    [self _stopAudioPlayingWithChangeCategory:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CALL object:@{@"chatter":self.conversation.conversationId, @"type":[NSNumber numberWithInt:1]}];
}

- (void)moreViewLeaveMessageAction:(HDChatBarMoreView *)moreView
{
    // Hide the keyboard
    [self.chatToolbar endEditing:YES];
    [self _stopAudioPlayingWithChangeCategory:YES];
    
}

#pragma mark - EMLocationViewDelegate

-(void)sendLocationLatitude:(double)latitude
                  longitude:(double)longitude
                 andAddress:(NSString *)address
{
    [self sendLocationMessageLatitude:latitude longitude:longitude andAddress:address];
}

#pragma mark - Hyphenate

#pragma mark - HChatDelegate

- (void)messagesDidReceive:(NSArray *)aMessages {
    for (HMessage *message in aMessages) {
        if ([self.conversation.conversationId isEqualToString:message.conversationId]) {
            [_conversation markAllMessagesAsRead:nil];
            [self addMessageToDataSource:message progress:nil];
        }
    }
}

- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages {
    for (HMessage *message in aCmdMessages) {
        if ([self.conversation.conversationId isEqualToString:message.conversationId]) {
            NSString *msg = [NSString stringWithFormat:@"%@", message.ext];
            NSLog(@"receive cmd message: %@", msg);
            break;
        }
    }
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


- (void)messageAttachmentStatusDidChange:(HMessage *)aMessage error:(HError *)aError {
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
        if (self.playingVoiceModel == nil) {
            [[HDCDDeviceManager sharedInstance] disableProximitySensor];
        }
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
    
    for (HMessage *message in messages) {
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
        BOOL isSender = message.direction == HMessageDirectionSend;
        if (isSender && _dataSource && [_dataSource respondsToSelector:@selector(messageViewController:modelForMessage:)]) {
            model = [_dataSource messageViewController:self modelForMessage:message];
        }
        else{
            model = [[HDMessageModel alloc] initWithMessage:message];
            NSDictionary *weichat = [NSDictionary dictionary];
            if ([message.ext objectForKey:@"weichat"]) {
                weichat = [message.ext valueForKey:@"weichat"];
            }
            NSDictionary *agent = [NSDictionary dictionary];
            if ([weichat objectForKey:@"agent"]) {
                agent = [weichat valueForKey:@"agent"];
            }
            if ([[agent allKeys] containsObject:@"avatar"]) {
                NSString *url = [agent valueForKey:@"avatar"];
                if (![url isKindOfClass:[NSNull class]]) {
                    if ([url hasPrefix:@"http"]) {
                        model.avatarURLPath = [agent valueForKey:@"avatar"];
                    } else {
                        model.avatarURLPath = [[@"https:" stringByAppendingString:[agent valueForKey:@"avatar"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    }
                }
            }
            model.avatarImage = [UIImage imageNamed:@"HelpDeskUIResource.bundle/user"];
            model.failImageName = @"imageDownloadFail";
        }

        if (model) {
            [formattedArray addObject:model];
        }
    }
    
    return formattedArray;
}

-(void)addMessageToDataSource:(HMessage *)message
                     progress:(id)progress
{
    @synchronized (self.messsagesSource) {
        [self.messsagesSource addObject:message];
        NSArray *messages = [self formatMessages:@[message]];
        NSMutableArray  *mArr = [NSMutableArray arrayWithCapacity:0];
        for (int i=0; i<messages.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count + i inSection:0];
            [mArr addObject:indexPath];
        }
        [self.dataArray addObjectsFromArray:messages];
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
        messageId = [(HMessage *)self.messsagesSource.firstObject messageId];
    }
    else {
        messageId = nil;
    }
    [self _loadMessagesBefore:messageId count:self.messageCountOfPage append:YES];
    
    [self tableViewDidFinishTriggerHeader:YES reload:YES];
}

#pragma mark - send message

- (void)_refreshAfterSentMessage:(HMessage*)aMessage
{
    if ([self.messsagesSource count] /*&& [EMClient sharedClient].options.sortMessageByServerTime*/) {
        NSString *msgId = aMessage.messageId;
        HMessage *last = self.messsagesSource.lastObject;
        if ([last isKindOfClass:[HMessage class]]) {
            __block NSUInteger index = NSNotFound;
            index = NSNotFound;
            [self.messsagesSource enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(HMessage *obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[HMessage class]] && [obj.messageId isEqualToString:msgId]) {
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
}

- (void)_sendMessage:(HMessage *)message
{
    [self addMessageToDataSource:message
                        progress:nil];
    
    __weak typeof(self) weakself = self;
    
    [[HChatClient sharedClient].chatManager sendMessage:message progress:nil completion:^(HMessage *message, HError *error) {
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



- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    
    if ([eventName isEqualToString:HRouterEventTapMenu]) {
        NSString *text = [userInfo objectForKey:@"clickText"];
        NSDictionary *ext = nil;
        if ([userInfo objectForKey:@"menuId"]) {
            ext = @{
                    @"msgtype":@{
                        @"choice":@{
                            @"menuid":[userInfo objectForKey:@"menuId"]
                        }
                    }
                    };
        }
        [self sendTextMessage:text withExt:ext];
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
    if ([eventName isEqualToString:HRouterEventTapTransform]) {
        if (_isSendingTransformMessage) return;
        _isSendingTransformMessage = YES;
        __block HMessage *message = [userInfo objectForKey:@"HMessage"];
        NSDictionary *weichat = [message.ext objectForKey:kMesssageExtWeChat];
        NSDictionary *ctrlArgs = [weichat objectForKey:kMesssageExtWeChat_ctrlArgs];
        ControlArguments *arguments = [ControlArguments new];
        arguments.identity = [ctrlArgs valueForKey:@"id"];
        arguments.sessionId = [ctrlArgs valueForKey:@"serviceSessionId"];
        HControlMessage *hcont = [HControlMessage new];
        hcont.arguments = arguments;
        if ([HMessageHelper getMessageExtType:message] == HExtToCustomServiceMsg) {
            //发送透传消息
            HMessage *aHMessage = [HDSDKHelper cmdMessageFormatTo:self.conversation.conversationId];
            [aHMessage addCompositeContent:hcont];
            __weak typeof(self) weakSelf = self;
            [[HChatClient sharedClient].chatManager sendMessage:aHMessage progress:nil completion:^(HMessage *aMessage, HError *aError) {
                _isSendingTransformMessage = NO;
                if (!aError) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        //更新ext，目的当点击一次转人工客服按钮且cmd发送成功后，此按钮不在被使用
                        [weakSelf updateTransferMessageExt:message];
                    });
                } else {
                    [weakSelf showHint:NSLocalizedString(@"transferToKf.fail", @"Transfer to the artificial customer service request failed, please confirm the connection status!")];
                }
            }];
        }
    }
    if ([eventName isEqualToString:HRouterEventTapEvaluate]) {
        if (_isSendingEvaluateMessage) return;
        _isSendingEvaluateMessage = YES;
        SatisfactionViewController *view = [[SatisfactionViewController alloc] init];
        id <HDIMessageModel> model = nil;
        model = [[HDMessageModel alloc] initWithMessage:[userInfo objectForKey:@"HMessage"]];
        view.messageModel = model;
        view.delegate = self;
        [self.navigationController pushViewController:view animated:YES];
    }
    
    if ([eventName isEqualToString:HRouterEventTextURLTapEventName]) {
        [self chatTextCellUrlPressed:[userInfo objectForKey:@"url"]];
    }
}

//链接被点击
- (void)chatTextCellUrlPressed:(NSURL *)url {
    if (url) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)backFromSatisfactionViewController {
    _isSendingEvaluateMessage = NO;
}


- (void)commitSatisfactionWithControlArguments:(ControlArguments *)arguments type:(ControlType *)type evaluationTagsArray:(NSMutableArray *)tags{
    HMessage *message = [HDSDKHelper textHMessageFormatWithText:@"" to:self.conversation.conversationId];
    HControlMessage *hCtrl = [HControlMessage new];
    hCtrl.type = type;
    hCtrl.arguments = arguments;
    [message addCompositeContent:hCtrl];
    // 将会话标签加到消息的ext中
    NSMutableDictionary *ext = [message.ext mutableCopy];
    NSMutableDictionary *ctrlArgs = [[ext objectForKey:@"weichat"] objectForKey:@"ctrlArgs"];
    NSArray *tagsArray = [NSArray arrayWithArray:tags];
    [ctrlArgs setObject:tagsArray forKey:@"appraiseTags"];
    message.ext = [ext copy];
    
    __weak typeof(self) weakself = self;
    [self showHudInView:self.view hint:NSLocalizedString(@"comment_submit", @"Comment Submit.")];
    [[HChatClient sharedClient].chatManager sendMessage:message progress:nil completion:^(HMessage *aMessage, HError *aError) {
        [self hideHud];
        if (!aError) {
            NSLog(@"message.ext--%@", message.ext);
            [weakself.tableView reloadData];
            [weakself showHint:NSLocalizedString(@"comment_suc", @"Add comment successful.")];
        } else {
            [weakself showHint:NSLocalizedString(@"comment_fail", @"Add comment fail.")];
        }
        [_conversation removeMessageWithMessageId:aMessage.messageId error:nil];
    }];
}

//更新转人工消息的ext
- (void)updateTransferMessageExt:(HMessage *)message {
    HMessage *_message = message;
    NSMutableDictionary *_ext = [NSMutableDictionary dictionaryWithDictionary:message.ext];
    
    [_ext setValue:@YES forKey:kMesssageExtWeChat_ctrlType_transferToKf_HasTransfer];
    _message.ext = [_ext copy];
    __weak typeof(self) weakSelf = self;
    [[HChatClient sharedClient].chatManager updateMessage:_message completion:^(HMessage *aMessage, HError *aError) {
        if (!aError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}

- (void)sendTextMessage:(NSString *)text withExt:(NSDictionary*)ext
{
    HMessage *message = [HDSDKHelper textHMessageFormatWithText:text to:self.conversation.conversationId];
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
    [self _sendMessage:message];
}

- (void)sendCustomMagicEmojiWithOriginUrl:(NSString *)url {
    HMessage *message = [HDSDKHelper customMagicEmojiMessageWithOriginUrl:url to:self.conversation.conversationId];
    [self _sendMessage:message];
}

- (void)sendLocationMessageLatitude:(double)latitude
                          longitude:(double)longitude
                         andAddress:(NSString *)address
{
    HMessage *message = [HDSDKHelper locationHMessageWithLatitude:latitude longitude:longitude address:address to:self.conversation.conversationId messageExt:nil];
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
    
    HMessage *message = [HDSDKHelper imageMessageWithImageData:imageData to:self.conversation.conversationId messageExt:nil];
    EMImageMessageBody *body = (EMImageMessageBody *)message.body;
    NSLog(@"body.localPathbody.localPath:%@",body.localPath);
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
    HMessage *message = [HDSDKHelper imageMessageWithImage:image to:self.conversation.conversationId messageExt:nil];
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
    
    HMessage *message = [HDSDKHelper voiceMessageWithLocalPath:localPath duration:duration to:self.conversation.conversationId messageExt:nil];
    [self _sendMessage:message];
}

- (void)sendVideoMessageWithURL:(NSURL *)url
{
    
}

#pragma mark - notifycation
- (void)didBecomeActive
{
    self.dataArray = [[self formatMessages:self.messsagesSource] mutableCopy];
    [self.tableView reloadData];
}

- (void)hideImagePicker
{
    if (_imagePicker && [HDSDKHelper shareHelper].isShowingimagePicker) {
        [_imagePicker dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - private
- (void)_reloadTableViewDataWithMessage:(HMessage *)message
{
    if ([self.conversation.conversationId isEqualToString:message.conversationId])
    {
        for (int i = 0; i < self.dataArray.count; i ++) {
            id object = [self.dataArray objectAtIndex:i];
            if ([object isKindOfClass:[HDMessageModel class]]) {
                id<HDIMessageModel> model = object;
                if ([message.messageId isEqualToString:model.messageId]) {
                    id<HDIMessageModel> model = nil;
                    if (self.dataSource && [self.dataSource respondsToSelector:@selector(messageViewController:modelForMessage:)]) {
                        model = [self.dataSource messageViewController:self modelForMessage:message];
                    }
                    else{
                        model = [[HDMessageModel alloc] initWithMessage:message];
                        model.avatarImage = [UIImage imageNamed:@"HelpDeskUIResource.bundle/user"];
                        model.failImageName = @"imageDownloadFail";
                    }
                    
                    [self.tableView beginUpdates];
                    [self.dataArray replaceObjectAtIndex:i withObject:model];
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    [self.tableView endUpdates];
                    break;
                }
            }
        }
    }
}


@end
