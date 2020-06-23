//
//  WebViewController.h
//  SendGoodsToCarrier
//
//  Created by HaoHuoBan on 2020/3/18.
//  Copyright © 2020 HaoHuoBan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : UIViewController<WKScriptMessageHandler, UIWebViewDelegate, WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIWebView *uweb;
@end

NS_ASSUME_NONNULL_END
