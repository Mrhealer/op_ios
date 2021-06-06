//
//  SearchApiResponse.swift
//  VoiceApp
//
//  Created by VMO on 02/03/2021.
//  Copyright © 2021 VoiceApp. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderApiResponse: ApiResponse {
    
    override func parsingData(json: JSON) {
        super.parsingData(json: json)
        print("json")
    }
    
}
