//
//  IMDeviceModelHelper.h.h
//  IMDemo
//
//  Created by mac on 2020/6/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMDeviceModelHelper : NSObject

+ (BOOL)isIPhoneX;

+ (CGFloat)safeAreaInsetsTop;

+ (CGFloat)safeAreaInsetsBottom;

@end

NS_ASSUME_NONNULL_END
