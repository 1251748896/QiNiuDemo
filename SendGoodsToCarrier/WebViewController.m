//
//  WebViewController.m
//  SendGoodsToCarrier
//
//  Created by HaoHuoBan on 2020/3/18.
//  Copyright © 2020 HaoHuoBan. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

//    [self makeUIWebView];
    [self makeWkWebView];
    
}

- (void)makeUIWebView {
    _uweb = [[UIWebView alloc] init];
    _uweb.frame = self.view.bounds;
    _uweb.delegate = self;
    [self.view addSubview:_uweb];
    
    NSString *url = @"https://h5.51zhaoyou.com/lvjy/dist/homePage?isLo…zcyfQ.xB_X6vfWSauBUIIuANAZ5DDDFTYHieE-9xlwHyjWHvw";
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [_uweb loadRequest:request];
}

- (void)makeBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(16, 80, 100, 44);
    [btn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)buttonClick {
    
}

- (void)makeWkWebView {
    WKWebViewConfiguration *configuration=[[WKWebViewConfiguration alloc] init];
    [configuration.userContentController addScriptMessageHandler:self name:@"nativejs"];
    
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    
    
    
//    [self loadUrl];
        [self loadHtml];
}

-(void)loadHtml {
//    NSString *htmlString = @"";
//    NSString *path = [NSString alloc] ini;
//    [_webView loadHTMLString:htmlString baseURL:nil];
}

-(void)loadUrl {
    NSString *url = @"http://newhcdapi.huochaoduo.com/api/services/Bill/H5Pay/CreatePayOrderAsync"; // @"https://www.baidu.com";
//    url = @"https://h5.51zhaoyou.com/lvjy/dist/#/homePage?isLo…zcyfQ.xB_X6vfWSauBUIIuANAZ5DDDFTYHieE-9xlwHyjWHvw";
//    url = @"https://www.baidu.com";
//    url = @"https://h5.51zhaoyou.com/lvjy/dist/#/homePage?isLogin=2&token=Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjdXN0b21lcl80MDQ4XzE4MjE2OSIsImlhdCI6MTU4NDY5MDMxOSwiZXhwIjoxNTg3MjgyMzE5fQ.MWGuWqmgmpSmhHkmiY6rd2rx6KiR1hgrDIhD-nEp6yI";
//    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    url = @"http://192.168.1.159:38009/Html/baiduMap";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [_webView loadRequest:request];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSDictionary * messageDic = [[NSDictionary alloc]initWithDictionary:message.body];
    
    id errorMessage = messageDic[@"onMessageError"];
    NSLog(@"messageDic = %@",messageDic);
    NSLog(@"messageDic = %@",errorMessage);
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"didFailLoadWithError = %@",error);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"absoluteString = %@",navigationAction.request.URL.absoluteString);
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"absoluteString11 = %@",navigationResponse.response.URL.absoluteString);
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"didFailProvisionalNavigation = %@",error);
}

@end
