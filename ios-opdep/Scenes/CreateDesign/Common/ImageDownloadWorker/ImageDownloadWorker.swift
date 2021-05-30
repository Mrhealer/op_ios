//
//  ImageDownloadWorker.swift
//  OPOS
//
//  Created by Tran Van Dinh on 9/10/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift
import AlamofireImage

enum ImageDownloadError: LocalizedError {
    case noImage
    var errorDescription: String? {
        switch self {
        case .noImage: return "Can't download image. Please check your image's url or your internet"
        }
    }
}

class ImageDownloadWorker {
    let downloader = ImageDownloader(maximumActiveDownloads: 10)
    func fetchImage(url: URL?) -> SignalProducer<UIImage?, ImageDownloadError> {
        SignalProducer { [downloader] observer, _ in
            guard let url = url else {
                observer.send(value: nil)
                observer.sendCompleted()
                return
            }
            let urlRequest = URLRequest(url: url)
            downloader.download(urlRequest, completion: { response in
                switch response.result {
                case .success(let image):
                    observer.send(value: image)
                    observer.sendCompleted()
                case .failure:
                    observer.send(error: ImageDownloadError.noImage)
                }
            })
        }
    }
    
    func clearCache() {
        downloader.imageCache?.removeAllImages()
    }
}
