//
//  DownloaderTest.swift
//  KODETests
//
//  Created by Victor on 08.12.2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import XCTest
import FutureKit
@testable import KODE

class MockDownloader: KODE.ConcurrentDownloader {
    private var downloadQueue: DispatchQueue = .global()
    
    func downloadImage(url: String) -> Future<Data> {
        let promise: Promise<Data> = .init()
        do {
            let bundle = Bundle(for: type(of: self))
            guard let resourceURL = bundle.url(forResource: url, withExtension: "jpg") else {
                return .init(failWithErrorMessage: "Cant read file!")
            }
            let data = try Data(contentsOf: resourceURL)
            downloadQueue.async {
                Thread.sleep(forTimeInterval: 3.0)
                promise.completeWithSuccess(data)
            }
        } catch {
            return .init(fail: error)
        }
        return promise.future
    }
}

class DownloaderTest: XCTestCase {

    var downloader: ConcurrentDownloader!
    
    override func setUp() {
        downloader = MockDownloader()
    }

    override func tearDown() {
        downloader = nil
    }

    func test_downloadImages_multipleDownload() {
        let expectation = XCTestExpectation(description: "Async load image")
        let firstImage = downloader.downloadImage(url: "food_1")
        let secondImage = downloader.downloadImage(url: "food_2")
        var countImages = 0
        firstImage.onFail { (error) in
            if let err = error as? FutureKitError {
                switch err {
                case .genericError(let message):
                    XCTFail(message)
                default:
                    XCTFail(err.localizedDescription)
                }
            } else {
                XCTFail(error.localizedDescription)
            }
        }
        secondImage.onFail { (error) in
            if let err = error as? FutureKitError {
                switch err {
                case .genericError(let message):
                    XCTFail(message)
                default:
                    XCTFail(err.localizedDescription)
                }
            } else {
                XCTFail(error.localizedDescription)
            }
        }
        firstImage.onSuccess { (data) -> Void in
            countImages += 1
            if countImages == 2 {
                XCTAssert(true)
                expectation.fulfill()
            }
        }
        secondImage.onSuccess { (data) -> Void in
            countImages += 1
            if countImages == 2 {
                XCTAssert(true)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 4)
    }
}
