//
//  GuaishowTableViewController.m
//  GZM
//
//  Created by wangmutian on 2018/1/5.
//  Copyright © 2018年 wangmutian. All rights reserved.
//

#import "GuaishowTableViewController.h"
#import "UIImageView+WebCache.h"
#import "AFNetWorking/AFNetWorking.h"
#import "MJExtension/MJExtension.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "MJRefresh.h"
#import "ChapterListModel.h"
#import "MYTapGestureRecognizer.h"
#import "UIView+Layout.h"
#import "pinglunModel.h"
#import "PinglunTableViewCell.h"
//屏幕宽

#define kScreenW [UIScreen mainScreen].bounds.size.width

//屏幕高

#define kScreenH [UIScreen mainScreen].bounds.size.height


@interface GuaishowTableViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,weak)  NSArray  *subTasgchpater;
@property(nonatomic) UITableView *livesListTable;

@property(nonatomic) UIButton *bottomButton;
//@property(nonatomic,weak) NSInteger *offsetY;
@property(nonatomic,strong) NSArray *pinglun;
@property(nonatomic)  UITableView *listtableView;
@end
//http://www.guaizhangmen.com/author.php/Nexts/listarray
NSString *BID;

@implementation GuaishowTableViewController
- (instancetype)initWithUserInfo:(NSString *) bookId {
    if (self = [super init]) {
        BID=bookId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom] ;
//    [btn setTitle:@"返回" forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
//
//     self.tableView.scrollEnabled = NO;
    [self bookhttp];
    
    [self fixview];
    
    
}

//-(void)back{
//    [self.navigationController popViewControllerAnimated:YES];
//
//}



-(void) fixview{
    //Add a container view as self.view and the superview of the tableview
    self.listtableView = (UITableView *)self.view;
    UIView *containerView = [[UIView alloc] initWithFrame:self.view.frame];
//    self.tableView.frame = self.listtableView.bounds;
    self.tableView.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-110);
    self.view = containerView;
    [containerView addSubview:self.listtableView];
}






//http://www.guaizhangmen.com/author.php/Nexts/listarray

-(void) drawableBox{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 500)];
    view.backgroundColor=[UIColor redColor];
}




