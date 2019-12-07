//
//  DownloaderError.swift
//  KODE
//
//  Created by Victor on 07.12.2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation

enum DownloaderError: Error {
    case invalidURL
    case cantLoadImage
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Неверный URL"
        case .cantLoadImage:
            return "Не удалось загрузить изображение"
        }
    }
}
