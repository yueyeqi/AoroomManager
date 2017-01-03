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
    case None
    case Start
    case Move
    case End
    case Cancel
}

class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = self.tabBarController as! BaseTabViewController
        tabbar.shareView.delegate = self
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBarHidden = false
    }
    
    @IBAction func homeAction(sender: AnyObject) {
        let dic = ["url": "http://aoroom.com","title":"首页"]
        pushWeb(dic)
    }
    @IBAction func xinpanAction(sender: AnyObject) {
        let dic = ["url": "http://aoroom.com/portal.php?mod=list&catid=1", "title":"新盘"]
        pushWeb(dic)
     
    }
    
    @IBAction func dituAction(sender: AnyObject) {
        let dic = ["url": "http://aoroom.com/test8.html", "title": "地图"]
        pushWeb(dic)
    }
    
    @IBAction func zufangAction(sender: AnyObject) {
        let dic = ["url": "http://aoroom.com/forum.php?mod=forumdisplay&fid=2", "title": "租房"]
        pushWeb(dic)
    }
    
    @IBAction func peixunAction(sender: AnyObject) {
        let dic = ["url": "http://aoroom.com/portal.php?mod=view&aid=108&mobile=yes", "title": "培训"]
        pushWeb(dic)
    }
    
    @IBAction func zhishiAction(sender: AnyObject) {
        let dic = ["url": "http://aoroom.com/portal.php?mod=list&catid=2", "title": "指数"]
        pushWeb(dic)
    }
    
    @IBAction func xinwenAction(sender: AnyObject) {
        let dic = ["url": "http://aoroom.com/news/", "title": "新闻"]
        pushWeb(dic)
    }
    
    @IBAction func zhishuAction(sender: AnyObject) {
        let dic = ["url": "http://aoroom.com/portal.php?mod=view&aid=24&mobile=yes", "title": "指数"]
        pushWeb(dic)
    }
    
    func pushWeb(dic: [String: String]) -> Void {
        self.performSegueWithIdentifier("segue", sender: dic)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let VC = segue.destinationViewController as! WebViewController
        let dic = sender as! [String: String]
        VC.currenUrl = dic["url"]!
        VC.title = dic["title"]!
    }
}

extension HomeViewController: shareViewDelegate {
    func shareViewWithType(shareType: ShareType) {
        var sence: Int32 = 1
        if shareType == ShareType.WeiXinType {
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
        
        WXApi.sendReq(wxSendMsg)

    }
}


