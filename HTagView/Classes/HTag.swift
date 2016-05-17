//
//  HTag.swift
//  Pods
//
//  Created by Chang, Hao on 5/16/16.
//
//

import UIKit

protocol HTagDelegate: class {
    func tagClicked(sender: HTag)
    func tagCancelled(sender: HTag)
}

class HTag: UIButton {
    
    var delegate: HTagDelegate?
    
    var tagString = ""{
        didSet{
            self.setTitle(tagString, forState: .Normal)
            sizeToFit()
        }
    }
    var cancelButtonHeight : CGFloat{
        get{
            return frame.height/4
        }
    }
    var withCancelButton = false{
        didSet{
            if withCancelButton{
                contentEdgeInsets = UIEdgeInsets(top: marg, left: marg + cancelButtonHeight + 1.5 * marg, bottom: marg, right: marg)
                sizeToFit()
                
                let cancelButton = UIButton(type: .Custom)
                cancelButton.setBackgroundImage(UIImage(named: "close_small", inBundle: NSBundle(forClass: self.classForCoder), compatibleWithTraitCollection: nil), forState: .Normal)
                cancelButton.frame = CGRect(x: marg, y: (frame.height - cancelButtonHeight)/2, width: cancelButtonHeight, height: cancelButtonHeight)
                cancelButton.addTarget(self, action: #selector(HTag.tagCancelled), forControlEvents: .TouchUpInside)
                addSubview(cancelButton)
            }else{
                self.setImage(nil, forState: .Normal)
            }
            sizeToFit()
        }
    }
    
    
    func tagCancelled(){
        delegate?.tagCancelled(self)
    }
    func tagClicked(){
        delegate?.tagClicked(self)
    }
    
    
    var marg = CGFloat(8){
        didSet{
            if withCancelButton{
                contentEdgeInsets = UIEdgeInsets(top: marg, left: marg + cancelButtonHeight, bottom: marg, right: marg)
            }else{
                contentEdgeInsets = UIEdgeInsets(top: marg, left: marg, bottom: marg, right: marg)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureButton()
    }
    
    func configureButton(){
//        backgroundColor = UIColor.darkGrayColor()
//        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        clipsToBounds = true
        contentEdgeInsets = UIEdgeInsets(top: marg, left: marg, bottom: marg, right: marg)
        addTarget(self, action: #selector(HTag.tagClicked), forControlEvents: .TouchUpInside)
    }
    
    func setBackColors(mainColor: UIColor, secondColor: UIColor){
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), mainColor.CGColor)
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRect(x: 0, y: 0, width: 1, height: 1))
        let mainColorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(mainColorImage, forState: .Normal)
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), secondColor.CGColor)
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRect(x: 0, y: 0, width: 1, height: 1))
        let secondColorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(secondColorImage, forState: .Selected)
    }
    
    func setTextColors(mainColor: UIColor, secondColor: UIColor){
        setTitleColor(mainColor, forState: .Normal)
        setTitleColor(secondColor, forState: .Selected)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
