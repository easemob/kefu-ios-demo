//
//  HDFormWebViewController.m
//  CustomerSystem-ios
//
//  Created by liyuzhao on 14/08/2017.
//  Copyright © 2017 easemob. All rights reserved.
//

#import "HDFormWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface HDFormWebViewController ()<UIWebViewDelegate, EasemobWebViewInterface>
@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic, strong) UIWebView *web;
@end

@implementation HDFormWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [self configWebView];
}

- (void)configWebView
{
    CGRect frame = CGRectMake(20, 40, kScreenWidth - 40 , kScreenHeight - 80);
    _web = [[UIWebView alloc]initWithFrame:frame];
    NSURL *trueUrl = nil;
    if (_url) {
        trueUrl = [NSURL URLWithString:_url];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:trueUrl];
    _web.delegate = self;
    [self.view addSubview:_web];
    [_web loadRequest:request];
    
}

#pragma mark - delegate

#pragma mark - UIWebViewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (!self.jsContext) {
        self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        
        // 关联打印异常
        self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception) {
//            context.exception = exception;
            NSLog(@"exception:%@", exception);
        };
        
    }
     self.jsContext[@"easemob"]=self;

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)closeWindow{
    dispatch_async(dispatch_get_main_queue(), ^{
        [super dismissViewControllerAnimated:YES completion:nil];
    });
}

-(void)showToast:(NSString *)toast{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:toast delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
    [alert show];
}

-(NSString *)imToken
{
    return [[HDClient sharedClient] accessToken];
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

    
-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    if(self.presentedViewController){
        [super dismissViewControllerAnimated:flag completion:completion];
    }
}
    
- (void)dealloc
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    _web.delegate = nil;
    _web = nil;
}
@end
