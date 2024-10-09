//
//  IMHtmlTableViewCell.m
//  UCC
//
//  Created by mac on 2021/5/20.
//

#import "IMHtmlTableViewCell.h"
#import "UIFont+IM.h"
#import "UIColor+IM.h"
#import "NSString+IM.h"
#import "IMCellDataHelper.h"
#import "IMTapMorePushVC.h"
#import "IMConfigSingleton.h"

@implementation IMHtmlTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellBgView = [[UIView alloc] init];
        _cellBgView.layer.cornerRadius = 12.0;
        _cellBgView.backgroundColor = [UIColor  cellServerBackgroundColor];
        [self.contentView addSubview:_cellBgView];
        
        _webView = [[WKWebView alloc] init];
//        _webView.scrollView.layer.cornerRadius = 12.0;
//        _webView.layer.cornerRadius = 12.0;
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.backgroundColor = [UIColor cellServerBackgroundColor];
        _webView.backgroundColor = [UIColor cellServerBackgroundColor];
        _webView.opaque = NO;
        // 添加kvo监听webview的scrollView.contentSize变化
        [_webView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew context:nil];
        [self.contentView addSubview:_webView];
    }
    return self;
}

- (void)setContentWithModel:(IMMsgModel*)model indexPath:(NSIndexPath *)indexPath {
    _msgModel = model;
    _indexPath = indexPath;
    //头像
    [self setContentHeadIconWithModel:model];
    
    _cellBgView.frame = CGRectMake(64, 0, kCellMaxWidth+32, _msgModel.cellHeight + 10);
    //内容
    _webView.frame = CGRectMake(74, 10, kCellMaxWidth+12, _msgModel.cellHeight);

    NSString *strCssHead = [NSString stringWithFormat:@"<head>"
                            "<link rel=\"stylesheet\" type=\"text/css\" href=\"iPhone.css\">"
                            "</head>"];
    NSString *strBody = [NSString stringWithFormat:@"<body>"
                            "<h1>%@</h1>"
                            @"</body>",model.mainInfo];
    
    [_webView loadHTMLString:[NSString stringWithFormat:@"%@%@",strCssHead,strBody]
                       baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"iPhone" ofType:@"css"]]];
//    [_webView loadHTMLString:model.mainInfo baseURL:nil];
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"scrollView.contentSize"]) {
        NSInteger webHeight = self.webView.scrollView.contentSize.height;
        if (_msgModel.cellHeight != webHeight && !_msgModel.isHtmlReload) {
            _msgModel.cellHeight = webHeight<40?40:webHeight;
            if (_delegate && [_delegate respondsToSelector:@selector(reloadHTMLData:)]) {
                [_delegate reloadHTMLData:_indexPath];
            }
        }
    }
}

#pragma mark - WKNavigationDelegate
- (void)removeWebViewObserver {
    @try {
        if (_webView) {
            [_webView.scrollView removeObserver:self forKeyPath:@"scrollView.contentSize"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"多次删除kvo 报错了");
    }
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {

}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

//页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.fontFamily='Montserrat-Medium';" completionHandler:nil];
//    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#FFFFFF'" completionHandler:nil];
//    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '400%'"completionHandler:nil];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
}

// 接收到服务器跳转请求之后调用
-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        NSString *url = [navigationAction.request.URL absoluteString];
        if ([url rangeOfString:@"webchat://"].location != NSNotFound) {
            url = [url stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
            NSString *title = [IMCellDataHelper getMatchHTML:_msgModel.mainInfo href:url];
            [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationSendMenuText object:@{@"title":title, @"content":url}];
        } else if ([url rangeOfString:[IMConfigSingleton sharedInstance].selfUrlScheme].location != NSNotFound) {
            // add by libiao 2021-12-21
            // 截取路由名称, 跳转对应的页面模块
            NSArray *list = [url componentsSeparatedByString:[IMConfigSingleton sharedInstance].selfUrlScheme];
            if (![NSString isIMBlankString:list[1]]) {
                [IMTapMorePushVC pushVCWithRouter:@{@"router":list[1]}];
            }
        } else {
            UIApplication *application = [UIApplication sharedApplication];
            if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                if (@available(iOS 10.0, *)) {
                    [application openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
                } else {
                    // Fallback on earlier versions
                }
            } else {
               [application openURL:[NSURL URLWithString:url]];
            }
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler (WKNavigationActionPolicyAllow);
    }
    return ;//不添加会崩溃
}

@end
