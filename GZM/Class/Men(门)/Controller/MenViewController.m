//
//  MenViewController.m
//  GZM
//
//  Created by wangmutian on 2018/1/2.
//  Copyright © 2018年 wangmutian. All rights reserved.
//

#import "MenViewController.h"

#import <QiniuSDK.h>
#import "AFNetWorking/AFNetWorking.h"
//#import "SaveImage_Util.h"

//#import "UploadManager.h"
//#import "HttpManager"
#import <GTMBase64/GTMBase64.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "MJExtension/MJExtension.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD/SVProgressHUD.h"
//#import "WXApi.h"
#import "WXApiManager.h"
//#import "WXApiObject.h"
//#import "WXApiRequestHandler.m"

NSString *filePath;
NSString *tokenstring;
//# http://wangmutian.gz01.bdysite.com/weixinzhifu/
@interface MenViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic , assign) int expires;
- (IBAction)weixinpay:(id)sender;

@end

@implementation MenViewController

- (NSString *)makeToken:(NSString *)accessKey secretKey:(NSString *)secretKey bucket:(NSString *)bucket key:(NSString *)key
{
    const char *secretKeyStr = [secretKey UTF8String];
    
    NSString *policy = [self marshal: bucket key:key];
    
    NSData *policyData = [policy dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *encodedPolicy = [GTMBase64 stringByWebSafeEncodingData:policyData padded:TRUE];
    const char *encodedPolicyStr = [encodedPolicy cStringUsingEncoding:NSUTF8StringEncoding];
    
    char digestStr[CC_SHA1_DIGEST_LENGTH];
    bzero(digestStr, 0);
    
    CCHmac(kCCHmacAlgSHA1, secretKeyStr, strlen(secretKeyStr), encodedPolicyStr, strlen(encodedPolicyStr), digestStr);
    
    NSString *encodedDigest = [GTMBase64 stringByWebSafeEncodingBytes:digestStr length:CC_SHA1_DIGEST_LENGTH padded:TRUE];
    
    NSString *token = [NSString stringWithFormat:@"%@:%@:%@",  accessKey, encodedDigest, encodedPolicy];
    
    return token;//得到了token
}
- (NSString *)marshal:(NSString *)bucket key:(NSString *)key

{
    _expires=3600;
    time_t deadline;
    
    time(&deadline);//返回当前系统时间
    
    //@property (nonatomic , assign) int expires; 怎么定义随你...
    
    deadline += (_expires > 0) ? _expires : 3600; // +3600秒,即默认token保存1小时.
    
    
    
    NSNumber *deadlineNumber = [NSNumber numberWithLongLong:deadline];
    
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    //images是我开辟的公共空间名（即bucket），aaa是文件的key，
    
    //按七牛“上传策略”的描述：    <bucket>:<key>，表示只允许用户上传指定key的文件。在这种格式下文件默认允许“修改”，若已存在同名资源则会被覆盖。如果只希望上传指定key的文件，并且不允许修改，那么可以将下面的 insertOnly 属性值设为 1。
    
    //所以如果参数只传users的话，下次上传key还是aaa的文件会提示存在同名文件，不能上传。
    
    //传images:aaa的话，可以覆盖更新，但实测延迟较长，我上传同名新文件上去，下载下来的还是老文件。
    
    NSString *value = [NSString stringWithFormat:@"%@:%@", bucket, key];
    
    [dic setObject:value forKey:@"scope"];//根据
    
    
    
    [dic setObject:deadlineNumber forKey:@"deadline"];
    
    
    
    NSString *json = [dic mj_JSONString];
    
    
    
    return json;
    
}

-(void) qiniu:(NSString *) path {
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *keystr = [NSString stringWithFormat:@"icon_%f", a];//转为字符型
    //NSString *keystr=@"icon";
    NSString *tokens=[self makeToken:@"lVWTt_OxbmlDhY_6Xu6RksVZQGmQGtVhkVp0bnlU" secretKey:@"t_uXWTU71d2Elfhqli4KrGdRcjCqmkTCYZbAlQ_w" bucket:@"guaizhangmen" key:keystr];
    NSLog(@"===>%@",tokens);
    
    //国内https上传
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.useHttps = YES;
    }];
    //重用uploadManager。一般地，只需要创建一个uploadManager对象
    NSString * token = tokens;
    NSString * key = keystr;
    NSString * filePath = path;
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];

    [upManager putFile:filePath key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if(info.ok)
        {
            NSLog(@"请求成功");
            
        }
        else{
            NSLog(@"失败");
            //如果失败，这里可以把info信息上报自己的服务器，便于后面分析上传错误原因
        }
        NSLog(@"info ===== %@", info);
        NSLog(@"resp ===== %@", resp);
        //  http://qiniu.guaizhangmen.com/key
        
        NSString *imageUlr=[NSString stringWithFormat:@"http://qiniu.guaizhangmen.com/%@?imageView2/2/w/100/h/100/interlace/0/q/100",key];
        
        NSLog(@"------>%@",imageUlr);
        [SVProgressHUD dismiss];
        [_imagexiang sd_setImageWithURL:[NSURL URLWithString:imageUlr] placeholderImage:[UIImage imageNamed:@"AppIcon"]];
        
//        resp mj_setKeyValues:@"key" context:
        
        
    } option:nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    
    
    // Do any additional setup after loading the view.
    self.navigationItem.title= @"门";
    UIFont *font = [UIFont fontWithName:@"Arial-ItalicMT" size:21];
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes =dic;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:199/255.0 green:21/255.0 blue:33/255.0 alpha:1];
    
    self.view.backgroundColor= [UIColor whiteColor];
