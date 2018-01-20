//
//  GuaiTabViewController.m
//  GZM
//
//  Created by wangmutian on 2018/1/18.
//  Copyright © 2018年 wangmutian. All rights reserved.
//

#import "GuaiTabViewController.h"
#import "UIView+Layout.h"
#import "AFNetWorking/AFNetWorking.h"
#import "MJExtension/MJExtension.h"
#import "Fication.h"
#import "GuaitableViewcell.h"
#import "GuaiTab.h"
#import "GuaishowTableViewController.h"
@interface GuaiTabViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
//用来存放所有子控制器的view
@property (nonatomic,weak) UIScrollView *scrollview;
//标题栏
@property (nonatomic,weak) UIView *titlesValue;
//下划线
@property (nonatomic,weak) UIView *titlesUnderline;
//记录上一次点击标题按钮
@property(nonatomic,weak) UIButton *previousClicked;

//记录上一次点击标题按钮
@property(nonatomic,strong) NSArray *car;

@property(nonatomic,strong) NSArray *data;

//视图界面的数据
@property(nonatomic,strong) NSArray *viewdata;

@property(nonatomic) NSInteger indexs;
@end

@implementation GuaiTabViewController
- (instancetype)initWithFicationId:(NSInteger) ficationId {
    if (self = [super init]) {
        
        self.indexs=ficationId;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom] ;
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    
   
   
    
    
     [self httpdataview];
}

