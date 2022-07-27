//
//  HDBubbleView+WebBubbleView.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/7/1.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDBubbleView.h"

#import "MBProgressHUD+Add.h"
#import "UIView+GestureRecognizer.h"
#import "YYModel.h" 
NS_ASSUME_NONNULL_BEGIN

@interface HDBubbleView (WebBubbleView)<WKUIDelegate,WKNavigationDelegate> 

//@property (nonatomic, copy) ClickIframeCloseBlock clickIframeCloseBlock;
- (void)setupHtmlBubbleView;

- (void)updateHtmlMargin:(UIEdgeInsets)margin;
- (void)setWebUrl:(NSString *)url;
-(void)setJson:(NSString *)json;
@end

NS_ASSUME_NONNULL_END
