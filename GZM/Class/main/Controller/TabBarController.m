//
//  TabBarController.m
//  GZM
//
//  Created by wangmutian on 2018/1/8.
//  Copyright © 2018年 wangmutian. All rights reserved.
//

#import "TabBarController.h"
#import "ZhangViewController.h"
#import "MenViewController.h"
#import "GuaiTableViewController.h"
#import "Men2ViewController.h"
@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    GuaiTableViewController *guai=[[GuaiTableViewController alloc] init];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:guai];
    [self addChildViewController:nav];
    
    ZhangViewController *zhang=[[ZhangViewController alloc] init];
    UINavigationController *nav1=[[UINavigationController alloc] initWithRootViewController:zhang];
    [self addChildViewController:nav1];
    
//    MenViewController *men=[[MenViewController alloc] init];
//    UINavigationController *nav2=[[UINavigationController alloc] initWithRootViewController:men];
//    [self addChildViewController:nav2];
    
//        Men2ViewController *men=[Men2ViewController men2view];
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:NSStringFromClass([Men2ViewController class]) bundle:nil];
    Men2ViewController *men = [storyboard instantiateInitialViewController];
        UINavigationController *nav2=[[UINavigationController alloc] initWithRootViewController:men];
        [self addChildViewController:nav2];
    
    nav.tabBarItem.title=@"怪";
    nav.tabBarItem.image=[UIImage imageNamed:@"guai"];
    nav.tabBarItem.selectedImage=[UIImage imageNamed:@"guai_hover"];
    //设置按钮选中标题颜色
    NSMutableDictionary *attrs=[NSMutableDictionary dictionary];
    //    attrs[NSForegroundColorAttributeName]=[UIColor redColor];
    attrs[NSForegroundColorAttributeName]=[UIColor colorWithRed:199/255.0 green:21/255.0 blue:33/255.0 alpha:1];
    [nav.tabBarItem setTitleTextAttributes:attrs forState:UIControlStateSelected];
    
    nav1.tabBarItem.title=@"掌";
    nav1.tabBarItem.image=[UIImage imageNamed:@"zhang"];
    nav1.tabBarItem.selectedImage=[UIImage imageNamed:@"zhang_hover"];
    //NSMutableDictionary *attrs=[NSMutableDictionary dictionary];
    //attrs[NSForegroundColorAttributeName]=[UIColor colorWithRed:199/255.0 green:21/255.0 blue:33/255.0 alpha:1];
    [nav1.tabBarItem setTitleTextAttributes:attrs forState:UIControlStateSelected];
    
    nav2.tabBarItem.title=@"门";
    nav2.tabBarItem.image=[UIImage imageNamed:@"men"];
    nav2.tabBarItem.selectedImage=[UIImage imageNamed:@"men_hover"];
    [nav2.tabBarItem setTitleTextAttributes:attrs forState:UIControlStateSelected];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
