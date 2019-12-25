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
    var scrollView: UIScrollView?
    var headerView: UIView?
    var dataJson:JSON = JSON.null
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "data", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        guard let json = try? JSON(data: data!) else {
            return
        }
        dataJson = json
        
        print("dataJson = \(dataJson)")
        arrX = dataJson["data"]["table_titles"].arrayValue
        arrY = dataJson["data"]["list_datas"].arrayValue
        
        //第一列tableView父视图
        headerView = UIView(frame: CGRect(x: 30, y: 50, width: 200, height: 300))
        headerView?.backgroundColor = UIColor.gray
        headerView?.isUserInteractionEnabled = true
        //设置边框，形成表格
        headerView?.layer.borderWidth = 0.5
        headerView?.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(headerView!)
        
        //可左右滑动tableView父视图
        scrollView = UIScrollView(frame: CGRect(x: 230, y: 50, width: 500, height: 300))
        scrollView?.contentSize = CGSize(width: (CGFloat)(arrX.count-1)*130, height: CGFloat(arrY.count*50))
        scrollView?.showsHorizontalScrollIndicator = true
        scrollView?.showsVerticalScrollIndicator = true
        scrollView?.bounces = false
        scrollView?.delegate = self
        scrollView?.backgroundColor = UIColor.lightGray
        //设置边框，形成表格
        scrollView?.layer.borderColor = UIColor.black.cgColor
        scrollView?.layer.borderWidth = 0.5
        self.view.addSubview(scrollView!)
        
        //第一列表
        let tableView:DataTableView = DataTableView(frame: headerView!.bounds, style: .plain)
        
        var titleArr1: [String] = []
        var levels: [String] = []
        arrY.forEach { (dic: JSON) in
            let titleStr = dic["date1"].stringValue
            titleArr1.append(titleStr)
            
            let level = dic["table_level"].stringValue
            levels.append(level)
        }
        
        tableView.titleArr = titleArr1
        tableView.levels = levels
        
        tableView.headerStr = arrX[0]["name1"].stringValue
        tableView.dele = self
        headerView?.addSubview(tableView)
        
        for i in 0 ..< arrX.count-1 {
            let tableV:DataTableView = DataTableView(frame: CGRect(x: CGFloat(130*i), y: 0, width: 130, height: 300), style: .plain)
            
            //x方向 取出key对应的字符串名字
            let xkey:String = "name\(i+2)"
            let xname:String = arrX[i+1][xkey].stringValue
            tableV.headerStr = xname
            
            //y方向
            var titleArr2: [String] = []
            for j in 0 ..< arrY.count {
                let ykey = "date\(i+2)"
                let yname = arrY[j][ykey].stringValue
                titleArr2.append(yname)
            }
            
            tableV.titleArr = titleArr2
            tableV.reloadData()
            tableV.dele = self
            scrollView?.addSubview(tableV)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: DataTableViewDelegate {
    func dataTableViewContentOffSet(contentOffSet: CGPoint) {
        for subView in scrollView?.subviews ?? [] {
            if subView is DataTableView {
                (subView as! DataTableView).setTableViewContentOffSet(contentOffset: contentOffSet)
            }
        }
        
        for subView in headerView?.subviews ?? [] {
            (subView as! DataTableView).setTableViewContentOffSet(contentOffset: contentOffSet)
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let p:CGPoint = scrollView.contentOffset
        print(NSCoder.string(for: p))
    }
}



