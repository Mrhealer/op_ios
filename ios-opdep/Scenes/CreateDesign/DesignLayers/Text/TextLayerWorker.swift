//
//  TextLayerWorker.swift
//  OPOS
//
//  Created by Tran Van Dinh on 8/3/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

class TextLayerWorker {
    let apiService: APIService
    init(apiService: APIService) {
        self.apiService = apiService
    }
    // Refactor???
    func fetchFont(from: DesignImageModel) -> SignalProducer<String?, Never> {
        SignalProducer { [weak self] observer, _ in
            guard let sself = self else {
                observer.send(value: nil)
                observer.sendCompleted()
                return
            }
            guard let route = from.imageLink else {
                observer.send(value: nil)
                observer.sendCompleted()
                return
            }
            if let path = sself.checkExistedFont(route: route) {
                if sself.registerFont(path: path) {
                    observer.send(value: from.info)
                } else {
                    observer.send(value: nil)
                }
                observer.sendCompleted()
                return
            }
            
            let request = DownloadFontRequest(route: route)
            sself.apiService.send(request: request,
                                  completion: { result in
                                    switch result {
                                    case .success(let model):
                                        if sself.registerFont(path: model.filePath) {
                                            observer.send(value: from.info)
                                        } else {
                                            observer.send(value: nil)
                                        }
                                        
                                        observer.sendCompleted()
                                    default:
                                        observer.send(value: nil)
                                        observer.sendCompleted()
                                    }
            })
        }
    }
    
    private func registerFont(path: String?) -> Bool {
        guard let path = path,
            let data = NSData(contentsOfFile: path),
            let provider = CGDataProvider(data: data),
            let font = CGFont(provider) else {
                return false
        }
        var error: Unmanaged<CFError>?
        CTFontManagerRegisterGraphicsFont(font, &error)
        if let error = error {
            let code = CFErrorGetCode(error.takeUnretainedValue())
            if code == 105 {
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    private func checkExistedFont(route: String) -> String? {
        if let url = URL(string: route) {
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory,
                                                in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(url.lastPathComponent)
            if fileManager.fileExists(atPath: fileURL.path) {
                return fileURL.path
            }
            return nil
        }
        return nil
    }
}
