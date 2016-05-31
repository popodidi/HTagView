//
//  HTagView.swift
//  Pods
//
//  Created by Chang, Hao on 5/16/16.
//
//

import UIKit

@objc
public protocol HTagViewDelegate {
    optional func tagView(tagView: HTagView, didCancelTag tagTitle: String)
    optional func tagView(tagView: HTagView, tagSelectionDidChange tagSelected: [String])
}


public enum HTagViewType{
    case Cancel, MultiSelect
}

@IBDesignable
public class HTagView: UIView, HTagDelegate {
    @IBOutlet
    public var delegate : AnyObject?
    
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
    @IBInspectable
    public var autosetHeight : Bool = true{
        didSet{
            layoutSubviews()
        }
    }
    
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
    @IBInspectable
    public var fontSize : CGFloat = 14{
        didSet{
            for tag in tags{
                tag.tagFontSize = fontSize
            }
            layoutIfNeeded()
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
            tag.titleLabel?.font = tag.titleLabel?.font.fontWithSize(fontSize)
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
            if autosetHeight { self.frame.size = CGSize(width: self.frame.width, height: 0) }
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
            if autosetHeight { self.frame.size = CGSize(width: self.frame.width, height: y + (tags.last?.frame.height ?? 0) + marg ) }
        }
    }
    
    // MARK: - Manipulate Tag
    public func selectTagWithTitles(titles: [String]){
        for tag in tags{
            for title in titles{
                if tag.tagString == title{
                    tag.selected = false
                }
            }
        }
    }
    
    
    // MARK: - Tag Delegate
    func tagCancelled(sender: HTag) {
        if let index = tags.indexOf(sender){
            tags.removeAtIndex(index)
            sender.removeFromSuperview()
        }
        
        layoutSubviews()
        (delegate as? HTagViewDelegate)?.tagView?(self, didCancelTag: sender.tagString)
    }
    func tagClicked(sender: HTag){
        if type == .MultiSelect{
            sender.selected = !sender.selected
        }
        (delegate as? HTagViewDelegate)?.tagView?(self, tagSelectionDidChange: selectedTagsTitle)
    }
    
}

