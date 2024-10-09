//
//  IMUserInfoTableViewCell.m
//  CLP
//
//  Created by 李标 on 2021/12/16.
//

#import "IMUserInfoTableViewCell.h"
#import "IMMenuBtnTableViewCell.h"
#import "UIColor+IM.h"
#import "IMCellDataHelper.h"
#import "UIFont+IM.h"
#import "NSString+IM.h"
#import <DXPToolsLib/HJMBProgressHUD.h>
#import <DXPToolsLib/HJMBProgressHUD+Category.h>

@interface IMUserInfoTableViewCell()<UITableViewDataSource, UITableViewDelegate, IMMenuBtnCellDelegate, UITextFieldDelegate> {
    
    IMMsgModel *_currentModel;
}

@property (nonatomic, strong) UIView *cellBgView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *titleLab; // 标题
@property (nonatomic, strong) UILabel *firstNameLab;
@property (nonatomic, strong) UITextField *firstNameTF;
@property (nonatomic, strong) UILabel *lastNameLab;
@property (nonatomic, strong) UITextField *lastNameTF;
@property (nonatomic, strong) UILabel *emailAddressLab;
@property (nonatomic, strong) UITextField *emailAddressTF;
@property (nonatomic, strong) UILabel *mobileNumberLab;
@property (nonatomic, strong) UITextField *mobileNumberTF;
@end

@implementation IMUserInfoTableViewCell

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
        [_tableView registerClass:[IMMenuBtnTableViewCell class] forCellReuseIdentifier:@"IMMenuBtnTableViewCell"];
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
        _cellBgView.backgroundColor = [UIColor clearColor];
    }
    
    //tableView
    _tableView.frame = CGRectMake(0, 0, kCellMaxWidth, model.cellHeight);
    [_tableView reloadData];
    
    
    if (isEmptyString_IM(self.firstNameTF.text)
        || isEmptyString_IM(self.lastNameTF.text)
        || isEmptyString_IM(self.emailAddressTF.text)) {
        // 初始化设置按钮不可点击
        [self setMenuButtonEnable:NO];
    } else {
        [self setMenuButtonEnable:YES];
    }
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

// 设置按钮可点击状态
- (void)setMenuButtonEnable:(BOOL)flag {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    IMMenuBtnTableViewCell *cell = (IMMenuBtnTableViewCell *)[self.tableView cellForRowAtIndexPath: indexPath];
    cell.menuBtn.enabled = flag;
    if (flag) {
        cell.menuBtn.alpha = 1.0;
    } else {
        cell.menuBtn.alpha = 0.4;
    }
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //得到输入框的内容
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.mobileNumberTF == textField) {  //判断是否时我们想要限定的那个输入框
        if (toBeString.length > 11) {
            return NO;
        }
        //限制输入框只能输入数字
        return [self validateNumber:string];
    }
    
    if (self.firstNameTF == textField || self.lastNameTF == textField) {
        // 只能输入字母
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    
    return YES;
}

//监听textField输入方法
- (void)changedTextField:(UITextField *)textField {
    if (isEmptyString_IM(self.firstNameTF.text) || isEmptyString_IM(self.lastNameTF.text) || isEmptyString_IM(self.emailAddressTF.text)) {
        [self setMenuButtonEnable:NO];
        return;
    }
    [self setMenuButtonEnable:YES];
}

