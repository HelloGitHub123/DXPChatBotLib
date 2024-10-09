//
//  IMMenuBtnListTableViewCell.m
//  CLP
//
//  Created by 李标 on 2021/12/13.
//

#import "IMMenuBtnListTableViewCell.h"
#import "UIColor+IM.h"
#import "IMCellDataHelper.h"
#import "UIFont+IM.h"
#import "NSString+IM.h"
#import "IMMenuBtnTableViewCell.h"

@interface IMMenuBtnListTableViewCell () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate> {
    IMMsgModel *_currentModel;
    NSArray *_operList;
}

@end

@implementation IMMenuBtnListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _operList = @[];
        
        self.backgroundColor = [UIColor yellowColor];
        
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
        [_tableView registerClass:[IMMenuBtnTableViewCell class] forCellReuseIdentifier:@"IMMenuBtnCell"];
        [_cellBgView addSubview:_tableView];
    }
    return self;
}

- (void)setContentWithModel:(IMMsgModel*)model operList:(NSArray *)operList indexPath:(NSIndexPath *)indexPath {
    _currentModel = model;
    _operList = operList;
    //头像
    [self setContentHeadIconWithModel:model];

    CGFloat f_height = model.cellHeight + kCellSpace10*2;
    //聊天背景
    if (model.createType == IMMsgCreateType_server) {
        _cellBgView.frame = CGRectMake(64, 0, kCellMaxWidth, f_height);
        _cellBgView.backgroundColor = [UIColor  clearColor];
    }

    //tableView
    _tableView.frame = CGRectMake(0, kCellSpace10, kCellMaxWidth, f_height - kCellSpace10*2);
    [_tableView reloadData];

    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - tableView delegate and source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([NSString isIMBlankString:_currentModel.mainInfo]) {
        return CGFLOAT_MIN;
    }
//    return _currentModel.cellHeight-kCellSpace10*2;
    CGSize maxSize = [_currentModel.mainInfo sizeForWidth:kCellMaxWidth-kCellSpace10*2 withFont:[UIFont cellContentFont]];
    return maxSize.height-kCellSpace10*2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *mainInfo = _currentModel.mainInfo;
    if ([NSString isIMBlankString:mainInfo]) {
        return nil;
    }
    
    CGSize titleSize = [mainInfo sizeForWidth:kCellMaxWidth withFont:[UIFont cellContentFont]];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCellMaxWidth, titleSize.height + kCellSpace10)];
    headView.backgroundColor = [UIColor cellServerBackgroundColor];
    headView.layer.cornerRadius = 8;
    
    UITextView *contentTiew = [[UITextView alloc] initWithFrame:CGRectMake(kCellSpace10, 10, kCellMaxWidth - kCellSpace10*2, titleSize.height)];
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

    NSMutableAttributedString *totalContent = [[NSMutableAttributedString alloc] initWithString:mainInfo attributes:@{NSForegroundColorAttributeName:contentTiew.textColor, NSFontAttributeName:[UIFont cellContentFont]}];
    NSMutableArray *clickArray = [IMCellDataHelper getMatchContent:mainInfo];
    if (clickArray.count > 0) {
        for (NSInteger i=0;i<clickArray.count;i++) {
            NSString *url = [clickArray objectAtIndex:i];
            NSRange ansRange = [mainInfo rangeOfString:url];
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
    return _operList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMMenuBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IMMenuBtnCell" forIndexPath:indexPath];
    [cell setContenWithTitle:[_operList objectAtIndex:indexPath.row] indexPath:indexPath];
    if (indexPath.row == 0) {
        cell.backgroundColor = [UIColor yellowColor];
    }
    
    return cell;
}

#pragma mark - method

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
