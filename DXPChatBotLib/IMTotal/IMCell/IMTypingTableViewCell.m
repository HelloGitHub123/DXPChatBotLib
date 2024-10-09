//
//  IMTypingTableViewCell.m
//  CLP
//
//  Created by 李标 on 2022/6/22.
//

#import "IMTypingTableViewCell.h"
#import "UIColor+IM.h"
#import "UIImage+GIF.h"

@interface IMTypingTableViewCell () {
    CGFloat baseAlpha;
}

@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;

@property (nonatomic, strong) UIImageView *imgview;

@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation IMTypingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellBgView = [[UIView alloc] init];
        _cellBgView.layer.cornerRadius = 12.0;
        [self.contentView addSubview:_cellBgView];
        
        baseAlpha = 0.3;
    }
    return self;
}

- (void)setContentWithModel:(IMMsgModel*)model indexPath:(NSIndexPath *)indexPath {
    _currentModel = model;
    //头像
    [self setContentHeadIconWithModel:model];
    
    //聊天背景
    if (model.createType == IMMsgCreateType_server) {
        _cellBgView.frame = CGRectMake(64, 0, 67, kCellMinHeight);
        //        _cellBgView.backgroundColor = [UIColor  cellServerBackgroundColor];
    }
    
//    self.view1 = [[UIView alloc] initWithFrame:CGRectMake(15, 15, 10, 10)];
//    self.view1.layer.cornerRadius = 5;
//    self.view1.alpha = 0.6;
//    self.view1.backgroundColor = [UIColor whiteColor];
//    [_cellBgView addSubview:self.view1];
//
//    self.view2 = [[UIView alloc] initWithFrame:CGRectMake(40, 15, 10, 10)];
//    self.view2.layer.cornerRadius = 5;
//    self.view2.alpha = 0.3;
//    self.view2.backgroundColor = [UIColor whiteColor];
//    [_cellBgView addSubview:self.view2];
//
//    self.view3 = [[UIView alloc] initWithFrame:CGRectMake(65, 15, 10, 10)];
//    self.view3.layer.cornerRadius = 5;
//    self.view3.alpha = 0;
//    self.view3.backgroundColor = [UIColor whiteColor];
//    [_cellBgView addSubview:self.view3];
    
    // 起定时器 1秒后关闭
//    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
//    dispatch_source_set_timer(self.timer,
//                                  dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC),
//                                  0.8 * NSEC_PER_SEC,
//                                  0);
//    dispatch_source_set_event_handler(self.timer, ^{
//        if (self.view1.alpha >= 0.9) {
//            self.view1.alpha = 0.3;
//        }
//        if (self.view2.alpha >=  0.9) {
//            self.view2.alpha = 0.3;
//        }
//        if (self.view3.alpha >=  0.9) {
//            self.view3.alpha = 0;
//        }
//        self.view1.alpha += baseAlpha;
//        self.view2.alpha += baseAlpha;
//        self.view3.alpha += baseAlpha;
//    });
//    dispatch_resume(self.timer);
    
    [self gifPlay];
    
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)gifPlay {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"typing" ofType:@"gif"];
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    self.imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, 45, 23)];
    self.imgview.image = [UIImage sd_imageWithGIFData:imageData];
    [_cellBgView addSubview:self.imgview];
}

@end
