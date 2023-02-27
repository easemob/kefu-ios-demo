//
//  HDUploadFileViewController.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/4/8.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDVECUploadFileViewController.h"
#import "HDVECControlBarView.h"
#import "KFICloudManager.h"
#import "TZImagePickerController.h"
#import "HDAppSkin.h"
#import "HDSanBoxFileManager.h"
#import "HDVECWhiteRoomManager.h"

@interface HDVECUploadFileViewController ()<UIDocumentPickerDelegate,TZImagePickerControllerDelegate,NSURLSessionTaskDelegate>{
    NSString *__path;
}
@property (nonatomic, strong) HDVECControlBarView *barView;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIDocumentPickerViewController *documentPickerVC;
/*
 * 弹窗窗口
 */
@property (strong, nonatomic) UIWindow *alertWindow;
@end
static dispatch_once_t onceToken;
static HDVECUploadFileViewController *_manger = nil;
@implementation HDVECUploadFileViewController

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
    
//    [self upload];
}
-(void)initData{
    HDVECControlBarModel * barModel = [HDVECControlBarModel new];
    barModel.itemType = HDVECControlBarItemTypeImage;
    barModel.name= NSLocalizedString(@"video.call.whiteBoard.upload.image", @"上传图片");
    barModel.imageStr= @"tupian";
    barModel.selImageStr= @"tupian";

    HDVECControlBarModel * barModel1 = [HDVECControlBarModel new];
    barModel1.itemType = HDVECControlBarItemTypeVideo;
    barModel1.name= NSLocalizedString(@"video.call.whiteBoard.upload.video", @"上传视频");
    barModel1.imageStr= @"shipin";
    barModel1.selImageStr= @"shipin";
    
    HDVECControlBarModel * barModel2 = [HDVECControlBarModel new];
    barModel2.itemType = HDVECControlBarItemTypeMute;
    barModel2.name= NSLocalizedString(@"video.call.whiteBoard.upload.audio", @"上传音频");
    barModel2.imageStr=@"yinpin";
    barModel2.selImageStr=@"yinpin";
    
    HDVECControlBarModel * barModel3 = [HDVECControlBarModel new];
    barModel3.itemType = HDVECControlBarItemTypeFile;
    barModel3.name= NSLocalizedString(@"video.call.whiteBoard.upload.file", @"上传文件");
    barModel3.imageStr=@"wendangzhongxin";
    barModel3.selImageStr=@"wendangzhongxin";
    
    NSArray * selImageArr = @[barModel,barModel1,barModel2,barModel3];
    
    [self.barView hd_buttonFromArrBarModels:selImageArr view:self.barView withButtonType:HDVECControlBarButtonStyleUploadFile];
    
}

#pragma mark- 单利
 
/** 单利创建
 */
 
+ (instancetype)sharedManager
{
    dispatch_once(&onceToken, ^{
        _manger = [[HDVECUploadFileViewController alloc] init];
        _manger.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _manger.alertWindow.windowLevel = 1;
        _manger.alertWindow.backgroundColor = [UIColor clearColor];
        _manger.alertWindow.rootViewController = [UIViewController new];
        _manger.alertWindow.accessibilityViewIsModal = YES;
        [_manger.alertWindow makeKeyAndVisible];
        _manger.view.frame = [UIScreen mainScreen].bounds;
        [_manger.alertWindow  addSubview:_manger.view];
    });
 
    return _manger;
 
}
 
/** 单利销毁
*/
 
- (void)removeSharedManager
{
    /**只有置成0，GCD才会认为它从未执行过。它默认为0。
     这样才能保证下次再次调用sharedManager的时候，再次创建对象。*/
    [self.documentPickerVC dismissViewControllerAnimated:YES completion:nil];
    [_manger removeAllSubviews];
    [_manger.alertWindow removeFromSuperview];
    _manger.alertWindow = nil;
    onceToken= 0;
    _manger=nil;
    
    [self.view removeFromSuperview];
    self.view = nil;
   
  
   
    
}
- (void)removeAllSubviews {
    while (_manger.alertWindow.subviews.count) {
        UIView* child = _manger.alertWindow.subviews.lastObject;
        [child removeFromSuperview];
    }
}

#pragma mark - event
-(void)muteBtnClicked:(UIButton *)sender{
    
    [self presentDocumentPicker];
    
}

