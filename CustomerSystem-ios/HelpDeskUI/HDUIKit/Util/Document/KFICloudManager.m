//
//  iCloudManager.m
//  HLtest
//
//  Created by houli on 2022/3/18.
//

#import "KFICloudManager.h"
#import "KFDocument.h"
@implementation KFICloudManager
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
    
    KFDocument *iCloudDoc = [[KFDocument alloc]initWithFileURL:url];
    
    [iCloudDoc openWithCompletionHandler:^(BOOL success) {
        if (success) {
            if (block) {
                block(iCloudDoc.data);
            }
            [iCloudDoc closeWithCompletionHandler:^(BOOL success) {
                NSLog(@"关闭成功");
            }];
            
           
            
        }
    }];
}
@end
