//
//  ChapterListModel.h
//  GZM
//
//  Created by wangmutian on 2018/1/13.
//  Copyright © 2018年 wangmutian. All rights reserved.
//chapterImg chaptreName createTime durationMsec

#import <Foundation/Foundation.h>

@interface ChapterListModel : NSObject
@property(nonatomic,strong) NSString *chapterId;
@property(nonatomic,strong) NSString *chapterImg;
@property(nonatomic,strong) NSString *chaptreName;
@property(nonatomic,strong) NSString *createTime;
@property(nonatomic,strong) NSString *durationMsec;
@end
