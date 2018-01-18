//
//  YSLoopBanner.h
//  GZM
//
//  Created by wangmutian on 2018/1/4.
//  Copyright © 2018年 wangmutian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSLoopBanner : UIView
/** click action */
@property (nonatomic, copy) void (^clickAction) (NSInteger curIndex) ;

/** data source */
@property (nonatomic, copy) NSArray *imageURLStrings;


- (instancetype)initWithFrame:(CGRect)frame scrollDuration:(NSTimeInterval)duration;

@end
