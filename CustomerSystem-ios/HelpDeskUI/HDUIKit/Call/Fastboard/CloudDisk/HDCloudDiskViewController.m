//
//  HDCloudDiskViewController.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/4/8.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDCloudDiskViewController.h"
#import "HDCloudDiskTableViewCell.h"
#import "HDUploadFileViewController.h"
@interface HDCloudDiskViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) NSMutableArray *deleteArray;//删除的数据
@property (nonatomic ,assign) BOOL isInsertEdit;//tableview编辑方式的判断
@property (nonatomic ,strong) UIButton *btn;//编辑按钮
@property (nonatomic ,strong) UIButton * btnContent;//显示内容



@end

@implementation HDCloudDiskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化数据
    [self initData];
    [self.view addSubview:self.headView];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headView.size.height, self.view.size.width, self.view.size.height-self.headView.size.height)];
    self.tableView.backgroundColor = [UIColor yellowColor];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(HDCloudDiskTableViewCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(HDCloudDiskTableViewCell.class)];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
- (void)initData{
    NSMutableArray * mArray = [[NSMutableArray alloc] init];
    HDCloudDiskModel * model = [[HDCloudDiskModel alloc] init];
    model.fileType = HDFastBoardFileTypeimg;
    model.fileName = @"aaa.png";
    model.fileSize = @"12.4kb";
    model.uploadDate= @"2020年4月8日 09:05";
    HDCloudDiskModel * model1 = [[HDCloudDiskModel alloc] init];
    model1.fileType = HDFastBoardFileTypeimg;
    model1.fileName = @"aaa.png";
    model1.fileSize = @"12.4kb";
    model1.uploadDate= @"2020年4月8日 09:05";
    
    [mArray addObject:model];
    [mArray addObject:model1];
    self.dataArray = mArray;
    
}
#pragma mark - event
- (void)dismissViewController{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

// 上传文件
- (void)addUploadDiskAction:(UIButton *)sender{
    
    HDUploadFileViewController * vc = [[HDUploadFileViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];

}
//编辑
- (void)editDiskAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    if (sender.selected) {
    //点击编辑的时候清空删除数组
        [self.deleteArray removeAllObjects];
//        [_btn setTitle:@"完成" forState:UIControlStateNormal];
        _isInsertEdit = YES;//这个时候是全选模式
        [_tableView setEditing:YES animated:YES];
            //改变头试图的值
        
    }else{
        self.btnContent.userInteractionEnabled = NO;
        [self.btnContent setTitle:@"已经使用12MB" forState:UIControlStateNormal];
        _isInsertEdit = NO;
        [_tableView setEditing:NO animated:YES];
        
    }
}
/**
 删除数据方法
 */
- (void)deleteData{
    if (self.deleteArray.count >0) {
        [self.dataArray removeObjectsInArray:self.deleteArray];
        [self.tableView reloadData];
    }
    
}
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  66;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDCloudDiskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(HDCloudDiskTableViewCell.class) forIndexPath:indexPath];
    [cell setCloudDiskModel:[self.dataArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //根据不同状态返回不同编辑模式
    if (_isInsertEdit) {
        
        return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
        
    }else{
        
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    
    //左滑删除数据方法
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataArray removeObjectAtIndex: indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //正常状态下，点击cell进入跳转下一页
    //在编辑模式下点击cell 是选中数据
    if (self.btn.selected) {
         NSLog(@"选中");
        self.btnContent.userInteractionEnabled = YES;
        [self.btnContent setTitle:@"删除" forState:UIControlStateNormal];
        [self.deleteArray addObject:[self.dataArray objectAtIndex:indexPath.row]];

    }else{
        NSLog(@"跳转下一页");
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
//    if (self.btn.selected) {
//        NSLog(@"撤销");
//        [self.deleteArray removeObject:[self.dataArray objectAtIndex:indexPath.row]];
//
//    }else{
//        NSLog(@"取消跳转");
//    }

    
}
#pragma mark - lazy
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (NSMutableArray *)deleteArray{
    if (!_deleteArray) {
        self.deleteArray = [NSMutableArray array];
    }
    return _deleteArray;
}
- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 22+44+44+44)];
        
        _headView.backgroundColor = [UIColor redColor];
        UIButton * addBtn = [[UIButton alloc] init];
        [addBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addUploadDiskAction:) forControlEvents:UIControlEventTouchUpInside];
         
        [_headView addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(25);
            make.trailing.offset(-20);
            make.width.height.offset(44);
        }];
        
        UIView * bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor cyanColor];
        [_headView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(0);
            make.leading.offset(0);
            make.trailing.offset(0);
            make.height.offset(44);
            
        }];
        
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:28.0f];
        titleLabel.text = @"云盘";
        [_headView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(bgView.mas_top).offset(-5);
            make.leading.offset(10);
        }];
        
        UIButton * backBtn = [[UIButton alloc] init];
        [backBtn setTitle:@"退出" forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:backBtn];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(25);
            make.leading.offset(20);
            make.width.height.offset(44);
        }];

        
        
        self.btnContent = [[UIButton alloc] init];
        [self.btnContent setTitle:@"已经使用12MB" forState:UIControlStateNormal];
        [self.btnContent addTarget:self action:@selector(deleteData) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:self.btnContent];
        self.btnContent.userInteractionEnabled = NO;
        [self.btnContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(10);
            make.centerY.equalTo(bgView.mas_centerY);
        
        }];
        
        
        UIButton * btn = [[UIButton alloc] init];
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        [btn setTitle:@"完成" forState:UIControlStateSelected];
        self.btn = btn;
        [btn addTarget:self action:@selector(editDiskAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.offset(-20);
            make.centerY.mas_equalTo(bgView.mas_centerY);
            make.width.height.offset(44);
        }];
        
    }
    return _headView;
}

@end
