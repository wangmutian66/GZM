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

@interface GuaiTableViewController ()
@property(nonatomic,strong) NSArray *subTasg;
@end

@implementation GuaiTableViewController

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
        NSLog(@"result:%@",error);
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
    //cell.textLabel.text=item.booksName;
    cell.item=item;
   
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{

    GuaishowTableViewController  *guaishow=[[GuaishowTableViewController alloc] init];
//     Guaishowindex1ViewController *guaishow = [self.storyboard instantiateViewControllerWithIdentifier:@"Guaishowindex1ViewController"];
    
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    GuaiModelcell *item = self.subTasg[indexPath.row];
    guaishow.title=item.booksName;
    guaishow.view.backgroundColor =[UIColor whiteColor];
    guaishow.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:guaishow animated:YES];
    
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
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    YSLoopBanner *loop = [[YSLoopBanner alloc] initWithFrame:CGRectMake(0, 0, size.width, 200) scrollDuration:3.f];

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
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 390, size.width, 390)];
    
    [v addSubview:loop];
    [v addSubview:[self scollview:size.width]];
    [v addSubview:labeview];
   
    
    [self.tableView setTableHeaderView:v];
    loop.imageURLStrings = @[@"1.jpg", @"2.jpg", @"3.jpg"];
    loop.clickAction = ^(NSInteger index) {
        NSLog(@"curIndex: %ld", index);
    };
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150; 
}


-(UIView *) scollview:(int) width {
    //设定 ScrollView 的 Frame，逐页滚动时，如果横向滚动，按宽度为一个单位滚动，纵向时，按高度为一个单位滚动
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 200, width, 150)];
    
    scrollView.backgroundColor = [UIColor whiteColor];  // ScrollView 背景色，即 View 间的填充色
    
    NSArray *arr1 = @[@"1", @"2",@"3", @"2",@"3"];
    int num_num=4;
    int onwidth=(int)(width-50)/num_num;
//    onwidth=onwidth-10;
    int numcount=0;
    for (NSInteger i = 0; i < [arr1 count]; i++)
    {
        NSString *str=[arr1 objectAtIndex:i];
        UIImageView *view1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:str]];
   
        view1.frame = CGRectMake((onwidth*i)+10*(i+1),5,onwidth,140);
        numcount+=(onwidth*i)+10*(i+1);
//        [view1 sizeToFit];
        
        
        [scrollView addSubview:view1];
        
        
        //NSLog(@"--%@",str);
    }
    
    
    
    scrollView.alwaysBounceHorizontal=YES;

    scrollView.contentSize = CGSizeMake((onwidth+10)*[arr1 count]+10, scrollView.frame.size.height * 1);

    return scrollView;
}





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
