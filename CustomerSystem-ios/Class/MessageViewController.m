//
//  MessageViewController.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 16/6/30.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "MessageViewController.h"
#import "LeaveMsgDetailModel.h"
#import "LeaveMsgCell.h"
#import "LeaveMessageCell.h"
#import "LeaveMsgDetailViewController.h"

@interface MessageViewController () <UITableViewDelegate,UITableViewDataSource,HDChatManagerDelegate,SRRefreshDelegate>
{
    NSInteger   _page;
    NSInteger   _pageSize;
    BOOL        _hasMore;
    NSObject    *_refreshLock;
    BOOL        _isRefreshing;
    UIView *_view;
    UILabel *_hintLabel;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) SRRefreshView *slimeView;
@property (nonatomic, strong) NSDateFormatter *dateformatter;

@end

@implementation MessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"title.messagebox", @"Message Box");
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.tableView addSubview:self.slimeView];
    
    _view = [[UIView alloc] init];
    _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 140)/2, 10, 140, 50)];
    _hintLabel.textAlignment = NSTextAlignmentCenter;
    _hintLabel.font = [UIFont systemFontOfSize:15];
//    _hintLabel.text = NSLocalizedString(@"no_more", @"NO More");
    [_view addSubview:_hintLabel];
    self.tableView.tableFooterView = _view;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = RGBACOLOR(238, 238, 245, 1);
    
    _pageSize = 10;
    _refreshLock = [[NSObject alloc] init];
    [self slimeRefreshStartRefresh:_slimeView];
    [self reloadLeaveMsgList];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLeaveMsgList) name:KNOTIFICATION_ADDMSG_TO_LIST object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadLeaveMsgList];
    [self registNotification];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregistNotification];
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
    
    self.slimeView.delegate = nil;
    self.slimeView = nil;
    
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - getter

- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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

- (NSDateFormatter*)dateformatter
{
    if (_dateformatter == nil) {
        _dateformatter = [[NSDateFormatter alloc] init];
        [_dateformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        [_dateformatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    }
    return _dateformatter;
}


#pragma mark - HDChatManagerDelegate

- (void)messagesDidReceive:(NSArray *)aMessages {
    for (HDMessage *message in aMessages) {
        NSDictionary *ext = [self _getSafeDictionary:message.ext];
        if ([ext objectForKey:@"weichat"] && [[ext objectForKey:@"weichat"] objectForKey:@"notification"]) {
            LeaveMsgBaseModelTicket *ticket = [[LeaveMsgBaseModelTicket alloc] initWithDictionary:[[[ext objectForKey:@"weichat"] objectForKey:@"event"] objectForKey:@"ticket"]];
            
            for (LeaveMsgCommentModel *comment in _dataArray) {
                if (comment.ticketId == ticket.ticketId) {
                    [self.tableView reloadData];
                    return;
                }
            }
            
            [self reloadLeaveMsgList];
        }
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
    _page = 0;
    __weak typeof(self) weakSelf = self;
    [self loadAndRefreshDataWithCompletion:^(BOOL success) {
        if ([_slimeView loading]) {
            [weakSelf.slimeView endRefresh];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_hasMore) {
        if (section == 0) {
            return [self.dataArray count];
        } else {
            return 1;
        }
    }
    return [self.dataArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_hasMore) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"LeaveMessage";
    if (indexPath.section == 0) {
        LeaveMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[LeaveMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        cell.leaveMessageModel = [self.dataArray objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loadMoreCell"];
    }
    
    cell.textLabel.text = NSLocalizedString(@"load_more", @"Click to load more");
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        LeaveMsgCommentModel *comment = [self.dataArray objectAtIndex:indexPath.row];
        [self loadLeaveMessageDetailWithTicketId:comment.ticketId];
//        LeaveMsgDetailViewController *leaveMsgDetail = [[LeaveMsgDetailViewController alloc] initWithTicketId:comment.ticketId chatter:nil];
//        [self.navigationController pushViewController:leaveMsgDetail animated:YES];
    } else {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.userInteractionEnabled = NO;
        [self loadAndRefreshDataWithCompletion:^(BOOL success) {
            cell.userInteractionEnabled = YES;
        }];
    }
}

- (void)loadLeaveMessageDetailWithTicketId:(NSString *)ticketId
{
    __weak typeof(self) weakSelf = self;
    CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
    [[[HDClient sharedClient]leaveMsgManager] getLeaveMsgDetailWithProjectId:lgM.projectId targetUser:lgM.cname ticketId:ticketId completion:^(id responseObject, NSError *error) {
        if (error == nil) {
            LeaveMsgDetailViewController *leaveMsgDetail = [[LeaveMsgDetailViewController alloc] initWithResponseObject:responseObject ticketId:ticketId];
            [weakSelf.navigationController pushViewController:leaveMsgDetail animated:YES];
        } else {
            NSLog(@"请求出错哦~");
        }
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [LeaveMsgCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

#pragma mark - private
- (void)loadAndRefreshDataWithCompletion:(void (^)(BOOL success))completion
{
    @synchronized (self) {
        if (_isRefreshing) {
            return;
        }
        _isRefreshing = YES;
    }
//    NSDictionary *parameters = @{@"size":@(_pageSize),@"page":@(_page),@"sort":@"updatedAt,desc"};
    __weak typeof(self) weakSelf = self;
    CSDemoAccountManager *lgm = [CSDemoAccountManager shareLoginManager];
    [[[HDClient sharedClient]leaveMsgManager] getLeaveMsgsWithProjectId:lgm.projectId targetUser:lgm.cname page:_page pageSize:_pageSize completion:^(id responseObject, NSError *error) {
        if (!error) { //请求成功
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                if (_page == 0) {
                    
                    [weakSelf.dataArray removeAllObjects];
                }
                _page ++ ;
                if ([responseObject objectForKey:@"entities"]) {
                    NSArray *array = [responseObject objectForKey:@"entities"];
                    for (NSDictionary *entity in array) {
                        LeaveMsgCommentModel *comment = [[LeaveMsgCommentModel alloc] initWithDictionary:entity];
                        [weakSelf.dataArray addObject:comment];
                    }
                    
                    if ([array count] == _pageSize) {
                        _hasMore = YES;
                    } else {
                        _hasMore = NO;
                    }
                }
                [weakSelf.tableView reloadData];
            }
            if (completion) {
                completion(YES);
            }
        } else { //失败
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.tableView reloadData];
            
            if (completion) {
                completion(NO);
                
                
            }
        }
        _isRefreshing = NO;
        
        if ([weakSelf.dataArray count] == 0) {
            _hintLabel.text = NSLocalizedString(@"no_leave_message", @"NO Leave Message");
            
        } else {
            _hintLabel.text = NSLocalizedString(@"no_more", @"NO More");
        }
    }];
    
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

#pragma mark - public 

- (void)reloadLeaveMsgList
{
    _page = 0;
    [self loadAndRefreshDataWithCompletion:nil];
}

#pragma mark - notification

- (void)addMsgToList:(NSNotification*)notify
{
//    if (notify.object && [notify.object isKindOfClass:[NSDictionary class]]) {
//        LeaveMsgCommentModel *comment = [[LeaveMsgCommentModel alloc] initWithDictionary:notify.object];
//        [self.dataArray insertObject:comment atIndex:0];
//        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
//        _pageSize++;
//    }
}

@end
