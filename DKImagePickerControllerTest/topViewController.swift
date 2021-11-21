//
//  topViewController.swift
//  DKImagePickerControllerTest
//
//  Created by 笹倉一也 on 2021/11/20.
//

import UIKit
import Firebase
import DKImagePickerController
import Photos

class topViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    
    var photos:[UIImage] = []
    var selectedCount = 0
    var globalIndex = 0
//    var userIconsave:[String] = []
    var urls = [String]()
    
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
        
        
        let nib = UINib(nibName: "topCollectionViewCell", bundle: nil)
        
        collection.register(nib, forCellWithReuseIdentifier: "Cell")
        
        
        collection.delegate = self
        collection.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func add(_ sender: Any) {
        
            let imagePicker = DKImagePickerController()
            imagePicker.maxSelectableCount = 3

               //カメラモード、写真モードの選択
            imagePicker.sourceType = .photo

               //キャンセルボタンの有効化
            imagePicker.showsCancelButton = true

               //UIのカスタマイズ
       //        imagePicker.UIDelegate = CustomUIDelegate()

            imagePicker.didSelectAssets = { (assets: [DKAsset]) in
                   // ここでは一旦全削除する
            self.photos.removeAll()

                   // assets に保存された枚数
            self.selectedCount = assets.count

            for asset in assets {
                       // asset からのダウンロードは非同期（iCloudなどにアクセスするため）
                asset.fetchFullScreenImage(completeBlock: { (image, info) in
                           // もし image が nil だったら早期リターン
                    guard let image = image else {
                        self.selectedCount -= 1
                        return
                    }

                           // photos に追加
                    self.photos.append(image)

                    
                    print(self.photos)
//                    self.collection.reloadData()
                           // reloadImage 内部で UITableView を操作しているため
                           // メインスレッドで実行
                    DispatchQueue.main.async {
                        self.reloadImage()
                    }
                })
            }
        }

               // ここでDKImagePickerを表示
        present(imagePicker, animated: true, completion: nil)
           }
    
    
    
    func reloadImage() {
         // photos.count と asset.count が等しければ tableView を再描画
         if photos.count == selectedCount {
             collection.reloadData()
         }
     }


    @IBAction func save(_ sender: Any) {
        
        uploadImage(forIndex: globalIndex)
        
        
    }
    
    
    func uploadImage(forIndex index: Int) {
        
        if index < photos.count {
       
        
        let date = NSDate()
        let currentTimeStampInSecond = UInt64(floor(date.timeIntervalSince1970 * 1000))
      
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("images").child(imageName)

        
              let metaData = StorageMetadata()
              metaData.contentType = "image/jpg"
        
        guard let uploadData = photos[index].jpegData(compressionQuality: 1.0) else { return }
        
        
        
        storageRef.putData(uploadData, metadata: metaData) { (metadata , error) in
                      if error != nil {
                          print("error: \(error?.localizedDescription)")
                      }
                      storageRef.downloadURL(completion: { (url, error) in
                          if error != nil {
                              print("error: \(error?.localizedDescription)")
                          }
                          
                          if let photoUrl = url?.absoluteString {
                              
                              let url = photoUrl

                            self.urls.append(url)
                              
                              
                              
                              let db = Firestore.firestore()
                                           
                              db.collection("users").document("dddd").setData([
                                "userIcon": self.urls
                                  ]) { err in
                                  if let err = err {
                                      print("Error writing document: \(err)")
                                          } else {
                              print("Document successfully written!")
                                               }
                                           }
                              
                              
                                }
                          
                            self.globalIndex += 1
                            self.uploadImage(forIndex: self.globalIndex)
                            return;
                                      
                      
                          print("url: \(url?.absoluteString)")
      
                      })
                  }
              }

    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(photos[indexPath.row])
    
    }
    
    

}
