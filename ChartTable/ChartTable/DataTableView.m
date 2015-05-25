//
//  DataTableView.m
//  ChartTable
//
//  Created by xun.liu on 15/5/25.
//  Copyright (c) 2015年 xun.liu. All rights reserved.
//  lx_xi163@163.com

#import "DataTableView.h"

@implementation DataTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        [self _initView];
    }
    return self;
}

-(void)_initView
{
    self.delegate = self;
    self.dataSource = self;
    self.showsVerticalScrollIndicator = NO;    //竖直
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;  //去掉分割线
    self.bounces = NO;
    self.rowHeight = 50;
}

-(void)setTableViewContentOffSet:(CGPoint)contentOffSet
{
    [self setContentOffset:contentOffSet];
}

-(void)setTitleArr:(NSArray *)titleArr
{
    _titleArr = titleArr;
}

#pragma mark - UITableView delegate/dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.backgroundColor = [UIColor clearColor];
        
        //设置边框，形成表格
        cell.layer.borderWidth = .5f;
        cell.layer.borderColor = [UIColor blackColor].CGColor;
        //取消选中
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width, 50)];
        label.tag = 100;
        [cell.contentView addSubview:label];
        
        
        //        NSLog(@"cell.contentView=%@",NSStringFromCGRect(cell.contentView.frame));
        //        NSLog(@"tableView=%@",NSStringFromCGRect(self.frame));
        
    }
    
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    label.text = [_titleArr objectAtIndex:indexPath.row];
    
    //分级
    NSString *level = [_levels objectAtIndex:indexPath.row];
    if ([level isEqualToString:@"1"])
    {
        CGRect frame = label.frame;
        frame.origin.x = 10;
        label.frame = frame;
    }
    else if ([level isEqualToString:@"2"])
    {
        CGRect frame = label.frame;
        frame.origin.x = 30;
        label.frame = frame;
    }
    else if ([level isEqualToString:@"3"])
    {
        CGRect frame = label.frame;
        frame.origin.x = 50;
        label.frame = frame;
    }
    
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
    headerView.backgroundColor = [UIColor darkGrayColor];
    
    CGRect frame = headerView.bounds;
    frame.origin.x = 10;
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = [UIColor whiteColor];
    label.text = self.headerStr;
    label.textColor = [UIColor blackColor];
    [headerView addSubview:label];
    
    headerView.layer.borderColor = [UIColor blackColor].CGColor;
    headerView.layer.borderWidth = .5f;
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

#pragma mark - UIScrollView delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scroll_delegate && [_scroll_delegate respondsToSelector:@selector(dataTableViewContentOffSet:)])
    {
        [_scroll_delegate dataTableViewContentOffSet:scrollView.contentOffset];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
