
#import <UIKit/UIKit.h>

#define KCELLDEFAULTHEIGHT 50

@interface HDVECRefreshTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_rightItems;
}

@property (strong, nonatomic) NSArray *rightItems;
@property (strong, nonatomic) UIView *defaultFooterView;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableDictionary *dataDictionary;
@property (nonatomic) int page;

@property (nonatomic) BOOL showRefreshHeader;
@property (nonatomic) BOOL showRefreshFooter;
@property (nonatomic) BOOL showTableBlankView;

- (instancetype)initWithStyle:(UITableViewStyle)style;

- (void)tableViewDidTriggerHeaderRefresh;
- (void)tableViewDidTriggerFooterRefresh;

- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload;

@end