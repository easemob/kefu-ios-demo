//
//  HDSignView.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/6/10.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDSignView.h"
#import "HDAppSkin.h"
@implementation HDSignView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self createUI];
      
    }
    
    return self;
}
- (void)createUI{
   
    [self addSubview:self.hdDrawView];
    [self.hdDrawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(-96/2);
        make.leading.offset(0);
        make.trailing.offset(0);

    }];
    
    [self addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.bottom.offset(-15);
        make.trailing.offset(-15);
        make.width.offset(100);
        make.height.offset(48);

    }];
    [self addSubview:self.resignBtn];
    [self.resignBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.sureBtn.mas_centerY).offset(0);
        make.leading.offset(15);
        make.width.offset(26);
        make.height.offset(26);

    }];
    

    __weak typeof(self) weakSelf = self;
    //是否有绘画，判定确认btn是否可点
    self.hdDrawView.drawCallBack = ^(BOOL isFinished) {
        [weakSelf sureBtnEnable:isFinished];
    };
    
    [self sureBtnEnable:NO];
    
}
#pragma mark - 事件监听
//重新签名btn
- (void)resignBtnClick:(id)sender {
//    [self sureBtnEnable:NO];
    [self.hdDrawView clearContent];
}

//确认btn
- (void)sureBtnClick:(id)sender {
    UIImage *img = [self changeToImage];
    NSData *signGraphic = [self UIImageToBase64Data:img];
    [self.delegate hdSignCompleteWithImage:img base64Data:signGraphic];
}

//转换图片
- (UIImage *)changeToImage {
    self.hdDrawView.backgroundColor = [UIColor clearColor];
    UIGraphicsBeginImageContextWithOptions(self.hdDrawView.frame.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.hdDrawView.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    self.hdDrawView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    return image;
}

//图片转字符串
-(NSString *)UIImageToBase64Str:(UIImage *) image {
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:0];
    return encodedImageStr;
}
//图片转data
-(NSData *)UIImageToBase64Data:(UIImage *) image {
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
   
    return data;
}
//确定btn是否可点，和颜色显示
- (void)sureBtnEnable:(BOOL)bl{
    self.sureBtn.enabled = bl;
    self.sureBtn.alpha = bl ? 1 : 0.3;
}

- (HDDrawingBoardView *)hdDrawView{
    
    if (!_hdDrawView) {
        
        _hdDrawView = [[HDDrawingBoardView alloc] init];
    }
    return  _hdDrawView;
    
}
- (NSData *)imageData {
    if (!_imageData) {
        _imageData = [NSData data];
    }
    return _imageData;
}
- (UIButton *)resignBtn{
    if (!_resignBtn) {
        _resignBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resignBtn addTarget:self action:@selector(resignBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //为button赋值
        [_resignBtn setImage:[UIImage imageNamed:@"vec_chexiao.png"] forState:UIControlStateNormal];
//        [_resignBtn setTitle:@"撤销" forState:UIControlStateNormal];
//        _resignBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
//        _resignBtn.backgroundColor = [UIColor blueColor];
    }
    return _resignBtn;
}
- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //为button赋值
//        [_sureBtn setImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
        [_sureBtn setTitle:NSLocalizedString(@"satisfaction.commit", @"提交") forState:UIControlStateNormal];
        _sureBtn.backgroundColor = [[HDAppSkin mainSkin] contentColorBlueHX];
        _sureBtn.layer.cornerRadius = 5.0f;
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    }
    return _sureBtn;
}
@end
