//
//  ViewController.swift
//  HTagView
//
//  Created by Chang, Hao on 05/16/2016.
//  Copyright (c) 2016 Chang, Hao. All rights reserved.
//

import UIKit
import HTagView

class ViewController: UIViewController {

    @IBOutlet weak var tagView: HTagView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tagView.addTagsWithTitle(["awef","aefawef","awefawef","awefhu","eiueue","aweiidknx"])
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

