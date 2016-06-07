//
//  HTagView.swift
//  Pods
//
//  Created by Chang, Hao on 5/16/16.
//
//

import UIKit

/**
 HTagViewDelegate is a protocol to implement for responding to user interactions to the HTagView.
 */
@objc
public protocol HTagViewDelegate {
    optional func tagView(tagView: HTagView, didCancelTag tagTitle: String)
    optional func tagView(tagView: HTagView, tagSelectionDidChange tagSelected: [String])
}

/**
 HTagView comes with two types, `.Cancel` and `.MultiSelect`.
 */
public enum HTagViewType{
    case Cancel, MultiSelect
}


@IBDesignable
public class HTagView: UIView, HTagDelegate {
    
    // MARK: - Delegate
    /**
     HTagViewDelegate
     */
    @IBOutlet
    public var delegate : AnyObject?
    
    // MARK: - HTagView Configuration
    /**
     Type of the HTagView
     */
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
    
    /**
     HTagView margin
     */
    @IBInspectable
    public var marg : CGFloat = 20
    /**
     Distance between tags in the same line
     */
    @IBInspectable
    public var btwTags : CGFloat = 8
    /**
     Distance between lines
     */
    @IBInspectable
    public var btwLines : CGFloat = 8
    
    // MARK: - HTag Configuration
    /**
     - `.Cancel` type: background color for all tags.
     - `.MultiSelect` type: background color for the selected tags.
     */
    @IBInspectable
    public var tagMainBackColor : UIColor = UIColor(colorLiteralRed: 100/255, green: 200/255, blue: 205/255, alpha: 1)
    /**
     - `.Cancel` type: text color for all tags.
     - `.MultiSelect` type: text color for the selected tags.
     */
    @IBInspectable
    public var tagMainTextColor : UIColor = UIColor.whiteColor()
    /**
     - `.MultiSelect` type: background color for the unselected tags.
     */
    @IBInspectable
    public var tagSecondBackColor : UIColor = UIColor.lightGrayColor()
    /**
     - `.MultiSelect` type: text color for the unselected tags.
     */
    @IBInspectable
    public var tagSecondTextColor : UIColor = UIColor.darkTextColor()
    /**
     The border width to height ratio of HTags.
     */
    @IBInspectable
    public var tagBorderWidth :CGFloat = CGFloat(0){
        didSet{
            for tag in tags{
                tag.layer.borderWidth = tagBorderWidth
            }
            layoutIfNeeded()
        }
    }
    /**
     The border color to height ratio of HTags.
     */
    @IBInspectable
    public var tagBorderColor :CGColor? = nil{
        didSet{
            for tag in tags{
                tag.layer.borderColor = tagBorderColor
            }
            layoutIfNeeded()
        }
    }
    
