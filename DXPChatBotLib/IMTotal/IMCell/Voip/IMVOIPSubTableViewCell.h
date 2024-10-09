//
//  IMVOIPSubTableViewCell.h
//  CLP
//
//  Created by 李标 on 2023/4/17.
//

#import <UIKit/UIKit.h>
#import "IMTableViewCell.h"
#import "IMMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, IMVOIPAgreeButtonType) {
    IMVOIPAgreeButtonType_Yes       =   0, // 不同意接入VOIP
    IMVOIPAgreeButtonType_No        =   1, // 不同意接入VOIP
};


@protocol IMVOIPSubTableViewCellDelegate <NSObject>

- (void)VOIPSubTableViewCellEventByTag:(IMVOIPAgreeButtonType)tag target:(id)target;
@end


@interface IMVOIPSubTableViewCell : UITableViewCell

@property (assign, nonatomic) IMVOIPAgreeButtonType agreeType;
@property (assign, nonatomic) id<IMVOIPSubTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
