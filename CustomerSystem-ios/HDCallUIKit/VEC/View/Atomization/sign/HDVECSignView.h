//
//  HDSignView.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/6/10.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDVECDrawingBoardView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol HDVECSignDelegate <NSObject>
- (void)hdSignCompleteWithImage:(UIImage *)img base64Data:(NSData *)base64data;
@optional
- (void)hdBackMethod;
//- (void)hdSignCompleteWithImage:(UIImage *)img base64str:(NSString *)base64str;
@end
@interface HDVECSignView : UIView
@property (nonatomic, strong) HDVECDrawingBoardView *hdDrawView;;
@property (strong, nonatomic)  UIButton *backBtn;
@property (strong, nonatomic)  UIButton *resignBtn;
@property (strong, nonatomic)  UIButton *sureBtn;
/** 图片数据流 */
@property (nonatomic,strong) NSData *imageData;
@property (nonatomic, weak) id<HDVECSignDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
