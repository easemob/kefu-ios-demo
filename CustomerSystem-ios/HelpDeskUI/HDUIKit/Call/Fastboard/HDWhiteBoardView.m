//
//  HDWhiteBoardView.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/4/11.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDWhiteBoardView.h"

#import "HDWhiteRoomManager.h"
#import "Utility.h"

#import "HDAppSkin.h"
#import "UIImage+HDIconFont.h"
#import "HDWhiteBoardDelegete.h"
@interface HDWhiteBoardView()<HDWhiteBoardDelegete>
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIStackView* stackView;
@property (nonatomic, copy) Theme theme;
@property (nonatomic, assign) BOOL isHide;
@end
@implementation HDWhiteBoardView
{
    FastRoom* _fastRoom;
    Theme _theme;
}
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor whiteColor];
        //创建ui
        [self initWhiteBoardView];
    }
    return self;
}
- (void)initWhiteBoardView{
    //加入房间
    [[HDWhiteRoomManager shareInstance] hd_OnJoinRoomWithFastView:self ];
    _fastRoom = [HDWhiteRoomManager shareInstance].fastRoom;
   [HDWhiteRoomManager shareInstance].whiteDelegate = self;
   [self setupTools];
}

// MARK: - Action

- (void)onDirection {
//    if (FastRoomView.appearance.operationBarDirection == OperationBarDirectionLeft) {
//        FastRoomView.appearance.operationBarDirection = OperationBarDirectionRight;
//        [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).inset(10);
//            make.left.equalTo(self).inset(88);
//            make.width.equalTo(@120);
//        }];
//    } else {
//        FastRoomView.appearance.operationBarDirection = OperationBarDirectionLeft;
//        [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).inset(10);
//            make.right.equalTo(self).inset(88);
//            make.width.equalTo(@120);
//        }];
//    }
//    [AppearanceManager.shared commitUpdate];
}

- (void)onBarSize {
    if (FastRoomControlBar.appearance.itemWidth == 48) {
        FastRoomControlBar.appearance.itemWidth = 44;
    } else {
        FastRoomControlBar.appearance.itemWidth = 48;
    }
    [AppearanceManager.shared commitUpdate];
}

- (void)onWritable {
    BOOL writable = _fastRoom.room.isWritable;
    [_fastRoom updateWritable:!writable completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"update writable fail");
        } else {
            NSLog(@"update writable successfully");
        }
    }];
}

- (void)onUserTheme {
    FastRoomWhiteboardAssets* white = [[FastRoomWhiteboardAssets alloc]
                               initWithWhiteboardBackgroundColor:UIColor.whiteColor
                               containerColor:UIColor.grayColor];
    
    FastRoomControlBarAssets* control = [[FastRoomControlBarAssets alloc]
                                 initWithBackgroundColor:[UIColor redColor]
                                 borderColor:UIColor.clearColor
                                 effectStyle:[UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular]];
    
    FastRoomPanelItemAssets* panel = [[FastRoomPanelItemAssets alloc] initWithNormalIconColor:UIColor.whiteColor
                                   selectedIconColor:[UIColor redColor]
                                 selectedIconBgColor:[UIColor redColor]
                                      highlightColor:[UIColor redColor]
                                    highlightBgColor:UIColor.clearColor
                                        disableColor:[UIColor.grayColor colorWithAlphaComponent:0.7]
                                subOpsIndicatorColor:UIColor.whiteColor
                                  pageTextLabelColor:UIColor.whiteColor];
    FastRoomThemeAsset* asset = [[FastRoomThemeAsset alloc] initWithWhiteboardAssets:white
                                                    controlBarAssets:control
                                                     panelItemAssets:panel];
    [FastRoomThemeManager.shared apply:asset];
}

- (void)onLayout {
    [_fastRoom.view.overlay invalidAllLayout];
    NSObject<FastRoomOverlay>* overlay = _fastRoom.view.overlay;
    if ([overlay isKindOfClass:[RegularFastRoomOverlay class]]) {
        RegularFastRoomOverlay* regular = overlay;
//        [regular.operationPanel.view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(regular.operationPanel.view.superview).inset(20);
//            make.centerY.equalTo(regular.operationPanel.view.superview);
//        }];
//
//        [regular.deleteSelectionPanel.view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(regular.operationPanel.view);
//            make.bottom.equalTo(regular.operationPanel.view.mas_top).offset(-8);
//        }];
//
//        [regular.undoRedoPanel.view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(regular.undoRedoPanel.view.superview).inset(20);
//            make.bottom.equalTo(_fastRoom.view.whiteboardView);
//        }];
//
//        [regular.scenePanel.view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(_fastRoom.view.whiteboardView);
//            make.centerX.equalTo(regular.scenePanel.view.superview);
//        }];
    }
    
    if ([overlay isKindOfClass:[CompactFastRoomOverlay class]]) {
        CompactFastRoomOverlay* compact = (CompactFastRoomOverlay*)overlay;
        [compact.operationPanel.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_fastRoom.view.whiteboardView);
            make.centerY.equalTo(@0);
        }];

        [compact.colorAndStrokePanel.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_fastRoom.view.whiteboardView);
            make.bottom.equalTo(compact.operationPanel.view.mas_top).offset(-8);
        }];

        [compact.deleteSelectionPanel.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(compact.colorAndStrokePanel.view);
        }];
