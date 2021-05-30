//
//  ImageContent.swift
//  OPOS
//
//  Created by Tran Van Dinh on 7/14/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import UIKit

protocol DesignContent {
    var url: URL? { get }
    var isColor: Bool { get }
    var color: UIColor? { get }
}
