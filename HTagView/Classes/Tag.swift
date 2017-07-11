//
//  Tag.swift
//  Pods
//
//  Created by Chang, Hao on 12/12/2016.
//
//

import UIKit

protocol TagDelegate: class {
    func tagClicked(_ sender: Tag)
    func tagCancelled(_ sender: Tag)
}

protocol TagDataSource: class{
    
    
}

public class Tag: UIView {
    weak var delegate: TagDelegate?
    
    // MARK: - HTag Configuration
    /**
     Type of tag
     */
    var tagType: HTagType = .cancel { didSet { updateAll() } }
    /**
     Title of tag
     */
    var tagTitle: String = "tag" { didSet { updateAll() } }
    /**
     Main background color of tags
     */
    var tagMainBackColor : UIColor = UIColor.white { didSet { updateTitlesColorsAndFontsDueToSelection() } }
    /**
     Main text color of tags
     */
    var tagMainTextColor : UIColor = UIColor.black { didSet { updateTitlesColorsAndFontsDueToSelection() } }
    /**
     Secondary background color of tags
     */
    var tagSecondBackColor : UIColor = UIColor.gray { didSet { updateTitlesColorsAndFontsDueToSelection() } }
    /**
     Secondary text color of tags
     */
    var tagSecondTextColor : UIColor = UIColor.white { didSet { updateTitlesColorsAndFontsDueToSelection() } }
    /**
     The border width to height ratio of HTags.
     */
    var tagBorderWidth :CGFloat = 1 { didSet { updateBorder() } }
    /**
     The border color to height ratio of HTags.
     */
    var tagBorderColor :CGColor? = UIColor.darkGray.cgColor { didSet { updateBorder() } }
    
    /**
     The corner radius to height ratio of HTags.
     */
    var tagCornerRadiusToHeightRatio :CGFloat = 0.2 { didSet { updateBorder() } }
    /**
     The content EdgeInsets of HTags, which would automatically adjust the position in `.cancel` type.
     On the other word, usages are the same in both types.
     */
    var tagContentEdgeInsets: UIEdgeInsets = UIEdgeInsets() { didSet { updateAll()} }
    /**
     The Font of HTags.
     */
    var tagFont: UIFont = UIFont.systemFont(ofSize: 17) { didSet { updateAll() } }
    
    // MARK: - status
    private(set) var isSelected: Bool = false
    
    
    // MARK: - Subviews
    var button: UIButton = UIButton(type: .system)
    var cancelButton: UIButton = UIButton(type: .system)
    
    // MARK: - Init
    override init(frame: CGRect){
        super.init(frame: frame)
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    deinit {
        button.removeObserver(self, forKeyPath: "highlighted")
    }
    
    // MARK: - Configure
    func configure(){
        setupButton()
        setupCancelButton()
        updateAll()
    }
    
    // MARK: - button
    func setupButton() {
        addSubview(button)
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        button.addObserver(self, forKeyPath: "highlighted", options: .new, context: nil)
    }
    
    func setHighlight(_ highlighted: Bool) {
        let color = isSelected ? tagMainBackColor : tagSecondBackColor
        backgroundColor = highlighted ? color.darker() : color
    }
    func setSelected(_ selected: Bool) {
        isSelected = selected
        updateTitlesColorsAndFontsDueToSelection()
    }
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let keyPath = keyPath else {
            return
        }
        switch keyPath {
        case "highlighted":
            guard let highlighted = change?[.newKey] as? Bool else  {
                break
            }
            setHighlight(highlighted)
        default:
            break
        }
    }
    
    // MARK: - cancel button
    func setupCancelButton() {
        cancelButton.setImage(UIImage(named: "close_small", in: Bundle(for: self.classForCoder), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(cancelled), for: .touchUpInside)
        addSubview(cancelButton)
        cancelButton.isHidden = tagType == .select
    }
    // MARK: - Layout
    public override func layoutSubviews() {
        button.sizeToFit()
        if tagType == .select {
            button.frame.origin = CGPoint(x: 20, y: 20)
        } else {
            button.frame.origin = CGPoint(x: 44 , y: 20)
            cancelButton.frame.size = CGSize(width: 20, height: 20)
            cancelButton.frame.origin = CGPoint(x: 20 , y: 20 + button.frame.height/2 - 10)
        }
        frame.size = CGSize(width: button.frame.maxX + 20, height: button.frame.maxY + 20)
    }
    
    func updateAll() {
        cancelButton.isHidden = tagType == .select
        updateTitlesColorsAndFontsDueToSelection()
        updateBorder()
        button.sizeToFit()
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
    
    func updateTitlesColorsAndFontsDueToSelection() {
        backgroundColor = isSelected ? tagMainBackColor : tagSecondBackColor
        let textColor = isSelected ? tagMainTextColor : tagSecondTextColor
        var attributes: [String: Any] = [:]
        attributes[NSFontAttributeName] = tagFont
        attributes[NSForegroundColorAttributeName] = textColor
        button.setAttributedTitle(NSAttributedString(string: tagTitle, attributes: attributes), for: .normal)
    }
    
    func updateBorder() {
        layer.borderWidth = tagBorderWidth
        layer.borderColor = tagBorderColor
        layer.cornerRadius = bounds.height * tagCornerRadiusToHeightRatio
    }
    
    // MARK: - User interaction
    func tapped(){
        print("tapped")
        delegate?.tagClicked(self)
    }
    func cancelled() {
        print("cancelled")
        delegate?.tagCancelled(self)
    }
}


extension UIColor {
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        }else{
            return nil
        }
    }
}
