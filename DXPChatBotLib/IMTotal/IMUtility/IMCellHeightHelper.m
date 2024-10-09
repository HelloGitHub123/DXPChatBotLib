//
//  IMCellHeightHelper.m
//  IMDemo
//
//  Created by mac on 2020/7/27.
//  Copyright © 2020 mac. All rights reserved.
//

#import "IMCellHeightHelper.h"
#import "NSString+IM.h"
#import "UIFont+IM.h"
#import "IMCellDataHelper.h"
#import "IMSatisfyMainInfoModel.h"
#import "IMSatisfyMenuModel.h"
#import "FontManager.h"

@implementation IMCellHeightHelper

+ (NSInteger)getCellHeight:(IMMsgModel *)model {
    
    if (model.msgType == IMMsgContentType_dataPrivacy) {
        CGFloat height = 0;
        CGSize maxSize = [model.mainInfo sizeForWidth:kCellMaxWidth-kCellSpace10*2 withFont:[UIFont cellContentFont]];
        height = maxSize.height+kCellSpace10*2 + (31+8)*3;
        return height;
        
    } else if (model.msgType == IMMsgContentType_text) {
        if (model.isHTML) {
            if ([model.mainInfo containsString:@"Click here"]) {
                // 针对性做特殊处理
                NSString *text = [self getZZwithString:model.mainInfo];
                CGSize maxSize = [text sizeForWidth:kCellMaxWidth-kCellSpace10*2 withFont:[UIFont cellContentFont]];
                return maxSize.height;
            } else {
                return 40;
            }
        }
        CGFloat height = 0;
        CGSize contentSize = [model.mainInfo singleSizeWithFont:[UIFont cellContentFont]];
        if ((contentSize.width+kCellSpace10*2)<kCellMaxWidth && [model.mainInfo rangeOfString:@"\n"].location == NSNotFound) {
            height = kCellMinHeight;//单行展示
        } else {
            CGSize maxSize = [model.mainInfo sizeForWidth:kCellMaxWidth-kCellSpace10*2 withFont:[UIFont cellContentFont]];
            height = maxSize.height+kCellSpace10*2;//多行展示
        }
        if (![NSString isIMBlankString:model.jumpMenu]) {
            height = height + 36;
        }
        return height;
    } else if (model.msgType == IMMsgContentType_file) {
        return kCellFileHeight;//根据显示固定图片大小来定的，ued给的图片尺寸是50*57
    } else if (model.msgType == IMMsgContentType_image) {
        return kCellImageHeight;//因为不知道网络图片的尺寸，请先写死
    } else if (model.msgType == IMMsgContentType_linkList) {
        if ([model.sessionState isEqualToString:@"C"] || [model.sessionState isEqualToString:@"Q"]) {
            NSString *title = [IMCellDataHelper getMenuHeaderContent:model.mainInfo];
            CGSize titleSize = [title sizeForWidth:kCellMaxWidth-kCellSpace10*2 withFont:[UIFont cellContentFont]];
            
            NSDictionary *mianInfoDic = [model.mainInfo JSONValue];
            NSString *showType = [mianInfoDic objectForKey:@"showType"];
            if ([showType isEqualToString:@"C"]) {
                // 评论反馈 显示菜单展示的方式 C:emoji横排展示
                NSLog(@"emoji横排展示");
                return kCellSpace10+titleSize.height+kCellSpace10+40+kCellSpace10;
            }
            
            NSArray *array = [IMCellDataHelper getMenuList:model.mainInfo];
            // 判断是否yes 和 no 按钮
            BOOL isNo = NO;
            BOOL isYes = NO;
            for (int i =0; i<array.count; i++) {
                NSDictionary *dic = [array objectAtIndex:i];
                NSString *str = [dic objectForKey:@"title"];
                if ([str isEqualToString:@"No"]) {
                    isNo = YES;
                }
                if ([str isEqualToString:@"Yes"]) {
                    isYes = YES;
                }
            }
            
            if (array == 0) {
                return kCellSpace10+titleSize.height+kCellSpace10*2;//单行展示
            } else if (isNo && isYes) {
                return kCellSpace10+titleSize.height+kCellSpace10+40+kCellSpace10;
            } else {
                if ([NSString isIMBlankString:title]) {
                    return kCellSpace10+array.count*40+kCellSpace10;//多行展示
                }
                return kCellSpace10+titleSize.height+kCellSpace10+array.count*40+kCellSpace10;//多行展示
            }
        } else {
            CGFloat height = kCellSpace10;
            IMSatisfyMainInfoModel *totalModel = [[IMSatisfyMainInfoModel alloc] initWithDic:[model.mainInfo JSONValue]];
            height = height + [[self class] getSingleHeightWithModel:totalModel];
            if (!model.isSubmit) {
                height = height + kCellSubmitBtn;
            }
            return height;
        }
    } else if (model.msgType == IMMsgContentType_menuList) {
        CGFloat height = kCellSpace10;
        NSDictionary *mainInfoDic = [model.mainInfo JSONValue];
        NSArray *menuList = [mainInfoDic objectForKey:@"menuList"];
        for (NSDictionary *dic in menuList) {
            IMSatisfyMainInfoModel *infoModel = [[IMSatisfyMainInfoModel alloc] initWithDic:dic];
            height = height + [[self class] getSingleHeightWithModel:infoModel];
        }
        if (!model.isSubmit) {
            height = height + kCellSubmitBtn;
        }
        return height;
    } else if (model.msgType == IMMsgContentType_VOIP) {
        NSString *title = [IMCellDataHelper getMenuHeaderContent:model.mainInfo];
        CGSize titleSize = [title sizeForWidth:kCellMaxWidth-kCellSpace10*2 withFont:[UIFont cellContentFont]];
        return kCellSpace10+titleSize.height+kCellSpace10+40+kCellSpace10;
        
    } else if (model.msgType == IMMsgContentType_commonQuestion) {
      
    } else if (model.msgType == IMMsgContentType_disLike) {
        if (model.isSubmit) {
          return 50+1*50+10;
        }
        return 50+[model.dislikeList count]*50+70;
    } else if (model.msgType == IMMsgContentType_quickQuesttion) {
      
    }
    
    return kCellMinHeight;
}

#pragma mark - private method
+ (CGFloat)getSingleHeightWithModel:(IMSatisfyMainInfoModel *)model {
    CGFloat tempHeight = 0;
    //header高度
	CGSize headerSize = [model.header sizeForWidth:kMaxCellWidthNoIcon withFont:[FontManager setMediumFontSize:14]];
    tempHeight = tempHeight + headerSize.height + kCellSpace10;
    
    //星星、单选、多选 每一行高度都是：kCellSingleList （kCellSingleList 包含上下间距了）
    if ([model.feedbackType isEqualToString:@"B"]) {
        tempHeight = tempHeight + kCellSingleList;
    } else {
        tempHeight = tempHeight + kCellSingleList*[model.menu count];
    }
    
    //评分项没有输入框,   改进项是否展示输入框
    if ([model.questionText isEqualToString:@"Y"] && (model.isTypeQ || model.menu.count == 0)) {
        tempHeight = tempHeight + kCellQuestTextHeight+kCellSpace10;
    }

    return tempHeight;
}


//正则去除标签
+ (NSString *)getZZwithString:(NSString *)string {
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n"
                                                                                    options:0
                                                                                      error:nil];
    string=[regularExpretion stringByReplacingMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) withTemplate:@""];
    return string;
}

@end
