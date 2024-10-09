//
//  IMVOIPTableViewCell.m
//  CLP
//
//  Created by 李标 on 2023/4/17.
//

#import "IMVOIPTableViewCell.h"
#import "IMCellDataHelper.h"
#import "UIFont+IM.h"
#import "NSString+IM.h"
#import "UIColor+IM.h"

@interface IMVOIPTableViewCell ()<UITableViewDataSource, UITableViewDelegate,UITextViewDelegate,IMVOIPSubTableViewCellDelegate> {
    IMMsgModel *_currentModel;
}

@end

@implementation IMVOIPTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellBgView = [[UIView alloc] init];
        _cellBgView.layer.cornerRadius = 12.0;
        [self.contentView addSubview:_cellBgView];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundView = nil;
        _tableView.backgroundColor = [UIColor  clearColor];
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = 40;
        [_tableView registerClass:[IMVOIPSubTableViewCell class] forCellReuseIdentifier:@"IMVOIPSubTableViewCell"];
        [_cellBgView addSubview:_tableView];
    }
    return self;
}

- (void)setContentWithModel:(IMMsgModel*)model indexPath:(NSIndexPath *)indexPath {
    _currentModel = model;
    //头像
    [self setContentHeadIconWithModel:model];
    
    //聊天背景
    if (model.createType == IMMsgCreateType_server) {
        _cellBgView.frame = CGRectMake(64, 0, kCellMaxWidth, model.cellHeight);
        _cellBgView.backgroundColor = [UIColor  clearColor];
    } else if (model.createType == IMMsgCreateType_user) {
        _cellBgView.frame = CGRectMake(kMainScreenWidth-64-kCellSpace10*2, 0, 40, model.cellHeight);
    }
    
    //tableView
    _tableView.frame = CGRectMake(0, 0, kCellMaxWidth, model.cellHeight);
    [_tableView reloadData];
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark -- IMVOIPSubTableViewCellDelegate
- (void)VOIPSubTableViewCellEventByTag:(IMVOIPAgreeButtonType)tag target:(id)target {
    if (tag == IMVOIPAgreeButtonType_Yes) {
        // 点击了yes 发送消息 刷新界面
        [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationSendMenuText object:@{@"title":@"Yes", @"content":@""}];
    }
    if (tag == IMVOIPAgreeButtonType_No) {
        // 点击了no 发送消息 刷新界面
        [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationSendMenuText object:@{@"title":@"No", @"content":@""}];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(VOIPTableViewCellEventByTag:IMMsgModel:cell:)]) {
        [self.delegate VOIPTableViewCellEventByTag:tag IMMsgModel:_currentModel cell:self];
    }
}

#pragma mark - tableView delegate and source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *title = [IMCellDataHelper getMenuHeaderContent:_currentModel.mainInfo];
    CGSize titleSize = [title sizeForWidth:kCellMaxWidth-kCellSpace10*2 withFont:[UIFont cellContentFont]];
    if ([NSString isIMBlankString:title]) {
        return CGFLOAT_MIN;
    }
    return kCellSpace10 + titleSize.height + kCellSpace10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *title = [IMCellDataHelper getMenuHeaderContent:_currentModel.mainInfo];
    if ([NSString isIMBlankString:title]) {
        return nil;
    }
    
    CGSize titleSize = [title sizeForWidth:kCellMaxWidth-kCellSpace10*2 withFont:[UIFont cellContentFont]];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCellMaxWidth, kCellSpace10 + titleSize.height + kCellSpace10)];
    headView.backgroundColor = [UIColor cellServerBackgroundColor];
    headView.layer.cornerRadius = 8;
    
    UITextView *contentTiew = [[UITextView alloc] initWithFrame:CGRectMake(kCellSpace10, kCellSpace10, kCellMaxWidth - kCellSpace10*2,  titleSize.height)];
    contentTiew.font = [UIFont cellContentFont];
    contentTiew.textColor = [UIColor cellServerContextColor];
    contentTiew.backgroundColor = [UIColor clearColor];
    contentTiew.textContainerInset = UIEdgeInsetsZero;
    contentTiew.textContainer.lineFragmentPadding = 0;
    contentTiew.editable = NO;
    contentTiew.delegate = self;
    contentTiew.scrollEnabled = NO;
    [headView addSubview:contentTiew];

    contentTiew.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor cellLinkContentColor], NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    
    NSString *desTitle = title;
    if ([title containsString:@"\\n"]) {
        desTitle = [title stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    }
    
    NSMutableAttributedString *totalContent = [[NSMutableAttributedString alloc] initWithString:desTitle attributes:@{NSForegroundColorAttributeName:contentTiew.textColor, NSFontAttributeName:[UIFont cellContentFont]}];
    NSMutableArray *clickArray = [IMCellDataHelper getMatchContent:title];
    if (clickArray.count > 0) {
        for (NSInteger i=0;i<clickArray.count;i++) {
            NSString *url = [clickArray objectAtIndex:i];
            NSRange ansRange = [title rangeOfString:url];
            [totalContent addAttribute:NSLinkAttributeName value:@"uccLinkString://" range:ansRange];
        }
    }
    contentTiew.attributedText = totalContent;
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMVOIPSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IMVOIPSubTableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextViewDelegate 点富文本
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction  API_AVAILABLE(ios(10.0)){
  
    if ([[URL scheme] isEqualToString:@"uccLinkString"]) {
        [textView.text enumerateSubstringsInRange:characterRange options:NSStringEnumerationByLines usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            [self openWithUrl:substring];
        }];
    }
    
    return YES;
}

- (void)openWithUrl:(NSString *)url {
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

@end
