//
//  WMTinputview.h
//  BQ
//
//  Created by wangmutian on 2018/1/30.
//  Copyright © 2018年 wangmutian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMTinputview;
@protocol WMTinputview <NSObject>
@optional
/** 更多按钮的点击 */
- (void)wmt_inputview:(WMTinputview *)inputView moreBtnClickWith:(NSInteger)moreStyle;

@end

@interface WMTinputview : UIView
@property (weak, nonatomic) IBOutlet UITextField *testfield;

+(instancetype) wmt_inputview;
- (IBAction)biaoqing:(id)sender;
- (IBAction)jianpan:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *jianpanbtn;
- (IBAction)jianpanb1:(UIButton *)sender;
- (IBAction)biaoqing1:(UIButton *)sender;

/** 代理 */
@property (nonatomic, weak) id<WMTinputview> delegate;
@end
