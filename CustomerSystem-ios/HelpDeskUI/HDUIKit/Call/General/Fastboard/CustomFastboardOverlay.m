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

@interface CustomFastboardOverlay() <FastRoomOverlay,FastRoomOperationItem>
@property (nonatomic, strong) FastRoomPanel* operationsPanel;
@end

@implementation CustomFastboardOverlay
- (void)setAllPanelWithHide:(BOOL)hide {
    for (FastRoomPanel* panel in [self allPanels]) {
        [panel.view setHidden:hide];
    }
}

- (void)setPanelItemHideWithItem:(FastRoomDefaultOperationIdentifier * _Nonnull)item hide:(BOOL)hide {
    for (FastRoomPanel* panel in [self allPanels]) {
        [panel setItemHideFromKey:item hide:hide];
    }
}

- (void)dismissAllSubPanels {
    
}

- (void)itemWillBeExecutionWithFastPanel:(FastRoomPanel * _Nonnull)fastPanel item:(id<FastRoomOperationItem> _Nonnull)item {
    
}

- (void)setupWithRoom:(WhiteRoom * _Nonnull)room fastboardView:(FastRoomView * _Nonnull)fastboardView direction:(enum OperationBarDirection)direction {
    
    UIView* operationView = [self.operationsPanel setupWithRoom:room
                                                      direction:direction
                                                           mask:kCALayerMinXMinYCorner || kCALayerMaxXMinYCorner];
    [fastboardView addSubview:operationView];
    [operationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(fastboardView.whiteboardView);
        make.bottom.equalTo(fastboardView.whiteboardView);
    }];
}

- (void)updateControlBarLayoutWithDirection:(enum OperationBarDirection)direction {
    
}

- (void)updateRedoEnable:(BOOL)enable {
    
}

- (void)updatePageState:(WhitePageState *)state {
    
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

- (void)invalidAllLayout {
    
}


- (void)updateBoxState:(WhiteWindowBoxState _Nullable)state {
    
}


- (void)updateRoomPhaseUpdate:(enum FastRoomPhase)phase {
    
}


- (FastRoomPanel*)createOperationPanel {
    NSMutableArray* items = [NSMutableArray array];
    FastRoomDefaultOperationItem* pencil = [FastRoomDefaultOperationItem selectableApplianceItem:AppliancePencil shape:nil];
    FastRoomDefaultOperationItem* eraser = [FastRoomDefaultOperationItem selectableApplianceItem:ApplianceEraser shape:nil];
    [items addObject:pencil];
    [items addObject:eraser];
    return [[FastRoomPanel alloc] initWithItems:items];
}
// MARK: - Getter
- (NSArray<FastRoomPanel*>*)allPanels {
    return @[self.operationsPanel];
}

- (FastRoomPanel *)operationsPanel {
    if (!_operationsPanel) {
        _operationsPanel = [self createOperationPanel];
    }
    return _operationsPanel;
}
@end
