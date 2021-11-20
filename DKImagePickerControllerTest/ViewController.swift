//
//  ViewController.swift
//  DKImagePickerControllerTest
//
//  Created by 笹倉一也 on 2021/11/18.
//

import UIKit
import Firebase

import DKImagePickerController

class ViewController: UIViewController {
   


    
    @IBOutlet weak var collection: UICollectionView!
    
    let tableView = UITableView()
    let button = UIButton(type: .system)

    var photos: [UIImage] = []
    // 実際に選択された枚数
    var selectedCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        
        // Do any additional setup after loading the view.
   
    }
    
}
