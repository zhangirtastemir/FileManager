//
//  ViewController.swift
//  FileManager
//
//  Created by Zhangir Tastemir on 4/27/20.
//  Copyright © 2020 AkanAkysh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum Constants {
        static let cellId = "fileCell"
        static let segueIdentifier = "GoToMusicVC"
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBarButton()
        FileService.shared.loadFiles()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        print(documentsDirectory)
        
        let documentDirectoryURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        print(documentDirectoryURL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FileService.shared.loadFiles()
        collectionView.reloadData()
    }
    
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        collectionView.allowsMultipleSelection = editing
        let indexPaths = collectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            let cell = collectionView.cellForItem(at: indexPath) as! FileCollectionViewCell
            cell.isInEditingMode = editing
        }
    }
    
    func setupNavBarButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        let musicAddButton = UIBarButtonItem(image: UIImage(systemName: "music.note"), style: .plain, target: self, action: #selector(musicAddButtonTapped))
        
        navigationItem.rightBarButtonItems = [addButton, musicAddButton]
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    @objc func addButtonTapped() {
        let alertController = UIAlertController(title: "Create Folder", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter folder name"
        }
        
        let saveAction = UIAlertAction(title: "Create", style: .default, handler: { alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            guard let fileName = textField.text else { return }
            FileService.shared.createFolder(fileName: fileName)
            self.collectionView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil )
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @objc func musicAddButtonTapped() {
        performSegue(withIdentifier: Constants.segueIdentifier, sender: nil)
    }
    
}

// collection view delegate
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FileInstance.shared.files.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellId, for: indexPath) as! FileCollectionViewCell
        cell.file = FileInstance.shared.files[indexPath.row]
        cell.deleteButton.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
}

extension ViewController: FileCollectionViewCellDelegate {
    func updateCollectionView() {
        collectionView.reloadData()
    }
}

