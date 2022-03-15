//
//  CallViewController.m
//  HLtest
//
//  Created by houli on 2022/3/4.
//

#import "HDCallViewController.h"
#import "HDControlBarView.h"
#import "HDMiddleVideoView.h"
#import "HDSmallWindowView.h"
#import "HDTitleView.h"
#import "Masonry.h"

#import "HDCallViewCollectionViewCellItem.h"
@interface HDCallViewController (){
    
    UIView *_changeView;
    NSMutableArray * _videoItemViews;
    NSMutableArray * _videoViews;
    NSMutableArray * _tmpArray;
}
@property (nonatomic, strong) HDControlBarView *barView;
@property (nonatomic, strong) HDMiddleVideoView *midelleVideoView;
@property (nonatomic, strong) HDSmallWindowView *smallWindowView;
@property (nonatomic, strong) HDTitleView *hdTitleView;
@property (nonatomic, strong) UIView *tmpView;
@property (nonatomic, assign) BOOL  isLandscape;//当前屏幕 是横屏还是竖屏


@end

@implementation HDCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.isLandscape = NO;
    _videoViews = [NSMutableArray new];
    _videoItemViews = [NSMutableArray new];
    //添加 页面布局
    [self addSubView];
    //默认进来调用竖屏
    [self updatePorttaitLayout];
    [self initData];
}

-(void)initData{
    HDControlBarModel * barModel = [HDControlBarModel new];
    barModel.itemType = HDControlBarItemTypeMute;
    barModel.name=@"";
    barModel.imageStr=@"muteButton";
    barModel.selImageStr=@"muteButtonSelected";
    
    HDControlBarModel * barModel1 = [HDControlBarModel new];
    barModel1.itemType = HDControlBarItemTypeVideo;
    barModel1.name=@"";
    barModel1.imageStr=@"videoMuteButton";
    barModel1.selImageStr=@"videoMuteButtonSelected";
    
    HDControlBarModel * barModel2 = [HDControlBarModel new];
    barModel2.itemType = HDControlBarItemTypeHangUp;
    barModel2.name=@"";
    barModel2.imageStr=@"hangUpButton";
    barModel2.selImageStr=@"hangUpButton";
    
    HDControlBarModel * barModel3 = [HDControlBarModel new];
    barModel3.itemType = HDControlBarItemTypeShare;
    barModel3.name=@"";
    barModel3.imageStr=@"screenShareButton";
    barModel3.selImageStr=@"screenShareButtonSelected";
    
    HDControlBarModel * barModel4 = [HDControlBarModel new];
    barModel4.itemType = HDControlBarItemTypeFlat;
    barModel4.name=@"";
    barModel4.imageStr=@"screenShareButton";
    barModel4.selImageStr=@"screenShareButtonSelected";
    
    NSArray * selImageArr = @[barModel,barModel1,barModel2,barModel3,barModel4];
    
    [self.barView buttonFromArrBarModels:selImageArr view:self.barView];
    
    HDCallViewCollectionViewCellItem *item = [[HDCallViewCollectionViewCellItem alloc] init];
    item.isSelected = YES; // 默认自己会被选中
    item.nickName = @"test";
    item.uid = @"123";
    UIView * localView = [[UIView alloc] init];
    localView.backgroundColor = [UIColor yellowColor];
    item.camView = localView;
    
    HDCallViewCollectionViewCellItem *item1 = [[HDCallViewCollectionViewCellItem alloc] init];
    item1.isSelected = NO; // 默认自己会被选中
    item1.nickName = @"访客"; 
    item1.uid = @"1234";
    UIView * localView1 = [[UIView alloc] init];
    localView1.backgroundColor = [UIColor grayColor];
    item1.camView = localView1;
    
    NSMutableArray * array = [NSMutableArray array];
    
    [array addObject:item];
    [array addObject:item1];
    
    [self.smallWindowView setItemData:array];
    
}
-(void)addSubView{
    //顶部 title
    [self.view addSubview:self.hdTitleView];
    //中间小窗
    [self.view addSubview:self.smallWindowView];
    //中间打窗口
    [self.view addSubview:self.midelleVideoView];
    //底部view
    [self.view addSubview:self.barView];
}
#pragma mark - 屏幕翻转就会调用
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        //计算旋转之后的宽度并赋值
        CGSize screen = [UIScreen mainScreen].bounds.size;
        //动画播放完成之后
        if(screen.width > screen.height){
            NSLog(@"横屏");
            [self updateCustomViewFrame:screen withScreen:YES];
        }else{
            NSLog(@"竖屏");
            [self updateCustomViewFrame:screen withScreen:NO];
        }
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        NSLog(@"动画播放完之后处理");
    }];
}

