//
//  CGSize.swift

import Foundation
import UIKit

extension CGSize {
    static func aspectFit(aspectRatio: CGSize, boundingSize: CGSize) -> CGSize {
        var bounding: CGSize = boundingSize
        let mW = boundingSize.width / aspectRatio.width
        let mH = boundingSize.height / aspectRatio.height

        if mH < mW {
            bounding.width = boundingSize.height / aspectRatio.height * aspectRatio.width
        } else if mW < mH {
            bounding.height = boundingSize.width / aspectRatio.width * aspectRatio.height
        }
        
        return bounding
    }
    
    static func aspectFill(aspectRatio: CGSize, minimumSize: CGSize) -> CGSize {
        var minimum: CGSize = minimumSize
        let mW = minimumSize.width / aspectRatio.width
        let mH = minimumSize.height / aspectRatio.height

        if mH > mW {
            minimum.width = minimumSize.height / aspectRatio.height * aspectRatio.width
        } else if mW > mH {
            minimum.height = minimumSize.width / aspectRatio.width * aspectRatio.height
        }
        
        return minimum
    }
}
