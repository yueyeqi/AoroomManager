//
//  CommonShareView.swift
//  NiangJiuDaShi
//
//  Created by choice on 15/11/4.
//  Copyright © 2015年 choice. All rights reserved.
//

import Foundation



@objc enum ShareType: Int{
    case WeiXinType
    case FriendType
}

//@objc(CommonShareView)

@objc protocol shareViewDelegate{
    func shareViewWithType(shareType : ShareType)
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
        
        let sWidth = UIScreen.mainScreen().bounds.size.width
        let sHeight = UIScreen.mainScreen().bounds.size.height
        
        self.frame = CGRectMake(0, 0, sWidth, sHeight)

        bgBt = UIButton.init(frame: CGRectMake(0, 0, sWidth, sHeight))
        bgBt?.backgroundColor = UIColor.clearColor()
//        bgBt?.alpha = 0.5
        bgBt?.addTarget(self, action: #selector(CommonShareView.cancelBtPressed), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(bgBt!)
        
        
        bottomView = UIView.init(frame: CGRectMake(0, sHeight-200, sWidth, sHeight))
        bottomView?.backgroundColor = UIColor.whiteColor()
        self.addSubview(bottomView!)
        
        let btWidth:CGFloat = 75
        
        let weixinImageView:UIImageView = UIImageView.init(frame: CGRectMake((sWidth-btWidth*2)/3, 10, btWidth, btWidth))
        weixinImageView.image = UIImage.init(named: "weixinShare-1")
        bottomView?.addSubview(weixinImageView)
        
        let labWeiXin:UILabel = UILabel.init(frame: CGRectMake((sWidth-btWidth*2)/3, 20+btWidth, btWidth, 20))
        labWeiXin.textAlignment = NSTextAlignment.Center
        labWeiXin.font = UIFont.systemFontOfSize(16)
        labWeiXin.textColor = UIColor.init(red: 0.55, green: 0.55, blue: 0.55, alpha: 1.0)
        labWeiXin.text = "微信好友"
        bottomView?.addSubview(labWeiXin)
        
        weiXinBt = UIButton.init(frame: CGRectMake((sWidth-btWidth*2)/3, 10, btWidth, btWidth+20))
        weiXinBt?.addTarget(self, action: #selector(CommonShareView.weixinBtPressed), forControlEvents: UIControlEvents.TouchUpInside)
        weiXinBt?.backgroundColor = UIColor.clearColor()
        bottomView!.addSubview(weiXinBt!)
        
        
        
        let friendImageView:UIImageView = UIImageView.init(frame: CGRectMake(sWidth-(sWidth-btWidth*2)/3 - btWidth, 10, btWidth, btWidth))
        friendImageView.image = UIImage.init(named: "weixinShare-2")
        bottomView?.addSubview(friendImageView)
        
        let labFriend:UILabel = UILabel.init(frame: CGRectMake(sWidth-(sWidth-btWidth*2)/3 - btWidth, 20+btWidth, btWidth, 20))
        labFriend.textAlignment = NSTextAlignment.Center
        labFriend.font = UIFont.systemFontOfSize(16)
        labFriend.textColor = UIColor.init(red: 0.55, green: 0.55, blue: 0.55, alpha: 1.0)
        labFriend.text = "朋友圈"
        bottomView?.addSubview(labFriend)
        
        
        friendBt = UIButton.init(frame: CGRectMake(sWidth-(sWidth-btWidth*2)/3 - btWidth, 10, btWidth, btWidth+20))
        friendBt?.backgroundColor = UIColor.clearColor()
        friendBt?.addTarget(self, action: #selector(CommonShareView.friendBtPressed), forControlEvents: UIControlEvents.TouchUpInside)
        bottomView!.addSubview(friendBt!)
        
        
        cancelBt = UIButton.init(frame: CGRectMake(10, 150, sWidth-20, 40))
        cancelBt?.layer.cornerRadius = 5
        cancelBt?.layer.masksToBounds = true
        cancelBt?.setTitle("取消", forState: UIControlState.Normal)
        cancelBt?.addTarget(self, action: #selector(CommonShareView.cancelBtPressed), forControlEvents: UIControlEvents.TouchUpInside)
        cancelBt?.backgroundColor = UIColor(rgba: "#BF2E2A")
        bottomView!.addSubview(cancelBt!)
    }
    
    func weixinBtPressed()
    {
        delegate?.shareViewWithType(.WeiXinType)
    }
    
    func friendBtPressed()
    {
        delegate?.shareViewWithType(.FriendType)
    }
    
    func cancelBtPressed()
    {
        let yuanFram = self.frame
        UIView.animateWithDuration(0.5, animations: {
            
            var fram = self.frame
            fram.origin.y = UIScreen.mainScreen().bounds.size.height
            self.frame = fram
            }) { (bool) in
              self.removeFromSuperview()
                self.frame = yuanFram
        }
        
    }
}