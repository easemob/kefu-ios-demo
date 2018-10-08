//
//  LeaveMsgDetailViewController.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 16/6/30.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "LeaveMsgDetailViewController.h"
#import "LeaveMsgDetailHeaderView.h"
#import "LeaseMsgReplyController.h"
#import "HDMessageReadManager.h"
#import "LeaveMsgCell.h"
#import "LeaveMsgDetailModel.h"
#import "HDCDDeviceManager+Media.h"
#import "SCAudioPlay.h"
#import "LeaveMsgAttatchmentView.h"
#import <objc/runtime.h>
#import "CustomButton.h"

@interface LeaveMsgDetailViewController () <UITableViewDelegate,UITableViewDataSource,LeaveMsgCellDelegate,SCAudioPlayDelegate,LeaseMsgReplyControllerDelegate,HDChatManagerDelegate>
{
    id _responseObject;
    NSString *_ticketId;
    NSDictionary *_temp;
    SCAudioPlay *_audioPlayer;
}

@property (nonatomic, strong) LeaveMsgDetailHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSDateFormatter *dateformatter;
@property (nonatomic, strong) UIButton *replyButton;

@end

@implementation LeaveMsgDetailViewController
{
    LeaveMsgAttatchmentView *_touchView;
}

- (instancetype)initWithResponseObject:(id)responseObject ticketId:(NSString *)ticketId{
    self = [super init];
    if (self) {
        _responseObject = responseObject;
        _ticketId = ticketId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self clearTempWav];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.replyButton];
    [self.view addSubview:self.tableView];
    
    [self setupBarButtonItem];
    [self loadLeaveMessageDetail];
    [self loadLeaveMessageAllComments];
    [self registNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackgroundLeaseMsgDetail)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
}

- (void)appDidEnterBackgroundLeaseMsgDetail
{
    [self _stopAudioPlayingWithChangeCategory];
}

