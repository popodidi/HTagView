//
//  HTagView.swift
//  Pods
//
//  Created by Chang, Hao on 5/16/16.
//
//

import UIKit

public protocol HTagViewDelegate {
    func tagViewTagCancelled(tagTitle: String)
}

@IBDesignable
public class HTagView: UIView, HTagDelegate {
    public var delegate : HTagViewDelegate?
    
    @IBInspectable
    public var type : HTagViewType = .MultiSelect{
        didSet{
            switch type{
            case .Cancel:
                for tag in tags{
                    tag.withCancelButton = true
                    tag.selected = true
                }
            case .MultiSelect:
                for tag in tags{
                    tag.withCancelButton = false
                }
            }
        }
    }
    
//    @IBInspectable
//    public var line : Int = 0
    @IBInspectable
    public var marg : CGFloat = 20
    @IBInspectable
    public var btwTags : CGFloat = 8
    @IBInspectable
    public var btwLines : CGFloat = 8
    @IBInspectable
    public var tagMainBackColor : UIColor = UIColor(colorLiteralRed: 100/255, green: 200/255, blue: 205/255, alpha: 1)
    @IBInspectable
    public var tagMainTextColor : UIColor = UIColor.whiteColor()
    @IBInspectable
    public var tagSecondBackColor : UIColor = UIColor.lightGrayColor()
    @IBInspectable
    public var tagSecondTextColor : UIColor = UIColor.darkTextColor()
    @IBInspectable
    public var tagCornerRadiusToHeightRatio :CGFloat = CGFloat(0.2){
        didSet{
            for tag in tags{
                tag.layer.cornerRadius = tag.frame.height * tagCornerRadiusToHeightRatio
            }
            layoutIfNeeded()
        }
    }
    @IBInspectable
    public var tagContentEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8){
        didSet{
            for tag in tags{
                tag.contentInsets = tagContentEdgeInsets
            }
        }
    }
    
    
    public var numberOfTags : Int{
        get{
            return tags.count
        }
    }
    public var selectedTagsTitle: [String]{
        var selectedTitles = [String]()
        for tag in tags{
            if !tag.selected{
                selectedTitles.append(tag.tagString)
            }
        }
        return selectedTitles
    }
    
    var tags : [HTag] = []{
        didSet{
            for tag in oldValue{
                tag.removeFromSuperview()
            }
            for tag in tags{
                addSubview(tag)
            }
            layoutSubviews()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: - Set Tags

    public func setTagsWithTitle(titles: [String]){
        var theTags = [HTag]()
        for title in titles{
            let tag = HTag()
            tag.delegate = self
            switch type {
            case .Cancel:
                tag.withCancelButton = true
                tag.selected = false
            case .MultiSelect:
                tag.withCancelButton = false
                tag.selected = true
            }
            tag.contentInsets = tagContentEdgeInsets
            tag.setBackColors(tagMainBackColor, secondColor: tagSecondBackColor)
            tag.setTextColors(tagMainTextColor, secondColor: tagSecondTextColor)
            tag.layer.cornerRadius = tag.frame.height * tagCornerRadiusToHeightRatio
            tag.tagString = title
            theTags.append(tag)
        }
        tags = theTags
    }
    
    override public func layoutSubviews() {
        if tags.count == 0{
            self.frame.size = CGSize(width: self.frame.width, height: 0)
        }else{
        var x = marg
        var y = marg
        for index in 0..<tags.count{
            if tags[index].frame.width + x > frame.width - marg{
                y += tags[index].frame.height + btwLines
                x = marg
            }
            tags[index].frame.origin = CGPoint(x: x, y: y)
            x += tags[index].frame.width + btwTags
        }
        self.frame.size = CGSize(width: self.frame.width, height: y + (tags.last?.frame.height ?? 0) + marg )
        }
    }

    
    // MARK: - Tag Delegate
    func tagCancelled(sender: HTag) {
        if let index = tags.indexOf(sender){
            tags.removeAtIndex(index)
            sender.removeFromSuperview()
        }
       
        layoutSubviews()
        delegate?.tagViewTagCancelled(sender.tagString)
    }
    func tagClicked(sender: HTag){
        if type == .MultiSelect{
            sender.selected = !sender.selected
        }
    }

}

public enum HTagViewType{
    case Cancel, MultiSelect
}
