//
//  ViewController.m
//  OCExample
//
//  Created by xuyunshi on 2021/12/28.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import "HDFastboardViewController.h"
#import "RoomInfo.h"
#import <Fastboard/Fastboard-Swift.h>
#import <Whiteboard/Whiteboard.h>
#import "Utility.h"
#import "CustomFastboardOverlay.h"
#import "HDStorageItem.h"
@interface HDFastboardViewController() <FastRoomDelegate,WhiteRoomCallbackDelegate>
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIStackView* stackView;
@property (nonatomic, copy) Theme theme;
@property (nonatomic, assign) BOOL isHide;
@end

@implementation HDFastboardViewController {
    FastRoom* _fastRoom;
    Theme _theme;
}

// MARK: - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupFastboardWithCustom:nil];
    [self setupTools];
    if (@available(iOS 13.0, *)) {
        _theme = ThemeAuto;
        [self applyTheme:ThemeAuto];
    } else {
        _theme = ThemeLight;
        [self applyTheme:ThemeLight];
    }
}

// MARK: - Action
- (void)onTheme {
    _theme = [self nextThemeFor:_theme];
    [self applyTheme:_theme];
}

- (void)onDirection {
    if (FastRoomView.appearance.operationBarDirection == OperationBarDirectionLeft) {
        FastRoomView.appearance.operationBarDirection = OperationBarDirectionRight;
        [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).inset(10);
            make.left.equalTo(self.view).inset(88);
            make.width.equalTo(@120);
        }];
    } else {
        FastRoomView.appearance.operationBarDirection = OperationBarDirectionLeft;
        [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).inset(10);
            make.right.equalTo(self.view).inset(88);
            make.width.equalTo(@120);
        }];
    }
    [AppearanceManager.shared commitUpdate];
}

- (void)onBarSize {
    if (FastRoomControlBar.appearance.itemWidth == 48) {
        FastRoomControlBar.appearance.itemWidth = 44;
    } else {
        FastRoomControlBar.appearance.itemWidth = 48;
    }
    [AppearanceManager.shared commitUpdate];
}

- (void)onIcons {
    [FastRoomThemeManager.shared updateIconsUsing:[NSBundle mainBundle]];
    [self reloadFastboardOverlay:nil];
    self.view.userInteractionEnabled = FALSE;
    dispatch_after(DISPATCH_TIME_NOW + 3, dispatch_get_main_queue(), ^{
        self.view.userInteractionEnabled = TRUE;
    });
}

- (void)onHideAll {
    self.isHide = !self.isHide;
}

- (void)onHideItem {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSMutableArray* values = [NSMutableArray array];
    [values addObject:[FastRoomDefaultOperationIdentifier appliceWithKey:ApplianceClicker shape:nil]];
    [values addObject:[FastRoomDefaultOperationIdentifier appliceWithKey:AppliancePencil shape:nil]];
    [values addObject:[FastRoomDefaultOperationIdentifier appliceWithKey:ApplianceSelector shape:nil]];
    [values addObject:[FastRoomDefaultOperationIdentifier appliceWithKey:ApplianceText shape:nil]];
    [values addObject:[FastRoomDefaultOperationIdentifier appliceWithKey:ApplianceEllipse shape:nil]];
    [values addObject:[FastRoomDefaultOperationIdentifier appliceWithKey:ApplianceRectangle shape:nil]];
    [values addObject:[FastRoomDefaultOperationIdentifier appliceWithKey:ApplianceEraser shape:nil]];
    [values addObject:[FastRoomDefaultOperationIdentifier appliceWithKey:ApplianceStraight shape:nil]];
    [values addObject:[FastRoomDefaultOperationIdentifier appliceWithKey:ApplianceArrow shape:nil]];
    [values addObject:[FastRoomDefaultOperationIdentifier appliceWithKey:ApplianceHand shape:nil]];
    [values addObject:[FastRoomDefaultOperationIdentifier appliceWithKey:ApplianceLaserPointer shape:nil]];
    
    [values addObject:[FastRoomDefaultOperationIdentifier appliceWithKey:ApplianceShape shape:ApplianceShapeTypeTriangle]];
    [values addObject:[FastRoomDefaultOperationIdentifier appliceWithKey:ApplianceShape shape:ApplianceShapeTypeRhombus]];
    [values addObject:[FastRoomDefaultOperationIdentifier appliceWithKey:ApplianceShape shape:ApplianceShapeTypePentagram]];
    [values addObject:[FastRoomDefaultOperationIdentifier appliceWithKey:ApplianceShape shape:ApplianceShapeTypeSpeechBalloon]];
    
    [values addObject:[FastRoomDefaultOperationIdentifier operationType:FastRoomDefaultOperationTypeDeleteSelection]];
    [values addObject:[FastRoomDefaultOperationIdentifier operationType:FastRoomDefaultOperationTypeStrokeWidth]];
    [values addObject:[FastRoomDefaultOperationIdentifier operationType:FastRoomDefaultOperationTypeClean]];
    [values addObject:[FastRoomDefaultOperationIdentifier operationType:FastRoomDefaultOperationTypeRedo]];
    [values addObject:[FastRoomDefaultOperationIdentifier operationType:FastRoomDefaultOperationTypeUndo]];
    [values addObject:[FastRoomDefaultOperationIdentifier operationType:FastRoomDefaultOperationTypeNewPage]];
    [values addObject:[FastRoomDefaultOperationIdentifier operationType:FastRoomDefaultOperationTypePreviousPage]];
    [values addObject:[FastRoomDefaultOperationIdentifier operationType:FastRoomDefaultOperationTypeNextPage]];
    [values addObject:[FastRoomDefaultOperationIdentifier operationType:FastRoomDefaultOperationTypePageIndicator]];
    
    for (FastRoomDefaultOperationIdentifier* item in values) {
        [alert addAction:[UIAlertAction actionWithTitle:item.identifier
                                                  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->_fastRoom setPanelItemHideWithItem:item hide:TRUE];
        }]];
    }
    alert.popoverPresentationController.sourceView = self.stackView;
    [self presentViewController:alert animated:TRUE completion:nil];
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

