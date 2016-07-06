//
//  LeaveMsgDetailViewController.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 16/6/30.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "LeaveMsgDetailViewController.h"

#import "LeaveMsgDetailHeaderView.h"
#import "EMHttpManager.h"
#import "MBProgressHUD+Add.h"
#import "EMIMHelper.h"
#import "LeaveMsgCell.h"
#import "LeaveMsgDetailModel.h"
#import "NSDate+Category.h"
#import "EaseMob.h"
#import "DXMessageToolBar.h"
#import "MessageReadManager.h"

@interface LeaveMsgDetailViewController () <UITableViewDelegate,UITableViewDataSource,EMChatManagerDelegate,DXMessageToolBarDelegate>
{
    NSString *_ticketId;
    NSDictionary *_temp;
}

@property (nonatomic, strong) LeaveMsgDetailHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DXMessageToolBar *chatToolBar;

@property (nonatomic, strong) EMConversation *conversation;//会话管理者
@property (nonatomic, strong) NSDateFormatter *dateformatter;

@end

@implementation LeaveMsgDetailViewController

- (instancetype)initWithTicketId:(NSString *)ticketId chatter:(NSString*)chatter
{
    self = [super init];
    if (self) {
        _ticketId = ticketId;
        _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:chatter conversationType:eConversationTypeChat];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"title.leavemsgdetail", @"Leave Message Detail");
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.chatToolBar];
    [_chatToolBar setLeaveMsgButtonHidden];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)];
    [self.headerView addGestureRecognizer:tap];
    
    [self setupBarButtonItem];
    [self loadLeaveMessageDetail];
    [self loadLeaveMessageAllComments];
    [self registNotification];
}

- (void)registNotification
{
    [self unregistNotification];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unregistNotification
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)dealloc
{
    [self unregistNotification];
}

- (void)setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
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

- (DXMessageToolBar *)chatToolBar
{
    if (_chatToolBar == nil) {
        _chatToolBar = [[DXMessageToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [DXMessageToolBar defaultHeight], self.view.frame.size.width, [DXMessageToolBar defaultHeight])];
        _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _chatToolBar.delegate = self;
    }
    return _chatToolBar;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.chatToolBar.frame.size.height) style:UITableViewStylePlain];
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

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - GestureRecognizer

// 点击背景隐藏
-(void)keyBoardHidden
{
    [self.chatToolBar endEditing:YES];
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
    static NSString *identify = @"MessageListCell";
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleCell"];
            CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, height - 1, kScreenWidth, 1)];
            lineView.backgroundColor = RGBACOLOR(207, 210, 213, 0.7);
            [cell.contentView addSubview:lineView];
        }
        cell.textLabel.text = NSLocalizedString(@"leaveMessage.leavemsg.comment", @"comment");
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    LeaveMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[LeaveMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    LeaveMsgCommentModel *comment = [self.dataArray objectAtIndex:indexPath.row - 1];
    cell.name = comment.creator.name;
    cell.placeholderImage = [UIImage imageNamed:@"customer"];
    if (comment.attachments) {
        cell.detailMsg = [NSString stringWithFormat:@"%@-[%@]",comment.content,NSLocalizedString(@"leaveMessage.leavemsg.attachment", @"Attachment")];
    } else {
        cell.detailMsg = comment.content;
    }
    cell.time = [NSDate formattedTimeFromTimeInterval:[[self.dateformatter dateFromString:comment.updated_at] timeIntervalSince1970]];
    return cell;
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
    return [LeaveMsgCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self keyBoardHidden];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row > 1) {
        LeaveMsgCommentModel *comment = [self.dataArray objectAtIndex:indexPath.row - 1];
        if ([comment.attachments count] > 0) {
            NSMutableArray *images = [NSMutableArray array];
            for (LeaveMsgAttachmentModel *attachment in comment.attachments) {
                if ([attachment.type isEqualToString:@"image"]) {
                    [images addObject:[NSURL URLWithString:attachment.url]];
                }
            }
            if ([images count] > 0) {
                [[MessageReadManager defaultManager] showBrowserWithImages:images];
            }
        }
    }
}

#pragma mark - private

