//
//  ViewController.swift
//  ChartTable_Swift
//
//  Created by xun.liu on 16/5/23.
//  Copyright © 2016年 TVM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var arrX:Array = [JSON]()
    var arrY:Array = [JSON]()
    var scrollView:UIScrollView!
    var headerView:UIView!
    var dataJson:JSON = JSON.null
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let path = NSBundle.mainBundle().pathForResource("data", ofType: "json")
        if (path != nil) {
            let data = NSData(contentsOfFile: path!)
            let json = JSON(data:data!)
            dataJson = json
        }
        else {
            dataJson = JSON.null
        }
        
        print("dataJson = \(dataJson)")
        
        if dataJson.type == Type.Dictionary {
            arrX = dataJson["data"]["table_titles"].arrayValue
            arrY = dataJson["data"]["list_datas"].arrayValue
        }
        
        //第一列tableView父视图
        headerView = UIView(frame: CGRectMake (30, 50, 200, 300))
        headerView.backgroundColor = UIColor.grayColor()
        headerView.userInteractionEnabled = true
        //设置边框，形成表格
        headerView.layer.borderWidth = 0.5
        headerView.layer.borderColor = UIColor.blackColor().CGColor
        self.view.addSubview(headerView)
        
        //可左右滑动tableView父视图
        scrollView = UIScrollView(frame: CGRectMake (230, 50, 500, 300))
        scrollView.contentSize = CGSizeMake((CGFloat)(arrX.count-1)*130, CGFloat(arrY.count*50))
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.lightGrayColor()
        //设置边框，形成表格
        scrollView.layer.borderColor = UIColor.blackColor().CGColor
        scrollView.layer.borderWidth = 0.5
        self.view.addSubview(scrollView)
        
        //第一列表
        let tableView:DataTableView = DataTableView(frame: headerView.bounds, style: .Plain)
        
        let titleArr1 = NSMutableArray()
        let levels = NSMutableArray()
        for var dic in arrY {
            let titleStr = dic["date1"].stringValue
            titleArr1.addObject(titleStr)
            
            let level = dic["table_level"].stringValue
            levels.addObject(level)
        }
        
        tableView.titleArr = titleArr1
        tableView.levels = levels
        
        tableView.headerStr = arrX[0]["name1"].stringValue
        tableView.dele = self
        headerView.addSubview(tableView)
        
        for i in 0 ..< arrX.count-1 {
            let tableV:DataTableView = DataTableView(frame: CGRectMake(CGFloat(130*i), 0, 130, 300), style: .Plain)
            
            //x方向 取出key对应的字符串名字
            let xkey:String = "name\(i+2)"
            let xname:String = arrX[i+1][xkey].stringValue
            tableV.headerStr = xname
            
            //y方向
            let titleArr2 = NSMutableArray()
            for j in 0 ..< arrY.count {
                let ykey = "date\(i+2)"
                let yname = arrY[j][ykey].stringValue
                titleArr2.addObject(yname)
            }
            
            tableV.titleArr = titleArr2
            tableV.reloadData()
            tableV.dele = self
            scrollView.addSubview(tableV)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: DataTableViewDelegate {
    func dataTableViewContentOffSet(contentOffSet: CGPoint) {
        for subView in scrollView.subviews {
            if subView.isKindOfClass(DataTableView) {
                (subView as! DataTableView).setTableViewContentOffSet(contentOffSet)
            }
        }
        
        for subView in headerView.subviews {
            (subView as! DataTableView).setTableViewContentOffSet(contentOffSet)
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let p:CGPoint = scrollView.contentOffset
        print(NSStringFromCGPoint(p))
    }
}