-(void)videoBtnClicked:(UIButton *)sender{
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.allowPickingImage = NO;
    imagePickerVc.allowPickingVideo = YES;
    imagePickerVc.allowPickingMultipleVideo = NO;
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}
-(void)imgBtnClicked:(UIButton *)sender{
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        NSData *data=   UIImageJPEGRepresentation(photos.firstObject,1.0f);
        PHAsset * asset = [assets firstObject];
        NSString *filename = [asset valueForKey:@"filename"];
        [HDLog logD:@"HD===%s filename==%@",__func__,filename];
        [self writeToFileData:data withFileName:filename];
        [self dismissViewController];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}


#pragma mark -TZImagePickerControllerDelegate

// 如果用户选择了一个视频且allowPickingMultipleVideo是NO，下面的代理方法会被执行
//如果allowPickingMultipleVideo是YES，将会调用imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset{

    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHVideoRequestOptionsVersionOriginal;
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
        if ([asset isKindOfClass:[AVURLAsset class]]) {
            AVURLAsset* urlAsset = (AVURLAsset*)asset;
            NSNumber *size;
            [urlAsset.URL getResourceValue:&size forKey:NSURLFileSizeKey error:nil];
            [HDLog logD:@"HD===%s size is %f",__func__,[size floatValue]/(1024.0*1024.0)];
            NSString *fileName = [self getVideoName:[NSString stringWithFormat:@"%@",urlAsset.URL]];
           
            NSData * data = [NSData dataWithContentsOfURL:urlAsset.URL];
            if (data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self writeToFileData:data withFileName:fileName];

                    [self dismissViewController];
                });
            }
     }
    }];
}

// 当allowEditVideo是YES且allowPickingMultipleVideo是NO是，如果用户选择了一个视频，下面的代理方法会被执行
//如果allowPickingMultipleVideo是YES，则不支持编辑视频，将会调用imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingAndEditingVideo:(UIImage *)coverImage outputPath:(NSString *)outputPath error:(NSString *)errorMsg{
}
-(void)uploadFileBtnClicked:(UIButton *)sender{

    [self presentDocumentPicker];
}
#pragma mark 获取视频名字
- (NSString *)getVideoName:(NSString *)url {
    NSArray * urlArray = [url componentsSeparatedByString:@"?"];
    if (urlArray.count > 0) {
        NSArray * nameArray = [urlArray[0] componentsSeparatedByString:@"/"];
        if (nameArray.count > 0) {
            return nameArray.lastObject;
        }
    }
    NSDate *senddate = [NSDate date];
    NSString *date2 = [NSString stringWithFormat:@"%ld%@", (long)[senddate timeIntervalSince1970],@"1"];
    return  [NSString stringWithFormat:@"%@%@.mov",senddate,date2];
}

#pragma mark - 文件上传
- (void)presentDocumentPicker {

    [self presentViewController:self.documentPickerVC animated:YES completion:nil];
}
//- (UIDocumentPickerViewController *)documentPickerVC {
//    if (!_documentPickerVC) {
//        NSArray *documentTypes = @[@"com.adobe.pdf", @"com.microsoft.word.doc",@"com.microsoft.word.docx", @"com.microsoft.excel.xls", @"com.microsoft.powerpoint.ppt",@"com.microsoft.powerpoint.pptx",@"public.audio"];
//        self.documentPickerVC = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes inMode:UIDocumentPickerModeOpen];
//        _documentPickerVC.delegate = self;
//        _documentPickerVC.modalPresentationStyle = UIModalPresentationFormSheet; //设置模态弹出方式
//    }
//    return _documentPickerVC;
//}

- (UIDocumentPickerViewController *)documentPickerVC {
    if (!_documentPickerVC) {
        NSArray *documentTypes = @[@"public.content", @"public.source-code ", @"public.audiovisual-content", @"com.adobe.pdf", @"com.microsoft.word.doc", @"com.microsoft.excel.xls", @"com.microsoft.powerpoint.ppt",@"public.audio"];
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
                [HDLog logD:@"HD===%s 开始上传文件==",__func__];
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
            [self dismissViewController];
        }];
        [urls.firstObject stopAccessingSecurityScopedResource];
    } else {
        //授权失败
    }
}

