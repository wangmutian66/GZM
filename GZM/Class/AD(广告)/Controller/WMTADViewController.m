//
//  WMTADViewController.m
//  GZM
//
//  Created by wangmutian on 2018/1/9.
//  Copyright © 2018年 wangmutian. All rights reserved.
//

#import "WMTADViewController.h"
#import "AFNetWorking/AFNetWorking.h"
#import "MJExtension/MJExtension.h"
#import "UIImageView+WebCache.h"
#import "WMTADItem.h"
#import "TabBarController.h"
@interface WMTADViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *LanuchImageView;
@property (weak, nonatomic) IBOutlet UIView *adContainView;
@property(nonatomic,strong) WMTADItem * item1;
@property (weak, nonatomic) IBOutlet UIImageView *adView;
@property(nonatomic,weak) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *gotext;
- (IBAction)goAction:(id)sender;


@end
#define code2 @"phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"

@implementation WMTADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupLaunchImae];
    [self loadData];
    
//    NSTimer scheduledTimerWithTimeInterval:1 repeats:<#(BOOL)#> block:<#^(NSTimer * _Nonnull timer)block#>
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
}

-(void)timeChange{
    //倒计时
    static int i = 3;
    [_gotext setTitle:[NSString stringWithFormat:@"跳转(%d)",i] forState:UIControlStateNormal];
    if(i==0){
        //销毁广告界面,进入主框架
        TabBarController *tabBar=[[TabBarController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController=tabBar;
        //干掉定时器
        [_timer invalidate];
    }
    i--;
    
}

-(UIImageView *) adView{
    if(_adView == nil){
        UIImageView *imageView=[[UIImageView alloc] init];
        [self.adContainView addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
        _adView=imageView;
    }
    return _adView;
}
-(void)tap{
    NSURL *url=[NSURL URLWithString:_item1.w_picurl];
    UIApplication *app=[UIApplication sharedApplication];
    
    if ([app canOpenURL:url]) {
        [app openURL:url];
    }
    [[UIApplication sharedApplication] canOpenURL:url];
    
}

-(void)loadData{
    //1.创建请求会话管理者
    AFHTTPSessionManager *mgr=[AFHTTPSessionManager manager];
    //2.拼接参数
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    parameters[@"code2"]=code2;
    //3.发送请求
    
    //点击项目 进入 info 添加-> "App Transport Security Settings" 在子下在添加 -> "Allow Arbitrary Loads" 配置写yes
    /*
     AFURLResponseSerialization.m中修改代码就能解决：
     修改文件223行处
     self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil nil];
     为
     self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil nil];
     */
    
    [mgr GET:@"http://mobads.baidu.com/cpro/ui/mads.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *_Nullable responseObject) {
        [responseObject writeToFile:@"/Users/apple/Desktop/plist/ad.plist" atomically:YES];
        NSDictionary *adDict=[responseObject[@"ad"] lastObject];
        //字典转模型
        _item1= [WMTADItem mj_objectWithKeyValues:adDict];
        
//        CGFloat h =  WMTScreenW/_item1.w*_item1.h;
        //_item1.ori_curl;
        
        
        self.adView.frame = CGRectMake(0, 0,WMTScreenW, WMTScreenH);
        //加载广告数据
//        NSLog(@"====>picurl:%@",_item1.w_picurl);
        
        [self.adView sd_setImageWithURL:[NSURL URLWithString:_item1.w_picurl]];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}


-(void)setupLaunchImae{
     self.LanuchImageView.image=[UIImage imageNamed:@"1"];
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

- (IBAction)goAction:(id)sender {
    TabBarController *tabBar=[[TabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController=tabBar;
    //干掉定时器
    [_timer invalidate];
}
@end
