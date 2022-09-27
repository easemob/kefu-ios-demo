//
//  HDSignView.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/6/10.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDDrawingBoardView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol HDSignDelegate <NSObject>
- (void)hdSignCompleteWithImage:(UIImage *)img base64Data:(NSData *)base64data;
@optional
- (void)hdBackMethod;
//- (void)hdSignCompleteWithImage:(UIImage *)img base64str:(NSString *)base64str;
@end
@interface HDSignView : UIView
@property (nonatomic, strong) HDDrawingBoardView *hdDrawView;;
@property (strong, nonatomic)  UIButton *backBtn;
@property (strong, nonatomic)  UIButton *resignBtn;
@property (strong, nonatomic)  UIButton *sureBtn;
/** 图片数据流 */
@property (nonatomic,strong) NSData *imageData;
@property (nonatomic, weak) id<HDSignDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
