//
//  GuaiTableViewController.m
//  GZM
//
//  Created by wangmutian on 2018/1/4.
//  Copyright © 2018年 wangmutian. All rights reserved.
//

#import "GuaiTableViewController.h"
#import "AFNetWorking/AFNetWorking.h"
#import "MJExtension/MJExtension.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "MJRefresh.h"

#import "GuaitableViewcell.h"
#import "YSLoopBanner.h"
//#import "Guaishowindex1ViewController.h"
#import "GuaiModelcell.h"
#import "GuaishowTableViewController.h"
#import "ZhangBannerModel.h"
#import "Fication.h"
#import "UIImageView+WebCache.h"
#import "GuaiTabViewController.h"

YSLoopBanner *loop;
@interface GuaiTableViewController ()<UIGestureRecognizerDelegate>
@property(nonatomic,strong) NSArray *subTasg;
@property(nonatomic,strong) NSArray *bannerarray;
@property(nonatomic,strong) NSArray *ficationarray;
@property  CGFloat wmt_centerX;
@end

@implementation GuaiTableViewController
-(void)setWmt_centerX:(CGFloat) wmt_centerX{
    CGPoint center = self.view.center;
    center.x=wmt_centerX;
    self.view.center=center;
}
-(CGFloat) wmt_centerX{
    return self.view.center.x;
}


- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationItem.title= @"怪";
    UIFont *font = [UIFont fontWithName:@"Arial-ItalicMT" size:21];
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes =dic;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:199/255.0 green:21/255.0 blue:33/255.0 alpha:1];
    
    self.view.backgroundColor= [UIColor whiteColor];
   
    
  
    [self loadData];
    [self addheaderview];
    
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
    
    //1.创建请求会话管理者
    AFHTTPSessionManager *mgr=[AFHTTPSessionManager manager];
    
    //2.拼接参数
    //    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    
    //3.发送请求
    
    [mgr GET:@"http://www.guaizhangmen.com/author.php/Nexts/bookslist" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *adDict=responseObject[@"dataList"] ;
        //_item1= [WMTADItem mj_objectWithKeyValues:adDict];
        //        [GuaiModelcell mj_objectWitchKeyValues:adDict];
       _subTasg= [GuaiModelcell mj_objectArrayWithKeyValuesArray:adDict];
        //字典转模型
        //NSLog(@"result:%@",item);
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
         [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"result:%@",error);
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subTasg.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    //自定义cell
    GuaitableViewcell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell =[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GuaitableViewcell class]) owner:nil options:nil][0];
    }
    GuaiModelcell *item = self.subTasg[indexPath.row];
//    NSLog(@"  ---------ITEM------%@",item);
    //cell.textLabel.text=item.booksName;
    cell.item=item;
   
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{

    
//     Guaishowindex1ViewController *guaishow = [self.storyboard instantiateViewControllerWithIdentifier:@"Guaishowindex1ViewController"];
    
    
    
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    GuaiModelcell *item = self.subTasg[indexPath.row];
    GuaishowTableViewController  *guaishow=[[GuaishowTableViewController alloc] initWithUserInfo:item.booksId];
    guaishow.title=item.booksName;
    guaishow.view.backgroundColor =[UIColor whiteColor];
    guaishow.hidesBottomBarWhenPushed = YES;
    
    // 属性传值：赋值
    //NSDictionary *userInfo = @{@"name":@"Charles", @"age":@(22)};
    //guaishow.bookId = item.booksId;
    //滑动返回
    self.navigationController.interactivePopGestureRecognizer.delegate=nil;
    //全屏返回
   
    
 
    [self.navigationController pushViewController:guaishow animated:YES];
    // 模态切换(界面跳转)
//    [self presentViewController:detailVc animated:YES completion:nil];

    
    //NSString *titileString = [array objectAtIndex:[indexPath row]];  //这个表示选中的那个cell上的数据
//    UIAlertView
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"message:"111" delegate:selfcancelButtonTitle:@"OK"otherButtonTitles:nil];
//
//    [alert show];
//    GuaiModelcell *item = self.subTasg[indexPath.row];
//    
//    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"您点击了:%@",item.booksImg] preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"进入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//
//
//    }];
//    
//    [alertController addAction:cancelAction];
//    
//    [alertController addAction:okAction];
    
    //[self presentViewController:alertController animated:YES completion:nil];
  
    
}




-(void) addheaderview{
    [self loadBanner];
    /*
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    

    //[self.tableView.tableHeaderView addSubview:loop];
//    [self.view addSubview:loop];
//    [self.tableView.tableHeaderView loop];
    //[self.tableView setTableHeaderView:loop];
//    CGRect rect = CGRectMake(100, 200, 50, 50);
//    UILabel *label = [[UILabel alloc] initWithFrame:rect];
//    label.text=@"文本信息";//设置内容
  
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, size.width, 40)];
    label.text=@"近期书籍";
    
    UIView *labeview=[[UILabel alloc] initWithFrame:CGRectMake(0, 350, size.width, 40)];
    labeview.backgroundColor= [UIColor grayColor];
    [labeview addSubview:label];
    */
    
}