- (void)onCustom {
    [self reloadFastboardOverlay:[[CustomFastboardOverlay alloc] init]];
    FastRoomControlBar.appearance.itemWidth = 66;
    [AppearanceManager.shared commitUpdate];
}

- (void)onPhoneItems {
    CompactFastRoomOverlay.defaultCompactAppliance = @[
        AppliancePencil,
        ApplianceSelector,
        ApplianceEraser
    ];
    [self reloadFastboardOverlay:nil];
}

- (void)onPadItems {
    NSMutableArray* items = [NSMutableArray array];
    [items addObject:[[SubOpsItem alloc] initWithSubOps:RegularFastRoomOverlay.shapeItems]];
    [items addObject:[FastRoomDefaultOperationItem selectableApplianceItem:AppliancePencil shape:nil]];
    [items addObject:[FastRoomDefaultOperationItem clean]];
    FastRoomPanel* panel = [[FastRoomPanel alloc] initWithItems:items];
    RegularFastRoomOverlay.customOptionPanel = ^FastRoomPanel * _Nonnull{
        return panel;
    };
    [self reloadFastboardOverlay:nil];
}

- (void)onLayout {
    [_fastRoom.view.overlay invalidAllLayout];
    NSObject<FastRoomOverlay>* overlay = _fastRoom.view.overlay;
    if ([overlay isKindOfClass:[RegularFastRoomOverlay class]]) {
        RegularFastRoomOverlay* regular = overlay;
        [regular.operationPanel.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(regular.operationPanel.view.superview).inset(20);
            make.centerY.equalTo(regular.operationPanel.view.superview);
        }];
        
        [regular.deleteSelectionPanel.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(regular.operationPanel.view);
            make.bottom.equalTo(regular.operationPanel.view.mas_top).offset(-8);
        }];
        
        [regular.undoRedoPanel.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(regular.undoRedoPanel.view.superview).inset(20);
            make.bottom.equalTo(_fastRoom.view.whiteboardView);
        }];
        
        [regular.scenePanel.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_fastRoom.view.whiteboardView);
            make.centerX.equalTo(regular.scenePanel.view.superview);
        }];
    }
    
    if ([overlay isKindOfClass:[CompactFastRoomOverlay class]]) {
        CompactFastRoomOverlay* compact = overlay;
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
        
        [compact.undoRedoPanel.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(_fastRoom.view.whiteboardView);
        }];
        
        [compact.scenePanel.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.bottom.equalTo(_fastRoom.view.whiteboardView);
        }];
    }
}

- (void)onPencil {
    FastRoom.followSystemPencilBehavior = !FastRoom.followSystemPencilBehavior;
}

- (void)onInsertIMAGE {
//    for (HDStorageItem* i in [HDStorageItem localStorage]) {
//        if (i.fileType == FileTypeImg) {
//            [self insertItem:i];
//            return;
//        }
//    }
}

