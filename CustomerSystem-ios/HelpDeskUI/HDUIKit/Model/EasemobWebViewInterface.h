//
//  EasemobWebViewInterface.h
//  CustomerSystem-ios
//
//  Created by 李玉召 on 14/08/2017.
//  Copyright © 2017 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol EasemobWebViewInterface <JSExport>

- (void)closeWindow;
- (void)showToast:(NSString *)toast;
- (NSString *) imToken;
@end
