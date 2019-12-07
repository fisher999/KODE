//
//  ConcurrentDownloader.swift
//  KODE
//
//  Created by Victor on 07.12.2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import FutureKit

protocol ConcurrentDownloader {
    func downloadImage(url: String) -> Future<Data>
}
