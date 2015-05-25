//
//  ViewController.m
//  ChartTable
//
//  Created by xun.liu on 15/5/25.
//  Copyright (c) 2015年 xun.liu. All rights reserved.
//

#import "ViewController.h"
#import "DataTableView.h"
#import "JSONKit.h"

@interface ViewController ()<scrollDelegate, UIScrollViewDelegate>

@end

@implementation ViewController
{
    NSArray *_arrX;
    NSMutableArray *_arrY;
    UIScrollView *_scroll;
    UIView *_headView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *dic = [str objectFromJSONString];
    NSDictionary *dataDic = [dic objectForKey:@"data"];
    
    //x方向数据
    _arrX = [dataDic objectForKey:@"table_titles"];
    
    //y方向数据
    _arrY = [dataDic objectForKey:@"list_datas"];
    
    
    //第一列tableView父视图
    _headView = [[UIView alloc] initWithFrame:CGRectMake(30, 50, 200, 300)];
    _headView.backgroundColor = [UIColor grayColor];
    _headView.userInteractionEnabled = YES;
    //设置边框，形成表格
    _headView.layer.borderWidth = .5f;
    _headView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_headView];
    
    //可左右滑动tableView父视图
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(230, 50, 500, 300)];
    _scroll.contentSize = CGSizeMake((_arrX.count-1)*130, _arrY.count*50);
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.bounces = NO;
    _scroll.delegate = self;
    _scroll.backgroundColor = [UIColor lightGrayColor];
    //设置边框，形成表格
    _scroll.layer.borderWidth = .5f;
    _scroll.layer.borderColor = [UIColor blackColor].CGColor;
    
    [self.view addSubview:_scroll];
    
    
    //第一列表
    DataTableView *tableView = [[DataTableView alloc] initWithFrame:_headView.bounds style:UITableViewStylePlain];
    
    NSMutableArray *titleArr1 = [NSMutableArray array];
    NSMutableArray *levels = [NSMutableArray array];
    for (NSDictionary *dic in _arrY)
    {
        NSString *titleStr = [dic objectForKey:@"date1"];
        [titleArr1 addObject:titleStr];
        
        NSString *level = [dic objectForKey:@"table_level"];
        [levels addObject:level];
    }
    tableView.titleArr = titleArr1;
    tableView.levels = levels;
    
    tableView.headerStr = [_arrX[0] objectForKey:@"name1"];
    tableView.scroll_delegate = self;
    [_headView addSubview:tableView];
    
    
    for (int i=0; i<_arrX.count-1; i++)
    {
        DataTableView *tableView = [[DataTableView alloc] initWithFrame:CGRectMake(130*i, 0, 130, 300) style:UITableViewStylePlain];
        
        //x方向 取出key对应的字符串名字
        NSString *xkey = [NSString stringWithFormat:@"name%i",i+2];
        NSString *xname = [_arrX[i+1] objectForKey:xkey];
        tableView.headerStr = xname;
        
        //y方向
        NSMutableArray *titleArr2 = [NSMutableArray array];
        for (int j=0; j<_arrY.count; j++)
        {
            NSString *ykey = [NSString stringWithFormat:@"date%i",i+2];
            NSString *yname = [_arrY[j] objectForKey:ykey];
            [titleArr2 addObject:yname];
        }
        tableView.titleArr = titleArr2;
        [tableView reloadData];
        tableView.scroll_delegate = self;
        [_scroll addSubview:tableView];
    }
}

#pragma mark - scrollDelegate
-(void)dataTableViewContentOffSet:(CGPoint)contentOffSet
{
    for (UIView *subView in _scroll.subviews)
    {
        if ([subView isKindOfClass:[DataTableView class]])
        {
            [(DataTableView *)subView setTableViewContentOffSet:contentOffSet];
        }
    }
    
    for (UIView *subView in _headView.subviews)
    {
        [(DataTableView *)subView setTableViewContentOffSet:contentOffSet];
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint p = scrollView.contentOffset;
    NSLog(@"%@",NSStringFromCGPoint(p));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
