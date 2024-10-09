//
//  IMPopupView.h
//  CLP
//
//  Created by 李标 on 2022/9/19.
//

#import <UIKit/UIKit.h>
#import <MMPopupView/MMPopupView.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMPopupView : MMPopupView

- (instancetype)initWithAttributedString:(NSMutableAttributedString *)attributedString doneText:(NSString *  __nullable )doneText cancleText:(NSString * __nullable)cancleText;
@property (nonatomic,copy) void(^doneBlock)(UIButton *sender);
@property (nonatomic,copy) void(^cancleBlock)(UIButton *sender);
@end

NS_ASSUME_NONNULL_END
