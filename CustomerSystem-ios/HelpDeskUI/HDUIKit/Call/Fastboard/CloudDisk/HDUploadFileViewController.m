//
//  HDUploadFileViewController.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/4/8.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDUploadFileViewController.h"
#import "HDControlBarView.h"
#import "KFICloudManager.h"
@interface HDUploadFileViewController ()<UIDocumentPickerDelegate>
@property (nonatomic, strong) HDControlBarView *barView;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIDocumentPickerViewController *documentPickerVC;
@end

@implementation HDUploadFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(22);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.height.offset(44);
        
        
    }];
    
    [self.view addSubview: self.barView];
    [self.barView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.height.offset(188);
        
        
    }];
    [self.barView layoutIfNeeded];
    [self initData];
}
-(void)initData{
    HDControlBarModel * barModel = [HDControlBarModel new];
    barModel.itemType = HDControlBarItemTypeMute;
    barModel.name=@"上传图片";
    barModel.imageStr= kjinmai;
    barModel.selImageStr= kmaikefeng1;
    
    HDControlBarModel * barModel1 = [HDControlBarModel new];
    barModel1.itemType = HDControlBarItemTypeVideo;
    barModel1.name=@"上传视频";
    barModel1.imageStr=kguanbishexiangtou1;
    barModel1.selImageStr=kshexiangtou1;
    
    HDControlBarModel * barModel2 = [HDControlBarModel new];
    barModel2.itemType = HDControlBarItemTypeHangUp;
    barModel2.name=@"上传音频";
    barModel2.imageStr=kguaduan1;
    barModel2.selImageStr=kguaduan1;
    
    HDControlBarModel * barModel3 = [HDControlBarModel new];
    barModel3.itemType = HDControlBarItemTypeShare;
    barModel3.name=@"上传文件";
    barModel3.imageStr=kpingmugongxiang2;
    barModel3.selImageStr=kpingmugongxiang2;
    
    NSArray * selImageArr = @[barModel,barModel1,barModel2,barModel3];
    
    [self.barView buttonFromArrBarModels:selImageArr view:self.barView withButtonType:HDControlBarButtonStyleUploadFile];
    
}

#pragma mark - event
-(void)muteBtnClicked:(UIButton *)sender{
    
    
    
}

-(void)videoBtnClicked:(UIButton *)sender{
    
    
    
}
-(void)imgBtnClicked:(UIButton *)sender{
    
    
    
}
-(void)uploadFileBtnClicked:(UIButton *)sender{

    [self presentDocumentPicker];
}

#pragma mark - 文件上传
- (void)presentDocumentPicker {

    [self presentViewController:self.documentPickerVC animated:YES completion:nil];
}
- (UIDocumentPickerViewController *)documentPickerVC {
    if (!_documentPickerVC) {
        NSArray *documentTypes = @[@"public.content", @"public.text", @"public.source-code ", @"public.image", @"public.audiovisual-content", @"com.adobe.pdf", @"com.apple.keynote.key", @"com.microsoft.word.doc", @"com.microsoft.excel.xls", @"com.microsoft.powerpoint.ppt"];
        self.documentPickerVC = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes inMode:UIDocumentPickerModeOpen];
        _documentPickerVC.delegate = self;
        _documentPickerVC.modalPresentationStyle = UIModalPresentationFormSheet; //设置模态弹出方式
    }
    return _documentPickerVC;
}

#pragma mark - UIDocumentPickerDelegate
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    //获取授权
    BOOL fileUrlAuthozied = [urls.firstObject startAccessingSecurityScopedResource];
    if (fileUrlAuthozied) {
        //通过文件协调工具来得到新的文件地址，以此得到文件保护功能
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
        NSError *error;
        
        [fileCoordinator coordinateReadingItemAtURL:urls.firstObject options:0 error:&error byAccessor:^(NSURL *newURL) {
            //读取文件
            if (error) {
                //读取出错
            } else {
                //文件 上传或者其它操作
//                [self uploadingWithFileData:fileData fileName:fileName fileURL:newURL];
                NSLog(@"------------->文件 上传或者其它操作");
                
                NSArray *array = [[newURL absoluteString] componentsSeparatedByString:@"/"];
                NSString *fileName = [array lastObject];
                fileName = [fileName stringByRemovingPercentEncoding];
                
//                if ([iCloudManager iCloudEnable]) {
                    [KFICloudManager downloadWithDocumentURL:newURL callBack:^(id obj) {
                        NSData *data = obj;
                        //写入沙盒Documents
                        NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",fileName]];
                        [self writeToFile:docPath withData:data];
                    }];
//                }
            }
            [self dismissViewControllerAnimated:YES completion:NULL];
        }];
        [urls.firstObject stopAccessingSecurityScopedResource];
    } else {
        //授权失败
    }
}

- (void)writeToFile:(NSString *)path withData:(NSData *)data{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //访问【沙盒的document】目录下的问题件，该目录下支持手动增加、修改、删除文件及目录
//    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/文档.docx"];
    if(![fileManager fileExistsAtPath:path]){
        //如果不存在
        BOOL success =   [data writeToFile:path atomically:YES];
        
        if (success) {
            //取出来
//            NSData *   datastr = [NSData dataWithContentsOfFile:path];
//            NSLog(@"------------->文件 上传或者其它操作==%@",datastr);
        }
        
    }else{
        //取出来 发送
//        NSData *   datastr = [NSData dataWithContentsOfFile:path];
//        NSLog(@"------------->文件 上传或者其它操作==%@",datastr);
       
    }
}

#pragma mark - event
- (void)dismissViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - lzye

- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc] init];
        UIButton * backBtn = [[UIButton alloc] init];
        [backBtn setTitle:@"云盘" forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:backBtn];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_navView.mas_centerY);
            make.leading.offset(20);
            make.width.height.offset(44);
        }];
        
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:18.0f];
        titleLabel.text = @"上传";
        [_navView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_navView.mas_centerY);
            make.centerX.mas_equalTo(_navView.mas_centerX);
        }];
        
    }
    
    return _navView;
}
- (HDControlBarView *)barView {
    if (!_barView) {
        _barView = [[HDControlBarView alloc]init];
//        _barView.backgroundColor = [UIColor redColor];
        __weak __typeof__(self) weakSelf = self;
        _barView.clickControlBarItemBlock = ^(HDControlBarModel * _Nonnull barModel, UIButton * _Nonnull btn) {
            
            switch (barModel.itemType) {
                case HDControlBarItemTypeMute:
                    [weakSelf muteBtnClicked:btn];
                    break;
                case HDControlBarItemTypeVideo:
                    [weakSelf videoBtnClicked:btn];
                    break;
                case HDControlBarItemTypeImage:
                    [weakSelf imgBtnClicked:btn];
                    break;
                case HDControlBarItemTypeFile:
                    [weakSelf uploadFileBtnClicked:btn];
                    break;
               
                    
                default:
                    break;
            }
            
        };
       
    }
    return _barView;
}

@end
