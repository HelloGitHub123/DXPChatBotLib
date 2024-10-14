//
//  IMBottomView.m
//  IMDemo
//
//  Created by mac on 2020/6/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import "IMBottomView.h"
#import "UCCHeader.h"
#import "UIColor+IM.h"
#import "UIFont+IM.h"
#import "IMDeviceModelHelper.h"
#import "NSString+IM.h"
#import <DXPToolsLib/HJTool.h>
#import <DXPFontManagerLib/FontManager.h>

@interface IMBottomView () <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    CGFloat bottomViewWidth;
    CGFloat bottomViewHeight;
    TextBlock _textBlock;
}

@property (nonatomic, strong) UIView *realView;//除了iphoneX底部空白区域
@property (nonatomic, strong) UIButton *picBtn;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, strong) UIButton *sendBtn;

@end

@implementation IMBottomView

- (id)initWithFrame:(CGRect)frame block:(TextBlock)block {
    self = [super initWithFrame:frame];
    if (self) {
        bottomViewWidth = frame.size.width;
        bottomViewHeight = frame.size.height - ([IMDeviceModelHelper isIPhoneX] ? 34.0f : 0);
        _textBlock = block;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self addSubview:self.realView];
    [self.realView addSubview:self.picBtn];
    [self.realView addSubview:self.bgView];
    [self.bgView addSubview:self.textView];
    [self.realView addSubview:self.sendBtn];
}

- (void)setBottomEnabled {
    self.picBtn.enabled = NO;
    self.textView.editable = NO;
    self.sendBtn.enabled = NO;
}

#pragma mark -  点击图片
- (void)picsAction {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
    [[HJTool currentVC].navigationController presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark -  点击发送按钮
- (void)textAction {
    if (_textBlock && ![NSString isIMBlankString:_textView.text]) _textBlock(_textView.text);
    _textView.text = @"";
}

#pragma mark - UIImagePickerControllerDelegate, UINavigationControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *selectImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationSendImage object:selectImage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
- (UIView *)realView {
    if (!_realView) {
        _realView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bottomViewWidth, bottomViewHeight)];
        _realView.backgroundColor = UIColorFromRGB_IM(0xFFFFFF);
    }
    return _realView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(16, (bottomViewHeight-46)/2, kMainScreenWidth-16-16-32-32-10-10, 46)];
        _bgView.backgroundColor = UIColorFromRGB_IM(0xFFFFFF);
        _bgView.layer.cornerRadius = 8;
        _bgView.layer.borderWidth = 1.0;
        _bgView.layer.borderColor = UIColorFromRGB_IM(0xC7C7C7).CGColor;
    }
    return _bgView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, _bgView.frame.size.width-10*2, 36)];
        _textView.backgroundColor = UIColorFromRGB_IM(0xFFFFFF);
        _textView.textColor = UIColorFromRGB_IM(0x3A2E2E);
		_textView.font =  [FontManager setMediumFontSize:16];
        _textView.returnKeyType = UIReturnKeySend;
        _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
//        _textView.autocorrectionType = UITextAutocorrectionTypeNo;
        _textView.delegate = self;
        
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, _textView.frame.size.width-10, 16)];
        _placeHolderLabel.text = @"Type something…";
        _placeHolderLabel.textColor = UIColorFromRGB_IM(0xC7C7C7);
		_placeHolderLabel.font =  [FontManager setMediumFontSize:14];
        [_textView addSubview:_placeHolderLabel];
    }
    return _textView;
}

- (UIButton *)picBtn {
    if (!_picBtn) {
        _picBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _picBtn.frame = CGRectMake(bottomViewWidth - 48 - 10 - 32, 17, 32, 32);
        [_picBtn setBackgroundImage:[UIImage imageNamed:@"sendPhoto"] forState:UIControlStateNormal];
        [_picBtn addTarget:self action:@selector(picsAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _picBtn;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.frame = CGRectMake(bottomViewWidth - 48, 17, 32, 32);
        [_sendBtn setBackgroundImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(textAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if ([NSString isIMBlankString:textView.text]) {
        self.placeHolderLabel.hidden = NO;
    } else {
        self.placeHolderLabel.hidden = YES;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self textAction];
        return NO;//这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
