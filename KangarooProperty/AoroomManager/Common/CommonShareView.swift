//
//  CommonShareView.swift
//  NiangJiuDaShi
//
//  Created by choice on 15/11/4.
//  Copyright © 2015年 choice. All rights reserved.
//

import Foundation



@objc enum ShareType: Int{
    case weiXinType
    case friendType
}

//@objc(CommonShareView)

@objc protocol shareViewDelegate{
    func shareViewWithType(_ shareType : ShareType)
}

class CommonShareView: UIView {
    var bgBt:UIButton?
    var bottomView:UIView?
    var cancelBt:UIButton?
    var weiXinBt:UIButton?
    var friendBt:UIButton?
    
    var delegate:shareViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
    }
    
    func initUI()
    {
        
        let sWidth = UIScreen.main.bounds.size.width
        let sHeight = UIScreen.main.bounds.size.height
        
        self.frame = CGRect(x: 0, y: 0, width: sWidth, height: sHeight)

        bgBt = UIButton.init(frame: CGRect(x: 0, y: 0, width: sWidth, height: sHeight))
        bgBt?.backgroundColor = UIColor.clear
//        bgBt?.alpha = 0.5
        bgBt?.addTarget(self, action: #selector(CommonShareView.cancelBtPressed), for: UIControlEvents.touchUpInside)
        self.addSubview(bgBt!)
        
        
        bottomView = UIView.init(frame: CGRect(x: 0, y: sHeight-200, width: sWidth, height: sHeight))
        bottomView?.backgroundColor = UIColor.white
        self.addSubview(bottomView!)
        
        let btWidth:CGFloat = 75
        
        let weixinImageView:UIImageView = UIImageView.init(frame: CGRect(x: (sWidth-btWidth*2)/3, y: 10, width: btWidth, height: btWidth))
        weixinImageView.image = UIImage.init(named: "weixinShare-1")
        bottomView?.addSubview(weixinImageView)
        
        let labWeiXin:UILabel = UILabel.init(frame: CGRect(x: (sWidth-btWidth*2)/3, y: 20+btWidth, width: btWidth, height: 20))
        labWeiXin.textAlignment = NSTextAlignment.center
        labWeiXin.font = UIFont.systemFont(ofSize: 16)
        labWeiXin.textColor = UIColor.init(red: 0.55, green: 0.55, blue: 0.55, alpha: 1.0)
        labWeiXin.text = "微信好友"
        bottomView?.addSubview(labWeiXin)
        
        weiXinBt = UIButton.init(frame: CGRect(x: (sWidth-btWidth*2)/3, y: 10, width: btWidth, height: btWidth+20))
        weiXinBt?.addTarget(self, action: #selector(CommonShareView.weixinBtPressed), for: UIControlEvents.touchUpInside)
        weiXinBt?.backgroundColor = UIColor.clear
        bottomView!.addSubview(weiXinBt!)
        
        
        
        let friendImageView:UIImageView = UIImageView.init(frame: CGRect(x: sWidth-(sWidth-btWidth*2)/3 - btWidth, y: 10, width: btWidth, height: btWidth))
        friendImageView.image = UIImage.init(named: "weixinShare-2")
        bottomView?.addSubview(friendImageView)
        
        let labFriend:UILabel = UILabel.init(frame: CGRect(x: sWidth-(sWidth-btWidth*2)/3 - btWidth, y: 20+btWidth, width: btWidth, height: 20))
        labFriend.textAlignment = NSTextAlignment.center
        labFriend.font = UIFont.systemFont(ofSize: 16)
        labFriend.textColor = UIColor.init(red: 0.55, green: 0.55, blue: 0.55, alpha: 1.0)
        labFriend.text = "朋友圈"
        bottomView?.addSubview(labFriend)
        
        
        friendBt = UIButton.init(frame: CGRect(x: sWidth-(sWidth-btWidth*2)/3 - btWidth, y: 10, width: btWidth, height: btWidth+20))
        friendBt?.backgroundColor = UIColor.clear
        friendBt?.addTarget(self, action: #selector(CommonShareView.friendBtPressed), for: UIControlEvents.touchUpInside)
        bottomView!.addSubview(friendBt!)
        
        
        cancelBt = UIButton.init(frame: CGRect(x: 10, y: 150, width: sWidth-20, height: 40))
        cancelBt?.layer.cornerRadius = 5
        cancelBt?.layer.masksToBounds = true
        cancelBt?.setTitle("取消", for: UIControlState())
        cancelBt?.addTarget(self, action: #selector(CommonShareView.cancelBtPressed), for: UIControlEvents.touchUpInside)
        cancelBt?.backgroundColor = UIColor(rgba: "#BF2E2A")
        bottomView!.addSubview(cancelBt!)
    }
    
    func weixinBtPressed()
    {
        delegate?.shareViewWithType(.weiXinType)
    }
    
    func friendBtPressed()
    {
        delegate?.shareViewWithType(.friendType)
    }
    
    func cancelBtPressed()
    {
        let yuanFram = self.frame
        UIView.animate(withDuration: 0.5, animations: {
            
            var fram = self.frame
            fram.origin.y = UIScreen.main.bounds.size.height
            self.frame = fram
            }, completion: { (bool) in
              self.removeFromSuperview()
                self.frame = yuanFram
        }) 
        
    }
}
