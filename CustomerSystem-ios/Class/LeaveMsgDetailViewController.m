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
//#import "EMHttpManager.h"
//#import "MBProgressHUD+Add.h"
//#import "EMIMHelper.h"
#import "LeaveMsgCell.h"
#import "LeaveMsgDetailModel.h"
#import "EMCDDeviceManager+Media.h"
//#import "NSDate+Category.h"
//#import "EaseMob.h"
//#import "MessageReadManager.h"
//#import "SCNetworkManager.h"
#import "SCAudioPlay.h"
#import "LeaveMsgAttatchmentView.h"

@interface LeaveMsgDetailViewController () <UITableViewDelegate,UITableViewDataSource,LeaveMsgCellDelegate/*,EMChatManagerDelegate, LeaseMsgReplyControllerDelegate,SCAudioPlayDelegate*/>
{
    NSInteger _ticketId;
    NSDictionary *_temp;
}

@property (nonatomic, strong) LeaveMsgDetailHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) EMConversation *conversation;//会话管理者
@property (nonatomic, strong) NSDateFormatter *dateformatter;
@property (nonatomic, strong) UIButton *replyButton;

@end

@implementation LeaveMsgDetailViewController
{
    LeaveMsgAttatchmentView *_touchView;
}

- (instancetype)initWithTicketId:(NSInteger)ticketId chatter:(NSString*)chatter
{
    self = [super init];
    if (self) {
        _ticketId = ticketId;
//        _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:chatter conversationType:eConversationTypeChat];
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
//    [LeaseMsgReplyController resetFile];
    [self clearTempWav];
    self.title = NSLocalizedString(@"title.leavemsgdetail", @"Leave Message Detail");
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.replyButton];
    [self.view addSubview:self.tableView];
    
    [self setupBarButtonItem];
    [self loadLeaveMessageDetail];
    [self loadLeaveMessageAllComments];
    [self registNotification];
}

