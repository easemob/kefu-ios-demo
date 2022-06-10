//
//  HDVideoLinkMessagePush.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/6/9.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HDVideoLinkMessagePush : UIView

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UILabel *loadLabel;


- (void)setWebUrl:(NSString *)url;




@end

NS_ASSUME_NONNULL_END
