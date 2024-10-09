//
//  IMViewMoreBottomView.m
//  Georgia_IOS
//
//  Created by mac on 2020/8/13.
//  Copyright © 2020 mac. All rights reserved.
//

#import "IMViewMoreBottomView.h"
#import "IMDeviceModelHelper.h"
#import "UCCHeader.h"
#import "NSString+IM.h"
#import "UIColor+IM.h"
#import <WebKit/WebKit.h>
#import <DXPToolsLib/HJMBProgressHUD.h>
#import <DXPToolsLib/HJMBProgressHUD+Category.h>
//#import "AppDelegate.h"

@interface IMViewMoreBottomView() <WKNavigationDelegate, WKUIDelegate> {
    CGFloat _viewHeight;
    NSString *_jumpMenu;
}

@property (nonatomic, strong) UIView *totalView;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation IMViewMoreBottomView

- (id)initWithJumpMenu:(NSString *)jumpMenu {
    self = [super init];
    if (self) {
        _jumpMenu = jumpMenu;
        [self initUI];
    }
    return self;
}

- (void)dealloc {
    _webView.navigationDelegate = nil;
    _webView = nil;
}

- (void)initUI {
    _viewHeight = ([IMDeviceModelHelper isIPhoneX] ? 34.f : 0.f) + kMainScreenHeight*3/5;
    self.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    self.backgroundColor = [UIColorFromRGB_IM(0x2E3B44) colorWithAlphaComponent:0.5];
    self.userInteractionEnabled = YES;
    [self addSubview:self.totalView];
}

- (void)coutomshowInView:(UIView *)view {
    if (!view){
        return;
    }
    [view addSubview:self];
    [view addSubview:_totalView];
    [_totalView setFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, _viewHeight)];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
        [_totalView setFrame:CGRectMake(0, kMainScreenHeight - _viewHeight, kMainScreenWidth, _viewHeight)];
    } completion:nil];
}

- (void)showInView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [_totalView setFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, _viewHeight)];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
        [_totalView setFrame:CGRectMake(0, kMainScreenHeight - _viewHeight, kMainScreenWidth, _viewHeight)];
    } completion:nil];
}

- (void)dismissView {
    [_totalView setFrame:CGRectMake(0, kMainScreenHeight - _viewHeight, kMainScreenWidth, _viewHeight)];
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.0;
        [_totalView setFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, _viewHeight)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_totalView removeFromSuperview];
    }];
}

#pragma mark- lazy
- (UIView *)totalView {
    if (!_totalView) {
        _totalView = [[UIView alloc]initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, _viewHeight)];
        _totalView.backgroundColor = UIColorFromRGB_IM(0XFFFFFF);
        
        //设置弧度
       UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:_totalView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(16, 16)];
       CAShapeLayer *cornerRadiusLayer = [[CAShapeLayer alloc ] init];
       cornerRadiusLayer.frame = _totalView.bounds;
       cornerRadiusLayer.path = cornerRadiusPath.CGPath;
       _totalView.layer.mask = cornerRadiusLayer;
        
        //取消按钮
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(kMainScreenWidth-55, 10, 45, 45);
        [cancelBtn setImage:[UIImage imageNamed:@"ic_shop_detail_close"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
        [_totalView addSubview:cancelBtn];
        
        //分割线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 54.5, kMainScreenWidth, 0.5)];
        lineView.backgroundColor = UIColorFromRGB_IM(0xEBEBEB);
        [_totalView addSubview:lineView];
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 55, kMainScreenWidth, _viewHeight-([IMDeviceModelHelper isIPhoneX] ? 34.f : 0.f)-55-10)];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        [_totalView addSubview:_webView];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self getUrlTimestampString:_jumpMenu] ]]];
    }
    return _totalView;
}

#pragma mark -WKNavigationDelegate-
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
	[HJMBProgressHUD showLoading];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

//页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
	[HJMBProgressHUD hideLoading];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
	[HJMBProgressHUD showText:@"network_unavailable"];
}

// 接收到服务器跳转请求之后调用
-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil]];
//    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [app.nav  presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil]];
//    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [app.nav  presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.text = defaultText;
//    }];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler(alertController.textFields[0].text?:@"");
//    }])];
//    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [app.nav  presentViewController:alertController animated:YES completion:nil];
}


#pragma mark -- other
- (NSString *)getUrlTimestampString:(NSString*)urlStr {
	if(isEmptyString_IM(urlStr)) return  urlStr;
	NSString *returnStr = urlStr;
	NSString *tmpStr = urlStr;
	
	if([urlStr isKindOfClass:[NSURL class]]) {
		NSURL *url = (NSURL *)urlStr;
		tmpStr = url.absoluteString;
	}
	
	if([tmpStr isKindOfClass:[NSString class]]) {
		NSInteger timestamp = (NSInteger)([[NSDate new] timeIntervalSince1970] * 1000);
		if([tmpStr containsString:@"?"] && [tmpStr containsString:@"="] ) {
			// 直接在尾部添加
			returnStr = [NSString stringWithFormat:@"%@&clptimestamp=%ld",tmpStr,timestamp];
		}
		if(![tmpStr containsString:@"?"]) {
			returnStr = [NSString stringWithFormat:@"%@?clptimestamp=%ld",tmpStr,timestamp];
		}
	}
	return returnStr;
}

@end
