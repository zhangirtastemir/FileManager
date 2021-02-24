//
//  FileCollectionViewCell.swift
//  FileManager
//
//  Created by Zhangir Tastemir on 4/27/20.
//  Copyright © 2020 AkanAkysh. All rights reserved.
//

import UIKit

protocol FileCollectionViewCellDelegate: class {
    func updateCollectionView()
}

class FileCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: FileCollectionViewCellDelegate?
    
    var file: File? {
        didSet {
            fileNameLabel.text = file?.name
            fileImageView.image = file?.image
        }
    }
    
    var isInEditingMode: Bool = false {
        didSet {
            deleteButton.isHidden = !isInEditingMode
        }
    }
    
    @IBOutlet weak var fileImageView: UIImageView!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        let file = FileInstance.shared.files[sender.tag]
        let filePath = FileService.shared.getFileUrl(for: file.name)
        FileService.shared.deleteFile(filePath: filePath.absoluteString)
        
        FileInstance.shared.files.remove(at: sender.tag)
        
        delegate?.updateCollectionView()
    }
}
