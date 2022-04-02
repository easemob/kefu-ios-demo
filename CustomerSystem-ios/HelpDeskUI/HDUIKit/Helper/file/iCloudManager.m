//
//  iCloudManager.m
//  HLtest
//
//  Created by houli on 2022/3/18.
//

#import "iCloudManager.h"
#import "ZZDocument.h"
@implementation iCloudManager
+ (BOOL)iCloudEnable {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSURL *url = [manager URLForUbiquityContainerIdentifier:nil];

    if (url != nil) {
        return YES;
    }
    
    NSLog(@"iCloud 不可用");
    return NO;
}
+ (void)downloadWithDocumentURL:(NSURL*)url callBack:(downloadBlock)block {
    
    ZZDocument *iCloudDoc = [[ZZDocument alloc]initWithFileURL:url];
    
    [iCloudDoc openWithCompletionHandler:^(BOOL success) {
        if (success) {
            
//            [iCloudDoc closeWithCompletionHandler:^(BOOL success) {
//                NSLog(@"关闭成功");
//            }];
            
            if (block) {
                block(iCloudDoc.data);
            }
            
        }
    }];
}
@end