-(void)updateCustomViewFrame:(CGSize)size withScreen:(BOOL)landscape{
    self.isLandscape = landscape;
    self.smallWindowView.isLandscape = landscape;
    if (landscape) {
        [self updateLandscapeLayout];
    }else{
        [self updatePorttaitLayout];
    }
}

/// 横屏布局
-(void)updateLandscapeLayout{
    
    //顶部 小窗口
    [self.smallWindowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hdTitleView.mas_bottom).offset(0);
        make.width.offset(90);
        make.trailing.offset(-10);
        make.bottom.mas_equalTo(self.barView.mas_top).offset(0);
        
    }];
    //中间 视频窗口
    [self.midelleVideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.bottom.offset(0);
    }];
    [self.view sendSubviewToBack:self.midelleVideoView];
    
  
    //底部 窗口
    [self.barView refreshView:self.barView withScreen:self.isLandscape];
    
}
/// 竖屏布局
-(void)updatePorttaitLayout{
    
    //顶部功能
    [self.hdTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.height.offset(44);
    }];
  
    //底部功能按钮
    [self.barView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.height.offset(84);
    }];
    [self.barView layoutIfNeeded];
    
    //顶部 小窗口
    [self.smallWindowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hdTitleView.mas_bottom).offset(20);
        make.leading.offset(15);
        make.trailing.offset(0);
        make.height.offset(90);
        
    }];
    //中间 视频窗口
    [self.midelleVideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.smallWindowView.mas_bottom).offset(44);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.height.offset([UIScreen mainScreen].bounds.size.width *9/16 );
        
    }];
    //底部 窗口
    [self.barView refreshView:self.barView withScreen:self.isLandscape];
}


/// 点击 cell。更改小窗试图
/// @param item  cell 里边的model
/// @param idx  当前点击cell 的index
- (void)changeCallViewItem:(HDCallViewCollectionViewCellItem *)item withIndex:(NSInteger)idx{
    
     //更新小窗口
    [self updateSmallVideoView:item withIndex:idx];

    //更新中间视频大窗口
    [self updateVideoView];
}
/// 更新视频窗口（大窗口）
-(void)updateSmallVideoView:(HDCallViewCollectionViewCellItem *)item withIndex:(NSInteger )idx{
    
    [_videoItemViews removeAllObjects];
    //这个数组里边添加的是小窗口需要放到中间视频窗口的view 在传给cell 前先保存之前的view
    [_videoItemViews addObject:item.camView];
    //cell 小窗口切换
    UIView * tmpVideoView = [_videoViews firstObject];
    item.camView = tmpVideoView;
    [self.smallWindowView setSelectCallItemChangeVideoView:item withIndex:idx];
 
}

/// 更新视频窗口（大窗口）
-(void)updateVideoView{
    
    [_videoViews removeAllObjects];
    UIView * videoView = [_videoItemViews firstObject];
    self.midelleVideoView = (HDMiddleVideoView *)videoView;
    [self.view addSubview:videoView];
    //中间 视频窗口
    
    if (self.isLandscape) {
        [videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.leading.offset(0);
            make.trailing.offset(0);
            make.bottom.offset(0);
            
        }];
        [self.view sendSubviewToBack:videoView];
    }else{
        
        [videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.smallWindowView.mas_bottom).offset(44);
            make.leading.offset(0);
            make.trailing.offset(0);
            make.height.offset([UIScreen mainScreen].bounds.size.width *9/16 );
        }];

        
    }
    
  
    [_videoViews addObject:videoView];

}


