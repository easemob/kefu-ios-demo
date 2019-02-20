//
//  QRCodeViewController.m
//  CustomerSystem-ios
//
//  Created by afanda on 16/12/13.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "QRCodeViewController.h"
#import "ScanningView.h"
#import <AVFoundation/AVFoundation.h>

#define kClearRectWH [UIScreen mainScreen].bounds.size.width*2/3
#define kClearRectLR [UIScreen mainScreen].bounds.size.width/6
#define kClearRectTop ([UIScreen mainScreen].bounds.size.height-kClearRectWH)/2

@interface QRCodeViewController () <AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic,strong) ScanningView *scanningView;
@end

@implementation QRCodeViewController
{
    AVCaptureSession *_session;//输入输出的中间桥梁
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self setLeftBarButtonItem];
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.scanningView];
    [self startScanning];
}

- (void)startScanning {
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!input) return;
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置有效扫描区域
    CGRect scanCrop=[self getScanCrop:CGRectMake(kClearRectLR, kClearRectTop, kClearRectWH, kClearRectWH) readerViewBounds:self.view.frame];
    output.rectOfInterest = scanCrop;
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [_session addInput:input];
    [_session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [_session startRunning];
    
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [_session stopRunning];
        [_scanningView stopScanning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        NSLog(@"%@",metadataObject.stringValue);
        NSString *value = metadataObject.stringValue;
        if (![value containsString:@"easemob.com"] || ![value containsString:@"appkey"]
            ||![value containsString:@"tenantid"] || ![value containsString:@"imservicenum"]) {
            [self showHint:NSLocalizedString(@"qrcode_invalid", @"QrCode Invalid")];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        NSString *useful = @"";
        NSMutableDictionary *useDic = [NSMutableDictionary dictionaryWithCapacity:0];
        NSArray *arr = [metadataObject.stringValue componentsSeparatedByString:@"?"];
        if (arr.count == 2) {
            useful = [arr[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSArray *arr1 = [useful componentsSeparatedByString:@"&"];
            if (arr1.count == 4) {
                for (int i=0 ; i<4 ;i++) {
                    NSArray *dics = [arr1[i] componentsSeparatedByString:@"="];
                    if (dics.count == 2) {
                        [useDic setValue:dics[1] forKey:dics[0]];
                    }
                }
                //字典dics里是有用数据
                __weak typeof(self) weakSelf = self;
                if (_qrBlock) {
                    _qrBlock(useDic);
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }
        }
        
    }
}
#pragma mark-> 获取扫描区域的比例关系
-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    y = (readerViewBounds.size.width - CGRectGetMaxX(rect))/readerViewBounds.size.width;
    x =  CGRectGetMinY(rect)/readerViewBounds.size.height;
    width = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
    height = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);
    return CGRectMake(x, y, width, height);
}

- (ScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [[ScanningView alloc] initWithFrame:self.view.bounds];
        _scanningView.clearRect = CGRectMake(kClearRectLR, kClearRectTop, kClearRectWH, kClearRectWH);
    }
    return _scanningView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
