//
//  IMHistoryViewController.m
//  CLP
//
//  Created by mac on 2021/5/11.
//

#import "IMHistoryViewController.h"
#import "UCCHeader.h"
#import "IMDeviceModelHelper.h"
#import "IMHistoryTableViewCell.h"
#import "IMChatDBManager.h"
#import "IMConfigSingleton.h"
#import "NSString+IM.h"
#import <DXPToolsLib/HJMBProgressHUD.h>
#import <DXPToolsLib/HJMBProgressHUD+Category.h>
#import "FontManager.h"

static NSString *historyCellIdentifier = @"IMHistoryTableViewCelldentifier";

@interface IMHistoryViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate> {
    ChatBlock _chatBlock;
    CGFloat topViewHeight;
    NSMutableArray *_chatArray;
    NSString *_keyWord;
}

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIView *inputBGView;
@property (nonatomic, strong) UIImageView *searchImageView;
@property (nonatomic, strong) UITextField *searchTF;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *noDataView;
@property (nonatomic, strong) UILabel *noDataLab;

@end

@implementation IMHistoryViewController

- (id)initWithBlock:(ChatBlock)block {
    self = [super init];
    if (self) {
        _chatBlock = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB_IM(0xF2F2F2);
    
    [self initData];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)initData {
    _chatArray = [[NSMutableArray alloc] init];
    _keyWord = @"";
    topViewHeight = [IMDeviceModelHelper isIPhoneX] ? 88.0f : 64.0f;
}

- (void)initUI {
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.backBtn];
    [self.topView addSubview:self.inputBGView];
    [self.inputBGView addSubview:self.searchImageView];
    [self.inputBGView addSubview:self.searchTF];
    
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.noDataView];
    [self.contentView addSubview:self.noDataLab];
}

#pragma mark - 返回
- (void)backAction {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView delegate and source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _chatArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMMsgModel *model = [_chatArray objectAtIndex:indexPath.section];
    CGSize textSize= [model.mainInfo sizeForWidth:kMainScreenWidth-56-16 withFont:[FontManager setMediumFontSize:14]];
    return 40+textSize.height+5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:historyCellIdentifier forIndexPath:indexPath];
    IMMsgModel *model = [_chatArray objectAtIndex:indexPath.section];
    [cell setContentWithModel:model key:_keyWord];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [HJMBProgressHUD showLoading];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        IMMsgModel *model = [_chatArray objectAtIndex:indexPath.section];
        NSMutableArray *array = [IMChatDBManager queryAllSearchChatDBWithUserId:[IMConfigSingleton sharedInstance].userId lastTime:model.createTime];
        dispatch_async(dispatch_get_main_queue(), ^{
            [HJMBProgressHUD hideLoading];
            if (_chatBlock) _chatBlock(array);
            [self.navigationController popViewControllerAnimated:YES];
        });
    });
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField becomeFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidChange:(UITextField *)textField {
    [_chatArray removeAllObjects];
    _keyWord = textField.text;
    if (![NSString isIMBlankString:_keyWord]) {
        _chatArray = [IMChatDBManager querySearchChatDBWithUserId:[IMConfigSingleton sharedInstance].userId key:_keyWord];
    }
    if (_chatArray.count > 0 && ![NSString isIMBlankString:textField.text]) {
        self.noDataLab.hidden = YES;
        self.noDataView.hidden = YES;
    } else {
        self.noDataLab.hidden = NO;
        self.noDataView.hidden = NO;
    }
    [self.tableView reloadData];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSString *inputText = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    if (inputText.length > 0) {
//        if ([[inputText substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"5"] && inputText.length<10) {
//            return YES;
//        } else {
//            return NO;
//        }
//    }
    return YES;
}

#pragma mark -
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, topViewHeight)];
        _topView.backgroundColor = UIColorFromRGB_IM(0xFFFFFF);
        
        UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:_topView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(18, 18)];
        CAShapeLayer *cornerRadiusLayer = [[CAShapeLayer alloc ] init];
        cornerRadiusLayer.frame = _topView.bounds;
        cornerRadiusLayer.path = cornerRadiusPath.CGPath;
        _topView.layer.mask = cornerRadiusLayer;
    }
    return _topView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(16, topViewHeight-35, 30, 30);
        [_backBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
        _backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIView *)inputBGView {
    if (!_inputBGView) {
        _inputBGView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.backBtn.frame), topViewHeight-40, kMainScreenWidth-CGRectGetMaxX(self.backBtn.frame)-32, 36)];
        _inputBGView.backgroundColor = UIColorFromRGB_IM(0xFFFFFF);
        _inputBGView.layer.cornerRadius = 8;
        _inputBGView.layer.borderColor = UIColorFromRGB_IM(0xC7C7C7).CGColor;
        _inputBGView.layer.borderWidth = 1;
    }
    return _inputBGView;
}

- (UIImageView *)searchImageView {
    if (!_searchImageView) {
        _searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 9, 18, 18)];
        _searchImageView.image = [UIImage imageNamed:@"search"];
    }
    return _searchImageView;
}

- (UITextField *)searchTF {
    if (!_searchTF) {
        _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(45, 3, self.inputBGView.frame.size.width-55, 30)];
        _searchTF.textColor = UIColorFromRGB_IM(0x3A2E2E);
        _searchTF.font = [FontManager setMediumFontSize:16];
        _searchTF.delegate = self;
        _searchTF.placeholder = @"Type something…";
        [_searchTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _searchTF;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, topViewHeight+16, kMainScreenWidth, kMainScreenHeight-topViewHeight-16)];
        _contentView.backgroundColor = UIColorFromRGB_IM(0xFFFFFF);

        UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(18, 18)];
        CAShapeLayer *cornerRadiusLayer = [[CAShapeLayer alloc ] init];
        cornerRadiusLayer.frame = _contentView.bounds;
        cornerRadiusLayer.path = cornerRadiusPath.CGPath;
        _contentView.layer.mask = cornerRadiusLayer;
    }
    return _contentView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, kMainScreenWidth, self.contentView.frame.size.height-10) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundView = nil;
        _tableView.backgroundColor = [UIColor clearColor];
        
        [_tableView registerClass:[IMHistoryTableViewCell class] forCellReuseIdentifier:historyCellIdentifier];
        
        if (@available(iOS 11.0, *)) {
            self.tableView.estimatedSectionHeaderHeight = 0;
            self.tableView.estimatedSectionFooterHeight = 0;
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (UIImageView *)noDataView {
    if (!_noDataView) {
        _noDataView = [[UIImageView alloc] initWithFrame:CGRectMake((kMainScreenWidth-188)/2, self.contentView.frame.size.height/2-200, 188, 159)];
        _noDataView.image = [UIImage imageNamed:@"img_no_data_found"];
        _noDataView.hidden = YES;
    }
    return _noDataView;
}

- (UILabel *)noDataLab {
    if (!_noDataLab) {
        _noDataLab = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.noDataView.frame)+20, kMainScreenWidth-40, 50)];
        _noDataLab.text = @"Sorry! No results found. Please try another search.";
        _noDataLab.font = [FontManager setMediumFontSize:18];
        _noDataLab.textAlignment = NSTextAlignmentCenter;
        _noDataLab.textColor = UIColorFromRGB_IM(0x3A2E2E);
        _noDataLab.numberOfLines = 0;
        _noDataLab.hidden = YES;
    }
    return _noDataLab;
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