    /**
     The corner radius to height ratio of HTags.
     */
    @IBInspectable
    public var tagCornerRadiusToHeightRatio :CGFloat = CGFloat(0.2){
        didSet{
            for tag in tags{
                tag.layer.cornerRadius = tag.frame.height * tagCornerRadiusToHeightRatio
            }
            layoutIfNeeded()
        }
    }
    /**
     The content EdgeInsets of HTags, which would automatically adjust the position in `.Cancel` type.
     On the other word, usages are the same in both types.
     */
    @IBInspectable
    public var tagContentEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8){
        didSet{
            for tag in tags{
                tag.contentInsets = tagContentEdgeInsets
            }
        }
    }
    /**
     The Font size of HTags.
     */
    @IBInspectable
    public var fontSize : CGFloat = 14{
        didSet{
            for tag in tags{
                tag.tagFontSize = fontSize
            }
            layoutIfNeeded()
            invalidateIntrinsicContentSize()
        }
    }
    
    // MARK: - APIs
    /**
     Total number of HTags in HTagView
     */
    public var numberOfTags : Int{
        get{
            return tags.count
        }
    }
    
    /**
     All the titles of HTags
     */
    public var tagTitles : [String]{
        get{
            var titles = [String]()
            for tag in tags{
                titles.append(tag.tagString)
            }
            return titles
        }
    }
    
    /**
     All the titles of selected HTags
     */
    public var selectedTagTitles: [String]{
        get{
            var selectedTitles = [String]()
            for tag in tags{
                if !tag.selected{
                    selectedTitles.append(tag.tagString)
                }
            }
            return selectedTitles
        }
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
    
    // MARK: - Manipulate Tags
    /**
     Remove all the exisiting HTags and set with titles
     */
    public func setTagsWithTitles(titles: [String]){
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
            tag.layer.borderColor = tagBorderColor
            tag.layer.borderWidth = tagBorderWidth
            tag.tagString = title
            theTags.append(tag)
        }
        tags = theTags
        invalidateIntrinsicContentSize()
    }
    
    /**
     Add tags with title
     */
    public func addTagWithTitle(title: String){
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
        tag.layer.borderColor = tagBorderColor
        tag.layer.borderWidth = tagBorderWidth
        tag.tagString = title
        
        tags.append(tag)
        
        invalidateIntrinsicContentSize()
    }
    
    /**
     Remove tag with title. The delegate method `tagView(_:didCancelTag:)` will be called.
     */
    public func removeTagWithTitle(title: String){
        
        var tagString : String?
        for tagIndex in 0..<tags.count{
            if tags[tagIndex].tagString == title{
                tags[tagIndex].removeFromSuperview()
                tagString = tags[tagIndex].tagString
                tags.removeAtIndex(tagIndex)
                break
            }
        }
        layoutSubviews()
        invalidateIntrinsicContentSize()
        
        if let cancelledTagString = tagString where type == .Cancel{
            (delegate as? HTagViewDelegate)?.tagView?(self, didCancelTag: cancelledTagString)
        }
    }
    
    /**
     Select on tag with titles in `.MultiSelect` type HTagView. The delegate method `tagView(_:tagSelectionDidChange:)` will be called.
     */
    public func selectTagWithTitles(titles: [String]){
        if type == .MultiSelect{
            for tagIndex in 0..<tags.count{
                for title in titles{
                    if tags[tagIndex].tagString == title{
                        tags[tagIndex].selected = false
                        break
                    }
                }
            }
        }
        (delegate as? HTagViewDelegate)?.tagView?(self, tagSelectionDidChange: selectedTagTitles)
    }
    /**
     Deselect on tag with titles in `.MultiSelect` type HTagView. The delegate method `tagView(_:tagSelectionDidChange:)` will be called.
     */
    public func deselectTagWithTitles(titles: [String]){
        if type == .MultiSelect{
            for tagIndex in 0..<tags.count{
                for title in titles{
                    if tags[tagIndex].tagString == title{
                        tags[tagIndex].selected = true
                        break
                    }
                }
            }
        }
        (delegate as? HTagViewDelegate)?.tagView?(self, tagSelectionDidChange: selectedTagTitles)
    }
    
    // MARK: - Subclassing UIView
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
    override public func intrinsicContentSize() -> CGSize {
        if tags.count == 0{
            return CGSize(width: UIViewNoIntrinsicMetric, height: 0)
        }else{
            let height = (tags.last?.frame.origin.y ?? 0) + (tags.last?.frame.height ?? 0) + marg
            return CGSize(width: UIViewNoIntrinsicMetric, height: height )
        }
    }
    
    // MARK: - Tag Delegate
    func tagCancelled(sender: HTag) {
        if let index = tags.indexOf(sender){
            tags.removeAtIndex(index)
            sender.removeFromSuperview()
        }
        
        layoutSubviews()
        invalidateIntrinsicContentSize()
        
        (delegate as? HTagViewDelegate)?.tagView?(self, didCancelTag: sender.tagString)
    }
    func tagClicked(sender: HTag){
        if type == .MultiSelect{
            sender.selected = !sender.selected
        }
        (delegate as? HTagViewDelegate)?.tagView?(self, tagSelectionDidChange: selectedTagTitles)
    }
    
    
}

