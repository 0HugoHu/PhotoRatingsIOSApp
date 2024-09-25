//
//  ImageStruct.swift
//  PhotoRatings
//
//  Created by Hugooooo on 9/21/24.
//

import SwiftUI

struct ImageStruct {
    let image: UIImage
    let filename: String
    let partition: String
    var isVisible: Bool = true
}

struct ImageList: Codable {
    let filename: String
    let partition: String
}

