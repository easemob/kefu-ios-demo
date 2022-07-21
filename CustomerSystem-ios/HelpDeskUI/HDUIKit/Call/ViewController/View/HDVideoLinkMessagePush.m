//
//  HDVideoLinkMessagePush.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/6/9.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDVideoLinkMessagePush.h"
#import "MBProgressHUD+Add.h"
#import "UIView+GestureRecognizer.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "HDCustomJSObject.h"
#define kIframeClose @"closeMessagePush"
@interface HDVideoLinkMessagePush()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

{
    NSURLRequest *_request;
}
@end
@implementation HDVideoLinkMessagePush

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self createUI];
      
    }
    
    return self;
}
- (void)createUI{
   
    [self addSubview:self.webView];
    [self addSubview:self.loadLabel];
   kWeakSelf
    [self.loadLabel setTapActionWithBlock:^{
        
        
//        重新加载
        [weakSelf refreshWebView];
        
    }];
    
    
}

- (void)refreshWebView{
    
    
    [self.webView reload];
    
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
        
    }];
    [self.loadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.offset(0);
        
    }];
    
}
- (void)hd_OnClose{
    
    
    NSLog(@"===h5调用了 app方法");
    
}
- (void)setWebUrl:(NSString *)url{
    
//    url = @"http://baidu.com";
//    NSURL *trueUrl = nil;
//    if (url) {
//        trueUrl = [NSURL URLWithString:url];
//    }
//    
//    
//    _request =[NSURLRequest requestWithURL:trueUrl];
//    
//    [self.webView loadRequest:_request];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"File" ofType:@"html"];


    NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];


    [self.webView loadHTMLString:htmlCont baseURL:baseURL];
    
}
- (NSString *)stringWithDictionary:(NSDictionary *)dic {
    if (dic == nil) {
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return json;
}


//WKScriptMessageHandler协议方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    //code
    
    //message.body为h5向原生交互时所传的参数，这个为客户端与h5端协商，端需要什么就让h5端给什么
       //以下为协商后处理的一个实例，根据方法名判断原生需要做什么处理
    if ([message.name isEqualToString:kIframeClose]) {
          
        NSString *body = message.body;
        
        [self closeCurrentView:body];
        
       }
    
    
    
}
- (void)closeCurrentView:(NSString *)content{
    
    if (self.clickIframeCloseBlock) {
        
        self.clickIframeCloseBlock(content);
    }
    [self  removeFromSuperview];
}
- (void)webViewClickButtonAction:(NSString *)str
{
    NSLog(@"OC 接收到 H5按钮点击事件");
}


#pragma mark - WKNavigationDelegate
/*
 WKNavigationDelegate主要处理一些跳转、加载处理操作，WKUIDelegate主要处理JS脚本，确认框，警告框等
 */

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"didStartProvisionalNavigation");
    self.loadLabel.hidden = YES;
    [MBProgressHUD showHUDAddedTo:self animated:YES];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
//    [self.progressView setProgress:0.0f animated:NO];
    NSLog(@"didFailNavigation");
    
    [MBProgressHUD hideHUDForView:self animated:YES];
    
    self.loadLabel.hidden = NO;

}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    self.loadLabel.hidden = YES;
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
//    [self addCustomAction];
    NSLog(@"didFinishNavigation");
    [MBProgressHUD hideHUDForView:self animated:YES];
    
    
//    NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:_request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//       NSHTTPURLResponse *tmpresponse = (NSHTTPURLResponse*)response;
//       NSLog(@"statusCode:%ld", tmpresponse.statusCode);
//        
//     }];
//     [dataTask resume];
    
    
}

//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
   
    
}

// 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
    
    
}

// 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString * urlStr = navigationAction.request.URL.absoluteString;
    NSLog(@"发送跳转请求：%@",urlStr);
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 根据客户端受到的服务器响应头以及response相关信息来决定是否可以跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSString * urlStr = navigationResponse.response.URL.absoluteString;
    NSLog(@"当前跳转地址：%@",urlStr);
    

    
//    NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:_request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//       NSHTTPURLResponse *tmpresponse = (NSHTTPURLResponse*)response;
//       NSLog(@"statusCode:%ld", tmpresponse.statusCode);
//
//     }];
//     [dataTask resume];
    
    
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}

//需要响应身份验证时调用 同样在block中需要传入用户身份凭证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    //用户身份信息
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential,card);
        }
}

//进程被终止时调用
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    
}

#pragma mark - WKUIDelegate

/**
 *  web界面中有弹出警告框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param completionHandler 警告框消失调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"HTML的弹出框" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler();
//    }])];
//    [self presentViewController:alertController animated:YES completion:nil];
    
    completionHandler();
}
// 确认框
//JavaScript调用confirm方法后回调的方法 confirm是js中的确定框，需要在block中把用户选择的情况传递进去
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler(NO);
//    }])];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler(YES);
//    }])];
//    [self presentViewController:alertController animated:YES completion:nil];
}
// 输入框
//JavaScript调用prompt方法后回调的方法 prompt是js中的输入框 需要在block中把用户输入的信息传入
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.text = defaultText;
//    }];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler(alertController.textFields[0].text?:@"");
//    }])];
//    [self presentViewController:alertController animated:YES completion:nil];
}
// 页面是弹出窗口 _blank 处理
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

// 请求加载中发生错误时调用
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    
    
    
}


#pragma mark - url 编码
- (NSString *)URLEncodeString:(NSString *)str {
    NSString *encodedString = [str stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"!@$^&%*+,;='\"`<>()[]{}\\| "] invertedSet]];
    return encodedString;
}
- (WKWebView *)webView{
    if(_webView == nil){
        //创建网页配置对象
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
        preference.minimumFontSize = 0;
        //设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preference;
        
        // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        config.allowsInlineMediaPlayback = YES;
        //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
        config.requiresUserActionForMediaPlayback = YES;
        //设置是否允许画中画技术 在特定设备上有效
        config.allowsPictureInPictureMediaPlayback = YES;
        //设置请求的User-Agent信息中应用程序名称 iOS9后可用
//        config.applicationNameForUserAgent = @"ChinaDailyForiPad";
        
        //这个类主要用来做native与JavaScript的交互管理
        //设置addScriptMessageHandler与name.并且设置<WKScriptMessageHandler>协议与协议方法
        [config.userContentController addScriptMessageHandler:self name:kIframeClose];
    
        //以下代码适配文本大小
        NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        
        NSString* wrapperSource = [NSString
                                      stringWithFormat:@"window.%@ = webkit.messageHandlers.%@;", kIframeClose, kIframeClose];
        WKUserScript* wrapperScript =
           [[WKUserScript alloc] initWithSource:wrapperSource
                                  injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                               forMainFrameOnly:NO];
        //用于进行JavaScript注入
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [config.userContentController addUserScript:wkUScript];
        [config.userContentController addUserScript:wrapperScript];
        
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        // UI代理
        _webView.UIDelegate = self;
        // 导航代理
        _webView.navigationDelegate = self;
        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
        _webView.allowsBackForwardNavigationGestures = YES;        
    }
    return _webView;
}
- (UILabel *)loadLabel{
    
    if (!_loadLabel) {
        _loadLabel = [[UILabel alloc] init];
        _loadLabel.text = @"加载失败 可以点击文字重新加载";
    }
    return _loadLabel;
}

@end
