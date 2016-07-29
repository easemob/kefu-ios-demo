//
//  LeaveMsgDetailModel.h
//  CustomerSystem-ios
//
//  Created by EaseMob on 16/7/1.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeaveMsgBaseModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

- (NSDictionary*)getContent;

@end

@class LeaveMsgCreatorModel;
@class LeaveMsgAssigneeModel;
@class LeaveMsgStatusModel;
@class LeaveMsgCommentModel;
@class LeaveMsgBaseModelTicket;
@interface LeaveMsgDetailModel : LeaveMsgBaseModel

@property (nonatomic, strong) LeaveMsgCommentModel *comment;
@property (nonatomic, strong) LeaveMsgAssigneeModel *assignee;
@property (nonatomic, strong) LeaveMsgStatusModel *status;

@end

@interface LeaveMsgCreatorModel : LeaveMsgBaseModel

@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *creatorDescription;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *creatorId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *qq;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *username;

@end

@interface LeaveMsgAssigneeModel : LeaveMsgBaseModel

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *assigneeId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *username;

@end

@interface LeaveMsgStatusModel : LeaveMsgBaseModel

@property (nonatomic, copy) NSString *statusId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *version;

@end

@interface LeaveMsgCommentModel : LeaveMsgBaseModel

@property (nonatomic, assign) NSInteger ticketId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, strong) LeaveMsgCreatorModel *creator;
@property (nonatomic, strong) NSMutableArray *attachments;

@end

@interface LeaveMsgAttachmentModel : LeaveMsgBaseModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *type;

@end

@interface LeaveMsgBaseModelTicket : LeaveMsgBaseModel

@property (nonatomic, assign) NSInteger ticketId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *version;

@end