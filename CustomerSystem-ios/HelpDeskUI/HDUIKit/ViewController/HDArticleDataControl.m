//
//  HDMessageVCDataControl.m
//  CustomerSystem-ios
//
//  Created by afanda on 8/4/17.
//  Copyright © 2017 easemob. All rights reserved.
//

#import "HDArticleDataControl.h"

@implementation HDArticleDataControl
+ (BOOL)isArticleMessage:(HMessage *)message {
    NSDictionary *dic = [message.ext objectForKey:@"msgtype"];
    if (dic) {
        if ([dic objectForKey:@"articles"]) {
            return YES;
        }
    }
    return NO;
}
@end
