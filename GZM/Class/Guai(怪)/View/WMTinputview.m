//
//  WMTinputview.m
//  BQ
//
//  Created by wangmutian on 2018/1/30.
//  Copyright © 2018年 wangmutian. All rights reserved.
//

#import "WMTinputview.h"

@implementation WMTinputview
-(void)awakeFromNib{
    [super awakeFromNib] ;
    self.jianpanbtn.hidden=YES;
}

+(instancetype)wmt_inputview{
    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}



- (IBAction)biaoqing:(id)sender {
   
}

- (IBAction)jianpan:(id)sender {
}




- (IBAction)jianpanb1:(UIButton *)sender {
     self.jianpanbtn.hidden=!sender.isSelected;
    [self jpanorbqing];
}

- (IBAction)biaoqing1:(UIButton *)sender {
    self.jianpanbtn.hidden=sender.isSelected;
    [self jpanorbqing];
}

-(void) jpanorbqing{
    if ([self.testfield isFirstResponder]) {
        [self.testfield resignFirstResponder];
    }
    
    
    // 2.根据下方keyboard的高度(控制器.view的y值,来确定它的滑入滑出状态)
    
    if ([self.delegate respondsToSelector:@selector(wmt_inputview:moreBtnClickWith:)]) {
        
        [self.delegate wmt_inputview:self moreBtnClickWith:0];
        
    }
}


@end
