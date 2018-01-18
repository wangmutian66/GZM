//
//  ZhangViewController.m
//  GZM
//
//  Created by wangmutian on 2018/1/6.
//  Copyright © 2018年 wangmutian. All rights reserved.
//

#import "ZhangViewController.h"
#import "AFNetWorking/AFNetWorking.h"
#import "MJExtension/MJExtension.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "MJRefresh.h"
#import "GuaiModelcell.h"
#import "GuaitableViewcell.h"
#import "TableViewCell.h"
#import "ZhangModel.h"
#import "DakaModel.h"
#import "UIImageView+WebCache.h"


@interface ZhangViewController ()
@property(nonatomic,strong) NSArray *subTasg;
@property(nonatomic,strong) NSArray *daka;

@property (nonatomic, strong)  TableViewCell *prototypeCell;
@end

@implementation ZhangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title= @"掌";
    UIFont *font = [UIFont fontWithName:@"Arial-ItalicMT" size:21];
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes =dic;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:199/255.0 green:21/255.0 blue:33/255.0 alpha:1];
    
    self.view.backgroundColor= [UIColor whiteColor];
    [self loadData];
    [SVProgressHUD showWithStatus:@"加载中"];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    //    header.stateLabel.hidden = YES;
    [header setTitle:@"再下拉一点就能刷新了" forState:MJRefreshStateIdle];
    [header setTitle:@"放开即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中 ..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    [self.tableView.mj_header beginRefreshing];
    
}


-(void) loadData{
     self.tableView.estimatedRowHeight = 170;
    
    //1.创建请求会话管理者
    AFHTTPSessionManager *mgr=[AFHTTPSessionManager manager];
    
    //2.拼接参数
    //    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    
    //3.发送请求
    NSString *path=[NSString stringWithFormat:@"%@/admin.php/Systeminterface/interview_list/",PUBLIC_URL];
    [mgr GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *adDict=responseObject[@"dataList"][@"list"] ;
        NSDictionary *clokln=responseObject[@"dataList"][@"clockIn"] ;
        
        _daka= [ZhangModel mj_objectArrayWithKeyValuesArray:clokln];
        _subTasg= [ZhangModel mj_objectArrayWithKeyValuesArray:adDict];
        
        [self scollview:responseObject[@"dataList"][@"clockIn"]];
      
        //字典转模型
        //NSLog(@"result:%@",item);
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"result:%@",error);
    }];
}




-(void) scollview:(NSArray *) arr1 {
    //设定 ScrollView 的 Frame，逐页滚动时，如果横向滚动，按宽度为一个单位滚动，纵向时，按高度为一个单位滚动
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    int width=size.width;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 200, width, 150)];
    
    scrollView.backgroundColor = [UIColor whiteColor];  // ScrollView 背景色，即 View 间的填充色
    
//    NSArray *arr1 = @[@"1", @"2",@"3", @"2",@"3"];
    int num_num=4;
    int onwidth=(int)(width-50)/num_num;
    //    onwidth=onwidth-10;
    int numcount=0;
    for (NSInteger i = 0; i < [arr1 count]; i++)
    {
//        NSLog(@"------>%@",[arr1 objectAtIndex:i][@"headImg"]);
        NSString *str=[arr1 objectAtIndex:i][@"headImg"];

        //UIImageView *view1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:str]];
        UIImageView *view1=[[UIImageView alloc] init];
        NSString *imageUlr=[NSString stringWithFormat:@"http://%@",str];
        [view1 sd_setImageWithURL:[NSURL URLWithString:imageUlr] placeholderImage:[UIImage imageNamed:@"AppIcon"]];
        
        view1.frame = CGRectMake((onwidth*i)+10*(i+1),5,onwidth,140);
        numcount+=(onwidth*i)+10*(i+1);
        //        [view1 sizeToFit];


        [scrollView addSubview:view1];
        
        
        //NSLog(@"--%@",str);
    }
    
    
    
    scrollView.alwaysBounceHorizontal=YES;
    
    scrollView.contentSize = CGSizeMake((onwidth+10)*[arr1 count]+10, scrollView.frame.size.height * 1);
    [self.tableView setTableHeaderView:scrollView];
//    return scrollView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.subTasg.count;
}

//定义间距
#define WYLMargin 10
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZhangModel *item = self.subTasg[indexPath.row];
    CGSize textMaxSize=CGSizeMake(WMTScreenW - 2 ,MAXFLOAT);
    CGFloat height=0;
    height+=50;
    height+=[item.profile sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:textMaxSize].height;
    
   
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell1";
    //自定义cell
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell =[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TableViewCell class]) owner:nil options:nil][0];
    }
    ZhangModel *item = self.subTasg[indexPath.row];
    //cell.textLabel.text=item.booksName;
    cell.model=item;
    
    return cell;
}


#pragma mark Configure Cell Data
- (void)configureCell:(TableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.model = [_subTasg objectAtIndex:indexPath.row];//Cell中对其进行处理
}


@end
