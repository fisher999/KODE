//
//  NetworkError.swift
//  KODE
//
//  Created by Victor on 07.12.2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import Alamofire

enum RecipeError: Error {
    case invalidURL
    case afError(AFError)
    case decodeError(DecodingError)
    case unexpectedError(Error)
    case emptyUrl
    case invalidPath(InvalidPath)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Указан неверный URL"
        case .afError(let err):
            return "Ошибка при загрузке. Reason: \(err.localizedDescription)"
        case .decodeError(let err):
            return "Ошибка при декодировании JSON: \(err.localizedDescription)"
        case .unexpectedError(let err):
            return "Непредвиденная ошибка. Reason: \(err.localizedDescription)"
        case .emptyUrl:
            return "Отсутсвует  URL"
        case .invalidPath(let err):
            return "Не удалось прочитать файл: Reson: \(err.localizedDescription)"
        }
    }
}
