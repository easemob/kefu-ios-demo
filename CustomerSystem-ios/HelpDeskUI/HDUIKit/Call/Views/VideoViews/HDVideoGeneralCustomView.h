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
typedef NS_ENUM(NSInteger, HDVideoGeneralType){
    HDVideoGeneral_BUTTON    =0,//按钮
    HDVideoGeneral_IMAGEVIEW =1,//图片
    HDVideoGeneral_GIF       =2,//gif图
    HDVideoGeneral_MUSIC     =3,//音乐界面
    HDVideoGeneral_VIDEO     =4,//视频界面
    HDVideoGeneral_SCROLLVIEW =5,//滚动多图
    HDVideoGeneral_OTHERVIEW =6//自定义view
};
@protocol HDVideoGeneralCustomViewDelegate <NSObject>
@optional
- (void)hdVideoGeneralCustomViewClicked:(id)sender;
- (void)hdVideoGeneralDragToTheLeft;
- (void)hdVideoGeneralDragToTheRight;
- (void)hdVideoGeneralDragToTheTop;
- (void)hdVideoGeneralDragToTheBottom;


@end
@interface HDVideoGeneralView : UIView
@end
@interface HDVideoGeneralImageView : UIImageView
@end
@interface HDVideoGeneralButton : UIButton
@end
@interface HDVideoGeneralScrollView : UIScrollView
@end
@interface HDVideoGeneralCustomView : UIView
@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, weak) id<HDVideoGeneralCustomViewDelegate> videoGeneralDelegate;
@property (nonatomic, strong) UIButton *customButton;
@property (nonatomic, strong) UIImageView *customImgV;
@property (nonatomic, strong) UIWebView *customGif;
@property (nonatomic, strong) HDVideoGeneralScrollView *customScrollView;
@property (nonatomic, strong) HDVideoGeneralView *customContentView;
- (void)initWithSuspendType:(NSString *)suspendType;
-(void)updateTimeText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
