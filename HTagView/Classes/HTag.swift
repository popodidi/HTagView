//
//  HTag.swift
//  Pods
//
//  Created by Chang, Hao on 5/16/16.
//
//

import UIKit

protocol HTagDelegate: class {
    func tagClicked(_ sender: HTag)
    func tagCancelled(_ sender: HTag)
}

class HTag: UIButton {
    
    var delegate: HTagDelegate?
    
    var tagString : String = ""{
        didSet{
            self.setTitle(tagString, for: UIControlState())
            layoutSubviews()
        }
    }
    var tagFontSize : CGFloat = 17{
        didSet{
            titleLabel?.font = titleLabel?.font.withSize(tagFontSize)
            layoutSubviews()
        }
    }
    let cancelButton = UIButton(type: .custom)
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
                self.setImage(nil, for: UIControlState())
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
    
    
    
    fileprivate func calculatedContentEdgeInsets(_ top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> UIEdgeInsets{
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
        addTarget(self, action: #selector(HTag.tagClicked), for: .touchUpInside)
    }
    
    // MARK: - layout
    override func layoutSubviews() {
        sizeToFit()
        configureCancelButton()
        super.layoutSubviews()
    }
    
    func configureCancelButton(){
        let image = UIImage(named: "close_small", in: Bundle(for: self.classForCoder), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        cancelButton.setBackgroundImage(image , for: UIControlState())
        cancelButton.tintColor = self.currentTitleColor
        
        cancelButton.contentVerticalAlignment = .fill;
        cancelButton.contentHorizontalAlignment = .fill;
        cancelButton.backgroundColor = UIColor.clear
        
        cancelButton.frame = CGRect(x: contentInsets.left, y: (frame.height - cancelButtonHeight)/2, width: cancelButtonHeight, height: cancelButtonHeight)
        cancelButton.isUserInteractionEnabled = false
        sizeToFit()
    }
    
    
    // MARK: - set color
    func setBackColors(_ mainColor: UIColor, secondColor: UIColor){
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(secondColor.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let secondColorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(secondColorImage, for: UIControlState())
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(mainColor.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let mainColorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(mainColorImage, for: .selected)
    }
    
    func setTextColors(_ mainColor: UIColor, secondColor: UIColor){
        setTitleColor(secondColor, for: UIControlState())
        setTitleColor(mainColor, for: .selected)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if bounds.contains(point){
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
