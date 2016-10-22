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
//    optional func tagView(tagView: HTagView, didCancelTag tagTitle: String)
    optional func tagView(tagView: HTagView, didCancelTagAtIndex index: Int)
//    optional func tagView(tagView: HTagView, tagSelectionDidChange tagSelected: [String])
    optional func tagView(tagView: HTagView, tagSelectionDidChange selectedIndices: [Int])
}

/**
 HTagViewDataSource is a protocol to implement for data source of the HTagView.
 */
public protocol HTagViewDataSource {
    func numberOfTags(tagView: HTagView) -> Int
    func tagView(tagView: HTagView, titleOfTagAtIndex index: Int) -> String
    func tagView(tagView: HTagView, tagTypeAtIndex index: Int) -> HTagType
}

/**
 HTag comes with two types, `.Cancel` and `.Select`.
 */
public enum HTagType{
    case Cancel, Select
}


/**
 HTagView comes with two types, `.Cancel` and `.Select`.
 */
//public enum HTagViewType{
//    case Cancel, Select
//}


@IBDesignable
public class HTagView: UIView, HTagDelegate {
    
    // MARK: - DataSource
    /**
     HTagViewDataSource
     */
    public var dataSource : HTagViewDataSource?{
        didSet{
            reloadData()
        }
    }
    
    // MARK: - Delegate
    /**
     HTagViewDelegate
     */
    public var delegate : HTagViewDelegate?
    
    // MARK: - HTagView Configuration
    /**
     HTagView multiselect
     */
    @IBInspectable
    public var multiselect : Bool = true
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
     - `.Select` type: background color for the selected tags.
     */
    @IBInspectable
    public var tagMainBackColor : UIColor = UIColor(colorLiteralRed: 100/255, green: 200/255, blue: 205/255, alpha: 1)
    /**
     - `.Cancel` type: text color for all tags.
     - `.Select` type: text color for the selected tags.
     */
    @IBInspectable
    public var tagMainTextColor : UIColor = UIColor.whiteColor()
    /**
     - `.Select` type: background color for the unselected tags.
     */
    @IBInspectable
    public var tagSecondBackColor : UIColor = UIColor.lightGrayColor()
    /**
     - `.Select` type: text color for the unselected tags.
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
    /**
     Indices of selected tags.
     */
    public var selectedIndices: [Int]{
        get{
            var selectedIndexes = [Int]()
            for (index, tag) in tags.enumerate(){
                if !tag.withCancelButton && tag.selected{
                    selectedIndexes.append(index)
                }
            }
            return selectedIndexes
        }
    }
    
    var tags : [HTag] = []
    
    // MARK: - init
    override public init(frame: CGRect){
        super.init(frame: frame)
        configure()
        reloadData(false)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
        reloadData(false)
    }
    
    func configure(){
    }
    
    // MARK: - reload
    public func reloadData(preserveSelectionState: Bool = true){
        guard let dataSource = dataSource else {
            return
        }
        
        let selection = selectedIndices
        
        for tag in tags {
            tag.removeFromSuperview()
        }
        tags = []
        
        for index in  0 ..< dataSource.numberOfTags(self) {
            let tag = HTag()
            tag.delegate = self
            switch dataSource.tagView(self, tagTypeAtIndex: index) {
            case .Cancel:
                tag.withCancelButton = true
                tag.selected = true
            case .Select:
                tag.withCancelButton = false
                tag.selected = preserveSelectionState ? selection.contains(index) : false
            }
            tag.contentInsets = tagContentEdgeInsets
            tag.titleLabel?.font = tag.titleLabel?.font.fontWithSize(fontSize)
            tag.setBackColors(tagMainBackColor, secondColor: tagSecondBackColor)
            tag.setTextColors(tagMainTextColor, secondColor: tagSecondTextColor)
            tag.layer.cornerRadius = tag.frame.height * tagCornerRadiusToHeightRatio
            tag.layer.borderColor = tagBorderColor
            tag.layer.borderWidth = tagBorderWidth
            tag.tagString = dataSource.tagView(self, titleOfTagAtIndex: index)
            addSubview(tag)
            tags.append(tag)
        }
        
        layoutSubviews()
        invalidateIntrinsicContentSize()
    }
    
    // MARK: - Subclassing UIView
    override public func layoutSubviews() {
        guard let dataSource = dataSource else {
            return
        }
        
        if dataSource.numberOfTags(self) == 0{
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
    
    // MARK: - Manipulate Tags
    /**
     Select on tag with titles in `.Select` type HTagView. The delegate method `tagView(_:tagSelectionDidChange:)` will be called.
     */
    public func selectTagAtIndex(index: Int){
        for (i, tag) in tags.enumerate() {
            guard let type = dataSource?.tagView(self, tagTypeAtIndex: i) where type == .Select else {
                continue
            }
            
            if i != index && !multiselect{
                tag.selected = false
            }else if i == index{
                tag.selected = true
            }
        }
    }
    /**
     Deselect on tag with titles in `.Select` type HTagView. The delegate method `tagView(_:tagSelectionDidChange:)` will be called.
     */
    public func deselectTagAtIndex(index: Int){
        guard let type = dataSource?.tagView(self, tagTypeAtIndex: index) where type == .Select else {
            return
        }
        
        tags[index].selected = false
    }
    
    // MARK: - Tag Delegate
    func tagCancelled(sender: HTag) {
        guard let index = tags.indexOf(sender) else{
            return
        }
        
        delegate?.tagView?(self, didCancelTagAtIndex: index)
    }
    func tagClicked(sender: HTag){
        guard let index = tags.indexOf(sender) else{
            return
        }
        if dataSource?.tagView(self, tagTypeAtIndex: index) == .Select{
            if sender.selected {
                deselectTagAtIndex(index)
            }else{
                selectTagAtIndex(index)
            }
        }
        
        delegate?.tagView?(self, tagSelectionDidChange: selectedIndices)
    }
    
    
}

