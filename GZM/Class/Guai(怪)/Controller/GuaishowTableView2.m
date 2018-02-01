//
//  GuaishowTableView2.m
//  GZM
//
//  Created by wangmutian on 2018/2/1.
//  Copyright © 2018年 wangmutian. All rights reserved.
//

#import "GuaishowTableView2.h"
#import "WMTinputview.h"
#import "UIView+Frame.h"
#import "WmtBiaoqingboardView.h"
#import "GuaishowTableViewController.h"
#define kInputViewH 44

@interface GuaishowTableView2()<UITableViewDataSource,UITableViewDelegate,WMTinputview,WmtBiaoqingboardView,UITextFieldDelegate,GuaishowTableViewController>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)WMTinputview *inputViewS;
@property(nonatomic,strong) WmtBiaoqingboardView *biaoqing;
@property(nonatomic,strong) GuaishowTableViewController *guaishow;
@property (nonatomic,strong) IBOutlet UITableView *tablesub;

@end
NSString *bid;
@implementation GuaishowTableView2

- (instancetype)initWithUserInfo:(NSString *) bookId {
    if (self = [super init]) {
        bid=bookId;
    }
    return self;
}



-(WmtBiaoqingboardView *)biaoqing
{
    if(!_biaoqing){
        _biaoqing =[[WmtBiaoqingboardView alloc] init];
        _biaoqing.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), kWMTMoreinputkeyboardView);
        _biaoqing.delegate=self;
        [[UIApplication sharedApplication].keyWindow addSubview:_biaoqing];
    }
    return _biaoqing;
}
-(void)viewDidAppear:(BOOL)animated{
    [self biaoqing];
}

-(GuaishowTableViewController *)guaishow{
    if(!_guaishow){
//        _guaishow = [[GuaishowTableViewController alloc] init];
        _guaishow  = [[GuaishowTableViewController alloc] initWithUserInfo:bid];
        _guaishow.delegate=self;
        _guaishow.tableView.dataSource=self;
        _guaishow.tableView.delegate=self;
       _guaishow.view.frame=CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height-144);
       
    }
    return _guaishow;
}


-(UIView *)inputViewS{
    if(!_inputViewS){
        _inputViewS=[WMTinputview wmt_inputview];
        //        _inputViewS.delegate=self;
        _inputViewS.delegate=self;
        [[UIApplication sharedApplication].keyWindow addSubview:_inputViewS];
        
        _inputViewS.frame=CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44);
    }
    return _inputViewS;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom] ;
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    
    _tablesub.dataSource=self;
    _tablesub.delegate=self;
    _tablesub.tableHeaderView=self.guaishow.view;
     _tablesub.scrollEnabled = NO;
    [self.view addSubview:self.inputViewS];
    [_tablesub reloadData];
    self.inputViewS.testfield.delegate=self;
    //监听键盘弹出，对相应的布局做修改
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        CGFloat endY=[note.userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
        CGFloat tempY = endY - self.view.bounds.size.height;
        CGFloat duration=[note.userInfo [UIKeyboardAnimationDurationUserInfoKey] floatValue];
        self.view.frame=CGRectMake(0, tempY, self.view.bounds.size.width, self.view.bounds.size.height);
        [UIView animateWithDuration:duration animations:^{
            [self.view setNeedsLayout];
            self.inputViewS.wmt_y=self.view.bounds.size.height - 44;
        }];
    }];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *ID=@"cell";
    int i=0;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    i++;
    cell.textLabel.text=[NSString stringWithFormat:@"测试 %d",i];
    
    
    return cell;
}



-(void)wmt_inputview:(WMTinputview *) inputView moreBtnClickWith:(NSInteger) moreStyle{
    
    if (self.view.frame.origin.y == 0) {
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            [self backinit];
            CGRect tempRect = CGRectMake(0, -kWMTMoreinputkeyboardView, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
            NSLog(@"  =======>viewheiht=:%f",CGRectGetHeight(self.view.bounds));
            self.view.frame = tempRect;
            
            //
        } completion:^(BOOL finished) {
            //
                        self.biaoqing.backgroundColor=[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
                        self.biaoqing.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - kWMTMoreinputkeyboardView, CGRectGetWidth(self.view.bounds), kWMTMoreinputkeyboardView);
        }];
    }else
    {
        [self.inputViewS.testfield becomeFirstResponder];
        
    }
}

//  视图将被从屏幕上移除之前执行
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
      NSLog(@"视图离开");
    [self backinit];
    //叫键盘回去
    [self.view endEditing:YES];
    self.inputViewS.jianpanbtn.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)scrollappend{
    [self backinit];
    //叫键盘回去
    [self.view endEditing:YES];
    self.inputViewS.jianpanbtn.hidden=YES;
}


//将more恢复到原样
-(void) backinit{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame=self.view.bounds;
        self.biaoqing.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), kWMTMoreinputkeyboardView);
    }];
    
}


- (void)wmt_biaoqingboaderView:(WmtBiaoqingboardView *)inputView  clickbiaoqing:(UIButton *)btn{
    NSLog(@"---------");
    NSLog(@"---BTN:%@---",btn.titleLabel.text);
    NSString *testfile = self.inputViewS.testfield.text;
    
    self.inputViewS.testfield.text=[NSString stringWithFormat:@"%@%@",testfile,btn.titleLabel.text];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self btnsenddd];
    return YES;
}

//发送消息
-(void)btnsenddd{
    NSString *filetext = self.inputViewS.testfield.text;
    NSLog(@"输入内容：%@",filetext);
    self.inputViewS.testfield.text=@"";
}



@end
