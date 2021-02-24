//
//  File.swift
//  FileManager
//
//  Created by Zhangir Tastemir on 4/27/20.
//  Copyright © 2020 AkanAkysh. All rights reserved.
//

import UIKit

struct File {
    let image: UIImage
    let name: String
}

class FileInstance {
    static let shared = FileInstance()
    var files: [File] = []
}