- (void)registNotification
{
    [self unregistNotification];
    [[HDClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
//    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unregistNotification
{
    [[HDClient sharedClient].chatManager removeDelegate:self];
}

- (void)dealloc
{
    [self unregistNotification];
}

- (void)setupBarButtonItem
{
    CustomButton * backButton = [CustomButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"Shape"] forState:UIControlStateNormal];
    [backButton setTitle:NSLocalizedString(@"title.leavemsgdetail", @"Leave Message Detail") forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:RGBACOLOR(184, 22, 22, 1) forState:UIControlStateHighlighted];
    backButton.imageRect = CGRectMake(10, 6.5, 16, 16);
    if ([NSLocalizedString(@"title.leavemsgdetail", @"Leave Message Detail") isEqualToString:@"留言详情"]) {
        backButton.titleRect = CGRectMake(28, 0, 83, 29);
        backButton.frame = CGRectMake(0, 0, 120, 29);
    } else {
        backButton.titleRect = CGRectMake(28, 0, 193, 29);
        backButton.frame = CGRectMake(0, 0, 230, 29);
    }
    
    [self.view addSubview:backButton];
    
    [backButton addTarget:self action:@selector(backBtnItem) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer.width = -16;
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer,backItem];
}

- (void)backBtnItem
{
    [self _stopAudioPlayingWithChangeCategory];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter

- (NSDateFormatter*)dateformatter
{
    if (_dateformatter == nil) {
        _dateformatter = [[NSDateFormatter alloc] init];
        [_dateformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        [_dateformatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    }
    return _dateformatter;
}

- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (LeaveMsgDetailHeaderView*)headerView
{
    if (_headerView == nil) {
        _headerView = [[LeaveMsgDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 227) dictionary:nil];
    }
    return _headerView;
}

- (UIButton*)replyButton
{
    if (_replyButton == nil) {
        _replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _replyButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _replyButton.frame = CGRectMake(20, kScreenHeight - 50.f, kScreenWidth-40, 40.f);
        [_replyButton setTitle:NSLocalizedString(@"leaveMessage.leavemsg.comment", @"comment") forState:UIControlStateNormal];
        [_replyButton setBackgroundColor:RGBACOLOR(184, 22, 22, 1)];
        [_replyButton addTarget:self action:@selector(replyAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _replyButton;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - CGRectGetHeight(_replyButton.frame) - 44.f) style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGBACOLOR(238, 238, 245, 1);;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

#pragma mark - action

- (void)replyAction
{
    [self _stopAudioPlayingWithChangeCategory];
    LeaseMsgReplyController *replyController = [[LeaseMsgReplyController alloc] init];
    replyController.delegate = self;
    [self.navigationController pushViewController:replyController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count] + 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleCell"];
            CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, height - 1, kScreenWidth, 1)];
            lineView.backgroundColor = RGBACOLOR(207, 210, 213, 0.7);
            [cell.contentView addSubview:lineView];
        }
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.text = NSLocalizedString(@"leaveMessage.leavemsg.comment", @"comment");
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString *identify = @"commentListID";
    LeaveMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[LeaveMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.delegate = self;
    }
    LeaveMsgCommentModel *comment = [self.dataArray objectAtIndex:indexPath.row - 1];
    [cell setModel:comment];
    cell.time = [self dateformatWithTimeStr:comment.updated_at];
    return cell;
}

- (NSString *)dateformatWithTimeStr:(NSString *)time {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    NSDate *date = [dateFormatter dateFromString:time];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *timeStr=[dateFormatter stringFromDate:date];
    return timeStr;
}

#pragma mark - Table view delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 15)];
    topLineView.backgroundColor = RGBACOLOR(238, 238, 245, 1);
    
    return topLineView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60.f;
    }
    LeaveMsgCommentModel *comment = [self.dataArray objectAtIndex:indexPath.row - 1];
    return [LeaveMsgCell tableView:tableView model:comment];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row > 0) {
        LeaveMsgCommentModel *comment = [self.dataArray objectAtIndex:indexPath.row - 1];
        if ([comment.attachments count] > 0) {
            NSMutableArray *images = [NSMutableArray array];
            for (LeaveMsgAttachmentModel *attachment in comment.attachments) {
                if ([attachment.type isEqualToString:@"image"]) {
                    [images addObject:[NSURL URLWithString:attachment.url]];
                }
            }
            NSMutableArray *imagesUrl = [NSMutableArray arrayWithCapacity:0];
            for (NSURL *url in images) {
                [imagesUrl addObject:url];
            }
            if ([images count] > 0) {
                [[HDMessageReadManager defaultManager] showBrowserWithImages:imagesUrl];
            }
        }
    }
}

#pragma mark - LeaveMsgCellDelegate

- (void)didSelectAudioAttachment:(LeaveMsgAttachmentModel *)attachment touchImage:(LeaveMsgAttatchmentView *)attatchmentView {
    _touchView = attatchmentView;
    kWeakSelf
    [[[HDClient sharedClient] leaveMsgManager] downloadFileWithUrl:attachment.url completionHander:^(BOOL success, NSURL *filePath, NSError *error) {
        if (!error) {
            NSString *toPath = [NSString stringWithFormat:@"%@/%d.wav",NSTemporaryDirectory(),123];
            BOOL success = [[HDCDDeviceManager new] convertAMR:[filePath path] toWAV:toPath];
            if (success) {
                [weakSelf playWithfilePath:toPath];
            }
        }else{
            NSLog(@"下载文件失败");
        }
    }];
}

- (void)playWithfilePath:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        [fm removeItemAtPath:path error:nil];
    }
    _audioPlayer = [SCAudioPlay sharedInstance];
    _audioPlayer.delegate = self;
    if (_audioPlayer.isPlaying) {
        [_audioPlayer stopSound];
    }
    [_audioPlayer playSoundWithData:data];
}

- (void)AVAudioPlayerBeiginPlay {
    if (_audioPlayer.attatchmentView != nil) {
        [_audioPlayer.attatchmentView stopAnimating];
    }
    _audioPlayer.attatchmentView = _touchView;
    [_touchView startAnimating];
}

- (void)AVAudioPlayerDidFinishPlay {
    [_touchView stopAnimating];
}