- (HDTitleView *)hdTitleView {
    if (!_hdTitleView) {
        _hdTitleView = [[HDTitleView alloc]init];
//        _hdTitleView.backgroundColor = [UIColor redColor];
       
    }
    return _hdTitleView;
}
- (HDControlBarView *)barView {
    if (!_barView) {
        _barView = [[HDControlBarView alloc]init];
//        _barView.backgroundColor = [UIColor redColor];
        __weak __typeof__(self) weakSelf = self;
        _barView.clickControlBarItemBlock = ^(HDControlBarModel * _Nonnull barModel, UIButton * _Nonnull btn) {
            
            switch (barModel.itemType) {
                case HDControlBarItemTypeMute:
                    [weakSelf muteBtnClicked:btn];
                    break;
                case HDControlBarItemTypeVideo:
                    [weakSelf videoBtnClicked:btn];
                    break;
                case HDControlBarItemTypeHangUp:
                    [weakSelf offBtnClicked:btn];
                    break;
                case HDControlBarItemTypeShare:
                    [weakSelf shareDesktopBtnClicked:btn];
                    break;
                case HDControlBarItemTypeFlat:
                    [weakSelf offBtnClickedFalt:btn];
                    break;
                    
                default:
                    break;
            }
            
            
        };
       
    }
    return _barView;
}
- (HDMiddleVideoView *)midelleVideoView {
    if (!_midelleVideoView) {
        _midelleVideoView = [[HDMiddleVideoView alloc]init];
        _midelleVideoView.backgroundColor = [UIColor blueColor];
        self.tmpView = _midelleVideoView;
        [_videoViews addObject:_midelleVideoView];
    }
    return _midelleVideoView;
}
- (HDSmallWindowView *)smallWindowView {
    if (!_smallWindowView) {
        _smallWindowView = [[HDSmallWindowView alloc]init];
        __weak __typeof__(self) weakSelf = self;
        _smallWindowView.clickCellItemBlock = ^(HDCallViewCollectionViewCellItem * _Nonnull item, NSIndexPath * _Nonnull indexpath) {
            //切换逻辑
            
            [weakSelf changeCallViewItem:item withIndex:indexpath.item];
        };
    }
    return _smallWindowView;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    [self.hdTitleView startTimer];
//    [self.hdTitleView modifyInfoLabelText: @"通话中好多好多人啊"];
    
    
    
}


#pragma mark - event

- (void)initBroadPickerView{
    if (@available(iOS 12.0, *)) {
       
    } else {
        // Fallback on earlier versions
    }
}

// 切换摄像头事件
- (void)camBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
//    [[HDAgoraCallManager shareInstance] switchCamera];
}

// 静音事件
- (void)muteBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
//        [[HDAgoraCallManager shareInstance] pauseVoice];
    } else {
//        [[HDAgoraCallManager shareInstance] resumeVoice];
    }
    
    NSLog(@"点击了静音事件");
}

// 停止发送视频流事件
- (void)videoBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
//    UIView *selfView = [_members.firstObject camView];
    if (btn.selected) {
//        [[HDAgoraCallManager shareInstance] pauseVideo];
    } else {
//        [[HDAgoraCallManager shareInstance] resumeVideo];
    }
//    selfView.hidden = btn.selected;
    NSLog(@"点击了视频事件");
}

// 扬声器事件
- (void)speakerBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
//    [[HDAgoraCallManager shareInstance] setEnableSpeakerphone:btn.selected];
    NSLog(@"点击了扬声器事件");
}

// 屏幕共享事件
- (void)shareDesktopBtnClicked:(UIButton *)btn {
//    for (UIView *view in _broadPickerView.subviews)
//    {
//        if ([view isKindOfClass:[UIButton class]])
//        {
//            //调起录像方法，UIControlEventTouchUpInside的方法看其他文章用的是UIControlEventTouchDown，
//            //我使用时用UIControlEventTouchUpInside用好使，看个人情况决定
//            [(UIButton*)view sendActionsForControlEvents:UIControlEventTouchUpInside];
//        }
//    }
    NSLog(@"点击了屏幕共享事件");
}

// 切换屏幕尺寸事件
- (void)screenBtnClicked:(UIButton *)btn {
    NSLog(@"点击了切换屏幕尺寸事件");
}

// 隐藏按钮事件
- (void)hiddenBtnClicked:(UIButton *)btn
{
    NSLog(@"点击了隐藏按钮事件");
}

// 挂断事件
- (void)offBtnClicked:(UIButton *)sender
{
    NSLog(@"点击了挂断共享事件");
   
}
// 互动白板
- (void)offBtnClickedFalt:(UIButton *)sender
{
    NSLog(@"点击了互动白板事件");
   
}

@end
