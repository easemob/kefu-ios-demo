//
//  HDVideoGeneralCustomView.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/5/25.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define WINDOWS [UIScreen mainScreen].bounds.size
typedef NS_ENUM(NSInteger, HDVECGeneralType){
    HDVECGeneral_BUTTON    =0,//按钮
    HDVECGeneral_IMAGEVIEW =1,//图片
    HDVECGeneral_GIF       =2,//gif图
    HDVECGeneral_MUSIC     =3,//音乐界面
    HDVECGeneral_VIDEO     =4,//视频界面
    HDVECGeneral_SCROLLVIEW =5,//滚动多图
    HDVECGeneral_OTHERVIEW =6//自定义view
};
@protocol HDVECGeneralCustomViewDelegate <NSObject>
@optional
- (void)hdVideoGeneralCustomViewClicked:(id)sender;
- (void)hdVideoGeneralDragToTheLeft;
- (void)hdVideoGeneralDragToTheRight;
- (void)hdVideoGeneralDragToTheTop;
- (void)hdVideoGeneralDragToTheBottom;


@end
@interface HDVECGeneralView : UIView
@end
@interface HDVECGeneralImageView : UIImageView
@end
@interface HDVECGeneralButton : UIButton
@end
@interface HDVECGeneralScrollView : UIScrollView
@end
@interface HDVECGeneralCustomView : UIView
@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, weak) id<HDVECGeneralCustomViewDelegate> videoGeneralDelegate;
@property (nonatomic, strong) UIButton *customButton;
@property (nonatomic, strong) UIImageView *customImgV;
@property (nonatomic, strong) WKWebView *customGif;
@property (nonatomic, strong) HDVECGeneralScrollView *customScrollView;
@property (nonatomic, strong) HDVECGeneralView *customContentView;
- (void)initWithSuspendType:(NSString *)suspendType;
-(void)updateTimeText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
