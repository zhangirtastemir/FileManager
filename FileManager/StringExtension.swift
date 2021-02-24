//
//  StringExtension.swift
//  FileManager
//
//  Created by Zhangir Tastemir on 4/28/20.
//  Copyright © 2020 AkanAkysh. All rights reserved.
//

import Foundation

extension String {
   func replace(string:String, replacement:String) -> String {
       return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
   }
 }