-(void)loadBanner{
    NSString *path=[NSString stringWithFormat:@"%@/admin.php/Systeminterface/banner_show",PUBLIC_URL];
    AFHTTPSessionManager *mgr=[AFHTTPSessionManager manager];
    [mgr GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        NSDictionary *adDict=responseObject[@"dataList"] ;

        CGRect rect = [[UIScreen mainScreen] bounds];
        CGSize size = rect.size;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, size.width, 40)];
        label.text=@"近期书籍";
        
        UIView *labeview=[[UILabel alloc] initWithFrame:CGRectMake(0, 294, size.width, 40)];
        labeview.backgroundColor= [UIColor grayColor];
        [labeview addSubview:label];
        _bannerarray=[ZhangBannerModel mj_objectArrayWithKeyValuesArray:adDict];
        
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 350, size.width, 350)];
        
        loop = [[YSLoopBanner alloc] initWithFrame:CGRectMake(0, 0, size.width, 200) scrollDuration:3.f];
        [v addSubview:loop];
        [self scollview:size.width parentview:v];
        
        //[v addSubview:[self scollview:size.width]];
        [v addSubview:labeview];
   
        _bannerarray=[ZhangBannerModel mj_objectArrayWithKeyValuesArray:adDict];
        NSMutableArray *array3 = [NSMutableArray arrayWithCapacity:_bannerarray.count];
     
        for(NSInteger i=0;i<_bannerarray.count;i++){
            ZhangBannerModel *baner= self.bannerarray[i];
            [array3  insertObject:baner.bannerImg atIndex:i];
            
        }
        loop.imageURLStrings = array3;
        
  
        [self.tableView setTableHeaderView:v];
 

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     
    }];
    
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150; 
}


-(void) scollview:(int) width parentview:(UIView *) v {
    //设定 ScrollView 的 Frame，逐页滚动时，如果横向滚动，按宽度为一个单位滚动，纵向时，按高度为一个单位滚动
    
    NSString *path=[NSString stringWithFormat:@"%@/admin.php/Systeminterface/all_fication",PUBLIC_URL];
    AFHTTPSessionManager *mgr=[AFHTTPSessionManager manager];
    [mgr GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSDictionary *adDict=responseObject[@"dataList"] ;
        _ficationarray=[Fication mj_objectArrayWithKeyValuesArray:adDict];
        
       
        
        
        int num_num=4;
        int onwidth=(int)(width-50)/num_num;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 200, width, onwidth+5)];
        
        scrollView.backgroundColor = [UIColor whiteColor];  // ScrollView 背景色，即 View 间的填充色
        
        //NSArray *arr1 = @[@"1", @"2",@"3", @"2",@"3"];
        
        //    onwidth=onwidth-10;
        int numcount=0;
        for (NSInteger i = 0; i < _ficationarray.count; i++)
        {
            Fication *fication=_ficationarray[i];
            
            NSString *str=fication.img;
            
            UIImageView *view1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:str]];
            
            NSString *imageUlr=[NSString stringWithFormat:@"http://%@",str];
            [view1 sd_setImageWithURL:[NSURL URLWithString:imageUlr] placeholderImage:[UIImage imageNamed:@"AppIcon"]];
            
            
            view1.frame = CGRectMake((onwidth*i)+10*(i+1),5,onwidth,onwidth);
            UIView *view = [[UIView alloc] init];
            UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
//            tapGesturRecognizer.view.tag=_ficationarray[i][@"ficationId"];
            [view addGestureRecognizer:tapGesturRecognizer];
            
            
            view.frame = CGRectMake((onwidth*i)+10*(i+1),5,onwidth,onwidth);
            view.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            
            CGSize textMaxSize=CGSizeMake(WMTScreenW - 2 ,MAXFLOAT);
            UILabel *lable=[[UILabel alloc] init];
            //         int width=[lable.text sizeWithFont:[lable font]].width;
            int width=[lable.text sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:textMaxSize].width;
            lable.frame=CGRectMake((onwidth-width)/4,20,  onwidth, 40);
            lable.text=fication.name;
            lable.textColor=[UIColor whiteColor];
            
            lable.font = [UIFont boldSystemFontOfSize:20];
            [view addSubview:lable];
            numcount+=(onwidth*i)+10*(i+1);
            
            
            scrollView.showsHorizontalScrollIndicator = NO; //去掉横向滚动条
            
            view1.layer.cornerRadius=5;
            view1.layer.masksToBounds=YES;
            
            view.layer.cornerRadius=5;
            view.layer.masksToBounds=YES;
            
            [scrollView addSubview:view1];
            [scrollView addSubview:view];
            
            
        }
        
        
        
        scrollView.alwaysBounceHorizontal=YES;
        
        scrollView.contentSize = CGSizeMake((onwidth+10)*_ficationarray.count+10, scrollView.frame.size.height * 1);
        
        [v addSubview:scrollView];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
//    return scrollView;
    
}


-(void)tapAction{

    self.navigationController.view.backgroundColor = [UIColor whiteColor];
  
    GuaiTabViewController  *tab=[[GuaiTabViewController alloc] initWithFicationId:@"0"];
    tab.title=@"怪掌门";
    tab.view.backgroundColor =[UIColor whiteColor];
    tab.hidesBottomBarWhenPushed = YES;
    
    // 属性传值：赋值
    //NSDictionary *userInfo = @{@"name":@"Charles", @"age":@(22)};
    //guaishow.bookId = item.booksId;
    //滑动返回
    self.navigationController.interactivePopGestureRecognizer.delegate=nil;
    //全屏返回
    
    
    
    [self.navigationController pushViewController:tab animated:YES];
}

@end
