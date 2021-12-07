#import <UIKit/UIKit.h>
#import <objc/message.h>

#define HDMJWeakSelf __weak typeof(self) weakSelf = self;

#ifdef DEBUG
#define HDMJRefreshLog(...) NSLog(__VA_ARGS__)
#else
#define HDMJRefreshLog(...)
#endif

#define HDMJRefreshDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

#define HDMJRefreshMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define HDMJRefreshMsgTarget(target) (__bridge void *)(target)

#define HDMJRefreshColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define HDMJRefreshLabelTextColor HDMJRefreshColor(90, 90, 90)
#define HDMJRefreshLabelFont [UIFont boldSystemFontOfSize:14]
#define HDMJRefreshSrcName(file) [@"HDMJRefresh.bundle" stringByAppendingPathComponent:file]
#define HDMJRefreshFrameworkSrcName(file) [@"Frameworks/HDMJRefresh.framework/HDMJRefresh.bundle" stringByAppendingPathComponent:file]

UIKIT_EXTERN const CGFloat HDMJRefreshHeaderHeight;
UIKIT_EXTERN const CGFloat HDMJRefreshFooterHeight;
UIKIT_EXTERN const CGFloat HDMJRefreshFastAnimationDuration;
UIKIT_EXTERN const CGFloat HDMJRefreshSlowAnimationDuration;

UIKIT_EXTERN NSString *const HDMJRefreshKeyPathContentOffset;
UIKIT_EXTERN NSString *const HDMJRefreshKeyPathContentSize;
UIKIT_EXTERN NSString *const HDMJRefreshKeyPathContentInset;
UIKIT_EXTERN NSString *const HDMJRefreshKeyPathPanState;
UIKIT_EXTERN NSString *const HDMJRefreshHeaderLastUpdatedTimeKey;

#define HDMJRefreshCheckState \
HDMJRefreshState oldState = self.state; \
if (state == oldState) return; \
[super setState:state];
