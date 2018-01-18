//
//  PinglunTableViewCell.m
//  GZM
//
//  Created by wangmutian on 2018/1/15.
//  Copyright © 2018年 wangmutian. All rights reserved.
//

#import "PinglunTableViewCell.h"
#import "pinglunModel.h"
#import "UIImageView+WebCache.h"

@implementation PinglunTableViewCell
-(void)setItem:(pinglunModel *) item{
    _pingluncontent.text=item.content;
    _pinglundai.text=item.otimeDate;
    _pingluntime.text=item.otimeTime;
    _pinglungmingzi.text=item.nickName;
    [_xnum setTitle:[NSString stringWithFormat:@"查看%@条回复",item.zsum] forState:UIControlStateNormal];
    NSString *imageUlr=[NSString stringWithFormat:@"http://%@",item.head_img];
    [_pingluntouxiang sd_setImageWithURL:[NSURL URLWithString:imageUlr] placeholderImage:[UIImage imageNamed:@"AppIcon"]];
    _pingluntouxiang.layer.cornerRadius=28;
    _pingluntouxiang.layer.masksToBounds=YES;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