- (void)writeToFileData:(NSData *)data withFileName:(NSString *)fileName{
    
    //获取创建library 下文件夹
   
    NSError * error;
    HDVECFastBoardFileType type;
    NSString * suffix = [HDSanBoxFileManager suffixAtPath:fileName];
    suffix = [suffix lowercaseString];
    if ([suffix isEqualToString:@"png"] || [suffix isEqualToString:@"jpg"] || [suffix isEqualToString:@"jpeg"]  ) {
        
        type = HDVECFastBoardFileTypeimg;
        fileName = [NSString stringWithFormat:@"%@.jpeg",fileName];
        
    }else if([suffix isEqualToString:@"mp3"] || [suffix isEqualToString:@"mp4"] || [suffix isEqualToString:@"mov"] ){
        type = HDVECFastBoardFileTypevideo;
//        fileName = [NSString stringWithFormat:@"%@.mp4",fileName];
       
    }else if([suffix isEqualToString:@" amr"] || [suffix isEqualToString:@" wav"] ){
        
        type = HDVECFastBoardFileTypemusic;

    }else if([suffix isEqualToString:@"pptx"] ){
        
        type = HDVECFastBoardFileTypeppt;

    }else if([suffix isEqualToString:@"pdf"]  ){
        
        type = HDVECFastBoardFileTypepdf;
    }
    else if([suffix isEqualToString:@"doc"] || [suffix isEqualToString:@"docx"]  || [suffix isEqualToString:@"ppt"]){
        
        type = HDVECFastBoardFileTypeword;
        
    }else{
        
        type = HDVECFastBoardFileTypeunknown;
        
    }
    NSString * fileDir = [NSString stringWithFormat:@"%@/hdvecwhiteBoard/%@",[HDSanBoxFileManager libraryDir],fileName];
    BOOL success = [HDSanBoxFileManager createFileAtPath:fileDir content:data overwrite:NO error:&error];
    if (success) {
     
        
        [self hd_uploadFile:nil withFileName:fileName withFilePath:fileDir withFileType:type] ;
    }
}

- (void)hd_uploadFile:(NSData *)data withFileName:(NSString *)fileName withFilePath:(NSString *)filePath withFileType:(HDVECFastBoardFileType) type{
    
    [[HDVECWhiteRoomManager shareInstance] whiteBoardUploadFileWithFilePath:filePath fileData:nil fileName:fileName fileType: type mimeType:@"" completion:^(id  _Nonnull responseObject, HDError * _Nonnull error) {
        
        if (!error && [responseObject isKindOfClass:[NSDictionary class]]) {
           //上传成功 删除文件夹
            
            [HDSanBoxFileManager  removeItemAtPath:filePath];
        }
    }];
    
}

#pragma mark - event
- (void)dismissViewController{
    [[HDVECUploadFileViewController sharedManager] removeSharedManager];
}

#pragma mark - lzye

- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc] init];
        UIButton * backBtn = [[UIButton alloc] init];
        [backBtn setTitle:@"" forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
        UIImage * img = [UIImage imageWithIcon:kfanhui inFont:kfontName size:30 color:[[HDVECAppSkin mainSkin] contentColorGray1] ];

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
- (HDVECControlBarView *)barView {
    if (!_barView) {
        _barView = [[HDVECControlBarView alloc]init];
        __weak __typeof__(self) weakSelf = self;
        _barView.clickControlBarItemBlock = ^(HDVECControlBarModel * _Nonnull barModel, UIButton * _Nonnull btn) {
            
            switch (barModel.itemType) {
                case HDVECControlBarItemTypeMute:
                    [weakSelf muteBtnClicked:btn];
                    break;
                case HDVECControlBarItemTypeVideo:
                    [weakSelf videoBtnClicked:btn];
                    break;
                case HDVECControlBarItemTypeImage:
                    [weakSelf imgBtnClicked:btn];
                    break;
                case HDVECControlBarItemTypeFile:
                    [weakSelf uploadFileBtnClicked:btn];
                    break;
               
                    
                default:
                    break;
            }
            
        };
       
    }
    return _barView;
}

#pragma mark - 代理方法 只要给服务器上传数据就会调用 可以计算出上传进度
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{

    //设置进度条
//    self.uploadProgress.progress = 1.0 * totalBytesSent / totalBytesExpectedToSend;
}
@end