- (void)loadLeaveMessageDetail
{
    MBProgressHUD *hud = [MBProgressHUD showMessag:NSLocalizedString(@"leaveMessage.leavemsg.load", "Loading...") toView:self.view];
    hud.layer.zPosition = 1.f;
    __weak MBProgressHUD *weakHud = hud;
    __weak typeof(self) weakSelf = self;
    [[EMHttpManager sharedInstance] asyncGetLeaveMessageDetailWithTenantId:[EMIMHelper defaultHelper].tenantId
                                                                 projectId:[EMIMHelper defaultHelper].projectId
                                                                  ticketId:_ticketId
                                                                parameters:nil
                                                                completion:^(id responseObject, NSError *error) {
                                                                    if (error == nil) {
                                                                        [weakSelf.headerView setDetail:responseObject];
                                                                        [weakHud setLabelText:NSLocalizedString(@"leaveMessage.leavemsg.loadsucceed", "Load succeed")];
                                                                        [weakHud hide:YES afterDelay:0.5];
                                                                    } else {
                                                                        [weakHud setLabelText:NSLocalizedString(@"leaveMessage.leavemsg.loadfailed", "Load failed")];
                                                                        [weakHud hide:YES afterDelay:0.5];
                                                                    }
                                                                }];
}

- (void)loadLeaveMessageAllComments
{
    [_conversation markAllMessagesAsRead:YES];
    __weak typeof(self) weakSelf = self;
    [[EMHttpManager sharedInstance] asyncGetLeaveMessageAllCommentsWithTenantId:[EMIMHelper defaultHelper].tenantId
                                                                      projectId:[EMIMHelper defaultHelper].projectId
                                                                       ticketId:_ticketId
                                                                     parameters:@{@"size":@(10000)}
                                                                     completion:^(id responseObject, NSError *error) {
                                                                         if (error == nil) {
                                                                             [weakSelf reloadDataArray:responseObject];
                                                                         } else {
                                                                         }
                                                                     }];
}

- (void)reloadDataArray:(NSDictionary*)dic
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
}

#pragma mark - EMChatManagerDelegate
- (void)didReceiveMessage:(EMMessage *)message
{
    [_conversation markMessageWithId:message.messageId asRead:YES];
    if ([_conversation.chatter isEqualToString:message.conversationChatter]) {
        if ([message.ext objectForKey:@"weichat"] && [[message.ext objectForKey:@"weichat"] objectForKey:@"event"]) {
            LeaveMsgCommentModel *comment = [[LeaveMsgCommentModel alloc] initWithDictionary:[[[message.ext objectForKey:@"weichat"] objectForKey:@"event"] objectForKey:@"comment"]];
            comment.content = ((EMTextMessageBody*)[message.messageBodies objectAtIndex:0]).text;
            [self.dataArray addObject:comment];
            [self.tableView reloadData];
            [self scrollViewToBottom:YES];
        }
    }
}

#pragma mark - DXMessageToolBarDelegate

- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView
{
    
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
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //[parameters setObject:@"" forKey:@"subject"];
    [parameters setObject:text forKey:@"content"];
    //[parameters setObject:@"" forKey:@"status_id"];
    
    //reply
    NSMutableDictionary *reply = [NSMutableDictionary dictionary];
    //[reply setObject:@"159545" forKey:@"id"];
    //[parameters setObject:reply forKey:@"reply"];
    
    //creator
    NSMutableDictionary *creator = [NSMutableDictionary dictionary];
    
    [creator setObject:[[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:@"username"] forKey:@"name"];
    [creator setObject:[[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:@"username"] forKey:@"username"];
    [creator setObject:@"" forKey:@"avatar"];
    [creator setObject:@"" forKey:@"email"];
    [creator setObject:@"" forKey:@"phone"];
    [creator setObject:@"" forKey:@"qq"];
    [creator setObject:@"" forKey:@"company"];
    [creator setObject:@"" forKey:@"description"];
    [creator setObject:@"VISITOR" forKey:@"type"];
    [parameters setObject:creator forKey:@"creator"];
    
    //attachments
    NSMutableArray *attachments = [NSMutableArray array];
    [parameters setObject:attachments forKey:@"attachments"];
    
    LeaveMsgCommentModel *comment = [[LeaveMsgCommentModel alloc] initWithDictionary:parameters];
    
    if (text && text.length > 0) {
        __weak typeof(self) weakSelf = self;
        [[EMHttpManager sharedInstance] asyncLeaveAMessageWithTenantId:[EMIMHelper defaultHelper].tenantId
                                                             projectId:[EMIMHelper defaultHelper].projectId
                                                              ticketId:_ticketId
                                                            parameters:parameters
                                                            completion:^(id responseObject, NSError *error) {
                                                                if (!error) {
                                                                    comment.updated_at = [responseObject objectForKey:@"updated_at"];
                                                                    comment.created_at = [responseObject objectForKey:@"created_at"];
                                                                    comment.ticketId = [responseObject objectForKey:@"id"];
                                                                    comment.version = [responseObject objectForKey:@"version"];
                                                                    [weakSelf.dataArray addObject:comment];
                                                                    [weakSelf.tableView reloadData];
                                                                    [weakSelf scrollViewToBottom:YES];
                                                                }
                                                            }];
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

@end
