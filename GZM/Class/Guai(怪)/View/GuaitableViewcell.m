//
//  GuaitableViewcell.m
//  GZM
//
//  Created by wangmutian on 2018/1/4.
//  Copyright © 2018年 wangmutian. All rights reserved.
//

#import "GuaitableViewcell.h"
#import "GuaiModelcell.h"
#import "UIImageView+WebCache.h"
#import "Guaitab.h"
@implementation GuaitableViewcell
-(void)setItem:(GuaiModelcell *) item{
    _item=item;
    _booksName.text=item.booksName;
    _booksSynopsis.text=item.booksSynopsis;
    _authorName.text=[NSString stringWithFormat:@"%@  著",item.authorName];

//    [_booksImg sd_setImageWithURL:NSURL URLWithString:item.b ]
//    NSString * imageUlr=NString initWi (@"http://%@",item.booksImg);
     NSString *imageUlr=[NSString stringWithFormat:@"http://%@",item.booksImg];
    [_booksImg sd_setImageWithURL:[NSURL URLWithString:imageUlr] placeholderImage:[UIImage imageNamed:@"AppIcon"]];
    
}
-(void)setItemtab:(Guaitab *) itemtab{
    _itemtab=itemtab;
     NSLog(@">>>>>>>>>>%@",itemtab.booksName);
    _booksName.text=itemtab.booksName;
    _booksSynopsis.text=itemtab.booksSynopsis;
    _authorName.text=[NSString stringWithFormat:@"%@  著",itemtab.autherName];
    
    
    NSString *imageUlr=[NSString stringWithFormat:@"http://%@",itemtab.booksImg];
    [_booksImg sd_setImageWithURL:[NSURL URLWithString:imageUlr] placeholderImage:[UIImage imageNamed:@"AppIcon"]];
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
