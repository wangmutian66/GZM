//
//  WmtBiaoqingboardView.h
//  BQ
//
//  Created by wangmutian on 2018/1/30.
//  Copyright © 2018年 wangmutian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WmtBiaoqingboardView;
@protocol WmtBiaoqingboardView <NSObject>
@optional
/** 更多按钮的点击 */
- (void)wmt_biaoqingboaderView:(WmtBiaoqingboardView *)inputView  clickbiaoqing:(UIButton *)btn;
//- (void)wmt_inputview:(WMTinputview *)inputView moreBtnClickWith:(NSInteger)moreStyle;
- (void) btnsenddd;
@end


#define kWMTMoreinputkeyboardView 200
#define kWMTdemo 140
#define kWMTdian 10
#define kWMTbutton 40
@interface WmtBiaoqingboardView : UIView
/** 代理 */
@property (nonatomic, weak) id<WmtBiaoqingboardView> delegate;
@end
