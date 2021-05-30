//
//  CreateDesignViewController+ImagePicker.swift
//  OPOS
//
//  Created by Tran Van Dinh on 7/30/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift

extension CreateDesignViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showAlertSelectPhoto() {
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        alertController.addAction(.init(title: "Camera",
                                        style: .default,
                                        handler: { [weak self] _ in
            self?.showPickerImageWithType(sourceType: .camera) }))
        
        alertController.addAction(.init(title: "Photo Library",
                                        style: .default,
                                        handler: { [weak self] _ in
            self?.showPickerImageWithType(sourceType: .photoLibrary) }))
        
        alertController.addAction(.init(title: "Cancel",
                                        style: .cancel,
                                        handler: { _ in }))

        present(alertController,
                animated: true)
    }
    
    func showPickerImageWithType(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = sourceType
            imagePickerController.delegate = self
            imagePickerController.modalPresentationStyle = .fullScreen
            present(imagePickerController,
                    animated: true,
                    completion: nil)
        }

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        viewModel.resizeImageAction.apply(image)
            .start(on: QueueScheduler(qos: .background))
            .start()
    }
}
