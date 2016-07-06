//
//  MessageViewController.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 16/6/30.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "MessageViewController.h"

#import "EaseMob.h"
#import "SRRefreshView.h"
#import "ChatViewController.h"
#import "LeaveMsgCell.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "NSDate+Category.h"
#import "LeaveMsgDetailViewController.h"
#import "LeaveMsgDetailModel.h"

@interface MessageViewController () <UITableViewDelegate,UITableViewDataSource,EMChatManagerDelegate,SRRefreshDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) SRRefreshView *slimeView;

@end

@implementation MessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"title.messagebox", @"Message Box");
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView addSubview:self.slimeView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = RGBACOLOR(238, 238, 245, 1);
    
    [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadAndRefreshData];
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
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unregistNotification
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)dealloc
{
    [self unregistNotification];
    
    self.slimeView.delegate = nil;
    self.slimeView = nil;
    
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
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

#pragma mark - IChatMangerDelegate

-(void)didUnreadMessagesCountChanged
{
    [self loadAndRefreshData];
}

- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error
{
    [self loadAndRefreshData];
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
    [self loadAndRefreshData];
    [_slimeView endRefresh];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"MessageListCell";
    LeaveMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[LeaveMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    EMConversation *conversation = [self.dataArray objectAtIndex:indexPath.row];
    cell.name = conversation.chatter;
    cell.detailMsg = [self subTitleMessageByConversation:conversation];
    cell.time = [self lastMessageTimeByConversation:conversation];
    cell.unreadCount = [self unreadMessageCountByConversation:conversation];
    if ([self isLeaveMsgCell:conversation.latestMessage]) {
        cell.name = [NSString stringWithFormat:@"ID: %@",[self getTicketIdWithMessage:conversation.latestMessage]];
        cell.placeholderImage = [UIImage imageNamed:@"message_comment"];
        cell.imageView.backgroundColor = RGBACOLOR(242, 83, 131, 1);
    } else {
        cell.placeholderImage = [UIImage imageNamed:@"message_avatar"];
        cell.imageView.backgroundColor = RGBACOLOR(212, 200, 204, 1);
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EMConversation *conversation = [self.dataArray objectAtIndex:indexPath.row];
    if ([self isLeaveMsgCell:conversation.latestMessage]) {
        LeaveMsgDetailViewController *leaveMsgDetail = [[LeaveMsgDetailViewController alloc] initWithTicketId:[self getTicketIdWithMessage:conversation.latestMessage] chatter:conversation.chatter];
        [self.navigationController pushViewController:leaveMsgDetail animated:YES];
    } else {
        ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:conversation.chatter type:eSaleTypeNone];
        chatController.title = @"演示客服";
        [self.navigationController pushViewController:chatController animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [LeaveMsgCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EMConversation *conversation = [self.dataArray objectAtIndex:indexPath.row];
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:conversation.chatter deleteMessages:YES append2Chat:YES];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - private

- (void)loadAndRefreshData
{
    NSMutableArray *ret = nil;
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    
    NSArray* sorted = [conversations sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          EMMessage *message2 = [obj2 latestMessage];
                          if(message1.timestamp > message2.timestamp) {
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                      }];
    
    ret = [[NSMutableArray alloc] initWithArray:sorted];
    [self.dataArray removeAllObjects];
    for (EMConversation *conversation in ret) {
        EMMessage *message = conversation.latestMessage;
        if ([message.ext objectForKey:@"weichat"] && [[message.ext objectForKey:@"weichat"] objectForKey:@"notification"]) {
        } else {
            [self.dataArray addObject:conversation];
        }
    }
    
    [self.tableView reloadData];
}

// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    return ret;
}

// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    return  ret;
}

// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                ret = didReceiveText;
            } break;
            case eMessageBodyType_Voice:{
                ret = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case eMessageBodyType_Location: {
                ret = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case eMessageBodyType_Video: {
                ret = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            default: {
            } break;
        }
    }
    return ret;
}

- (NSString*)getTicketIdWithMessage:(EMMessage*)message
{
    NSDictionary *ext = [self _getSafeDictionary:message.ext];
    if (ext) {
        if ([ext objectForKey:@"weichat"]) {
            if ([[ext objectForKey:@"weichat"] objectForKey:@"event"]) {
                if ([[[ext objectForKey:@"weichat"] objectForKey:@"event"] objectForKey:@"ticket"]) {
                    return [[[[ext objectForKey:@"weichat"] objectForKey:@"event"] objectForKey:@"ticket"] objectForKey:@"id"];
                }
            }
        }
    }
    return @"";
}

- (BOOL)isLeaveMsgCell:(EMMessage*)message
{
    NSDictionary *ext = [self _getSafeDictionary:message.ext];
    if (ext) {
        if ([ext objectForKey:@"weichat"]) {
            if ([[ext objectForKey:@"weichat"] objectForKey:@"event"]) {
                if ([[[ext objectForKey:@"weichat"] objectForKey:@"event"] objectForKey:@"eventName"]) {
                    if ([[[[ext objectForKey:@"weichat"] objectForKey:@"event"] objectForKey:@"eventName"] isEqualToString:@"CommentCreatedEvent"]) {
                        return YES;
                    }
                }
            }
        }
    }
    return NO;
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

@end
