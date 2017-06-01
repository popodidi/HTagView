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
public protocol HTagViewDelegate: class {
    /**
     Called when user did cancel tag at index
     */
    @objc optional func tagView(_ tagView: HTagView, didCancelTagAtIndex index: Int)
    @objc optional func tagView(_ tagView: HTagView, tagSelectionDidChange selectedIndices: [Int])
}

/**
 HTagViewDataSource is a protocol to implement for data source of the HTagView.
 */
public protocol HTagViewDataSource: class {
    func numberOfTags(_ tagView: HTagView) -> Int
    func tagView(_ tagView: HTagView, titleOfTagAtIndex index: Int) -> String
    func tagView(_ tagView: HTagView, tagTypeAtIndex index: Int) -> HTagType
    func tagView(_ tagView: HTagView, tagWidthAtIndex index: Int) -> CGFloat
}

public let HTagAutoWidth: CGFloat = 1.3465473892318276435675432

/**
 HTag comes with two types, `.cancel` and `.select`.
 */
public enum HTagType{
    case cancel, select
}

/**
 HTagView is customized tag view sublassing UIView where tag could be either with cancel button or seletable.
 */
@IBDesignable
open class HTagView: UIView{//, HTagDelegate {
    
    // MARK: - DataSource
    /**
     HTagViewDataSource
     */
    open weak var dataSource : HTagViewDataSource?{
        didSet{
            reloadData()
        }
    }
    
    // MARK: - Delegate
    /**
     HTagViewDelegate
     */
    open weak var delegate : HTagViewDelegate?
    
    // MARK: - HTagView Configuration
    /**
     HTagView multiselect
     */
    @IBInspectable
    open var multiselect : Bool = true
    /**
     HTagView margin
     */
    @IBInspectable
    open var marg : CGFloat = 20
    /**
     Distance between tags in the same line
     */
    @IBInspectable
    open var btwTags : CGFloat = 8
    /**
     Distance between lines
     */
    @IBInspectable
    open var btwLines : CGFloat = 8
    
