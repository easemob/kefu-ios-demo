//
//  WritableDetectRoom.m
//  Whiteboard
//
//  Created by xuyunshi on 2022/3/17.
//
#if DEBUG
#import "WritableDetectRoom.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "WhiteRoom+Private.h"

@implementation WritableDetectRoom

static NSMutableArray* assertableMethodNames;

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSString* selStr = NSStringFromSelector(anInvocation.selector);
    
    if ([assertableMethodNames containsObject:selStr]) {
        WhiteRoom* room = anInvocation.target;
        NSAssert(!room.isUpdatingWritable, @"Please do not call %@ when updating", selStr);
        NSAssert(room.isWritable, @"Please do not call %@ when not writable", selStr);
    }
    
    SEL originalSel = NSSelectorFromString([WritableDetectRoom newMethodNameForMethodName:selStr]);
    anInvocation.selector = originalSel;
    [anInvocation invoke];
}

+ (Class)class { return [WhiteRoom class]; }

+ (NSArray<NSString *>*)doNotDetectFunctions {
    return @[@"setViewMode",
             @"setWritable",
             @"setTimeDelay",
             @"disableSerialization",
             @"setObserverId",
             @"setIsUpdatingWritable",
             @"setShouldCheckingRepeatSetWritable",
             @"setDisconnectedBySelf"];
}

+ (NSArray<NSString *>*)additionalDetectFunctions {
    return @[@"dispatchMagixEvent",
             @"pptNextStep",
             @"pptPreviousStep",
             @"putScenes",
             @"cleanScene",
             @"removeScenes",
             @"moveScene",
             @"nextPage",
             @"prevPage",
             @"copy",
             @"paste",
             @"duplicate",
             @"deleteOperation",
             @"redo",
             @"undo",
             @"safeSetAttributes",
             @"safeUpdateAttributes"];
}

+ (void)load {
    Class roomCls = [WhiteRoom class];
    Class newCls = NSClassFromString(@"WritableDetectRoom");
    
    assertableMethodNames = [NSMutableArray array];
    
    unsigned int count;
    Method *methods = class_copyMethodList(roomCls, &count);
    for (int i = 0; i < count; i++) {
        Method method = methods[i];
        SEL selector = method_getName(method);
        NSString *name = NSStringFromSelector(selector);

        BOOL shouldIgnore = NO;
        for (NSString* i in [WritableDetectRoom doNotDetectFunctions]) {
            if ([name containsString:i]) { shouldIgnore = YES; }
        }
        if (shouldIgnore) { continue; }
        
        BOOL additionalDetectFunctions = NO;
        for (NSString* i in [WritableDetectRoom additionalDetectFunctions]) {
            if ([name containsString:i]) { additionalDetectFunctions = YES; }
        }
        
        if (additionalDetectFunctions ||
            [name hasPrefix:@"set"] ||
            [name hasPrefix:@"disable"] ||
            [name hasPrefix:@"insert"] ||
            [name hasPrefix:@"add"]) {
            
            const char *types = method_getTypeEncoding(method);
            SEL newSel = NSSelectorFromString([WritableDetectRoom newMethodNameForMethodName:name]);
            class_addMethod(newCls, newSel, method_getImplementation(method), types);
            class_addMethod(newCls, selector, _objc_msgForward, types);
            
            [assertableMethodNames addObject:name];
        }
    }
}

+ (NSString *)newMethodNameForMethodName:(NSString *)name {
    return [NSString stringWithFormat:@"__white__%@", name];
}

+ (void)startObserveRoom:(WhiteRoom *)room {
    object_setClass(room, NSClassFromString(@"WritableDetectRoom"));
}

@end
#endif
