//
//  WebViewController.swift
//  KangarooProperty
//
//  Created by YYQ on 16/3/24.
//  Copyright © 2016年 YYQ. All rights reserved.
//

import UIKit
import Photos

class WebViewController: BaseViewController {
    
    var webViewProgressView: NJKWebViewProgressView?
    var webViewProgress: NJKWebViewProgress?
    var currenUrl: String = ""
    var currenInnerHTML: String = ""
    
    static var imgUrl:String = ""//存储当前点击的图片路径
    var touchState:TouchState = TouchState.none//设置默认的点击状态为NONE
    var timer:Timer? = nil//定时器 长按时 定时器启动 执行一次 弹出保存确认
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.scrollView.bounces = false
        webView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        webView.scalesPageToFit = true
        webView.isMultipleTouchEnabled = true
        webView.isUserInteractionEnabled = true
        createWebProgress()
        loadWebView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let tabbar = self.tabBarController as! BaseTabViewController
        tabbar.shareView.delegate = self
    }
    ///  webView 请求
    func loadWebView() {
        webView.loadRequest(URLRequest(url: URL(string: currenUrl)!))
    }
    
    ///  创建webView进度条
    func createWebProgress() {
        webViewProgress = NJKWebViewProgress()
        webView.delegate = webViewProgress
        webViewProgress?.webViewProxyDelegate = self
        webViewProgress?.progressDelegate = self
        
        let navBounds: CGRect = (self.navigationController?.navigationBar.bounds)!
        let barFrame: CGRect = CGRect(x: 0, y: navBounds.size.height - 2, width: navBounds.size.width, height: 2)
        
        webViewProgressView = NJKWebViewProgressView(frame: barFrame)
        webViewProgressView?.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleTopMargin]
        webViewProgressView?.setProgress(0, animated: true)
        self.navigationController?.navigationBar.addSubview(webViewProgressView!)
    }
    
    
    @IBAction func backAction(_ sender: AnyObject) {
        self.webView.goBack()
    }

    @IBAction func forwardAction(_ sender: AnyObject) {
       self.webView.goForward()
    }
    
    @IBAction func refreshAction(_ sender: AnyObject) {
        self.webView.reload()
    }
    
    func handleLongTouch(){
        if(WebViewController.imgUrl != "" && touchState == TouchState.start){
            let alertSheetCtr = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alertSheetCtr.addAction(UIAlertAction(title: "保存图片", style: .default, handler: { (alert) in
                let urlToSave: String = self.webView.stringByEvaluatingJavaScript(from: WebViewController.imgUrl)!
                if urlToSave.characters.count > 0 {
                    var data: Data! = nil
                    do {
                        try data = Data(contentsOf: URL(string: urlToSave)!)
                        let image: UIImage = UIImage(data: data)!
                        let status = PHPhotoLibrary.authorizationStatus()
                        if (status == PHAuthorizationStatus.restricted) || (status == PHAuthorizationStatus.denied) {
                            print("没有权限")
                        }else {
                            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
                        }
                    }catch let error {
                        print(error)
                    }
                }
            }))
            alertSheetCtr.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(alertSheetCtr, animated: true, completion: nil)
        }
    }
}

extension WebViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        currenUrl = ""
        currenInnerHTML = ""
        let str = webView.stringByEvaluatingJavaScript(from: "document.title")
        if (str?.characters.count)! > 0 {
            self.navigationController!.navigationBar.topItem!.title = str
        }
        currenUrl = webView.stringByEvaluatingJavaScript(from: "document.location.href")!
        currenInnerHTML = webView.stringByEvaluatingJavaScript(from: "document.getElementsByName(\"description\")[0].content")!
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.stringByEvaluatingJavaScript(from: kTouchJavaScriptString)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let requestStr:String = request.url!.absoluteString
        let components = requestStr.components(separatedBy: ":")
        if(components.count>1 && components[0] == "myweb"){
            if(components[1] == "touch"){
                if(components[2] == "start"){
                    touchState = TouchState.start
                    let ptX:Float32 = (components[3] as NSString).floatValue
                    let ptY:Float32 = (components[4] as NSString).floatValue
                    let js:String = "document.elementFromPoint(\(ptX), \(ptY)).tagName"
                    let tagName:String? = webView.stringByEvaluatingJavaScript(from: js)
                    if(tagName!.uppercased() == "IMG")
                    {
                        let srcJS:String = "document.elementFromPoint(\(ptX), \(ptY)).src"
                        WebViewController.imgUrl = srcJS
                        if(WebViewController.imgUrl != ""){
                            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.handleLongTouch), userInfo: nil, repeats: false)
                        }
                    }
                }else if(components[2] == "move"){
                    touchState = TouchState.move
                    if(timer != nil)
                    {
                        timer!.fire()
                    }
                }
                else if(components[2] == "cancel"){
                    touchState = TouchState.cancel
                    if(timer != nil)
                    {
                        timer!.fire()
                    }
                }
                else if(components[2] == "end"){
                    touchState = TouchState.end
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

extension WebViewController: NJKWebViewProgressDelegate {
    func webViewProgress(_ webViewProgress: NJKWebViewProgress!, updateProgress progress: Float) {
        webViewProgressView?.setProgress(progress, animated: true)
    }
}

extension WebViewController: shareViewDelegate {
    func shareViewWithType(_ shareType: ShareType) {
        if currenUrl.characters.count < 1 || currenInnerHTML.characters.count < 1 {
            UIAlertView(title: "提示", message: "网页还没有加载噢", delegate: nil, cancelButtonTitle: "知道了").show()
            return
        }
        var sence: Int32 = 1
        if shareType == ShareType.weiXinType {
            sence = 0
        }else {
            sence = 1
        }
        let wxSendMsg = SendMessageToWXReq()
        wxSendMsg.scene = sence
        
        let urlMessage = WXMediaMessage()
        urlMessage.title = self.navigationController!.navigationBar.topItem!.title
        urlMessage.description = currenInnerHTML
        urlMessage.setThumbImage(UIImage(named: "arrow"))
        let webObj = WXWebpageObject()
        webObj.webpageUrl = currenUrl
        
        urlMessage.mediaObject = webObj
        wxSendMsg.message = urlMessage
        
        WXApi.send(wxSendMsg)
    }
}

