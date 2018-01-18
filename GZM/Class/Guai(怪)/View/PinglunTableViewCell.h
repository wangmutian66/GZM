//
//  PinglunTableViewCell.h
//  GZM
//
//  Created by wangmutian on 2018/1/15.
//  Copyright © 2018年 wangmutian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class pinglunModel;
@interface PinglunTableViewCell : UITableViewCell
@property(nonatomic,strong) pinglunModel *item;
@property (weak, nonatomic) IBOutlet UIImageView *pingluntouxiang;
@property (weak, nonatomic) IBOutlet UILabel *pinglungmingzi;
@property (weak, nonatomic) IBOutlet UILabel *pingluntime;
@property (weak, nonatomic) IBOutlet UILabel *pinglundai;
@property (weak, nonatomic) IBOutlet UILabel *pingluncontent;
@property (weak, nonatomic) IBOutlet UIButton *xnum;

@end