- (void)onInsertMP3 {
//    for (StorageItem* i in [StorageItem localStorage]) {
//        if (i.fileType == FileTypeMusic) {
//            [self insertItem:i];
//            return;
//        }
//    }
}

- (void)onInsertMP4 {
//    for (StorageItem* i in [StorageItem localStorage]) {
//        if (i.fileType == FileTypeVideo) {
//            [self insertItem:i];
//            return;
//        }
//    }
}

- (void)onInsertPPT {
//    for (StorageItem* i in [StorageItem localStorage]) {
//        if (i.fileType == FileTypePpt && i.taskType == WhiteConvertTypeStatic) {
//            [self insertItem:i];
//            return;
//        }
//    }
}

- (void)onInsertPDF {
//    for (StorageItem* i in [StorageItem localStorage]) {
//        if (i.fileType == FileTypePdf) {
//            [self insertItem:i];
//            return;
//        }
//    }
}

- (void)onInsertDOC {
//    for (StorageItem* i in [StorageItem localStorage]) {
//        if (i.fileType == FileTypeWord) {
//            [self insertItem:i];
//            return;
//        }
//    }
}

- (void)onInsertPPTX {
//    for (StorageItem* i in [StorageItem localStorage]) {
//        if (i.taskType == WhiteConvertTypeDynamic) {
//            [self insertItem:i];
//            return;
//        }
//    }
}

- (void)insertItem:(HDStorageItem *)item {
    if (item.fileType == HDFastBoardFileTypeimg) {
        [[NSURLSession.sharedSession downloadTaskWithURL:[NSURL URLWithString:item.fileUrl] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) { return ; }
            NSData* data = [[NSData alloc] initWithContentsOfURL:location];
            UIImage* img = [UIImage imageWithData:data];
            // 远程图片的路径
            [self->_fastRoom insertImg:[NSURL URLWithString:item.fileUrl] imageSize:img.size];
        }] resume];
    }
    
    if ((item.fileType == HDFastBoardFileTypevideo) || (item.fileType == HDFastBoardFileTypemusic)) {
        [self->_fastRoom insertMedia:[NSURL URLWithString:item.fileUrl] title:item.fileName completionHandler:nil];
        return;
    }
    
    [WhiteConverterV5 checkProgressWithTaskUUID:item.taskUUID
                                          token:item.taskToken
                                         region:item.region
                                       taskType:item.taskType result:^(WhiteConversionInfoV5 * _Nullable info, NSError * _Nullable error) {
        if (error) { return; }
        if (!info) { return; }
        
        NSArray* pages = info.progress.convertedFileList;
        if (!pages) { return; }
        switch (item.fileType) {
            case HDFastBoardFileTypeimg:
                break;
            case HDFastBoardFileTypepdf:
                [self->_fastRoom insertStaticDocument:pages
                                                 title:item.fileName completionHandler:nil];
                break;
            case HDFastBoardFileTypevideo:
                break;
            case HDFastBoardFileTypemusic:
                break;
            case HDFastBoardFileTypeppt:
                if (item.taskType == WhiteConvertTypeDynamic) {
                    [self->_fastRoom insertPptx:pages
                                           title:item.fileName completionHandler:nil];
                } else {
                    [self->_fastRoom insertStaticDocument:pages
                                                     title:item.fileName completionHandler:nil];
                }
                break;
            case HDFastBoardFileTypeword:
                [self->_fastRoom insertStaticDocument:pages
                                                 title:item.fileName completionHandler:nil];
                break;
            case HDFastBoardFileTypeunknown:
                break;
        }
    }];
}

- (void)onReload {
    UIApplication.sharedApplication.keyWindow.rootViewController = [HDFastboardViewController new];
}

// MARK: - Private
- (void)setupFastboardWithCustom: (id<FastRoomOverlay>)custom {
//    Fastboard.globalFastboardRatio = 16.0 / 9.0;
    FastRoomConfiguration* config = [[FastRoomConfiguration alloc] initWithAppIdentifier:[RoomInfo getValueFrom:RoomInfoAPPID]
                                                                                roomUUID:[RoomInfo getValueFrom:RoomInfoRoomID]
                                                                               roomToken:[RoomInfo getValueFrom:RoomInfoRoomToken]
                                                                                  region:FastRegionCN
                                                                                 userUID:@"some-unique"];
    config.customOverlay = custom;
    _fastRoom = [Fastboard createFastRoomWithFastRoomConfig:config];
    FastRoomView *fastRoomView = _fastRoom.view;
    _fastRoom.delegate = self;
    [_fastRoom joinRoom];
    [self.view addSubview:fastRoomView];
    self.view.autoresizesSubviews = TRUE;
    fastRoomView.frame = self.view.bounds;
    fastRoomView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _fastRoom.roomDelegate = self;
}

