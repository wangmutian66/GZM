//
//  TableViewCell.m
//  GZM
//
//  Created by wangmutian on 2018/1/6.
//  Copyright © 2018年 wangmutian. All rights reserved.
//

#import "TableViewCell.h"
#import "ZhangModel.h"
#import "UIImageView+WebCache.h"

@implementation TableViewCell
-(void)cellAutoLayoutHeight:(NSString *)str{

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - Setters
-(void)setModel:(ZhangModel *)model
{
    _model = model;
    
    _name.text=model.name;
     _profile.text=model.profile;
    _timey.text=model.timey;
    
    NSString *imageUlr=[NSString stringWithFormat:@"http://%@",model.cover];
    [_cover sd_setImageWithURL:[NSURL URLWithString:imageUlr] placeholderImage:[UIImage imageNamed:@"AppIcon"]];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
