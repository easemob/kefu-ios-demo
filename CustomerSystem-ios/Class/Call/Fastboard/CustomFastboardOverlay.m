//
//  CustomFastboardOverlay.m
//  OCExample
//
//  Created by xuyunshi on 2022/1/11.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

#import "CustomFastboardOverlay.h"
#import <Fastboard/Fastboard-Swift.h>
#import <Whiteboard/Whiteboard.h>
#import <HDMasonry/HDMasonry.h>

@interface CustomFastboardOverlay() <FastboardOverlay>
@property (nonatomic, strong) FastPanel* operationsPanel;
@end

@implementation CustomFastboardOverlay
- (void)setAllPanelWithHide:(BOOL)hide {
    for (FastPanel* panel in [self allPanels]) {
        [panel.view setHidden:hide];
    }
}

- (void)setPanelItemHideWithItem:(DefaultOperationIdentifier * _Nonnull)item hide:(BOOL)hide {
    for (FastPanel* panel in [self allPanels]) {
        [panel setItemHideFromKey:item hide:hide];
    }
}

- (void)itemWillBeExecutionWithFastPanel:(FastPanel * _Nonnull)fastPanel item:(id<FastOperationItem> _Nonnull)item {
    
}

- (void)setupWithRoom:(WhiteRoom * _Nonnull)room fastboardView:(FastboardView * _Nonnull)fastboardView direction:(enum OperationBarDirection)direction {
    
    UIView* operationView = [self.operationsPanel setupWithRoom:room
                              direction:direction
                                   mask:kCALayerMinXMinYCorner || kCALayerMaxXMinYCorner];
    [fastboardView addSubview:operationView];
    [operationView hdmas_makeConstraints:^(HDMASConstraintMaker *make) {
        make.centerX.equalTo(fastboardView.whiteboardView);
        make.bottom.equalTo(fastboardView.whiteboardView);
    }];
}

- (void)updateControlBarLayoutWithDirection:(enum OperationBarDirection)direction {
    
}

- (void)updateRedoEnable:(BOOL)enable {
    
}

- (void)updateSceneState:(WhiteSceneState * _Nonnull)scene {
    
}

- (void)updateStrokeColor:(UIColor * _Nonnull)color {
    
}

- (void)updateStrokeWidth:(float)width {
    
}

- (void)updateUIWithInitAppliance:(WhiteApplianceNameKey _Nullable)appliance shape:(WhiteApplianceShapeTypeKey _Nullable)shape {
    if (appliance) {
        [self.operationsPanel updateWithApplianceOutside:appliance shape:shape];
    }
}

- (void)updateUndoEnable:(BOOL)enable {
    
}

- (FastPanel*)createOperationPanel {
    NSMutableArray* items = [NSMutableArray array];
    DefaultOperationItem* pencil = [DefaultOperationItem selectableApplianceItem:AppliancePencil shape:nil];
    DefaultOperationItem* eraser = [DefaultOperationItem selectableApplianceItem:ApplianceEraser shape:nil];
    [items addObject:pencil];
    [items addObject:eraser];
    return [[FastPanel alloc] initWithItems:items];
}

// MARK: - Getter
- (NSArray<FastPanel*>*)allPanels {
    return @[self.operationsPanel];
}

- (FastPanel *)operationsPanel {
    if (!_operationsPanel) {
        _operationsPanel = [self createOperationPanel];
    }
    return _operationsPanel;
}
@end
