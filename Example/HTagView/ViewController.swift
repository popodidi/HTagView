//
//  ViewController.swift
//  HTagView
//
//  Created by Chang, Hao on 05/16/2016.
//  Copyright (c) 2016 Chang, Hao. All rights reserved.
//

import UIKit
import HTagView

class ViewController: UIViewController, HTagViewDelegate {

    @IBOutlet weak var tagView1: HTagView!
    @IBOutlet weak var tagView1HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tagView2: HTagView!
    @IBOutlet weak var tagView2HeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        tagView1.type = .Cancel
        tagView1.delegate = self
        tagView1.autosetHeight = true
        tagView1.marg = 20
        tagView1.btwTags = 20
        tagView1.btwLines = 20
        tagView1.fontSize = 15
        tagView1.tagMainBackColor = UIColor(red: 121/255, green: 196/255, blue: 1, alpha: 1)
        tagView1.tagSecondBackColor = UIColor.lightGrayColor()
        tagView1.tagSecondTextColor = UIColor.darkTextColor()
        tagView1.tagContentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        tagView1.setTagsWithTitle(["Hey!","This","is","a","HTagView."])
        
        tagView2.type = .MultiSelect
        tagView2.delegate = self
        tagView2.autosetHeight = true
        tagView2.marg = 20
        tagView2.btwTags = 20
        tagView2.btwLines = 20
        tagView2.fontSize = 15
        tagView2.tagMainBackColor = UIColor(red: 1, green: 130/255, blue: 103/255, alpha: 1)
        tagView2.tagSecondBackColor = UIColor.lightGrayColor()
        tagView2.tagSecondTextColor = UIColor.darkTextColor()
        tagView2.tagContentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        tagView2.setTagsWithTitle(["Hey!","This","is","a","HTagView."])
    }
    
    // MARK: - HTagViewDelegate
    func tagView(tagView: HTagView, tagSelectionDidChange tagSelected: [String]){
        // For .MultiSelect type HTagView
        print(tagSelected)
        
    }
    
    func tagView(tagView: HTagView, didCancelTag tagTitle: String) {
        // For .Cancel type HTagView
        print("tag with title: '\(tagTitle)' has been removed from tagView")        
    }
    
    

}

