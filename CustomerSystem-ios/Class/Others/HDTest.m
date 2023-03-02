//
//  HDTest.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/6/23.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDTest.h"

@implementation HDTest

-(void) setInstanceWithObject:(NSDictionary *)obj {
    self.title = [obj objectForKey:@"title"];

}
-(NSMutableDictionary *)content {
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.title forKey:@"title"];
   
    if (self.customDic.count >0) {
        [dict addEntriesFromDictionary:self.customDic];
    }
    return dict;
}

- (NSString *)getName{
    
    return @"test";
    
}
-(NSString *)getParentName{
    
    return TAG_WEICHAT;
    
}
@end
