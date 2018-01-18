//
//  GuaishowTableViewController.m
//  GZM
//
//  Created by wangmutian on 2018/1/5.
//  Copyright © 2018年 wangmutian. All rights reserved.
//

#import "GuaishowTableViewController.h"
#import "Guaishowindex1ViewController.h"
#import "UIImageView+WebCache.h"
@interface GuaishowTableViewController ()<UIGestureRecognizerDelegate>

@end

@implementation GuaishowTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom] ;
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
//    self.interfaceOrientatio
//    self.interactivePopGestureRecognizer
//    NSLog(@"%@",self.interactivePopGestureRecognizer);
    //[self drawableBox];
}

-(void) drawableBox{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 500)];
    view.backgroundColor=[UIColor redColor];
    
    UIImageView *bookImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 100, 150)];
    NSString *bookurl=[NSString stringWithFormat:@"https://ss0.bdstatic.com/k4oZeXSm1A5BphGlnYG/newmusic/suibiantingting.png"];
    [bookImage sd_setImageWithURL:[NSURL URLWithString:bookurl] placeholderImage:[UIImage imageNamed:@"AppIcon"]];
    
    UILabel *booktitle=[[UILabel alloc]  initWithFrame:CGRectMake(105, 5, 100, 150)];
    booktitle.text=@"书的名字";
    
    [view addSubview:bookImage];
    
    
    
    
    [self.tableView setTableHeaderView:view];
    
    
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}


-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
