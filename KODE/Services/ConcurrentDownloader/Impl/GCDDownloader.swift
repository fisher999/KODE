//
//  GCDDownloader.swift
//  KODE
//
//  Created by Victor on 07.12.2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import FutureKit

class GCDDownloader: ConcurrentDownloader {
    private var downloadImageQueue: DispatchQueue = .global()
    private var serialQueue: DispatchQueue = .init(label: "com.KODETest.victor.Services.GCDDownloader")
    private var cachedImages: [String: Data] = [:]
    
    func downloadImage(url: String) -> Future<Data> {
        if let image = cachedImages[url] {
            return .init(success: image)
        }
        guard let imageURL = URL(string: url) else {
            return .init(fail: DownloaderError.invalidURL)
        }
        let promise = Promise<Data>()
        downloadImageQueue.async { [weak self] in
            do {
                let imageData = try Data(contentsOf: imageURL)
                self?.serialQueue.async(flags: .barrier) {
                    self?.cachedImages[url] = imageData
                    promise.completeWithSuccess(imageData)
                }
            } catch {
                print(error.localizedDescription)
                self?.serialQueue.async(flags: .barrier) {
                    promise.completeWithFail(DownloaderError.cantLoadImage)
                }
            }
        }
        return promise.future
    }
}
