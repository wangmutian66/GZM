//
//  GuaitableViewcell.h
//  GZM
//
//  Created by wangmutian on 2018/1/4.
//  Copyright © 2018年 wangmutian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GuaiModelcell;
@class Guaitab;
@interface GuaitableViewcell : UITableViewCell
@property(nonatomic,strong) GuaiModelcell *item;
@property(nonatomic,strong) Guaitab *itemtab;

@property (weak, nonatomic) IBOutlet UIImageView *booksImg;
@property (weak, nonatomic) IBOutlet UILabel *booksName;

@property (weak, nonatomic) IBOutlet UILabel *booksSynopsis;

@property (weak, nonatomic) IBOutlet UILabel *authorName;


@end
