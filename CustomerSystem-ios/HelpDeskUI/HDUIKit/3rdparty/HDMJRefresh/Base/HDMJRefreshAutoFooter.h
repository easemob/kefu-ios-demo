//
//  HDMJRefreshAutoFooter.h
//  HDMJRefreshExample
//

#import "HDMJRefreshFooter.h"

@interface HDMJRefreshAutoFooter : HDMJRefreshFooter

@property (assign, nonatomic, getter=isAutomaticallyRefresh) BOOL automaticallyRefresh;

@property (assign, nonatomic) CGFloat appearencePercentTriggerAutoRefresh HDMJRefreshDeprecated("请使用automaticallyChangeAlpha属性");
@property (assign, nonatomic) CGFloat triggerAutomaticallyRefreshPercent;
@end
