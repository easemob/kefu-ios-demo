//
//  HDVideoIDCardScaningView.h
//
//
//  Created by HanJunqiang on 2017/2/17.
//  Copyright © 2017年 HanJunqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HDVideoIDCardScaningViewType) {
    HDVideoIDCardScaningViewTypeIDCard, //  身份证
    HDVideoIDCardScaningViewTypeFace, //  人像
};
@interface HDVideoIDCardScaningView : UIView
typedef void(^ClickCloseIDCardBlock)(UIButton *btn,HDVideoIDCardScaningView * view);
@property (nonatomic,assign) CGRect facePathRect;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, copy) ClickCloseIDCardBlock clickCloseIDCardBlock;

- (void)setVideoScanType:(HDVideoIDCardScaningViewType)type withISSmallWindow:(BOOL)iSSmallWindow;
@end
