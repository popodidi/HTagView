//
//  ViewController.swift
//  HTagView
//
//  Created by Chang, Hao on 05/16/2016.
//  Copyright (c) 2016 Chang, Hao. All rights reserved.
//

import UIKit
import HTagView

class ViewController: UIViewController, HTagViewDelegate, HTagViewDataSource {

    @IBOutlet weak var tagView1: HTagView!
    @IBOutlet weak var tagView2: HTagView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagView1.delegate = self
        tagView1.dataSource = self
        tagView1.multiselect = false
        tagView1.marg = 20
        tagView1.btwTags = 20
        tagView1.btwLines = 20
        tagView1.fontSize = 15
        tagView1.tagMainBackColor = UIColor(red: 121/255, green: 196/255, blue: 1, alpha: 1)
        tagView1.tagMainTextColor = UIColor.whiteColor()
        tagView1.tagSecondBackColor = UIColor.lightGrayColor()
        tagView1.tagSecondTextColor = UIColor.darkTextColor()
        tagView1.tagContentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        
        tagView2.delegate = self
        tagView2.dataSource = self
        tagView2.marg = 20
        tagView2.btwTags = 20
        tagView2.btwLines = 20
        tagView2.fontSize = 15
        tagView2.tagMainBackColor = UIColor(red: 1, green: 130/255, blue: 103/255, alpha: 1)
        tagView2.tagSecondBackColor = UIColor.lightGrayColor()
        tagView2.tagSecondTextColor = UIColor.darkTextColor()
        tagView2.tagContentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        tagView2.tagBorderColor = UIColor.blackColor().CGColor
        tagView2.tagBorderWidth = 2
        
        
        tagView2.selectTagAtIndex(6)
        tagView1.selectTagAtIndex(3)
        
        
        tagView1.reloadData()
        tagView2.reloadData()
        
    }
    
    // MARK: - Data
    let tagView1_data = ["Hey!","This","is","a","HTagView."]
    var tagView2_data = ["Hey!","This","is","a","HTagView", "as", "well."]
    
    // MARK: - HTagViewDataSource
    func numberOfTags(tagView: HTagView) -> Int {
        switch tagView {
        case tagView1:
            return tagView1_data.count
        case tagView2:
            return tagView2_data.count
        default:
            return 0
        }
    }
    
    func tagView(tagView: HTagView, titleOfTagAtIndex index: Int) -> String {
        switch tagView {
        case tagView1:
            return tagView1_data[index]
        case tagView2:
            return tagView2_data[index]
        default:
            return "???"
        }
    }
    
    func tagView(tagView: HTagView, tagTypeAtIndex index: Int) -> HTagType {
        switch tagView {
        case tagView1:
            return .Select
        case tagView2:
            return index > 3 ? .Select : .Cancel
        default:
            return Bool(drand48()) ? .Select : .Cancel
        }
    }
    
    // MARK: - HTagViewDelegate
    func tagView(tagView: HTagView, tagSelectionDidChange selectedIndices: [Int]) {
        print("tag with indices \(selectedIndices) are selected")
    }
    func tagView(tagView: HTagView, didCancelTagAtIndex index: Int) {
        print("tag with index: '\(index)' has to be removed from tagView")
        tagView2_data.removeAtIndex(index)
        tagView.reloadData()
    }
    

}

