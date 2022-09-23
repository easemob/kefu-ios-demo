//
//  main.m
//  CustomerSystem-ios
//
//  Created by dhc on 15/2/13.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
// 第一步：在 main() 函数里用变量 MainStartTime 记录当前时间
CFAbsoluteTime MainStartTime;
int main(int argc, char * argv[]) {
    @autoreleasepool {
        MainStartTime = CFAbsoluteTimeGetCurrent();
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
