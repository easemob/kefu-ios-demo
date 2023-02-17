//
//  HDTitleView.h
//  HLtest
//
//  Created by houli on 2022/3/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define kApplicationStatusBarHeight  [UIApplication sharedApplication].statusBarFrame.size.height //状态栏的高度

typedef void(^ClickHideBlock)(UIButton *btn);
typedef void(^ClickZoomBtnBlock)(UIButton *btn);
@interface HDTitleView : UIView
@property(nonatomic ,strong)UIView *cellView;
@property(nonatomic ,strong)UILabel *infoLabel; // 正在通话中...
@property(nonatomic ,strong)UILabel *timeLabel;  // 时间 00:00:00;
@property(nonatomic ,strong)UIButton *hideBtn;  // 隐藏按钮;
@property(nonatomic ,strong)UIButton *zoomBtn;  // 缩放按钮;
/**  定时器  **/
@property (nonatomic , strong)NSTimer  *timer;
@property (nonatomic, copy) ClickHideBlock clickHideBlock;
@property (nonatomic, copy) ClickZoomBtnBlock clickZoomBtnBlock;

@property(nonatomic ,assign)BOOL *isLandscape; // 判断是横竖屏 默认竖屏


- (void)startTimer;
- (void)stopTimer;

//动态修改文字更新布局
-(void)modifyInfoLabelText:(NSString *)text;

- (void)modifyTextColor:(UIColor *)color;
- (void)modifyIconBackColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
