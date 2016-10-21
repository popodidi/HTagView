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
    
    var tagString : String = ""{
        didSet{
            self.setTitle(tagString, forState: .Normal)
            layoutSubviews()
        }
    }
    var tagFontSize : CGFloat = 17{
        didSet{
            titleLabel?.font = titleLabel?.font.fontWithSize(tagFontSize)
            layoutSubviews()
        }
    }
    let cancelButton = UIButton(type: .Custom)
    var cancelButtonHeight : CGFloat{
        get{
            return bounds.height/4
        }
    }
    
    var btwCancelButtonAndText = CGFloat(10)
    var withCancelButton : Bool = false{
        didSet{
            if withCancelButton{
                contentInsets = UIEdgeInsets(top: contentInsets.top, left: contentInsets.left, bottom: contentInsets.bottom, right: contentInsets.right)
                addSubview(cancelButton)
            }else{
                contentEdgeInsets = calculatedContentEdgeInsets(contentInsets.top, left: contentInsets.left, bottom: contentInsets.bottom, right: contentInsets.right)
                self.setImage(nil, forState: .Normal)
                cancelButton.removeFromSuperview()
            }
            layoutSubviews()
        }
    }
    var contentInsets : UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8){
        didSet{
            contentEdgeInsets = calculatedContentEdgeInsets(contentInsets.top, left: contentInsets.left, bottom: contentInsets.bottom, right: contentInsets.right)
            layoutSubviews()
        }
    }
    
    
    
    func tagClicked(){
        if withCancelButton{
            delegate?.tagCancelled(self)
        }else{
            delegate?.tagClicked(self)
        }
    }
    
    
    
    private func calculatedContentEdgeInsets(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> UIEdgeInsets{
        if withCancelButton{
           return UIEdgeInsets(top: top, left: left + cancelButtonHeight + btwCancelButtonAndText, bottom: bottom, right: right)
        }else{
            return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
        configureCancelButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureButton()
        configureCancelButton()
    }
    
    func configureButton(){
        clipsToBounds = true
        contentInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        addTarget(self, action: #selector(HTag.tagClicked), forControlEvents: .TouchUpInside)
    }
    
    // MARK: - layout
    override func layoutSubviews() {
        sizeToFit()
        configureCancelButton()
        super.layoutSubviews()
    }
    
    func configureCancelButton(){
        let image = UIImage(named: "close_small", inBundle: NSBundle(forClass: self.classForCoder), compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
        cancelButton.setBackgroundImage(image , forState: .Normal)
        cancelButton.tintColor = self.currentTitleColor
        
        cancelButton.contentVerticalAlignment = .Fill;
        cancelButton.contentHorizontalAlignment = .Fill;
        cancelButton.backgroundColor = UIColor.clearColor()
        
        cancelButton.frame = CGRect(x: contentInsets.left, y: (frame.height - cancelButtonHeight)/2, width: cancelButtonHeight, height: cancelButtonHeight)
        cancelButton.userInteractionEnabled = false
        sizeToFit()
    }
    
    
    // MARK: - set color
    func setBackColors(mainColor: UIColor, secondColor: UIColor){
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext()!, mainColor.CGColor)
        CGContextFillRect(UIGraphicsGetCurrentContext()!, CGRect(x: 0, y: 0, width: 1, height: 1))
        let mainColorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(mainColorImage, forState: .Normal)
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext()!, secondColor.CGColor)
        CGContextFillRect(UIGraphicsGetCurrentContext()!, CGRect(x: 0, y: 0, width: 1, height: 1))
        let secondColorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(secondColorImage, forState: .Selected)
    }
    
    func setTextColors(mainColor: UIColor, secondColor: UIColor){
        setTitleColor(mainColor, forState: .Normal)
        setTitleColor(secondColor, forState: .Selected)
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        if CGRectContainsPoint(bounds, point){
            if withCancelButton{
                if point.x < bounds.origin.x + contentEdgeInsets.left + cancelButtonHeight + btwCancelButtonAndText{
                    return true
                }
            }else{
                return true
            }
        }
        return false
    }
    
}