#pragma mark - tableView delegate and source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGSize titleSize = [_currentModel.mainInfo sizeForWidth:kCellMaxWidth-kCellSpace10*2 withFont:[UIFont cellFontTextSize12]];
    return kCellSpace10 + titleSize.height + (kCellSpace6 + 12 + kCellSpace6 + 40)*4 + kCellSpace10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGSize titleSize = [_currentModel.mainInfo sizeForWidth:kCellMaxWidth-kCellSpace10*2 withFont:[UIFont cellFontTextSize12]];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCellMaxWidth, kCellSpace10 + titleSize.height + (kCellSpace6 + 12 + kCellSpace6 + 40)*4 + kCellSpace10)];
    headView.backgroundColor = [UIColor cellServerBackgroundColor];
    headView.layer.cornerRadius = 8;
    // 标题
    [headView addSubview:self.titleLab];
    // First Name
    [headView addSubview:self.firstNameLab];
    // First Name Tf
    [headView addSubview:self.firstNameTF];
    // Last Name
    [headView addSubview:self.lastNameLab];
    // Last Name tf
    [headView addSubview:self.lastNameTF];
    // email address
    [headView addSubview:self.emailAddressLab];
    // email address TF
    [headView addSubview:self.emailAddressTF];
    // Mobile Number(Optional)
    [headView addSubview:self.mobileNumberLab];
    // Mobile Number(Optional) TF
    [headView addSubview:self.mobileNumberTF];
    
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
    IMMenuBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IMMenuBtnTableViewCell" forIndexPath:indexPath];
    cell.delegate =self;
    [cell setContenWithTitle:@"Start conversation" indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - IMMenuBtnCellDelegate
- (void)menuButtonClickByTarget:(IMMenuBtnTableViewCell *)cell indexPath:(nonnull NSIndexPath *)indexPath {
    if (isEmptyString_IM(self.firstNameTF.text)
        || isEmptyString_IM(self.lastNameTF.text)
        || isEmptyString_IM(self.emailAddressTF.text)) {
        
        return;
    }
    
    //  校验邮箱
    if (![self checkEmail:self.emailAddressTF.text]) {
		[HJMBProgressHUD showText:@"Please enter a valid email address."];
        return;
    }
    
    if (!isEmptyString_IM(self.mobileNumberTF.text)) {
        // 号码不为空，那就必须09开头 11位
        if (self.mobileNumberTF.text.length < 11) {
			[HJMBProgressHUD showText:@"Please enter a valid contact number. Number should start from 09XXXXXXXXX."];
            return;
        }
        
        NSString *prefix = [self.mobileNumberTF.text substringToIndex:2];
        if (![prefix isEqualToString:@"09"]) {
			[HJMBProgressHUD showText:@"Please enter a valid contact number. Number should start from 09XXXXXXXXX."];
            return;
        }
    }
    
    // 提交用户数据
    if (self.delegate && [self.delegate respondsToSelector:@selector(SubmitUserInfoAction:firstName:lastName:emailAddress:mobileNumber:birthday:)]) {
        // 客户确认，目前birthday写死。各渠道创建客户的参数都不一样
        [self.delegate SubmitUserInfoAction:self firstName:self.firstNameTF.text lastName:self.lastNameTF.text emailAddress:self.emailAddressTF.text mobileNumber:self.mobileNumberTF.text birthday:@"2000-01-01"];
    }
}

#pragma mark - 懒加载
- (UILabel *)titleLab {
    if (!_titleLab) {
        NSString *title = @"Please fill in the details below to start the conversation.:";
        CGSize titleSize = [title sizeForWidth:kCellMaxWidth-kCellSpace10*2 withFont:[UIFont cellFontTextSize12]];
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(kCellSpace10, kCellSpace10, kCellMaxWidth-kCellSpace10*2, titleSize.height)];
        _titleLab.text = title;
        _titleLab.numberOfLines = 0;
        _titleLab.font = [UIFont cellFontTextSize12];
        _titleLab.textColor = UIColorFromRGB_IM(0xFFFFFF);
    }
    return _titleLab;
}

- (UILabel *)firstNameLab {
    if (!_firstNameLab) {
        _firstNameLab = [[UILabel alloc] initWithFrame:CGRectMake(kCellSpace10, CGRectGetMaxY(self.titleLab.frame)+kCellSpace6, kCellMaxWidth-kCellSpace10*2, 12)];
        _firstNameLab.text = @"First Name";
        _firstNameLab.font = [UIFont cellFontTextSize12];
        _firstNameLab.textColor = UIColorFromRGB_IM(0xFFFFFF);
    }
    return _firstNameLab;
}

- (UITextField *)firstNameTF {
    if (!_firstNameTF) {
        _firstNameTF = [[UITextField alloc] initWithFrame:CGRectMake(kCellSpace10, CGRectGetMaxY(self.firstNameLab.frame)+kCellSpace6, kCellMaxWidth-kCellSpace10*2, 40)];
        _firstNameTF.delegate = self;
        _firstNameTF.textColor = UIColorFromRGB_IM(0x2F3043);
        _firstNameTF.font = [UIFont cellFontTextSize16];
        _firstNameTF.backgroundColor = [UIColor whiteColor];
        _firstNameTF.layer.cornerRadius = 8;
        _firstNameTF.layer.borderWidth = 1;
        _firstNameTF.placeholder = @"";
        _firstNameTF.layer.borderColor = UIColorFromRGB_IM(0xC7C7C7).CGColor;
        _firstNameTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 0)];
        _firstNameTF.leftViewMode = UITextFieldViewModeAlways;
        [_firstNameTF addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    }
    return _firstNameTF;
}

- (UILabel *)lastNameLab {
    if (!_lastNameLab) {
        _lastNameLab = [[UILabel alloc] initWithFrame:CGRectMake(kCellSpace10, CGRectGetMaxY(self.firstNameTF.frame)+kCellSpace6, kCellMaxWidth-kCellSpace10*2, 12)];
        _lastNameLab.text = @"Last Name";
        _lastNameLab.font = [UIFont cellFontTextSize12];
        _lastNameLab.textColor = UIColorFromRGB_IM(0xFFFFFF);
    }
    return _lastNameLab;
}