    // MARK: - HTag Configuration
    /**
     Main background color of tags
     */
    @IBInspectable
    open var tagMainBackColor : UIColor = UIColor(colorLiteralRed: 100/255, green: 200/255, blue: 205/255, alpha: 1) {
        didSet {
            newTags.forEach {
                $0.tagMainBackColor = tagMainBackColor
            }
        }
    }
    /**
     Main text color of tags
     */
    @IBInspectable
    open var tagMainTextColor : UIColor = UIColor.white {
        didSet {
            newTags.forEach {
                $0.tagMainTextColor = tagMainTextColor
            }
        }
    }
    /**
     Secondary background color of tags
     */
    @IBInspectable
    open var tagSecondBackColor : UIColor = UIColor.lightGray {
        didSet {
            newTags.forEach {
                $0.tagSecondBackColor = tagSecondBackColor
            }
        }
    }
    /**
     Secondary text color of tags
     */
    @IBInspectable
    open var tagSecondTextColor : UIColor = UIColor.darkText {
        didSet {
            newTags.forEach {
                $0.tagSecondTextColor = tagSecondTextColor
            }
        }
    }
    /**
     The border width to height ratio of HTags.
     */
    @IBInspectable
    open var tagBorderWidth :CGFloat = CGFloat(0){
        didSet{
            newTags.forEach {
                $0.tagBorderWidth = tagBorderWidth
            }
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
    open var tagBorderColor :CGColor? = nil{
        didSet{
            newTags.forEach {
                $0.tagBorderColor = tagBorderColor
            }
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
    open var tagCornerRadiusToHeightRatio :CGFloat = CGFloat(0.2){
        didSet{
            newTags.forEach {
                $0.tagCornerRadiusToHeightRatio = tagCornerRadiusToHeightRatio
            }
            for tag in tags{
                tag.layer.cornerRadius = tag.frame.height * tagCornerRadiusToHeightRatio
            }
            layoutIfNeeded()
        }
    }
    /**
     The content EdgeInsets of HTags, which would automatically adjust the position in `.cancel` type.
     On the other word, usages are the same in both types.
     */
    @IBInspectable
    open var tagContentEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8){
        didSet{
            for tag in tags{
                tag.contentInsets = tagContentEdgeInsets
            }
        }
    }
    /**
     The Font of HTags.
     */
    @IBInspectable
    open var tagFont : UIFont = UIFont.systemFont(ofSize: 17) {
        didSet{
            for tag in newTags {
                tag.tagFont = tagFont
            }
            layoutIfNeeded()
            invalidateIntrinsicContentSize()
        }
    }
    /*
    /**
     The Font size of HTags.
     */
    @IBInspectable
    open var fontSize : CGFloat = 14{
        didSet{
            for tag in tags{
                tag.tagFontSize = fontSize
            }
            layoutIfNeeded()
            invalidateIntrinsicContentSize()
        }
    }*/
    /**
     Indices of selected tags.
     */
    open var selectedIndices: [Int]{
        get{
            var selectedIndexes = [Int]()
//            for (index, tag) in tags.enumerated(){
//                if !tag.withCancelButton && tag.isSelected{
//                    selectedIndexes.append(index)
//                }
//            }
            
            for (index, tag) in newTags.enumerated(){
                if tag.tagType == .select && tag.isSelected{
                    selectedIndexes.append(index)
                }
            }
            return selectedIndexes
        }
    }
    
    var tags : [HTag] = []
    var newTags: [Tag] = []
    
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
    open func reloadData(_ preserveSelectionState: Bool = true){
        guard let dataSource = dataSource else {
            return
        }
        
        let selection = selectedIndices
        
        
        for tag in newTags {
            tag.removeFromSuperview()
        }
        newTags = []
        for index in  0 ..< dataSource.numberOfTags(self) {
            let tag = Tag()
            tag.delegate = self
            tag.tagType = dataSource.tagView(self, tagTypeAtIndex: index)
            if tag.tagType == .select {
                tag.setSelected(preserveSelectionState ? selection.contains(index) : false)
            }
            tag.tagContentEdgeInsets = tagContentEdgeInsets
            tag.tagFont = tagFont
            tag.tagMainBackColor = tagMainBackColor
            tag.tagSecondBackColor = tagSecondBackColor
            tag.tagMainTextColor = tagMainTextColor
            tag.tagSecondTextColor = tagSecondTextColor
            tag.tagBorderColor = tagBorderColor
            tag.tagBorderWidth = tagBorderWidth
            tag.tagCornerRadiusToHeightRatio = tagCornerRadiusToHeightRatio
            tag.tagTitle = dataSource.tagView(self, titleOfTagAtIndex: index)
            addSubview(tag)
            newTags.append(tag)
        }
        
        layoutSubviews()
        invalidateIntrinsicContentSize()
    }
    
    // MARK: - Subclassing UIView
    override open func layoutSubviews() {
        guard let dataSource = dataSource else {
            return
        }
        
        if dataSource.numberOfTags(self) == 0 {
            self.frame.size = CGSize(width: self.frame.width, height: 0)
        }else{
            var x = marg
            var y = marg
            for index in 0..<newTags.count{
                if dataSource.tagView(self, tagWidthAtIndex: index) != HTagAutoWidth {
                    newTags[index].frame.size.width = dataSource.tagView(self, tagWidthAtIndex: index)
                }
                if newTags[index].frame.width + x > frame.width - marg{
                    y += newTags[index].frame.height + btwLines
                    x = marg
                }
                
                newTags[index].frame.origin = CGPoint(x: x, y: y)
                x += newTags[index].frame.width + btwTags
            }
            self.frame.size = CGSize(width: self.frame.width, height: y + (newTags.last?.frame.height ?? 0) + marg )
        }
    }
    
    override open var intrinsicContentSize : CGSize {
        if newTags.count == 0{
            return CGSize(width: UIViewNoIntrinsicMetric, height: 0)
        }else{
            let height = (newTags.last?.frame.origin.y ?? 0) + (newTags.last?.frame.height ?? 0) + marg
            return CGSize(width: UIViewNoIntrinsicMetric, height: height )
        }
        
        /*
        if tags.count == 0{
            return CGSize(width: UIViewNoIntrinsicMetric, height: 0)
        }else{
            let height = (tags.last?.frame.origin.y ?? 0) + (tags.last?.frame.height ?? 0) + marg
            return CGSize(width: UIViewNoIntrinsicMetric, height: height )
        }*/
    }
    
    // MARK: - Manipulate Tags
    /**
     Select on tag with titles in `.select` type HTagView. The delegate method `tagView(_:tagSelectionDidChange:)` will be called.
     */
    open func selectTagAtIndex(_ index: Int){
        for (i, tag) in newTags.enumerated() {
            guard let type = dataSource?.tagView(self, tagTypeAtIndex: i) , type == .select else {
                continue
            }
            
            if i != index && !multiselect{
                tag.setSelected(false)
            }else if i == index{
                tag.setSelected(true)
            }
        }
        
        /*
        for (i, tag) in tags.enumerated() {
            guard let type = dataSource?.tagView(self, tagTypeAtIndex: i) , type == .select else {
                continue
            }
            
            if i != index && !multiselect{
                tag.isSelected = false
            }else if i == index{
                tag.isSelected = true
            }
        }*/
    }
    /**
     Deselect on tag with titles in `.select` type HTagView. The delegate method `tagView(_:tagSelectionDidChange:)` will be called.
     */
    open func deselectTagAtIndex(_ index: Int){
        guard let type = dataSource?.tagView(self, tagTypeAtIndex: index) , type == .select else {
            return
        }
        
        newTags[index].setSelected(false)
//        tags[index].isSelected = false
    }
    
    /*
    // MARK: - Tag Delegate
    func tagCancelled(_ sender: HTag) {
        guard let index = tags.index(of: sender) else{
            return
        }
        
        delegate?.tagView?(self, didCancelTagAtIndex: index)
    }
    func tagClicked(_ sender: HTag){
        guard let index = tags.index(of: sender) else{
            return
        }
        if dataSource?.tagView(self, tagTypeAtIndex: index) == .select{
            if sender.isSelected {
                deselectTagAtIndex(index)
            }else{
                selectTagAtIndex(index)
            }
        }
        
        delegate?.tagView?(self, tagSelectionDidChange: selectedIndices)
    }*/
    
    
}

extension HTagView: TagDelegate {
    func tagClicked(_ sender: Tag) {
        guard let index = newTags.index(of: sender) else{
            return
        }
        if dataSource?.tagView(self, tagTypeAtIndex: index) == .select{
            if sender.isSelected {
                deselectTagAtIndex(index)
            }else{
                selectTagAtIndex(index)
            }
        }
        
        delegate?.tagView?(self, tagSelectionDidChange: selectedIndices)
        
    }
    func tagCancelled(_ sender: Tag) {
        guard let index = newTags.index(of: sender) else{
            return
        }
        
        delegate?.tagView?(self, didCancelTagAtIndex: index)
        
    }
}
