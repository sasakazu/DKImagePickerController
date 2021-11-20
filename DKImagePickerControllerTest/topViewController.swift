//
//  topViewController.swift
//  DKImagePickerControllerTest
//
//  Created by 笹倉一也 on 2021/11/20.
//

import UIKit
import Firebase
import DKImagePickerController

class topViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    
    var photos:[UIImage] = []
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! topCollectionViewCell
        
        cell.imageview.image = photos[indexPath.row]
             
        return cell
    
    
    }
    

    
    @IBOutlet weak var collection: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func add(_ sender: Any) {
    }
    
    
    
    @IBAction func save(_ sender: Any) {
    }
    
    
    
    
    

}