- (UITextField *)lastNameTF {
    if (!_lastNameTF) {
        _lastNameTF = [[UITextField alloc] initWithFrame:CGRectMake(kCellSpace10, CGRectGetMaxY(self.lastNameLab.frame)+kCellSpace6, kCellMaxWidth-kCellSpace10*2, 40)];
        _lastNameTF.delegate = self;
        _lastNameTF.textColor = UIColorFromRGB_IM(0x2F3043);
        _lastNameTF.font = [UIFont cellFontTextSize16];
        _lastNameTF.backgroundColor = [UIColor whiteColor];
        _lastNameTF.layer.cornerRadius = 8;
        _lastNameTF.layer.borderWidth = 1;
        _lastNameTF.placeholder = @"";
        _lastNameTF.layer.borderColor = UIColorFromRGB_IM(0xC7C7C7).CGColor;
        _lastNameTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 0)];
        _lastNameTF.leftViewMode = UITextFieldViewModeAlways;
        [_lastNameTF addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    }
    return _lastNameTF;
}

- (UILabel *)emailAddressLab {
    if (!_emailAddressLab) {
        _emailAddressLab = [[UILabel alloc] initWithFrame:CGRectMake(kCellSpace10, CGRectGetMaxY(self.lastNameTF.frame)+kCellSpace6, kCellMaxWidth-kCellSpace10*2, 12)];
        _emailAddressLab.text = @"Email Address";
        _emailAddressLab.font = [UIFont cellFontTextSize12];
        _emailAddressLab.textColor = UIColorFromRGB_IM(0xFFFFFF);
    }
    return _emailAddressLab;
}

- (UITextField *)emailAddressTF {
    if (!_emailAddressTF) {
        _emailAddressTF = [[UITextField alloc] initWithFrame:CGRectMake(kCellSpace10, CGRectGetMaxY(self.emailAddressLab.frame)+kCellSpace6, kCellMaxWidth-kCellSpace10*2, 40)];
        _emailAddressTF.delegate = self;
        _emailAddressTF.textColor = UIColorFromRGB_IM(0x2F3043);
        _emailAddressTF.font = [UIFont cellFontTextSize16];
        _emailAddressTF.backgroundColor = [UIColor whiteColor];
        _emailAddressTF.layer.cornerRadius = 8;
        _emailAddressTF.layer.borderWidth = 1;
        _emailAddressTF.placeholder = @"";
        _emailAddressTF.layer.borderColor = UIColorFromRGB_IM(0xC7C7C7).CGColor;
        _emailAddressTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 0)];
        _emailAddressTF.leftViewMode = UITextFieldViewModeAlways;
        [_emailAddressTF addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    }
    return _emailAddressTF;
}

- (UILabel *)mobileNumberLab {
    if (!_mobileNumberLab) {
        _mobileNumberLab = [[UILabel alloc] initWithFrame:CGRectMake(kCellSpace10, CGRectGetMaxY(self.emailAddressTF.frame)+kCellSpace6, kCellMaxWidth-kCellSpace10*2, 12)];
        _mobileNumberLab.text = @"Mobile Number(Optional)";
        _mobileNumberLab.font = [UIFont cellFontTextSize12];
        _mobileNumberLab.textColor = UIColorFromRGB_IM(0xFFFFFF);
    }
    return _mobileNumberLab;
}

- (UITextField *)mobileNumberTF {
    if (!_mobileNumberTF) {
        _mobileNumberTF = [[UITextField alloc] initWithFrame:CGRectMake(kCellSpace10, CGRectGetMaxY(self.mobileNumberLab.frame)+kCellSpace6, kCellMaxWidth-kCellSpace10*2, 40)];
        _mobileNumberTF.delegate = self;
        _mobileNumberTF.textColor = UIColorFromRGB_IM(0x2F3043);
        _mobileNumberTF.keyboardType = UIKeyboardTypeNumberPad;
        _mobileNumberTF.font = [UIFont cellFontTextSize16];
        _mobileNumberTF.backgroundColor = [UIColor whiteColor];
        _mobileNumberTF.layer.cornerRadius = 8;
        _mobileNumberTF.layer.borderWidth = 1;
        _mobileNumberTF.placeholder = @"";
        _mobileNumberTF.layer.borderColor = UIColorFromRGB_IM(0xC7C7C7).CGColor;
        _mobileNumberTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 0)];
        _mobileNumberTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _mobileNumberTF;
}

#pragma mark - util
// 限制输入框只能输入数字
- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

// 邮箱格式校验
- (BOOL)checkEmail:(NSString *)email {
    if (IsNilOrNull_IM(email)) {
        return NO;
    }
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTest evaluateWithObject:email];
}

@end
