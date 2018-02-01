//
//  GuaishowTableViewController.h
//  GZM
//
//  Created by wangmutian on 2018/1/5.
//  Copyright © 2018年 wangmutian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GuaishowTableViewController;
@protocol GuaishowTableViewController <NSObject>
@optional
/** 滚动发生 **/
- (void)scrollappend;

@end

@interface GuaishowTableViewController : UITableViewController
- (instancetype)initWithUserInfo:(NSString *) bookId;
@property (weak, nonatomic) IBOutlet UIImageView *bookimg;
@property (weak, nonatomic) IBOutlet UILabel *bookname;
@property (weak, nonatomic) IBOutlet UILabel *bookdesc;

@property (weak, nonatomic) IBOutlet UIImageView *autuimg;

@property (weak, nonatomic) IBOutlet UILabel *authname;
@property (weak, nonatomic) IBOutlet UILabel *authdesc;
@property (weak, nonatomic) IBOutlet UILabel *profile;
@property (weak, nonatomic) IBOutlet UIView *kechenglog;
@property (weak, nonatomic) IBOutlet UIView *tableviewheader;
@property (weak, nonatomic) IBOutlet UIView *tablefooter;
/** 代理 */
@property (nonatomic, weak) id<GuaishowTableViewController> delegate;
@end
