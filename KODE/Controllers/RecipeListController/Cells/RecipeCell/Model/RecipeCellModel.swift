//
//  RecipeCellModel.swift
//  KODE
//
//  Created by Victor on 07.12.2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import FutureKit

struct RecipeCellModel {
    var imageData: Future<Data>
    let name: String
    let description: String?
}
