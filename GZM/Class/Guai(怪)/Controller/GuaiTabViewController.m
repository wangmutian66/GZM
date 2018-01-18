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
@interface GuaiTabViewController ()<UIScrollViewDelegate,UITableViewDataSource>
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

@end

@implementation GuaiTabViewController
- (instancetype)initWithFicationId:(NSString *) ficationId {
    if (self = [super init]) {
        //        NSLog(@"----->bookid:%@", bookId);
//        BID=bookId;
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
    
    
    [self setupScrollView];
    
    [self tabinit];
    [self httpqingqiu];
}

//httpqing 请求
-(void)httpqingqiu{
    NSString *path=[NSString stringWithFormat:@"%@/admin.php/Systeminterface/all_fication",PUBLIC_URL];
    AFHTTPSessionManager *mgr=[AFHTTPSessionManager manager];
    [mgr GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *adDict=responseObject[@"dataList"] ;
        _car=[Fication mj_objectArrayWithKeyValuesArray:adDict];
        
        
       
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

//滚动条是 tabBar  是叫scroll 的内容向下移动 64
-(void) setupScrollView{
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
        for(NSInteger i = 0; i<5;i++){
            UITableView *tableview = [[UITableView alloc] init];

            tableview.frame=CGRectMake(scrollview.widht*i, 0, scrollview.widht, scrollview.heiht);
            if(i%2==0){
                tableview.backgroundColor=[UIColor greenColor];
            }
            tableview.dataSource=self;
            UIView *v=[[UIView alloc] init];
            v.frame=CGRectMake(0, 0, self.view.widht, 50);
            [tableview setTableHeaderView:v];
            [scrollview addSubview:tableview];
            
        }

    scrollview.contentSize = CGSizeMake(5 *scrollview.widht , 0);
    
    
 
}


-(void) tabinit{
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.5];
    //    titleView.backgroundColor =[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    //    titleView.alpha=0.5;
    titleView.frame= CGRectMake(0, 64, self.view.widht, 50);
    self.titlesValue=titleView;
    [self.view addSubview:titleView];
    
    //标题栏按钮
    [self setupTitleButtons];
//
    //下划线
    [self setuptitleUnderline];
    
}

-(void)setupTitleButtons{
    NSArray *titlearr=@[@"全部",@"视频",@"声音",@"图片",@"段子"];
    NSUInteger count = titlearr.count;
    CGFloat titleButtonW=self.titlesValue.widht / count;
    CGFloat titleButtonH=self.titlesValue.heiht;
    
    for (NSInteger i=0; i < count; i++) {
        UIButton *titleButton = [[UIButton alloc] init];
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titlesValue addSubview:titleButton];
        [titleButton setTitleColor:[UIColor darkGrayColor]  forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor redColor]  forState:UIControlStateSelected];
        titleButton.frame=CGRectMake(titleButtonW * i, 0, titleButtonW, titleButtonH);
        [titleButton setTitle:titlearr[i] forState:UIControlStateNormal];
        
    }
}
-(void)titleButtonClick:(UIButton *) titleButton{
    //    self.previousClicked=titleButton;
    //    [self.previousClicked setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //[titleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.previousClicked.selected=NO;
    titleButton.selected=YES;
    self.previousClicked = titleButton;
    
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

-(void)setuptitleUnderline{
    
    UIButton *btn=self.titlesValue.subviews.firstObject;
    
    
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
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID=@"cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell  == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text= @"lalalala";
    return cell;
    
    
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