-(void)bookhttp{
    NSLog(@" 到这里了！");
    NSString *path=[NSString stringWithFormat:@"%@/author.php/Nexts/listarray",PUBLIC_URL];
    AFHTTPSessionManager *mgr=[AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    parameters[@"books_id"]=BID;
    parameters[@"member_id"]=0;
    
    [mgr POST:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary  * _Nullable responseObject) {
        
        [responseObject writeToFile:@"/Users/apple/Desktop/111/P.plist" atomically:YES];
        NSDictionary *adDict=responseObject[@"dataList"][@"books"] ;
        NSDictionary *author=responseObject[@"dataList"][@"author"] ;
        NSDictionary *chapterList=responseObject[@"dataList"][@"chapterList"] ;
        NSDictionary *commentList=responseObject[@"dataList"][@"commentList"] ;
        _pinglun = [pinglunModel mj_objectArrayWithKeyValuesArray:commentList];
        //        pinglun
        
        _bookname.text=adDict[@"booksName"];
        _bookdesc.text=adDict[@"booksSynopsis"];
        _authname.text=author[@"name"];
        _authdesc.text=author[@"profile"];
        _profile.text=author[@"detailedProfile"];
        
        NSString *booksImg=[NSString stringWithFormat:@"http://%@",adDict[@"booksImg"]];
        [_bookimg sd_setImageWithURL:[NSURL URLWithString:booksImg] placeholderImage:[UIImage imageNamed:@"AppIcon"]];
        NSString *authorimg=[NSString stringWithFormat:@"http://%@",author[@"headImg"]];
        [_autuimg sd_setImageWithURL:[NSURL URLWithString:authorimg] placeholderImage:[UIImage imageNamed:@"iconheader_03"]];
        
        
        
        _subTasgchpater= [ChapterListModel mj_objectArrayWithKeyValuesArray:chapterList];
        int keheight=120;
        _tableviewheader.heiht=451 + 57 + keheight*[_subTasgchpater count] + 10+47;
        
        for(NSInteger i=0; i<[_subTasgchpater count];i++){
            ChapterListModel *chapter=_subTasgchpater[i];
            
            UIView * view =[[UIView alloc] init];
            //打开用户交互(不可少)
            view.userInteractionEnabled = YES;
            //添加手势
            MYTapGestureRecognizer * tapGesture = [[MYTapGestureRecognizer alloc] initWithTarget:self action:@selector(event:) ];
            [view addGestureRecognizer:tapGesture];
            
            tapGesture.data=[NSString stringWithFormat:@"HAHA   %@",chapter.chapterId ];
            view.frame=CGRectMake(0, keheight*i+10,_kechenglog.bounds.size.width, keheight);
            view.backgroundColor =[UIColor whiteColor];
            
            //添加图片视图
            UIView *viewimage=[[UIView alloc] init];
            viewimage.frame=CGRectMake(0, 0, 90, view.bounds.size.height);
            //            viewimage.backgroundColor=[UIColor grayColor];
            [view addSubview:viewimage];
            
            UIImage *image = [UIImage imageNamed:@"AppIcon"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            NSString *imageUlr=[NSString stringWithFormat:@"http://%@",chapter.chapterImg];
            
            
            
            CGFloat viewimagewidth= viewimage.bounds.size.width;
            CGFloat viewimageheight= viewimage.bounds.size.height;
            
            CGFloat imageViewwidth=imageView.bounds.size.width;
            CGFloat imageViewheight=imageView.bounds.size.height;
            
            [viewimage addSubview:imageView];
            
            if(imageViewwidth < imageViewheight){
                imageView.frame=CGRectMake(0, 0, imageViewwidth/imageViewheight*viewimageheight, viewimageheight);
            }else{
                imageView.frame=CGRectMake(0, 0, viewimagewidth, imageViewheight/imageViewwidth*viewimagewidth);
            }
            //自适应图片宽高比例
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUlr] placeholderImage:[UIImage imageNamed:@"AppIcon"]];
            
            
            
            //添加文字
            UIView *viewtext=[[UIView alloc] init];
            viewtext.frame=CGRectMake(100, 0, view.bounds.size.width - 100, view.bounds.size.height);
            //            viewtext.backgroundColor=[UIColor grayColor];
            [view addSubview:viewtext];
            
            UIView *viewtitle=[[UIView alloc] init];
            viewtitle.frame=CGRectMake(10, 10, viewtext.bounds.size.width-10, 30);
            [viewtext addSubview:viewtitle];
            
            UILabel *labeltitle=[[UILabel alloc] init];
            labeltitle.text=chapter.chaptreName;
            labeltitle.font=[UIFont systemFontOfSize:22.0];
            
            labeltitle.frame=CGRectMake(0, 0, viewtext.bounds.size.width-10, 30);
            [viewtitle addSubview:labeltitle];
            
            UIView *iconview1=[[UIView alloc] init];
            iconview1.backgroundColor=[UIColor whiteColor];
            iconview1.frame=CGRectMake(10, viewtext.bounds.size.height-55, viewtext.bounds.size.width-10, 30);
            [viewtext addSubview:iconview1];
            
            UIImageView *imageicon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"time_clock"]];
            UIImage *time_clock = [UIImage imageNamed:@"time_clock"];
            UIImageView *time_clockview = [[UIImageView alloc] initWithImage:time_clock];
            
            [iconview1 addSubview:time_clockview];
            
            
            UILabel *day=[[UILabel alloc] init];
            day.text=chapter.createTime;
            day.frame=CGRectMake(30, -5, 135, 35);
            [iconview1 addSubview:day];
            
            //            UIImageView *imageicon1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"time_clock"]];
            //            UIImage *time_clock1 = [UIImage imageNamed:@"time_clock"];
            //            UIImageView *time_clockview1 = [[UIImageView alloc] initWithImage:time_clock];
            //
            //            [iconview1 addSubview:time_clockview1];
            
            [self createImage:iconview1 rectMakex:0 rectMakey:0 rectMakewidth:25 rectMakexheight:25 imagename:@"time_clock"];
            
            UILabel *days=[[UILabel alloc] init];
            days.text=chapter.createTime;
            days.frame=CGRectMake(30, -5, 135, 35);
            [iconview1 addSubview:days];
            
            [self createImage:iconview1 rectMakex:130 rectMakey:0 rectMakewidth:25 rectMakexheight:25 imagename:@"time_clock"];
            
            UILabel *time=[[UILabel alloc] init];
            time.text=chapter.durationMsec;
            time.frame=CGRectMake(170, -5, 135, 35);
            [iconview1 addSubview:time];
            
            [_kechenglog addSubview:view];
            [self.listtableView reloadData];
        }
        
        
        
        //        NSLog(@"     -====--->%@",adDict[@"booksName"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"222");
    }];
}

-(void)createImage:(UIView *) view rectMakex:(CGFloat) x  rectMakey: (CGFloat) y rectMakewidth: (CGFloat) width rectMakexheight:(CGFloat) height imagename:(NSString *)imagename{
    
    UIImage *time_clock = [UIImage imageNamed:imagename];
    UIImageView *time_clockview1 = [[UIImageView alloc] initWithImage:time_clock];
    time_clockview1.frame=CGRectMake(x, y, width, height);
    [view addSubview:time_clockview1];
    
}


-(void)event:(UITapGestureRecognizer *)tapRecognizer {
    //    sender.view.tag;
    MYTapGestureRecognizer *tap = (MYTapGestureRecognizer *)tapRecognizer;
    
    NSLog(@"data : %@", tap.data);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return _pinglun.count;
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID=@"cell";
    PinglunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell =[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PinglunTableViewCell class]) owner:nil options:nil][0];
    }
    //    cell.textLabel.text=@"测试";
    pinglunModel *pinglun=self.pinglun[indexPath.row];
    cell.item=pinglun;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 144;
}

//监听滚动滚动
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"广东跳了");
    if ([self.delegate respondsToSelector:@selector(scrollappend)]) {
        
        [self.delegate scrollappend];
        
    }
//    [self backinit];
//    //叫键盘回去
//    [self.view endEditing:YES];
//    self.inputViewS.jianpanbtn.hidden=YES;
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
