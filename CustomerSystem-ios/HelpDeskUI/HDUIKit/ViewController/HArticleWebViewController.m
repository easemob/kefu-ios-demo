//
//  HArticleWebViewController.m
//  CustomerSystem-ios
//
//  Created by afanda on 8/7/17.
//  Copyright © 2017 easemob. All rights reserved.
//

#import "HArticleWebViewController.h"

@interface HArticleWebViewController ()

@end

@implementation HArticleWebViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSURL *trueUrl = nil;
    if (_url) {
        trueUrl = [NSURL URLWithString:_url];
    }
    NSURLRequest *request =[NSURLRequest requestWithURL:trueUrl];
    
    [self.view addSubview:webView];
    
    [webView loadRequest:request];
    
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
