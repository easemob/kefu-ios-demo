//
//  HDVideoIDCardScaningView.h
//
//
//  Created by HanJunqiang on 2017/2/17.
//  Copyright © 2017年 HanJunqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HDVECIDCardScaningViewType) {
    HDVECIDCardScaningViewTypeIDCard, //  身份证
    HDVECIDCardScaningViewTypeFace, //  人像
};
@interface HDVECIDCardScaningView : UIView
typedef void(^HDVECClickCloseIDCardBlock)(UIButton *btn,HDVECIDCardScaningView * view);
@property (nonatomic,assign) CGRect facePathRect;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, copy) HDVECClickCloseIDCardBlock clickCloseIDCardBlock;

- (void)setVideoScanType:(HDVECIDCardScaningViewType)type withISSmallWindow:(BOOL)iSSmallWindow;
@end
