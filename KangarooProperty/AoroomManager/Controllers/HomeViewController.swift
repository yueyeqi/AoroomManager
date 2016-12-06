//
//  HomeViewController.swift
//  KangarooProperty
//
//  Created by YYQ on 16/3/20.
//  Copyright © 2016年 YYQ. All rights reserved.
//

import UIKit

public let kTouchJavaScriptString: String = "document.ontouchstart=function(event){x=event.targetTouches[0].clientX;y=event.targetTouches[0].clientY;document.location=\"myweb:touch:start:\"+x+\":\"+y;};document.ontouchmove=function(event){x=event.targetTouches[0].clientX;y=event.targetTouches[0].clientY;document.location=\"myweb:touch:move:\"+x+\":\"+y;};document.ontouchcancel=function(event){document.location=\"myweb:touch:cancel\";};document.ontouchend=function(event){document.location=\"myweb:touch:end\";};"

enum TouchState {
    case none
    case start
    case move
    case end
    case cancel
}

class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = self.tabBarController as! BaseTabViewController
        tabbar.shareView.delegate = self
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func homeAction(_ sender: AnyObject) {
        let dic = ["url": "http://aoroom.com","title":"首页"]
        pushWeb(dic)
    }
    @IBAction func xinpanAction(_ sender: AnyObject) {
        let dic = ["url": "http://aoroom.com/portal.php?mod=list&catid=1", "title":"新盘"]
        pushWeb(dic)
     
    }
    
    @IBAction func dituAction(_ sender: AnyObject) {
        let dic = ["url": "http://aoroom.com/test8.html", "title": "地图"]
        pushWeb(dic)
    }
    
    @IBAction func zufangAction(_ sender: AnyObject) {
        let dic = ["url": "http://aoroom.com/forum.php?mod=forumdisplay&fid=2", "title": "租房"]
        pushWeb(dic)
    }
    
    @IBAction func peixunAction(_ sender: AnyObject) {
        let dic = ["url": "http://aoroom.com/portal.php?mod=view&aid=108&mobile=yes", "title": "培训"]
        pushWeb(dic)
    }
    
    @IBAction func zhishiAction(_ sender: AnyObject) {
        let dic = ["url": "http://aoroom.com/portal.php?mod=list&catid=2", "title": "指数"]
        pushWeb(dic)
    }
    
    @IBAction func xinwenAction(_ sender: AnyObject) {
        let dic = ["url": "http://aoroom.com/news/", "title": "新闻"]
        pushWeb(dic)
    }
    
    @IBAction func zhishuAction(_ sender: AnyObject) {
        let dic = ["url": "http://aoroom.com/portal.php?mod=view&aid=24&mobile=yes", "title": "指数"]
        pushWeb(dic)
    }
    
    func pushWeb(_ dic: [String: String]) -> Void {
        self.performSegue(withIdentifier: "segue", sender: dic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let VC = segue.destination as! WebViewController
        let dic = sender as! [String: String]
        VC.currenUrl = dic["url"]!
        VC.title = dic["title"]!
    }
}

extension HomeViewController: shareViewDelegate {
    func shareViewWithType(_ shareType: ShareType) {
        var sence: Int32 = 1
        if shareType == ShareType.weiXinType {
            sence = 0
        }else {
            sence = 1
        }
        let wxSendMsg = SendMessageToWXReq()
        wxSendMsg.scene = sence
        
        let urlMessage = WXMediaMessage()
        urlMessage.title = "袋鼠房产网"
        urlMessage.description = "袋鼠房产网  澳洲房产资讯"
        urlMessage.setThumbImage(UIImage(named: "arrow"))
        let webObj = WXWebpageObject()
        webObj.webpageUrl = "http://www.aoroom.com"
        
        urlMessage.mediaObject = webObj
        wxSendMsg.message = urlMessage
        
        WXApi.send(wxSendMsg)

    }
}