- (void)didSelectFileAttachment:(LeaveMsgAttachmentModel*)attachment
{

    NSString *textToShare = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"leaveMessage.leavemsg.attachment", @"Attachment"),attachment.name];
    NSURL *urlToShare = [NSURL URLWithString:attachment.url];
    NSArray *activityItems = @[textToShare, urlToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems
                                                                            applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

#pragma mark - private

- (void)loadLeaveMessageDetail
{
    [self.headerView setDetail:_responseObject];
    self.tableView.tableHeaderView = self.headerView;
//    [self.tableView layoutSubviews];
}

//请求所有回复
- (void)loadLeaveMessageAllComments
{
    __weak typeof(self) weakSelf = self;
    CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
    [[[HDClient sharedClient] leaveMsgManager]getLeaveMsgCommentsWithProjectId:lgM.projectId targetUser:lgM.cname ticketId:_ticketId page:0 pageSize:100 completion:^(id responseObject, NSError *error) {
        if (error == nil) {
            [weakSelf loadDataArray:responseObject];
        }
    }];
    
}

- (void)loadDataArray:(NSDictionary*)dic
{
    [self.dataArray removeAllObjects];
    if ([dic objectForKey:@"entities"]) {
        _temp = [NSDictionary dictionaryWithDictionary:dic];
        NSArray *entities = [dic objectForKey:@"entities"];
        for (NSDictionary *entity in entities) {
            LeaveMsgCommentModel *comment = [[LeaveMsgCommentModel alloc] initWithDictionary:entity];
            [self.dataArray addObject:comment];
        }
    }
    [self.tableView reloadData];
    [self scrollViewToBottom:YES];
}
//
#pragma mark - HDChatManagerDelegate

- (void)messagesDidReceive:(NSArray *)aMessages {
    for (HDMessage *message in aMessages) {
        NSDictionary *ext = [self _getSafeDictionary:message.ext];
        if ([ext objectForKey:@"weichat"] && [[ext objectForKey:@"weichat"] objectForKey:@"event"]) {
            NSDictionary *event = [[ext objectForKey:@"weichat"] objectForKey:@"event"];
            if ([event objectForKey:@"comment"]) {
                LeaveMsgBaseModelTicket *ticket = [[LeaveMsgBaseModelTicket alloc] initWithDictionary:[event objectForKey:@"ticket"]];
                if ([ticket.ticketId  isEqualToString:_ticketId]) {
                    [self loadLeaveMessageAllComments];
                }
            }
        }
    }
}


//
//- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
//{
//    for (EMMessage *message in offlineMessages) {
//        NSDictionary *ext = [self _getSafeDictionary:message.ext];
//        if ([ext objectForKey:@"weichat"] && [[ext objectForKey:@"weichat"] objectForKey:@"event"]) {
//            NSDictionary *event = [[ext objectForKey:@"weichat"] objectForKey:@"event"];
//            if ([event objectForKey:@"comment"]) {
//                LeaveMsgBaseModelTicket *ticket = [[LeaveMsgBaseModelTicket alloc] initWithDictionary:[event objectForKey:@"ticket"]];
//                if ([ticket.ticketId  isEqualToString:_ticketId] ) {
//                    [self loadLeaveMessageAllComments];
//                    break;
//                }
//            }
//        }
//    }
//}

- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:YES];
    }
}

#pragma mark - LeaseMsgReplyControllerDelegate