- (void)registNotification
{
    [self unregistNotification];
//    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unregistNotification
{
//    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)dealloc
{
    [self unregistNotification];
}

- (void)setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
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
        _replyButton.frame = CGRectMake(0, kScreenHeight - 50.f, kScreenWidth, 50.f);
        [_replyButton setTitle:NSLocalizedString(@"leaveMessage.leavemsg.reply", @"Reply") forState:UIControlStateNormal];
        [_replyButton setBackgroundColor:RGBACOLOR(242, 83, 131, 1)];
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
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
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
//    [NSDate formattedTimeFromTimeInterval:[[self.dateformatter dateFromString:comment.updated_at] timeIntervalSince1970]];
    return cell;
}


- (NSString *)dateformatWithTimeStr:(NSString *)time {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSDate *date = [dateFormatter dateFromString:time];
    [dateFormatter setDateFormat:@"MM月DD日HH:MM"];
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
//    if (indexPath.row > 0) {
//        LeaveMsgCommentModel *comment = [self.dataArray objectAtIndex:indexPath.row - 1];
//        if ([comment.attachments count] > 0) {
//            NSMutableArray *images = [NSMutableArray array];
//            for (LeaveMsgAttachmentModel *attachment in comment.attachments) {
//                if ([attachment.type isEqualToString:@"image"]) {
//                    [images addObject:[NSURL URLWithString:attachment.url]];
//                }
//            }
//            if ([images count] > 0) {
//                [[MessageReadManager defaultManager] showBrowserWithImages:images];
//            }
//        }
//    }
}

#pragma mark - LeaveMsgCellDelegate

- (void)didSelectAudioAttachment:(LeaveMsgAttachmentModel *)attachment touchImage:(LeaveMsgAttatchmentView *)attatchmentView {
    _touchView = attatchmentView;
    HNetworkManager *manager = [HNetworkManager shareInstance];
    kWeakSelf
    [manager downloadFileWithUrl:attachment.url completionHander:^(BOOL success, NSURL *filePath, NSError *error) {
        if (!error) {
            NSString *toPath = [NSString stringWithFormat:@"%@/%d.wav",NSTemporaryDirectory(),123];
            BOOL success = [[EMCDDeviceManager new] convertAMR:[filePath path] toWAV:toPath];
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
    SCAudioPlay *play = [SCAudioPlay sharedInstance];
    play.delegate = self;
    if (play.isPlaying) {
        [play stopSound];
    }
    [play playSoundWithData:data];
}

- (void)AVAudioPlayerBeiginPlay {
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
//    MBProgressHUD *hud = [MBProgressHUD showMessag:NSLocalizedString(@"leaveMessage.leavemsg.load", "Loading...") toView:self.view];
//    hud.layer.zPosition = 1.f;
//    __weak MBProgressHUD *weakHud = hud;
    __weak typeof(self) weakSelf = self;
    SCLoginManager *lgM = [SCLoginManager shareLoginManager];
    [[HNetworkManager shareInstance] asyncGetLeaveMessageDetailWithTenantId:lgM.tenantId projectId:lgM.projectId ticketId:_ticketId parameters:nil completion:^(id responseObject, NSError *error) {
        if (error == nil) {
            [weakSelf.headerView setDetail:responseObject];
            weakSelf.tableView.tableHeaderView = weakSelf.headerView;
            [weakSelf.tableView layoutSubviews];
//            [weakHud setLabelText:NSLocalizedString(@"leaveMessage.leavemsg.loadsucceed", "Load succeed")];
//            [weakHud hide:YES afterDelay:0.5];
        } else {
            NSLog(@"请求出错哦~");
//            [weakHud setLabelText:NSLocalizedString(@"leaveMessage.leavemsg.loadfailed", "Load failed")];
//            [weakHud hide:YES afterDelay:0.5];
        }
        
    }];
}

//请求所有回复
- (void)loadLeaveMessageAllComments
{
    __weak typeof(self) weakSelf = self;
    SCLoginManager *lgM = [SCLoginManager shareLoginManager];
    [[HNetworkManager shareInstance] asyncGetLeaveMessageAllCommentsWithTenantId:lgM.tenantId projectId:lgM.projectId ticketId:_ticketId parameters:@{@"size":@(10000)} completion:^(id responseObject, NSError *error) {
        if (error == nil) {
            [weakSelf loadDataArray:responseObject];
        } else {
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
#pragma mark - EMChatManagerDelegate
- (void)didReceiveMessage:(EMMessage *)message
{
    NSDictionary *ext = [self _getSafeDictionary:message.ext];
    if ([ext objectForKey:@"weichat"] && [[ext objectForKey:@"weichat"] objectForKey:@"event"]) {
        NSDictionary *event = [[ext objectForKey:@"weichat"] objectForKey:@"event"];
        if ([event objectForKey:@"comment"]) {
            LeaveMsgBaseModelTicket *ticket = [[LeaveMsgBaseModelTicket alloc] initWithDictionary:[event objectForKey:@"ticket"]];
            if (ticket.ticketId  == _ticketId) {
                [self loadLeaveMessageAllComments];
            }
        }
    }
}
//
- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    for (EMMessage *message in offlineMessages) {
        NSDictionary *ext = [self _getSafeDictionary:message.ext];
        if ([ext objectForKey:@"weichat"] && [[ext objectForKey:@"weichat"] objectForKey:@"event"]) {
            NSDictionary *event = [[ext objectForKey:@"weichat"] objectForKey:@"event"];
            if ([event objectForKey:@"comment"]) {
                LeaveMsgBaseModelTicket *ticket = [[LeaveMsgBaseModelTicket alloc] initWithDictionary:[event objectForKey:@"ticket"]];
                if (ticket.ticketId == _ticketId) {
                    [self loadLeaveMessageAllComments];
                    break;
                }
            }
        }
    }
}

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
    /*
     {
     subject: "评论的主题, 可选",
     content: "评论的内容",
     reply : {
     id: "回复的哪条评论的id, 可选"
     },
     creator: {
     id: "创建这个评论的人的id", //可选
     username: "创建这个comment的人的username",
     name: "创建这个comment的人的name",
     avatar: "创建这个comment的人的头像",
     type: "创建这个comment的人的类型, 例如是坐席还是访客"
     email: "电子邮件地址",
     phone: "电话号码",
     qq: "qq号码",
     company: "公司",
     description: "具体的描述信息"
     },
     attachments:[{
     name: "该附件的名称",
     url: "该附件的url",
     type: "附件的类型, 当前支持image和file"
     }],
     status_id: "status 的id" //设置了这个属性的话, 可以在添加评论的时候同时设置这个ticket的状态, 只有agent能够调用
     }
     */
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:aParameters];
    //creator
    NSMutableDictionary *creator = [NSMutableDictionary dictionary];
    
    SCLoginManager *lgM =[SCLoginManager shareLoginManager];
    
    LeaveMsgDetailModel *model = [_headerView getMsgDetailModel];
    if (model.comment.creator.name) {
        [creator setObject:model.comment.creator.name forKey:@"name"];
    } else {
        [creator setObject:lgM.nickname forKey:@"name"];
    }
    [creator setObject:lgM.nickname forKey:@"username"];
    [creator setObject:@"" forKey:@"avatar"];
    [creator setObject:@"afan@163.com" forKey:@"email"];
    [creator setObject:@"110" forKey:@"phone"];
    [creator setObject:@"12580" forKey:@"qq"];
    [creator setObject:@"中国·北京" forKey:@"company"];
    [creator setObject:@"" forKey:@"description"];
    [creator setObject:@"VISITOR" forKey:@"type"];
    [parameters setObject:creator forKey:@"creator"];
    
    LeaveMsgCommentModel *comment = [[LeaveMsgCommentModel alloc] initWithDictionary:parameters];
    
    __weak typeof(self) weakSelf = self;
    
    [[HNetworkManager shareInstance] asyncLeaveAMessageWithTenantId:lgM.tenantId projectId:lgM.projectId ticketId:_ticketId parameters:parameters completion:^(id responseObject, NSError *error) {
        if (!error) {
            comment.updated_at = [responseObject objectForKey:@"updated_at"];
            comment.created_at = [responseObject objectForKey:@"created_at"];
            comment.ticketId = [[responseObject objectForKey:@"id"] integerValue];
            comment.version = [responseObject objectForKey:@"version"];
            [weakSelf.dataArray addObject:comment];
            [weakSelf.tableView reloadData];
            [weakSelf scrollViewToBottom:YES];
        }
    }];
    
    [self.navigationController popToViewController:self animated:YES];
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

@end
