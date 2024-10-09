//
//  IMHtmlTableViewCell.h
//  UCC
//
//  Created by mac on 2021/5/20.
//

#import "IMTableViewCell.h"
#import "IMMsgModel.h"
#import <WebKit/WebKit.h>
#import "IMMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HtmlTableViewCellDelagate <NSObject>

- (void)reloadHTMLData:(NSIndexPath *)indexPath;

@end

@interface IMHtmlTableViewCell : IMTableViewCell <WKUIDelegate, WKNavigationDelegate> {
    IMMsgModel *_msgModel;
    NSIndexPath *_indexPath;
}

@property (nonatomic, strong) UIView *cellBgView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) id<HtmlTableViewCellDelagate> delegate;

- (void)setContentWithModel:(IMMsgModel*)model indexPath:(NSIndexPath *)indexPath;


@end

NS_ASSUME_NONNULL_END
