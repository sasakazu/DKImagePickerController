//
//  ViewController.swift
//  DKImagePickerControllerTest
//
//  Created by 笹倉一也 on 2021/11/18.
//

import UIKit
import DKImagePickerController



class ViewController: UIViewController {

    
    let tableView = UITableView()
    let button = UIButton(type: .system)

    var photos: [UIImage] = []
    // 実際に選択された枚数
    var selectedCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
   
        
        view.addSubview(tableView)
              view.addSubview(button)

              tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
              tableView.dataSource = self

              button.addTarget(self, action: #selector(selectImages), for: .touchUpInside)
              button.setTitle("追加", for: .normal)
          }

          // ボタンが押された時の処理
          @objc func selectImages(_ sender: UIButton) {
              let imagePicker = DKImagePickerController()
              //選択できる写真の最大数を指定
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

          // Asset の読み込みは非同期なので、全てダウンロードされた場合に再描画させる
          func reloadImage() {
              // photos.count と asset.count が等しければ tableView を再描画
              if photos.count == selectedCount {
                  tableView.reloadData()
              }
          }

          override func viewWillLayoutSubviews() {
              super.viewWillLayoutSubviews()

              let topInset = view.safeAreaInsets.top
              let bottomInset = view.safeAreaInsets.bottom
              print(topInset, bottomInset)
              let height = view.frame.height - (topInset + bottomInset)
              let width = view.frame.width
              print(height)
              tableView.frame = CGRect(x: 0, y: topInset, width: width, height: height - 30)
              button.frame = CGRect(x: 0, y: topInset + height - 30, width: width, height: 30)
          }
      }

      extension ViewController: UITableViewDataSource {
          func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
              return photos.count
          }

          func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
              let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

              cell.imageView?.image = photos[indexPath.row]
              cell.textLabel?.text = String(indexPath.row)

              return cell
          }
      }
