//
//  String+LoadFromFile.swift
//  KODE
//
//  Created by Victor on 08.12.2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation

struct InvalidPath: Error {
    var localizedDescription: String {
        return "Invalid path of file"
    }
}

extension Data {
    static func dataFromFile(bundleOfType Type: AnyObject.Type, _ filename: String, ofExt ext: String? = nil) throws -> Data {
        guard let path = Bundle(for: Type).path(forResource: filename, ofType: ext) else {
            throw InvalidPath()
        }
        do {
            let url = URL(fileURLWithPath: path)
            return try Data(contentsOf: url)
        }
        catch {
            throw error
        }
    }
}
