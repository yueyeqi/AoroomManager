//
//  PersonalViewController.swift
//  KangarooProperty
//
//  Created by YYQ on 16/3/18.
//  Copyright © 2016年 YYQ. All rights reserved.
//

import UIKit

class PersonalViewController: BaseViewController {

    var webViewProgressView: NJKWebViewProgressView?
    var webViewProgress: NJKWebViewProgress?
    var currenTitle: String = ""
    var currenUrl: String = ""
    var currenInnerHTML: String = ""
    
    static var imgUrl:String = ""//存储当前点击的图片路径
    var touchState:TouchState = TouchState.None//设置默认的点击状态为NONE
    var timer:NSTimer? = nil//定时器 长按时 定时器启动 执行一次 弹出保存确认
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "个人网店"
        webView.scrollView.bounces = false
        webView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        webView.scalesPageToFit = true
        webView.multipleTouchEnabled = true
        webView.userInteractionEnabled = true
        createWebProgress()
        loadWebView()
        setLeftButtonImage(nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = self.tabBarController as! BaseTabViewController
        tabbar.shareView.delegate = self
    }
    
///  webView 请求
    func loadWebView() {
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.aoroom.com/address.htm")!))
    }
    
///  创建webView进度条
    func createWebProgress() {
        webViewProgress = NJKWebViewProgress()
        webView.delegate = webViewProgress
        webViewProgress?.webViewProxyDelegate = self
        webViewProgress?.progressDelegate = self
        
        let navBounds: CGRect = (self.navigationController?.navigationBar.bounds)!
        let barFrame: CGRect = CGRectMake(0, navBounds.size.height - 2, navBounds.size.width, 2)
        
        webViewProgressView = NJKWebViewProgressView(frame: barFrame)
        webViewProgressView?.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleTopMargin]
        webViewProgressView?.setProgress(0, animated: true)
        self.navigationController?.navigationBar.addSubview(webViewProgressView!)
    }
    
// MARK: - Action
    
    @IBAction func backAction(sender: AnyObject) {
        if currenUrl == "http://www.aoroom.com/address.htm" {
            return
        }
        self.webView.goBack()
    }
    
    @IBAction func forwardAction(sender: AnyObject) {
        self.webView.goForward()
    }
    
    @IBAction func refreshAction(sender: AnyObject) {
        self.webView.reload()
    }
    
    func handleLongTouch(){
        if(PersonalViewController.imgUrl != "" && touchState == TouchState.Start){
            let alertSheetCtr = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            alertSheetCtr.addAction(UIAlertAction(title: "保存图片", style: .Default, handler: { (alert) in
                let urlToSave: String = self.webView.stringByEvaluatingJavaScriptFromString(PersonalViewController.imgUrl)!
                let data: NSData = NSData(contentsOfURL: NSURL(string: urlToSave)!)!
                let image: UIImage = UIImage(data: data)!
                UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
            }))
            alertSheetCtr.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
            self.presentViewController(alertSheetCtr, animated: true, completion: nil)
        }
    }

}

extension PersonalViewController: UIWebViewDelegate {
    func webViewDidStartLoad(webView: UIWebView) {
        currenUrl = ""
        currenInnerHTML = ""
        let str = webView.stringByEvaluatingJavaScriptFromString("document.title")
        if str?.characters.count > 0 {
            self.navigationController!.navigationBar.topItem!.title = str
            self.currenTitle = str!
        }else {
            self.navigationController!.navigationBar.topItem!.title = "个人网店"
        }
        
        currenUrl = webView.stringByEvaluatingJavaScriptFromString("document.location.href")!
        if currenUrl.characters.count < 1 || currenUrl == "about:blank" {
            currenUrl = "http://www.aoroom.com"
            currenTitle = "袋鼠房产网"
        }
        currenInnerHTML = webView.stringByEvaluatingJavaScriptFromString("document.getElementsByName(\"description\")[0].content")!
        if currenInnerHTML.characters.count < 1 {
            currenInnerHTML = "袋鼠房产网  澳洲房产资讯"
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        webView.stringByEvaluatingJavaScriptFromString(kTouchJavaScriptString)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let requestStr:String = request.URL!.absoluteString
        let components = requestStr.componentsSeparatedByString(":")
        if(components.count>1 && components[0] == "myweb"){
            if(components[1] == "touch"){
                if(components[2] == "start"){
                    touchState = TouchState.Start
                    let ptX:Float32 = (components[3] as NSString).floatValue
                    let ptY:Float32 = (components[4] as NSString).floatValue
                    let js:String = "document.elementFromPoint(\(ptX), \(ptY)).tagName"
                    let tagName:String? = webView.stringByEvaluatingJavaScriptFromString(js)
                    if(tagName!.uppercaseString == "IMG")
                    {
                        let srcJS:String = "document.elementFromPoint(\(ptX), \(ptY)).src"
                        PersonalViewController.imgUrl = srcJS
                        if(PersonalViewController.imgUrl != ""){
                            timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(self.handleLongTouch), userInfo: nil, repeats: false)
                        }
                    }
                }else if(components[2] == "move"){
                    touchState = TouchState.Move
                    if(timer != nil)
                    {
                        timer!.fire()
                    }
                }
                else if(components[2] == "cancel"){
                    touchState = TouchState.Cancel
                    if(timer != nil)
                    {
                        timer!.fire()
                    }
                }
                else if(components[2] == "end"){
                    touchState = TouchState.End
                    if(timer != nil)
                    {
                        timer!.fire()
                    }
                }
            }
        }
        return true
    }
    
}

extension PersonalViewController: NJKWebViewProgressDelegate {
    func webViewProgress(webViewProgress: NJKWebViewProgress!, updateProgress progress: Float) {
        webViewProgressView?.setProgress(progress, animated: true)
    }
}

extension PersonalViewController: shareViewDelegate {
    func shareViewWithType(shareType: ShareType) {
        if currenUrl.characters.count < 1 || currenInnerHTML.characters.count < 1 {
            UIAlertView(title: "提示", message: "网页还没有加载噢", delegate: nil, cancelButtonTitle: "知道了").show()
            return
        }
        var sence: Int32 = 1
        if shareType == ShareType.WeiXinType {
            sence = 0
        }else {
            sence = 1
        }
        let wxSendMsg = SendMessageToWXReq()
        wxSendMsg.scene = sence
        
        let urlMessage = WXMediaMessage()
        urlMessage.title = self.currenTitle
        urlMessage.description = currenInnerHTML
        urlMessage.setThumbImage(UIImage(named: "arrow"))
        let webObj = WXWebpageObject()
        webObj.webpageUrl = currenUrl
        
        urlMessage.mediaObject = webObj
        wxSendMsg.message = urlMessage
        
        WXApi.sendReq(wxSendMsg)
    }
}
