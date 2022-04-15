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
#import "TZImagePickerController.h"
#import "HDAppSkin.h"
#import "HDSanBoxFileManager.h"
#import "MBProgressHUD+Add.h"
//分隔符
#define YFBoundary @"AnHuiWuHuYungFan"
//换行
#define YFEnter [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]
//NSString转NSData
#define YFEncode(string) [string dataUsingEncoding:NSUTF8StringEncoding]


@interface HDUploadFileViewController ()<UIDocumentPickerDelegate,TZImagePickerControllerDelegate,NSURLSessionTaskDelegate>
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
    
    
    [self upload];
}
-(void)initData{
    HDControlBarModel * barModel = [HDControlBarModel new];
    barModel.itemType = HDControlBarItemTypeImage;
    barModel.name=@"上传图片";
    barModel.imageStr= @"tupian";
    barModel.selImageStr= @"tupian";
    
    HDControlBarModel * barModel1 = [HDControlBarModel new];
    barModel1.itemType = HDControlBarItemTypeVideo;
    barModel1.name=@"上传视频";
    barModel1.imageStr= @"shipin";
    barModel1.selImageStr= @"shipin";
    
    HDControlBarModel * barModel2 = [HDControlBarModel new];
    barModel2.itemType = HDControlBarItemTypeMute;
    barModel2.name=@"上传音频";
    barModel2.imageStr=@"yinpin";
    barModel2.selImageStr=@"yinpin";
    
    HDControlBarModel * barModel3 = [HDControlBarModel new];
    barModel3.itemType = HDControlBarItemTypeFile;
    barModel3.name=@"上传文件";
    barModel3.imageStr=@"wendangzhongxin";
    barModel3.selImageStr=@"wendangzhongxin";
    
    NSArray * selImageArr = @[barModel,barModel1,barModel2,barModel3];
    
    [self.barView hd_buttonFromArrBarModels:selImageArr view:self.barView withButtonType:HDControlBarButtonStyleUploadFile];
    
}

#pragma mark - event
-(void)muteBtnClicked:(UIButton *)sender{
    
    [self presentDocumentPicker];
    
}

-(void)videoBtnClicked:(UIButton *)sender{
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.allowPickingImage = NO;
    imagePickerVc.allowPickingVideo = YES;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

        
        
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}
-(void)imgBtnClicked:(UIButton *)sender{
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingVideo = NO;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

        
        
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
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
                
                if ([KFICloudManager iCloudEnable]) {
                    [KFICloudManager downloadWithDocumentURL:newURL callBack:^(id obj) {
                        NSData *data = obj;
                        //写入沙盒Library 并创建文件夹
                        [self writeToFileData:data withFileName:fileName];
                    }];
                }
            }
//            [self dismissViewControllerAnimated:YES completion:NULL];
        }];
        [urls.firstObject stopAccessingSecurityScopedResource];
    } else {
        //授权失败
    }
}

- (void)writeToFileData:(NSData *)data withFileName:(NSString *)fileName{
    //获取创建library 下文件夹
    NSString * fileDir = [NSString stringWithFormat:@"%@/whiteBoard/%@",[HDSanBoxFileManager libraryDir],fileName];
    NSError * error;
    
//    NSString *  str = [NSString stringWithFormat:@"%@",data];
//    
//    MBProgressHUD *hud = [MBProgressHUD showMessag:str toView:self.view];
//    hud.layer.zPosition = 1.f;
    BOOL success = [HDSanBoxFileManager createFileAtPath:fileDir content:data overwrite:NO error:&error];
       
    if (success) {
        
        [self hd_uploadFile:data withFileName:fileName withFilePath:fileDir];
    }
}

- (void)hd_uploadFile:(NSData *)data withFileName:(NSString *)fileName withFilePath:(NSString *)filePath{

    NSProgress  * __autoreleasing progress = [NSProgress new];
//    MBProgressHUD *hud = [MBProgressHUD showMessag:NSLocalizedString(@"uploading...", "Upload attachment") toView:self.view];
//    hud.layer.zPosition = 1.f;
//    __weak MBProgressHUD *weakHud = hud;
//    [[HDClient sharedClient].whiteboardManager whiteBoardUploadFileWithSessionId:@"kefuchannelimid_248171" file:data fileName:filePath progress:&progress completion:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
//        [weakHud hideAnimated:YES];
        
//    }];
    
   NSLog(@"%lf",1.0 *progress.completedUnitCount / progress.totalUnitCount);
    
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
        [backBtn setTitle:@"" forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
        UIImage * img = [UIImage imageWithIcon:kfanhui inFont:kfontName size:30 color:[[HDAppSkin mainSkin] contentColorGray1] ];

        [backBtn setImage:img forState:UIControlStateNormal];
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

- (void)upload {

    //1、确定URL
    NSURL *url = [NSURL URLWithString:@"http://sandbox.kefu.easemob.com/v1/agorartc/tenant/77556/whiteboard/call/123/conversion/upload"];
    //2、确定请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //3、设置请求头
    NSString *head = [NSString stringWithFormat:@"multipart/form-data;boundary=%@", YFBoundary];
    [request setValue:head forHTTPHeaderField:@"Content-Type"];
    //4、设置请求方式，上传时必须是Post请求
    request.HTTPMethod = @"POST";
    //5、创建NSURLSession
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    //6、获取上传的数据
    NSData *uploadData = [self getData];
    //7、创建上传任务 上传的数据来自getData方法
    NSURLSessionUploadTask *task = [session uploadTaskWithRequest:request fromData:uploadData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        NSLog(@"==%@",response);
        
       //上传成功以后改变UILabel文本为服务器返回的数据
//       self.uploadInfo.text =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    }];
    //8、执行上传任务
    [task resume];
    
}


/**
 *  设置请求体
 *
 *  @return 请求体内容
 */
-(NSData *)getData
{
    NSMutableData *data = [NSMutableData data];
    
    //1、开始标记
    //--
    [data appendData:YFEncode(@"--")];
    //boundary
    [data appendData:YFEncode(YFBoundary)];
    //换行符
    [data appendData:YFEnter];
    //文件参数名 Content-Disposition: form-data; name="myfile"; filename="wall.jpg"
    [data appendData:YFEncode(@"Content-Disposition:form-data; name=\"file\"; filename=\"wall.jpg\"")];
    //换行符
    [data appendData:YFEnter];
    //Content-Type 上传文件的类型 MIME
    [data appendData:YFEncode(@"Content-Type:image/jpeg")];
    //换行符
    [data appendData:YFEnter];
    //换行符
    [data appendData:YFEnter];
    //2、上传的文件数据
    
    //图片数据  并且转换为Data
    UIImage *image = [UIImage imageNamed:@"videoMuteButtonSelected"];
    NSData *imagedata = UIImageJPEGRepresentation(image, 1.0);
    [data appendData:imagedata];
    //换行符
    [data appendData:YFEnter];
 
    //3、结束标记
    //--
    [data appendData:YFEncode(@"--")];
    //boundary
    [data appendData:YFEncode(YFBoundary)];
    //--
    [data appendData:YFEncode(@"--")];
    //换行符
    [data appendData:YFEnter];
    
    return data;
    
}

#pragma mark - 代理方法 只要给服务器上传数据就会调用 可以计算出上传进度
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{

    //设置进度条
//    self.uploadProgress.progress = 1.0 * totalBytesSent / totalBytesExpectedToSend;
}
@end
