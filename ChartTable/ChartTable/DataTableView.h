//
//  DataTableView.h
//  ChartTable
//
//  Created by xun.liu on 15/5/25.
//  Copyright (c) 2015年 xun.liu. All rights reserved.
//

#import <UIKit/UIKit.h>

//设置同步滑动代理
@protocol scrollDelegate <NSObject>

-(void)dataTableViewContentOffSet:(CGPoint)contentOffSet;

@end

@interface DataTableView : UITableView<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSString *headerStr;
@property (nonatomic, strong) NSArray *levels;

@property (nonatomic, assign) id<scrollDelegate> scroll_delegate;

-(void)setTableViewContentOffSet:(CGPoint)contentOffSet;

@end
