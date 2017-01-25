//
//  LeaveMsgDetailModel.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 16/7/1.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "LeaveMsgDetailModel.h"

@implementation LeaveMsgBaseModel

- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        [self updateModel:dictionary];
    }
    return self;
}

- (void)updateModel:(NSDictionary*)dictionary
{

}

-(NSDictionary*)getContent
{
    return [NSDictionary dictionary];
}

@end

@implementation LeaveMsgDetailModel

- (void)updateModel:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"assignee"]) {
        _assignee = [[LeaveMsgAssigneeModel alloc] initWithDictionary:[dictionary objectForKey:@"assignee"]];
    }
    
    if ([dictionary objectForKey:@"status"]) {
        _status = [[LeaveMsgStatusModel alloc] initWithDictionary:[dictionary objectForKey:@"status"]];
    }
    
    if (dictionary) {
        _comment = [[LeaveMsgCommentModel alloc] initWithDictionary:dictionary];
    }
}

@end

@implementation LeaveMsgCreatorModel

- (void)updateModel:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"company"]) {
        _company = [dictionary objectForKey:@"company"];
    }
    
    if ([dictionary objectForKey:@"description"]) {
        _creatorDescription = [dictionary objectForKey:@"description"];
    }
    
    if ([dictionary objectForKey:@"email"]) {
        _email = [dictionary objectForKey:@"email"];
    }
    
    if ([dictionary objectForKey:@"id"]) {
        _creatorId = [dictionary objectForKey:@"id"];
    }
    
    if ([dictionary objectForKey:@"name"]) {
        _name = [dictionary objectForKey:@"name"];
    }
    
    if ([dictionary objectForKey:@"phone"]) {
        _phone = [dictionary objectForKey:@"phone"];
    }
    
    if ([dictionary objectForKey:@"qq"]) {
        _qq = [dictionary objectForKey:@"qq"];
    }
    
    if ([dictionary objectForKey:@"type"]) {
        _type = [dictionary objectForKey:@"type"];
    }
    
    if ([dictionary objectForKey:@"username"]) {
        _username = [dictionary objectForKey:@"username"];
    }
}

@end

@implementation LeaveMsgAssigneeModel

- (void)updateModel:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"avatar"]) {
        _avatar = [dictionary objectForKey:@"avatar"];
    }
    
    if ([dictionary objectForKey:@"id"]) {
        _assigneeId = [dictionary objectForKey:@"id"];
    }
    
    if ([dictionary objectForKey:@"name"]) {
        _name = [dictionary objectForKey:@"name"];
    }
    
    if ([dictionary objectForKey:@"phone"]) {
        _phone = [dictionary objectForKey:@"phone"];
    }
    
    if ([dictionary objectForKey:@"username"]) {
        _username = [dictionary objectForKey:@"username"];
    }
}

@end

@implementation LeaveMsgStatusModel

- (void)updateModel:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"id"]) {
        _statusId = [dictionary objectForKey:@"id"];
    }
    
    if ([dictionary objectForKey:@"name"]) {
        _name = [dictionary objectForKey:@"name"];
    }
    
    if ([dictionary objectForKey:@"version"]) {
        _version = [dictionary objectForKey:@"version"];
    }
}

@end

@implementation LeaveMsgCommentModel

- (void)updateModel:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"id"]) {
        _ticketId = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"id"]];
    }
    
    if ([dictionary objectForKey:@"content"]) {
        _content = [dictionary objectForKey:@"content"];
    }
    
    if ([dictionary objectForKey:@"created_at"]) {
        _created_at = [dictionary objectForKey:@"created_at"];
    }
    
    if ([dictionary objectForKey:@"updated_at"]) {
        _updated_at = [dictionary objectForKey:@"updated_at"];
    }
    
    if ([dictionary objectForKey:@"version"]) {
        _version = [dictionary objectForKey:@"version"];
    }
    
    if ([dictionary objectForKey:@"subject"]) {
        _subject = [dictionary objectForKey:@"subject"];
    }
    
    if ([dictionary objectForKey:@"creator"]) {
        _creator = [[LeaveMsgCreatorModel alloc] initWithDictionary:[dictionary objectForKey:@"creator"]];
    }
    
    if ([dictionary objectForKey:@"attachments"] && [[dictionary objectForKey:@"attachments"] isKindOfClass:[NSArray class]]) {
        if ([[dictionary objectForKey:@"attachments"] count] > 0) {
            if (_attachments == nil) {
                _attachments = [NSMutableArray array];
            } else {
                [_attachments removeAllObjects];
            }
            for (NSDictionary *dic in [dictionary objectForKey:@"attachments"]) {
                LeaveMsgAttachmentModel *attachment = [[LeaveMsgAttachmentModel alloc] initWithDictionary:dic];
                [_attachments addObject:attachment];
            }
        }
    }
}

@end

@implementation LeaveMsgAttachmentModel

- (void)updateModel:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"name"]) {
        _name = [dictionary objectForKey:@"name"];
    }
    
    if ([dictionary objectForKey:@"url"]) {
        _url = [dictionary objectForKey:@"url"];
    }
    
    if ([dictionary objectForKey:@"type"]) {
        _type = [dictionary objectForKey:@"type"];
    }
}

-(NSDictionary*)getContent
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if (_name.length > 0) {
        [dictionary setObject:_name forKey:@"name"];
    }
    
    if (_url.length > 0) {
        [dictionary setObject:_url forKey:@"url"];
    }
    
    if (_type.length > 0) {
        [dictionary setObject:_type forKey:@"type"];
    }
    
    return dictionary;
}

@end

@implementation LeaveMsgBaseModelTicket

- (void)updateModel:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"id"]) {
        _ticketId = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"id"]];
    }
    
    if ([dictionary objectForKey:@"content"]) {
        _content = [dictionary objectForKey:@"content"];
    }
    
    if ([dictionary objectForKey:@"created_at"]) {
        _created_at = [dictionary objectForKey:@"created_at"];
    }
    
    if ([dictionary objectForKey:@"updated_at"]) {
        _updated_at = [dictionary objectForKey:@"updated_at"];
    }
    
    if ([dictionary objectForKey:@"version"]) {
        _version = [dictionary objectForKey:@"version"];
    }
    
    if ([dictionary objectForKey:@"subject"]) {
        _subject = [dictionary objectForKey:@"subject"];
    }
}

@end