//
        [compact.undoRedoPanel.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_fastRoom.view.whiteboardView);
            make.top.equalTo(compact.operationPanel.view.mas_bottom).offset(5);
        }];
        
        [compact.scenePanel.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(_fastRoom.view.whiteboardView);
            make.bottom.equalTo(_fastRoom.view.whiteboardView).offset(-25);
        }];
    }
}

- (void)onPencil {
    FastRoom.followSystemPencilBehavior = !FastRoom.followSystemPencilBehavior;
}
- (void)reloadFastboardOverlayWithScle:(BOOL)isScle{
   
 
    [[HDWhiteRoomManager shareInstance] reloadFastboardOverlayWithView:self];
    
   
}

//上传文件
- (void)onUploadFile {

    NSLog(@"=====点击了上传文件");
    if (self.clickWhiteBoardViewBlock) {
        UIButton *btn = (UIButton *)[self viewWithTag:HDClickButtonTypeFile +1001];
        self.clickWhiteBoardViewBlock(HDClickButtonTypeFile, btn);
    }

}
//缩放
- (void)onScale {

    NSLog(@"=====点击了缩放");
    if (self.clickWhiteBoardViewBlock) {
        UIButton *btn = (UIButton *)[self viewWithTag:HDClickButtonTypeScale + 1001];
        self.clickWhiteBoardViewBlock(HDClickButtonTypeScale, btn);
    }
}

//推出房间
- (void)onLogout {

    NSLog(@"=====点击了退出房间");
    [[HDWhiteRoomManager shareInstance] hd_OnLogout];
    
    if (self.clickWhiteBoardViewBlock) {
        UIButton *btn = (UIButton *)[self viewWithTag:HDClickButtonTypeScale + 1001];
        self.clickWhiteBoardViewBlock(HDClickButtonTypeLogout, btn);
    }
}


- (FastRoom *)room{
    
    return _fastRoom;
}
- (void)setupTools {
    [self addSubview:self.stackView];
    self.stackView.axis = UILayoutConstraintAxisHorizontal;
    self.stackView.distribution = UIStackViewDistributionFillEqually;

    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_fastRoom.view.mas_top).offset(0);
        make.trailing.offset(-20);
        make.height.offset(26);
//        make.width.offset(118);
    }];

}

- (void)hd_ModifyStackViewLayout:(UIView *)view withScle:(BOOL)isScle{
    
    if (isScle) {
        [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_bottom).offset(10);
            make.trailing.offset(-20);
            make.height.offset(26);
    //        make.width.offset(118);
        }];
        
        [self.stackView.subviews[0] removeFromSuperview];
    }else{
       
        [self.stackView removeFromSuperview];
        self.stackView =nil;
        
        [self setupTools];
        
        
    }
   
    
}

- (NSArray<UIButton *> *)setupButtons {
    NSArray* titles = @[@"Scale",
                        @"UploadFile",
                        @"Logout",
                       ];
    NSMutableArray* btns = [NSMutableArray new];
    [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString* title = obj;
        int index = (int)idx;
        UIButton* btn = [Utility buttonWith:title index:index];
        SEL sel = NSSelectorFromString([NSString stringWithFormat:@"on%@", title]);
        [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
        [btns addObject:btn];
    }];
    return btns;
}

// MARK: - Setter
- (void)setIsHide:(BOOL)isHide {
    _isHide = isHide;
    [_fastRoom setAllPanelWithHide:isHide];
}

// MARK: - Lazy
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithArrangedSubviews:[self setupButtons]];
        _stackView.spacing = 20;
        _stackView.layer.cornerRadius = 10;
        _stackView.layer.borderWidth = 1;
        _stackView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    }
    return _stackView;
}

#pragma mark - hd

- (void)onFastboardDidJoinRoomSuccess{
    
    CompactFastRoomOverlay* compact = (CompactFastRoomOverlay *)_fastRoom.view.overlay;
    compact.undoRedoPanel.view.direction =UILayoutConstraintAxisVertical;
//    compact.scenePanel.view.direction = UILayoutConstraintAxisVertical;
//    compact.scenePanel.view.hidden = YES;
    [AppearanceManager.shared commitUpdate];
    
    [self onLayout];
    
    if (self.fastboardDidJoinRoomSuccessBlock) {
        self.fastboardDidJoinRoomSuccessBlock();
    }
}
- (void)onFastboardDidJoinRoomFail{
    
    if (self.fastboardDidJoinRoomFailBlock) {
        self.fastboardDidJoinRoomFailBlock();
    }
}
@end
