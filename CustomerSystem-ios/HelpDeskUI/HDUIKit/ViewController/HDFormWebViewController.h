//
//  HDFormWebViewController.h
//  CustomerSystem-ios
//
//  Created by 李玉召 on 14/08/2017.
//  Copyright © 2017 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EasemobWebViewInterface <NSObject>

- (void)closeWindow;
- (void)showToast:(NSString *)toast;
- (NSString *) imToken;
@end

@interface HDFormWebViewController : UIViewController
@property(nonatomic,strong) NSString *url;

@end