- (void)setupTools {
//    [self.view addSubview:self.scrollView];
//    [self.scrollView addSubview:self.stackView];
//    self.stackView.axis = UILayoutConstraintAxisVertical;
//    self.stackView.distribution = UIStackViewDistributionFillEqually;
//
//    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.top.equalTo(self.view).inset(10);
//        make.right.equalTo(self.view).inset(88);
//        make.width.equalTo(@120);
//    }];
//    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.scrollView);
//        make.width.equalTo(@120);
//    }];
}

- (void)reloadFastboardOverlay: (id<FastRoomOverlay>)custom {
    [_fastRoom.view removeFromSuperview];
    [self setupFastboardWithCustom:custom];
    [self.view bringSubviewToFront:self.stackView];
}

- (Theme)nextThemeFor: (Theme)theme {
    if (@available(iOS 13.0, *)) {
        if ([theme isEqualToString:ThemeAuto]) {
            return ThemeLight;
        } else if ([theme isEqualToString:ThemeLight]) {
            return ThemeDark;
        } else {
            return ThemeAuto;
        }
    } else {
        if ([theme isEqualToString:ThemeAuto]) {
            return ThemeLight;
        } else if ([theme isEqualToString:ThemeLight]) {
            return ThemeDark;
        } else {
            return ThemeLight;
        }
    }
}

- (void)applyTheme: (Theme)theme {
    UIButton* themeBtn = [self.stackView arrangedSubviews][0];
    [themeBtn setTitle:theme forState:UIControlStateNormal];
    if ([theme isEqualToString:ThemeAuto]) {
        [FastRoomThemeManager.shared apply:FastRoomDefaultTheme.defaultAutoTheme];
    } else if ([theme isEqualToString:ThemeLight]) {
        [FastRoomThemeManager.shared apply:FastRoomDefaultTheme.defaultDarkTheme];
    } else if ([theme isEqualToString:ThemeDark]) {
        [FastRoomThemeManager.shared apply:FastRoomDefaultTheme.defaultAutoTheme];
    }
}

- (NSArray<UIButton *> *)setupButtons {
    NSArray* titles = @[@"Theme",
                        @"UserTheme",
                        @"Direction",
                        @"PhoneItems",
                        @"PadItems",
                        @"BarSize",
                        @"Icons",
                        @"HideAll",
                        @"HideItem",
                        @"Writable",
                        @"Custom",
                        @"Layout",
                        @"Reload",
                        @"Pencil",
                        @"InsertPPTX",
                        @"InsertDOC",
                        @"InsertPDF",
                        @"InsertPPT",
                        @"InsertMP4",
                        @"InsertMP3",
                        @"InsertIMAGE",];
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
    }
    return _stackView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor redColor];
    }
    return _scrollView;
}


// MARK: - Fastboard Delegate
- (void)fastboard:(Fastboard * _Nonnull)fastboard error:(FastRoomError * _Nonnull)error {
    NSLog(@"error %@", error);
}

- (void)fastboardPhaseDidUpdate:(Fastboard * _Nonnull)fastboard phase:(enum FastRoomPhase)phase {
    NSLog(@"phase, %d", (int)phase);
}

- (void)fastboardUserKickedOut:(Fastboard * _Nonnull)fastboard reason:(NSString * _Nonnull)reason {
    NSLog(@"kicked out");
}

- (void)fastboardDidJoinRoomSuccess:(FastRoom * _Nonnull)fastboard room:(WhiteRoom * _Nonnull)room {
    NSLog(@"fastboardDidJoinRoomSuccess = %@ == %@",fastboard.room.uuid,fastboard.room.roomMembers);
}


- (void)fastboardDidOccurError:(FastRoom * _Nonnull)fastboard error:(FastRoomError * _Nonnull)error {
    NSLog(@"fastboardDidOccurError");
}
// MARK: - WhiteRoomCallbackDelegate
-(void)fireRoomStateChanged:(WhiteRoomState *)modifyState{
    
    
    NSLog(@"fireRoomStateChanged = %@",modifyState);
}
@end
