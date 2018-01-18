//
//  ZhangModel.h
//  GZM
//
//  Created by wangmutian on 2018/1/6.
//  Copyright © 2018年 wangmutian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhangModel : NSObject
@property(nonatomic,strong) NSString *profile;
@property(nonatomic,strong) NSString *cover;
@property(nonatomic,strong) NSString *timey;
@property(nonatomic,strong) NSString *name;
/** 根据当前模型数据计算出来的cell高度*/
//@property (nonatomic ,assign) NSInteger cellHeight;
@end