//    interactivePopGestureRecognizer;
//    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
//    [self.view addGestureRecognizer:pan];
//
//    //控制我们的手势什么时候被触发，只有非根控制器 的时候
//    pan.delegate=self;
//
//    //禁止之前的手势
//    self.interactivePopGestureRecognizer.delegate=NO;
    [_imagexiang setUserInteractionEnabled:YES];
    [_imagexiang addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory:)]];
}

-(void)clickCategory:(UITapGestureRecognizer *)gestureRecognizer{
    [self respondsButton];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)respondsButton{
    
    // 1、初始化
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择"
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    // 3、添加新浪微博按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          // 此处处理点击新浪微博按钮逻辑
                                                          [self openCamera];
                                                      }]];
    
    // 4、添加腾讯微博按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"相册"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          // 此处处理点击腾讯微博按钮逻辑
                                                          [self openPhotoLibrary];
                                                      }]];
    
    // 4、添加退出按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction *action) {
                                                          // 此处处理点击退出按钮逻辑
                                                          
                                                      }]];
    
    // 5、模态切换显示表单
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}
/**
 
 *  调用照相机
 
 */

- (void)openCamera{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    
    picker.allowsEditing = YES; //可编辑
    
    //判断是否可以打开照相机
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        //摄像头
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }else{
        
        NSLog(@"没有摄像头");
        
    }
    
}

/**
 
 *  打开相册
 
 */

-(void)openPhotoLibrary{
    
    // 进入相册
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        
    {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        
        imagePicker.allowsEditing = YES;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        imagePicker.delegate = self;
        
        [self presentViewController:imagePicker animated:YES completion:^{

            NSLog(@"打开相册");

        }];

      
        
    }
    
    else
        
    {
        
        NSLog(@"不能打开相册");
        
    }
    
}


#pragma mark - UIImagePickerControllerDelegate




//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        NSLog(@"===>filepath:%@",filePath);
        [self qiniu:filePath];
        //关闭相册界面
         [self dismissViewControllerAnimated:YES completion:nil];
//        [picker dismissModalViewControllerAnimated:YES];
        
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
//        UIImageView *smallimage = [[[UIImageView alloc] initWithFrame:
//                                    CGRectMake(50, 120, 40, 40)] autorelease];
        
//        smallimage.image = image;
        //加在视图中
        
//        [self.view addSubview:smallimage];
        
    }
    
}
//#http://wangmutian.gz01.bdysite.com/weixinzhifu/
- (IBAction)weixinpay:(id)sender {
    NSString *path=[NSString stringWithFormat:@"%@/admin.php/Systeminterface/all_fication",PUBLIC_URL];
    AFHTTPSessionManager *mgr=[AFHTTPSessionManager manager];
    [mgr GET:@"http://wangmutian.gz01.bdysite.com/weixinzhifu/" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *appid=responseObject[@"appid"] ;
        NSString *noncestr=responseObject[@"noncestr"] ;
        NSString *package=responseObject[@"package"] ;
        NSString *partnerid=responseObject[@"partnerid"] ;
        NSString *prepayid=responseObject[@"prepayid"] ;
        NSString *timestamp=responseObject[@"timestamp"] ;
        NSString *sign=responseObject[@"sign"] ;
        NSString *out_trade_no=responseObject[@"out_trade_no"] ;
        NSLog(@"->  %@",appid);
        
        //需要创建这个支付对象
        PayReq *req   = [[PayReq alloc] init];
        //由用户微信号和AppID组成的唯一标识，用于校验微信用户
        req.openID = appid;
        
        // 商家id，在注册的时候给的
        req.partnerId = partnerid;
        
        // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
        req.prepayId  = prepayid;
        
        // 根据财付通文档填写的数据和签名
        //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
        req.package   = package;
        
        // 随机编码，为了防止重复的，在后台生成
        req.nonceStr  = noncestr;
        
        // 这个是时间戳，也是在后台生成的，为了验证支付的
        NSString * stamp = timestamp;
        req.timeStamp = stamp.intValue;
        
        // 这个签名也是后台做的
        req.sign =sign;
        
        //发送请求到微信，等待微信返回onResp
        [WXApi sendReq:req];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
//    //需要创建这个支付对象
//    PayReq *req   = [[PayReq alloc] init];
//    //由用户微信号和AppID组成的唯一标识，用于校验微信用户
//    req.openID = @"wx900520eae73ea184";
//
//    // 商家id，在注册的时候给的
//    req.partnerId = @"wx20180115192629ba9e1c725d0145235356";
//
//    // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
//    req.prepayId  = @"1492764802";
//
//    // 根据财付通文档填写的数据和签名
//    //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
//    req.package   = @"Sign=WXPay";
//
//    // 随机编码，为了防止重复的，在后台生成
//    req.nonceStr  = @"qTTOOIGV1WIidYRVzbx4LVmeCTth0zLQ";
//
//    // 这个是时间戳，也是在后台生成的，为了验证支付的
//    NSString * stamp = @"1516015589";
//    req.timeStamp = stamp.intValue;
//
//    // 这个签名也是后台做的
//    req.sign = @"B0721EC656EDF3CF4A0B9C60116D50D4";
//
//    //发送请求到微信，等待微信返回onResp
//    [WXApi sendReq:req];
    
    
    
}
@end