- (void)didSelectSendButtonWithParameters:(NSDictionary*)aParameters
{
    LeaveMsgDetailModel *model = [_headerView getMsgDetailModel];
    CSDemoAccountManager *lgM =[CSDemoAccountManager shareLoginManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    NSArray *atts = [aParameters valueForKey:@"attachments"];
    NSMutableArray *attachments = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in atts) {
        LeaveMsgAttachmentModel *model = [[LeaveMsgAttachmentModel alloc] initWithDictionary:dic];
        LeaveMsgAttachment *attachment = [LeaveMsgAttachment new];
        attachment.name = model.name;
        attachment.url = model.url;
        if ([model.type isEqualToString:@"image"]) {
            attachment.type = AttachmentTypeImage;
        } else if ([model.type isEqualToString:@"file"]) {
            attachment.type = AttachmentTypeFile;
        } else if ([model.type isEqualToString:@"audio"]){
            attachment.type = AttachmentTypeAudio;
        }
        [attachments addObject:attachment];
        
    }
    Creator *ctr=[Creator new];
    ctr.identity =  [HDClient sharedClient].currentUsername;
    ctr.name = model.comment.creator.name ? model.comment.creator.name:lgM.nickname;
    ctr.email = @"afanda@163.com";
    ctr.phone = @"110119120";
    ctr.qq = @"12345";
    ctr.companyName = @"环信";
    
    LeaveMsgRequestBody *body = [LeaveMsgRequestBody new];
    body.attachments = attachments;
    body.creator = ctr;
    body.content = [aParameters valueForKey:@"content"];
    
    parameters = [self getParametersWithRequestBody:body];
    
    LeaveMsgCommentModel *comment = [[LeaveMsgCommentModel alloc] initWithDictionary:parameters];
    __weak typeof(self) weakSelf = self;
    [[[HDClient sharedClient]leaveMsgManager] createLeaveMsgCommentWithProjectId:lgM.projectId targetUser:lgM.cname ticketId:_ticketId requestBody:body completion:^(id responseObject, NSError *error) {
        if (error == nil) {
            comment.updated_at = [responseObject objectForKey:@"updated_at"];
            comment.created_at = [responseObject objectForKey:@"created_at"];
            comment.ticketId = [responseObject objectForKey:@"id"];
            comment.version = [responseObject objectForKey:@"version"];
            [weakSelf.dataArray addObject:comment];
            [weakSelf.tableView reloadData];
            [weakSelf scrollViewToBottom:YES];
        } else {
            [self showHint:@"回复失败，请稍后再试"];
        }
    }];
    [self.navigationController popToViewController:self animated:YES];
}

- (NSMutableDictionary *)getParametersWithRequestBody:(LeaveMsgRequestBody *)body {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [mDic setValue:body.subject forKey:@"subject"];
    [mDic setValue:body.content forKey:@"content"];
    [mDic setValue:[self getJsonWithObject:body.creator] forKey:@"creator"];
    [mDic setValue:[self getJsonWithObject:body.attachments] forKey:@"attachments"];
    return mDic;
}

- (id )getJsonWithObject:(id)object {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    if ([object isKindOfClass:[Creator class]]) {
        Creator *creator = object;
        [dic setValue:creator.name forKey:@"name"];
        [dic setValue:creator.avatar forKey:@"avatar"];
        [dic setValue:creator.email forKey:@"email"];
        [dic setValue:creator.phone forKey:@"phone"];
        [dic setValue:creator.qq forKey:@"qq"];
        [dic setValue:creator.companyName forKey:@"company"];
        [dic setValue:creator.desc forKey:@"description"];
        [dic setValue:creator.identity forKey:@"id"];
        return dic;
    } else if ([object isKindOfClass:[NSArray class]]) {
        NSMutableArray *marr = [NSMutableArray arrayWithCapacity:0];
        for (LeaveMsgAttachment *attachment in object) {
            NSString *type = @"";
            if (attachment.type == AttachmentTypeImage) {
                type = @"image";
            } else if (attachment.type == AttachmentTypeAudio) {
                type = @"audio";
            } else if (attachment.type == AttachmentTypeFile) {
                type = @"file";
            }
            [marr addObject:@{
                              @"name":attachment.name,
                              @"url":attachment.url,
                              @"type":type
                              }];
        }
        [dic setValue:marr forKey:@"attachments"];
        return marr;
    }
    
    return nil;
}

- (NSMutableDictionary*)_getSafeDictionary:(NSDictionary*)dic
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:dic];
    if ([[userInfo allKeys] count] > 0) {
        for (NSString *key in [userInfo allKeys]){
            if ([userInfo objectForKey:key] == [NSNull null]) {
                [userInfo removeObjectForKey:key];
            } else {
                if ([[userInfo objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                    [userInfo setObject:[self _getSafeDictionary:[userInfo objectForKey:key]] forKey:key];
                }
            }
        }
    }
    return userInfo;
}

- (void)clearTempWav {
    NSString *path = [NSString stringWithFormat:@"%@/%d.wav",NSTemporaryDirectory(),123];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        [fm removeItemAtPath:path error:nil];
    }
}

- (void)_stopAudioPlayingWithChangeCategory
{
    //停止音频播放及播放动画
    if (_audioPlayer.isPlaying) {
        [_audioPlayer stopSound];
    }
    if (_audioPlayer.attatchmentView != nil) {
        [_audioPlayer.attatchmentView stopAnimating];
    }
}

@end
