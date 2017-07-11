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
        tagView1.tagFont = UIFont.systemFont(ofSize: 15)
        tagView1.tagMainBackColor = UIColor(red: 121/255, green: 196/255, blue: 1, alpha: 1)
        tagView1.tagMainTextColor = UIColor.white
        tagView1.tagSecondBackColor = UIColor.lightGray
        tagView1.tagSecondTextColor = UIColor.darkText
        
        
        tagView2.delegate = self
        tagView2.dataSource = self
        tagView2.marg = 20
        tagView2.btwTags = 20
        tagView2.btwLines = 20
        tagView2.tagFont = UIFont.systemFont(ofSize: 15)
        tagView2.tagMainBackColor = UIColor(red: 1, green: 130/255, blue: 103/255, alpha: 1)
        tagView2.tagSecondBackColor = UIColor.lightGray
        tagView2.tagSecondTextColor = UIColor.darkText
        tagView2.tagContentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        tagView2.tagMaximumWidth = .HTagAutoMaximumWidth
        tagView2.tagBorderColor = UIColor.black.cgColor
        tagView2.tagBorderWidth = 2
        
        
        tagView2.selectTagAtIndex(6)
        tagView1.selectTagAtIndex(3)
        
        
        tagView1.reloadData()
        tagView2.reloadData()
        
    }
    
    // MARK: - Data
    let tagView1_data = ["Hey!","This","is","a","HTagView."]
    var tagView2_data = ["Hey!","This","is","a","HTagView", "as", "well.", "WEOPIkl,.cviwoipaeai;kdxioaw389WOIERJAAW;EOIFJAOIEJWFAWEIOFPJIPOJ"]
    
    // MARK: - HTagViewDataSource
    func numberOfTags(_ tagView: HTagView) -> Int {
        switch tagView {
        case tagView1:
            return tagView1_data.count
        case tagView2:
            return tagView2_data.count
        default:
            return 0
        }
    }
    
    func tagView(_ tagView: HTagView, titleOfTagAtIndex index: Int) -> String {
        switch tagView {
        case tagView1:
            return tagView1_data[index]
        case tagView2:
            return tagView2_data[index]
        default:
            return "???"
        }
    }
    
    func tagView(_ tagView: HTagView, tagTypeAtIndex index: Int) -> HTagType {
        switch tagView {
        case tagView1:
            return index > 0 ? .select : .cancel
        case tagView2:
            return index > 3 ? .select : .cancel
        default:
            return .select
        }
    }
    
    func tagView(_ tagView: HTagView, tagWidthAtIndex index: Int) -> CGFloat {
        return .HTagAutoWidth
//        return 150
    }
    
    // MARK: - HTagViewDelegate
    func tagView(_ tagView: HTagView, tagSelectionDidChange selectedIndices: [Int]) {
        print("tag with indices \(selectedIndices) are selected")
    }
    func tagView(_ tagView: HTagView, didCancelTagAtIndex index: Int) {
        print("tag with index: '\(index)' has to be removed from tagView")
        tagView2_data.remove(at: index)
        tagView.reloadData()
    }
    

}

