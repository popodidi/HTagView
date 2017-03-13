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
    var tagType: HTagType = .select
    /**
     Main background color of tags
     */
    var tagMainBackColor : UIColor = UIColor.white
    /**
     Main text color of tags
     */
    var tagMainTextColor : UIColor = UIColor.black
    /**
     Secondary background color of tags
     */
    var tagSecondBackColor : UIColor = UIColor.gray
    /**
     Secondary text color of tags
     */
    var tagSecondTextColor : UIColor = UIColor.white
    /**
     The border width to height ratio of HTags.
     */
    var tagBorderWidth :CGFloat = 1
    /**
     The border color to height ratio of HTags.
     */
    var tagBorderColor :CGColor? = UIColor.darkGray.cgColor
    
    /**
     The corner radius to height ratio of HTags.
     */
    var tagCornerRadiusToHeightRatio :CGFloat = 0.2
    /**
     The content EdgeInsets of HTags, which would automatically adjust the position in `.cancel` type.
     On the other word, usages are the same in both types.
     */
    var tagContentEdgeInsets: UIEdgeInsets = UIEdgeInsets()
    /**
     The Font size of HTags.
     */
    var fontSize : CGFloat = 17
    
    // MARK: - status
    var isSelected: Bool {
        return button.isSelected
    }
    
    
    // MARK: - Subviews
    var button: UIButton = UIButton(type: .system)
    var cancelButton: UIButton?
    
    // MARK: - Init
    override init(frame: CGRect){
        super.init(frame: frame)
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    // MARK: - Configure
    func configure(){
        setupButton()
        setupCancelButton()
        setupConstraints()
    }
    
    // MARK: - button
    func setupButton() {
        addSubview(button)
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        button.addObserver(self, forKeyPath: "selected", options: .new, context: nil)
        button.addObserver(self, forKeyPath: "highlighted", options: .new, context: nil)
        
        button.setTitle("tag", for: UIControlState())
    }
    
    func setHighlight(_ highlighted: Bool) {
        var color = isSelected ? tagMainBackColor : tagSecondBackColor
        backgroundColor = highlighted ? color.darker() : color
    }
    func setSelected(_ selected: Bool) {
        backgroundColor = selected ? tagMainBackColor.darker() : tagMainBackColor
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
//        if tagType == .cancel {
            cancelButton = UIButton()
            cancelButton?.setImage(UIImage(named: "close_small", in: Bundle(for: self.classForCoder), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate), for: UIControlState())
            button.addTarget(self, action: #selector(cancelled), for: .touchUpInside)
            addSubview(cancelButton!)
//        } else {
//            cancelButton?.removeFromSuperview()
//            self.cancelButton = nil
//        }
        cancelButton?.isHidden = tagType == .select
    }
    
    // MARK: - Constraint
    func setupConstraints() {
        if #available(iOS 9.0, *) {
            button.translatesAutoresizingMaskIntoConstraints = false
            cancelButton?.translatesAutoresizingMaskIntoConstraints = false
            
            cancelButton?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: tagContentEdgeInsets.right).isActive = true
            cancelButton?.topAnchor.constraint(equalTo: topAnchor, constant: tagContentEdgeInsets.top).isActive = true
            cancelButton?.bottomAnchor.constraint(equalTo: bottomAnchor, constant: tagContentEdgeInsets.bottom).isActive = true
            
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: tagContentEdgeInsets.right).isActive = true
            button.topAnchor.constraint(equalTo: topAnchor, constant: tagContentEdgeInsets.top).isActive = true
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: tagContentEdgeInsets.bottom).isActive = true
            
            cancelButton?.rightAnchor.constraint(equalTo: button.leftAnchor, constant: 20).isActive = true
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    // MARK: - Layout
    
    // MARK: - User interaction
    func tapped(){
        delegate?.tagClicked(self)
    }
    func cancelled() {
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
