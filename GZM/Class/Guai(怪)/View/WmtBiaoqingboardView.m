//
//  WmtBiaoqingboardView.m
//  BQ
//
//  Created by wangmutian on 2018/1/30.
//  Copyright © 2018年 wangmutian. All rights reserved.
//

#import "WmtBiaoqingboardView.h"
#import "UIView+Frame.h"
static int xddemo;
@interface WmtBiaoqingboardView()<UIScrollViewDelegate>
/** 添加btn**/
@property(nonatomic,strong) NSMutableArray *btns;
/**数组的标题**/
@property(nonatomic,strong) NSArray *btnsTitle;

@property(nonatomic,strong) UIButton *cursor;

@end

@implementation WmtBiaoqingboardView

-(NSArray *)btnsTitle{
    if(!_btnsTitle){
       
        _btnsTitle=@[@"😊",@"😢",@"😊",@"😢",@"😢",@"😊",@"😢",@"😢",@"😊",@"😢",@"😢",@"😊",@"😢",@"😢",@"😊",@"😢",@"😢",@"😊",@"😢",@"😢",@"😊",@"😢",@"😢",@"😊",@"😢",@"😢",@"😊",@"😢",@"😢",@"😊",@"😢"];
    }
    return _btnsTitle;
}

-(NSMutableArray *)btns{
    if(!_btns){
        _btns=[NSMutableArray array];
    }
    return _btns;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    
    if (self) {
        self.backgroundColor=[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
        
        //添加子控件
        for(NSString *title in self.btnsTitle){
            
            [self wmt_setBtnWithTile:title  parentUI:self];
        }
    }
    return self;
}

#pragma  - 添加按钮
-(void)wmt_setBtnWithTile:(NSString *) title parentUI:(UIView *) v{

    UIButton *btn  = [[UIButton alloc] init];
//    btn.backgroundColor=[UIColor redColor];
    [btn setTitle:title forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:22.0];
    [btn addTarget:self action:@selector(moreinputBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //[v addSubview:btn];
    [self.btns addObject:btn];
    
}
-(void)moreinputBtnClick:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(wmt_biaoqingboaderView:clickbiaoqing:)]) {
        
        [self.delegate wmt_biaoqingboaderView:self clickbiaoqing:btn];
        
    }
    
  
}





-(void)layoutSubviews{
    [super layoutSubviews];
    NSInteger maxRowCount  = 3;
    NSInteger maxColCount = 8;
    
    UIScrollView *scrollview = [[UIScrollView alloc] init];
//    scrollview.backgroundColor =[UIColor blackColor];
    scrollview.delegate=self;
    scrollview.frame= self.bounds;
    scrollview.showsHorizontalScrollIndicator = NO; //去掉横向滚动条
    scrollview.showsVerticalScrollIndicator = NO; //去掉 纵向滚动条
    scrollview.pagingEnabled = YES; //让可以分页
    [self addSubview:scrollview];
//    self.scrollview=scrollview;
    
    float count = [self.btns count];
    float totalcount = (maxRowCount * maxColCount);
    float totalnum= count/totalcount;
    
    int num=ceil(totalnum);
   
    [self xiaodian:num];
    
    for(NSInteger i=0;i<num;i++){
        UIView * view=[[UIView alloc] init];
        view.frame=CGRectMake(self.wmt_width * i, 0, self.wmt_width, kWMTdemo);
//        view.backgroundColor=[UIColor redColor];
         view.tag = i;
        [scrollview addSubview:view];
    }
    
    
    
    
    
    CGFloat btnW = 40;
    CGFloat btnH = btnW;
    CGFloat orx = 10;
    CGFloat ory = 5;
    
    
    CGFloat colMargin  = (CGRectGetWidth(self.bounds) - 2*orx - maxColCount * btnW)/(maxColCount + 1);
    CGFloat rowMargin  = (kWMTdemo - 2*ory - maxRowCount * btnH)/(maxRowCount + 2);
    
    int index=0;
    for(UIButton *btn in self.btns){
        int c = (int)index/(maxRowCount * maxColCount);
        
        NSLog(@" %d c=%d",index,c);
        //if(index < (maxRowCount * maxColCount)){
            NSInteger col = index % maxColCount;
            NSInteger row= (index%(maxRowCount * maxColCount)) / maxColCount;
            btn.frame = CGRectMake(orx+ col*(btnW + colMargin) , ory + row*(btnH + rowMargin), btnW, btnH);

            UIView *views = [scrollview viewWithTag:c];
            [views addSubview:btn];
            
        //}
        index++;
    }
    
    
     scrollview.contentSize = CGSizeMake(num*scrollview.wmt_width , 0);
}

-(void) xiaodian:(int) num{
    UIView *xdview = [[UIView alloc] init];
    xdview.frame = CGRectMake(0, kWMTdemo, self.wmt_width, kWMTdian);
//    xdview.backgroundColor = [UIColor greenColor];
    [self addSubview:xdview];
    
    xddemo = (self.wmt_width - (num*kWMTdian+(num - 1) * kWMTdian))/2;
    
    for(NSInteger i=0;i<num;i++ ){
        UIButton *btn=[[UIButton alloc] init];
        btn.frame =CGRectMake(xddemo+i*kWMTdian*2 , 0, kWMTdian, kWMTdian);
        btn.backgroundColor = [UIColor lightGrayColor];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        [xdview addSubview:btn];
    }
    
    //创建实心的小点
    _cursor=[[UIButton alloc] init];
    _cursor.frame =CGRectMake(xddemo, 0, kWMTdian, kWMTdian);
    _cursor.backgroundColor = [UIColor darkGrayColor];
    _cursor.layer.cornerRadius = 5;
    _cursor.layer.masksToBounds = YES;
    [xdview addSubview:_cursor];
    
    //底部 kWMTbutton
    UIView *viewbottom = [[UIView alloc] init];
    viewbottom.frame=CGRectMake(0, kWMTdemo + kWMTdian+10 , self.wmt_width, kWMTbutton);
    viewbottom.backgroundColor=[UIColor whiteColor];
    [self addSubview:viewbottom];
    
    UIButton *btnbutton=[[UIButton alloc] init];
    [btnbutton setTitle:@"发送" forState:UIControlStateNormal];
    btnbutton.frame=CGRectMake(self.wmt_width - 70, 0, 70, kWMTbutton);
//    btnbutton.backgroundColor = [UIColor colorWithRed:4 green:122 blue:251 alpha:1];
    btnbutton.backgroundColor = [UIColor blueColor];
    [btnbutton addTarget:self action:@selector(btnsend) forControlEvents:UIControlEventTouchUpInside];
    [viewbottom addSubview:btnbutton];
}

-(void)btnsend{
    if ([self.delegate respondsToSelector:@selector(btnsenddd)]) {
        
        [self.delegate btnsenddd];
        
    }
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"滚动过程中");
    float index = scrollView.contentOffset.x / scrollView.wmt_width;
    _cursor.frame =CGRectMake(xddemo+index*kWMTdian*2 , 0, kWMTdian, kWMTdian);
}

#pragma 注册协议 结束减速 滚动禁止
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSUInteger index = scrollView.contentOffset.x / scrollView.wmt_width;
    _cursor.frame =CGRectMake(xddemo+index*kWMTdian*2 , 0, kWMTdian, kWMTdian);
}





@end