-(void) httpdataview{
    NSString *path=[NSString stringWithFormat:@"%@/author.php/Nexts/getAllCategoryAndBooksList",PUBLIC_URL];
    AFHTTPSessionManager *mgr=[AFHTTPSessionManager manager];
    [mgr GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *adDict=responseObject[@"dataList"] ;
//        _viewdata=[Fication mj_objectArrayWithKeyValuesArray:adDict];
        
        _viewdata=responseObject[@"dataList"] ;
         [self setupScrollView:[_viewdata count]];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}




//滚动条是 tabBar  是叫scroll 的内容向下移动 64
-(void) setupScrollView:(NSUInteger) count{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollview = [[UIScrollView alloc] init];
    scrollview.backgroundColor =[UIColor greenColor];
    scrollview.frame= self.view.bounds;
    scrollview.showsHorizontalScrollIndicator = NO; //去掉横向滚动条
    scrollview.showsVerticalScrollIndicator = NO; //去掉 纵向滚动条
    scrollview.pagingEnabled = YES; //让可以分页
    [self.view addSubview:scrollview];
    self.scrollview=scrollview;
    scrollview.delegate = self;
    
    for(NSInteger i = 0; i<count;i++){
        UITableView *tableview = [[UITableView alloc] init];
        tableview.tag=i;
//        data[i][@""]
        
//        tableview.alpha=0.5;
        tableview.frame=CGRectMake(scrollview.widht*i, 50, scrollview.widht, scrollview.heiht);
        if(i%2==0){
            tableview.backgroundColor=[UIColor greenColor];
        }
        tableview.delegate = self;
        tableview.dataSource=self;
        tableview.rowHeight=150;
//        tableview.delegate=self;
        UIView *v=[[UIView alloc] init];
        v.frame=CGRectMake(0, 0, self.view.widht, 50);
        [tableview setTableHeaderView:v];
         [tableview setTableFooterView:v];
        [scrollview addSubview:tableview];
        
    }
    
    scrollview.contentSize = CGSizeMake(5 *scrollview.widht , 0);
    
    
    //标题栏按钮 中的数据请求
    [self httpqingqiu];
}



//httpqing 请求
-(void)httpqingqiu{
    
    NSString *path=[NSString stringWithFormat:@"%@/admin.php/Systeminterface/all_fication",PUBLIC_URL];
    AFHTTPSessionManager *mgr=[AFHTTPSessionManager manager];
    [mgr GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *adDict=responseObject[@"dataList"] ;
        _car=[Fication mj_objectArrayWithKeyValuesArray:adDict];
//        NSLog(@"======++++=>%x",[_car count]);
        
        
         [self setupTitleButtons:_car];
        CGFloat offsetx=self.scrollview.widht * self.indexs;
        self.scrollview.contentOffset=CGPointMake(offsetx, self.scrollview.contentOffset.y);
        UIButton *titleButton=self.titlesValue.subviews[self.indexs];
        CGFloat centerx=titleButton.center.x;

        self.titlesUnderline.centerX = centerx;
        
//        [self titleButtonClick:button];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}


-(void)setupTitleButtons:(NSArray *) titlearr{
    //    NSArray *titlearr=@[@"全部",@"视频",@"声音",@"图片",@"段子"];
   NSUInteger count = titlearr.count;
   
    UIView *titleView = [[UIView alloc] init];
//    titleView.backgroundColor=[UIColor blueColor];
        titleView.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.5];
    //    titleView.backgroundColor =[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    //    titleView.alpha=0.5;
    titleView.frame= CGRectMake(0, 64, self.view.widht, 50);
    self.titlesValue=titleView;
    [self.view addSubview:titleView];
    
    CGFloat titleButtonW=self.titlesValue.widht / count;
    CGFloat titleButtonH=self.titlesValue.heiht;
  
    for (NSInteger i=0; i < count; i++) {
        Fication  *fication = titlearr[i];
        
        UIButton *titleButton = [[UIButton alloc] init];
        titleButton.tag=i;
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
     
        [titleButton setTitleColor:[UIColor darkGrayColor]  forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor redColor]  forState:UIControlStateSelected];
        titleButton.frame=CGRectMake(titleButtonW * i, 0, titleButtonW, titleButtonH);
        
        [titleButton setTitle:fication.name forState:UIControlStateNormal];
        [self.titlesValue addSubview:titleButton];
    }
    //下划线
    [self setuptitleUnderline:self.titlesValue];
    
}

-(void)titleButtonClick:(UIButton *) titleButton{
    //    self.previousClicked=titleButton;
    //    [self.previousClicked setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //[titleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.previousClicked.selected=NO;
    titleButton.selected=YES;
    self.previousClicked = titleButton;
//    _car[titleButton.tag];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat centerx=titleButton.center.x;
        //        [titleButton titleForState:UIControlStateNormal]; 获取图片的文字
        //        self.titlesUnderline.widht= [titleButton.currentTitle sizeWithFont:titleButton.titleLabel.font].width;
       self.titlesUnderline.centerX = centerx;
        //滚动到标题按钮对应的控制器
        NSUInteger index=[self.titlesValue.subviews indexOfObject:titleButton];
  
        CGFloat offsetx=self.scrollview.widht * index;
        self.scrollview.contentOffset=CGPointMake(offsetx, self.scrollview.contentOffset.y);
        
    }];
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)setuptitleUnderline:(UIView *) titlevalue{
    
    UIButton *btn=titlevalue.subviews.firstObject;
    
    
    UIView *titleUnderline= [[UIView alloc] init];
    titleUnderline.frame= CGRectMake(0, self.titlesValue.heiht - 2, 70, 2);
    
    titleUnderline.backgroundColor = [btn titleColorForState:UIControlStateSelected];
    [self.titlesValue addSubview:titleUnderline];
    self.titlesUnderline = titleUnderline;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma 注册协议
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSUInteger index = scrollView.contentOffset.x / scrollView.widht;
    UIButton *button=self.titlesValue.subviews[index];
    [self titleButtonClick:button];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//      NSLog(@"  ---->>>>>%d",);
    return [self.viewdata[tableView.tag][@"dataList"] count];
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID=@"cell";
//    NSLog(@"  ---->%d",tableView.tag);
//    tableView.frame=CGRectMake(0, 0, self.view.widht, 150);
    GuaitableViewcell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell  == nil){
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell =[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GuaitableViewcell class]) owner:nil options:nil][0];
    }
//    cell.textLabel.text= @"lalalala";
 
//    Guaitab *itemtab = self.viewdata[tableView.tag][@"dataList"][indexPath.row];
    Guaitab *itemtab = [Guaitab mj_objectWithKeyValues:self.viewdata[tableView.tag][@"dataList"][indexPath.row]];
   
   
    cell.itemtab=itemtab;
    
    return cell;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
//    GuaiModelcell *item = self.subTasg[indexPath.row];
    Guaitab *itemtab = [Guaitab mj_objectWithKeyValues:self.viewdata[tableView.tag][@"dataList"][indexPath.row]];
    GuaishowTableViewController  *guaishow=[[GuaishowTableViewController alloc] initWithUserInfo:itemtab.booksId];
    guaishow.title=itemtab.booksName;
    guaishow.view.backgroundColor =[UIColor whiteColor];
    guaishow.hidesBottomBarWhenPushed = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate=nil;
    [self.navigationController pushViewController:guaishow animated:YES];
}


@end

