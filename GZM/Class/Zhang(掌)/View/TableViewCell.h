//
//  TableViewCell.h
//  GZM
//
//  Created by wangmutian on 2018/1/6.
//  Copyright © 2018年 wangmutian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZhangModel;
@interface TableViewCell : UITableViewCell
@property(nonatomic,strong) ZhangModel *model;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *timey;
@property (weak, nonatomic) IBOutlet UIImageView *cover;
@property (weak, nonatomic) IBOutlet UILabel *profile;
/** 根据当前模型数据计算出来的cell高度*/
@property (nonatomic ,assign) NSInteger cellHeight;
-(void)cellAutoLayoutHeight:(NSString *)str;
@end
