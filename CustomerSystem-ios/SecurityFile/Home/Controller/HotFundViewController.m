//
//  HotFundViewController.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 17/6/20.
//  Copyright © 2017年 easemob. All rights reserved.
//

#import "HotFundViewController.h"
#import "MoreChoiceView.h"
#import "HotFundCell.h"
#import "HotFundModel.h"
#import "FundDetailsViewController.h"

@interface HotFundViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UIWindow *_window;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) MoreChoiceView *choiceView;
@end

@implementation HotFundViewController

- (NSArray *)dataArray
{
    if (_dataArray == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"hotFundInfo.plist" ofType:nil];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *temp = [NSMutableArray array];
        // 字典转模型
        for (NSDictionary *hotFundDict in array) {
            HotFundModel *model = [HotFundModel hotFundWithDict:hotFundDict];
            [temp addObject:model];
        }
        _dataArray = temp;
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    
    self.view.backgroundColor = RGBACOLOR(247, 247, 247, 1);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hotResignWindowClick) name:@"hotResignWindow" object:nil];
    
    [self setNavTitleView];
    [self setupBarButtonItem];
    [self setUI];
    
}

- (void)hotResignWindowClick
{
    _window.hidden = YES;
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"Path"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer.width = -15;
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer,backItem];

    
    UIButton *chatButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 17)];
    [chatButton setImage:[UIImage imageNamed:@"GroupWrite"] forState:UIControlStateNormal];
    [chatButton addTarget:self action:@selector(chatItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *chatItem = [[UIBarButtonItem alloc] initWithCustomView:chatButton];
    UIBarButtonItem *nagetiveSpacerChat = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacerChat.width = 0;
    self.navigationItem.rightBarButtonItems = @[nagetiveSpacerChat,chatItem];
    
}

- (void)back
{
    [self hotResignWindowClick];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chatItemAction
{
    if (_choiceView.hidden) {
        _choiceView.hidden = NO;
        [_window makeKeyAndVisible];
    } else {
        _choiceView.hidden = YES;
        _window.hidden = YES;
    }
}

- (void)setNavTitleView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 152, 30)];
    view.backgroundColor = RGBACOLOR(104, 110, 124, 1);
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 15;
    NSArray *array = @[@"排行",@"自选"];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:array];
    segment.frame = CGRectMake(1, 1, 150, 28);
    [segment setTitle:array[0] forSegmentAtIndex:0];
    [segment setTitle:array[1] forSegmentAtIndex:1];
    segment.selectedSegmentIndex = 0;
    segment.clipsToBounds = YES;
    segment.layer.cornerRadius = 15;
    segment.tintColor = [UIColor clearColor];
    //定义选中状态的样式selected，类型为字典  RGBACOLOR(189, 192, 194,1)
    NSDictionary *selected = @{NSFontAttributeName:[UIFont systemFontOfSize:15],
                               NSForegroundColorAttributeName:RGBACOLOR(189, 192, 194,1)};
    //定义未选中状态下的样式normal，类型为字典
    NSDictionary *normal = @{NSFontAttributeName:[UIFont systemFontOfSize:15],
                             NSForegroundColorAttributeName:RGBACOLOR(123, 123, 123,1)};
    
    [segment setTitleTextAttributes:normal forState:UIControlStateNormal];
    [segment setTitleTextAttributes:selected forState:UIControlStateSelected];
    
    [segment setBackgroundImage:[self createImageWithColor:RGBACOLOR(60, 66, 83,1)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [segment setBackgroundImage:[self createImageWithColor:RGBACOLOR(104, 110, 124,1)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [view addSubview:segment];
    
    self.navigationItem.titleView = view;
}

- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)setUI
{
    UIImageView *imageVC = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight * 0.057) ];
    imageVC.image = [UIImage imageNamed:@"img2"];
    [self.view addSubview:imageVC];
    
    UIView *listView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageVC.frame) + 10, kScreenWidth, 38)];
    listView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:listView];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    topLine.backgroundColor = RGBACOLOR(226, 226, 226, 1);
    [listView addSubview:topLine];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(19, 12, 50, 14)];
    name.text = @"基金名称";
    name.font = [UIFont systemFontOfSize:12];
    name.textColor = RGBACOLOR(98, 98, 98, 1);
    name.textAlignment = NSTextAlignmentLeft;
    [listView addSubview:name];
    
    UILabel *netValue = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(name.frame) + 140, 12, 25, 14)];
    netValue.text = @"净值";
    netValue.font = [UIFont systemFontOfSize:12];
    netValue.textColor = RGBACOLOR(98, 98, 98, 1);
    netValue.textAlignment = NSTextAlignmentCenter;
    [listView addSubview:netValue];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 10.3 - kScreenWidth*0.0738, 17, 10.3, 5)];
    [button setImage:[UIImage imageNamed:@"Path4"] forState:UIControlStateNormal];
    [listView addSubview:button];
    
    UILabel *rise = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(button.frame) - 46, 12, 37, 14)];
    rise.text = @"日涨幅";
    rise.font = [UIFont systemFontOfSize:12];
    [rise setTextColor:RGBACOLOR(100, 162, 232, 1)];
    rise.textAlignment = NSTextAlignmentLeft;
    [listView addSubview:rise];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(listView.frame), kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    UIView *view = [[UIView alloc] init];
//    self.tableView.tableFooterView = view;
    [self.view addSubview:self.tableView];
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = RGBACOLOR(247, 247, 247, 1);
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, kScreenWidth, 0.5)];
    line.backgroundColor = RGBACOLOR(216, 216, 216, 1);
    [topView addSubview:line];
    self.tableView.tableFooterView = topView;
    
    _choiceView = [[MoreChoiceView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    _choiceView.hidden = YES;
    [self.view addSubview:_choiceView];
    [self.view bringSubviewToFront:_choiceView];
    
    UIImageView *triangleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 12)];
    triangleView.image = [UIImage imageNamed:@"Triangle"];
    _window = [[UIWindow alloc]initWithFrame:CGRectMake(kScreenWidth - 25 - 14.4, 56, 25, 12)];
    _window.windowLevel = UIWindowLevelAlert+1;
    _window.backgroundColor = [UIColor clearColor];
    _window.hidden = YES;
    [_window addSubview:triangleView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"HotFundCell";
    HotFundCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HotFundCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HotFundModel *model = self.dataArray[indexPath.row];
    cell.hotFundModel = model;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resignWindow" object:nil];
    FundDetailsViewController *fundDetailsVC = [[FundDetailsViewController alloc] init];
    HotFundModel *model = self.dataArray[indexPath.row];
    fundDetailsVC.model = model;
    fundDetailsVC.title = @"基金详情";
    [self.navigationController pushViewController:fundDetailsVC animated:YES];
}

@end
