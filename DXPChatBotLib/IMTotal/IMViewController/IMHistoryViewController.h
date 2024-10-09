//
//  IMHistoryViewController.h
//  CLP
//
//  Created by mac on 2021/5/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ChatBlock)(NSMutableArray *dataArray);

@interface IMHistoryViewController : UIViewController

- (id)initWithBlock:(ChatBlock)block;

@end

NS_ASSUME_NONNULL_END
