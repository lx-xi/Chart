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
    var titleArr: [String] = []
    var headerStr: String = ""
    var levels: [String] = []
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style:style)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
        self.delegate = self
        self.dataSource = self
        self.showsVerticalScrollIndicator = false //竖直
        self.backgroundColor = UIColor.clear
        self.separatorStyle = .none //去掉分割线
        self.bounces = false
        self.rowHeight = 50
    }
    
    func setTableViewContentOffSet(contentOffset:CGPoint) {
        self.setContentOffset(contentOffset, animated: false)
    }
    
    //MARK: - UITableView delegate/dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identify = "CELL"
        var cell = tableView.dequeueReusableCell(withIdentifier: identify)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identify)
            cell?.backgroundColor = UIColor.clear
            
            //设置边框，形成表格
            cell?.layer.borderWidth = 0.5
            cell?.layer.borderColor = UIColor.black.cgColor
            //取消选中
            cell?.selectionStyle = .none
            
            let label = UILabel(frame: CGRect(x: 10, y: 0, width: self.frame.size.width, height: 50))
            label.tag = 100
            cell?.contentView.addSubview(label)
        }
        
        let label:UILabel = (cell?.contentView.viewWithTag(100) as! UILabel)
        label.text = titleArr[indexPath.row]
        
        //分级
        if levels.count > 0 {
            let level = levels[indexPath.row]
            if level == "1" {
                var frame:CGRect = label.frame
                frame.origin.x = 10
                label.frame = frame
            } else if level == "2" {
                var frame:CGRect = label.frame
                frame.origin.x = 30
                label.frame = frame
            } else if level == "3" {
                var frame:CGRect = label.frame
                frame.origin.x = 50
                label.frame = frame
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
        headerView.backgroundColor = UIColor.darkGray
        
        var frame:CGRect = headerView.bounds
        frame.origin.x = 10
        
        let label:UILabel = UILabel(frame: frame)
        label.textColor = UIColor.white
        label.text = self.headerStr
        label.textColor = UIColor.black
        headerView.addSubview(label)
        
        headerView.layer.borderColor = UIColor.black.cgColor
        headerView.layer.borderWidth = 0.5
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    //MARK: - UIScrollView delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        dele?.dataTableViewContentOffSet(contentOffSet: scrollView.contentOffset)
    }
}

