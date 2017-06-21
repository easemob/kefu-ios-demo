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
    
    self.view.backgroundColor = RGBACOLOR(233, 233, 233, 1);
    
    [self setNavTitleView];
    [self setupBarButtonItem];
    [self setUI];
    
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
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    UIButton *chatButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 17)];
    [chatButton setImage:[UIImage imageNamed:@"GroupWrite"] forState:UIControlStateNormal];
    [chatButton addTarget:self action:@selector(chatItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithCustomView:chatButton];
    [self.navigationItem setRightBarButtonItem:sendItem];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chatItemAction
{
    if (_choiceView.hidden) {
        _choiceView.hidden = NO;
    } else {
        _choiceView.hidden = YES;
    }
    
}

- (void)setNavTitleView
{
    NSArray *array = @[@"排行",@"自选"];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:array];
    segment.frame = CGRectMake(0, 0, 140, 30);
    [segment setTitle:array[0] forSegmentAtIndex:0];
    [segment setTitle:array[1] forSegmentAtIndex:1];
    segment.selectedSegmentIndex = 0;
    segment.clipsToBounds = YES;
    segment.layer.cornerRadius = 14;
    segment.tintColor = [UIColor clearColor];
    //定义选中状态的样式selected，类型为字典
    NSDictionary *selected = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                               NSForegroundColorAttributeName:RGBACOLOR(158, 163, 171,1)};
    //定义未选中状态下的样式normal，类型为字典
    NSDictionary *normal = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                             NSForegroundColorAttributeName:RGBACOLOR(158, 163, 171,1)};
    
    [segment setTitleTextAttributes:normal forState:UIControlStateNormal];
    [segment setTitleTextAttributes:selected forState:UIControlStateSelected];
    
    [segment setBackgroundImage:[self createImageWithColor:RGBACOLOR(60, 66, 83,1)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [segment setBackgroundImage:[self createImageWithColor:RGBACOLOR(104, 109, 124,1)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.titleView = segment;
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
    UIImageView *imageVC = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) ];
    imageVC.image = [UIImage imageNamed:@"img2"];
    [self.view addSubview:imageVC];
    
    UIView *listView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageVC.frame) + 10, kScreenWidth, 40)];
    listView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:listView];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth*0.4, 20)];
    name.text = @"基金名称";
    name.font = [UIFont systemFontOfSize:10];
    name.textAlignment = NSTextAlignmentLeft;
    [listView addSubview:name];
    
    UILabel *netValue = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(name.frame), 10, kScreenWidth * 0.3, 20)];
    netValue.text = @"净值";
    netValue.font = [UIFont systemFontOfSize:10];
    netValue.textAlignment = NSTextAlignmentCenter;
    [listView addSubview:netValue];
    
    UILabel *rise = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(netValue.frame) + 30, 10, 40, 20)];
    rise.text = @"日涨幅";
    rise.font = [UIFont systemFontOfSize:10];
    [rise setTextColor:[UIColor blueColor]];
    rise.textAlignment = NSTextAlignmentLeft;
    [listView addSubview:rise];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rise.frame), 10, 20, 20)];
    [button setImage:[UIImage imageNamed:@"Path4"] forState:UIControlStateNormal];
    [listView addSubview:button];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(listView.frame), kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    [self.view addSubview:self.tableView];
    
    _choiceView = [[MoreChoiceView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    _choiceView.hidden = YES;
    [self.view addSubview:_choiceView];
    [self.view bringSubviewToFront:_choiceView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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
    FundDetailsViewController *fundDetailsVC = [[FundDetailsViewController alloc] init];
    HotFundModel *model = self.dataArray[indexPath.row];
    fundDetailsVC.model = model;
    fundDetailsVC.title = @"基金详情";
    [self.navigationController pushViewController:fundDetailsVC animated:YES];
}

@end
