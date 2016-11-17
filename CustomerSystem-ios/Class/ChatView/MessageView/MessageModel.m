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

#import "MessageModel.h"

@implementation MessageModel

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        //code
    }
    
    return self;
}

- (void)dealloc{
    
}

- (NSString *)messageId
{
    return _message.messageId;
}

- (MessageDeliveryState)status
{
    return _message.deliveryState;
}

@end

@implementation FileMessageBody

- (instancetype)initWithDic :(EMFileMessageBody *)body {
    if (self = [super init]) {
        [self setup:body];
    }
    return self;
}

- (void)setup:(EMFileMessageBody *)body {
    self.filename = body.displayName;
    self.file_length = [NSString stringWithFormat:@"%lld",body.fileLength];
    self.url = body.remotePath;
}



@end
