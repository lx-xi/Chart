//
//  DataTableView.swift
//  ChartTable_Swift
//
//  Created by xun.liu on 16/5/23.
//  Copyright © 2016年 TVM. All rights reserved.
//

import UIKit

protocol DataTableViewDelegate {
    func dataTableViewContentOffSet(contentOffSet:CGPoint)
}

class DataTableView: UITableView, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    var dele:DataTableViewDelegate!
    var titleArr = NSMutableArray()
    var headerStr:String = ""
    var levels = NSMutableArray()
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style:style)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.delegate = self
        self.dataSource = self
        self.showsVerticalScrollIndicator = false //竖直
        self.backgroundColor = UIColor.clearColor()
        self.separatorStyle = .None //去掉分割线
        self.bounces = false
        self.rowHeight = 50
    }
    
    func setTableViewContentOffSet(contentOffset:CGPoint) {
        self.setContentOffset(contentOffset, animated: false)
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    //MARK: - UITableView delegate/dataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identify = "CELL"
        var cell = tableView.dequeueReusableCellWithIdentifier(identify)
        if (cell == nil) {
            cell = UITableViewCell(style: .Default, reuseIdentifier: identify)
            cell?.backgroundColor = UIColor.clearColor()
            
            //设置边框，形成表格
            cell?.layer.borderWidth = 0.5
            cell?.layer.borderColor = UIColor.blackColor().CGColor
            //取消选中
            cell?.selectionStyle = .None
            
            let label = UILabel(frame: CGRectMake (10, 0, self.frame.size.width, 50))
            label.tag = 100
            cell?.contentView.addSubview(label)
            
        }
        
        let label:UILabel = (cell?.contentView.viewWithTag(100) as! UILabel)
        label.text = titleArr[indexPath.row] as? String
        
        //分级
        if levels.count > 0 {
            let level = levels[indexPath.row] as? String
            if level == "1" {
                var frame:CGRect = label.frame
                frame.origin.x = 10
                label.frame = frame
            }
            else if level == "2" {
                var frame:CGRect = label.frame
                frame.origin.x = 30
                label.frame = frame
            }
            else if level == "3" {
                var frame:CGRect = label.frame
                frame.origin.x = 50
                label.frame = frame
            }
        }
        
        
        return cell!
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView:UIView = UIView(frame: CGRectMake (0, 0, 120, 50))
        headerView.backgroundColor = UIColor.darkGrayColor()
        
        var frame:CGRect = headerView.bounds
        frame.origin.x = 10
        
        let label:UILabel = UILabel(frame: frame)
        label.textColor = UIColor.whiteColor()
        label.text = self.headerStr
        label.textColor = UIColor.blackColor()
        headerView.addSubview(label)
        
        headerView.layer.borderColor = UIColor.blackColor().CGColor
        headerView.layer.borderWidth = 0.5
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    //MARK: - UIScrollView delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        dele?.dataTableViewContentOffSet(scrollView.contentOffset)
    }
}

