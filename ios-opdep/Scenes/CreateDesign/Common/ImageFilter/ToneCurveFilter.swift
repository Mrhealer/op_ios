//
//  ToneCurveFilter.swift
//  OPOS
//
//  Created by Tran Van Dinh on 8/1/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import GPUImage

class ToneCurveFilter: GPUImageFilterGroup {
    let acvFileName: String
    init(acvFileName: String) {
        self.acvFileName = acvFileName
        super.init()
        guard let toneCurveFilter = GPUImageToneCurveFilter(acv: acvFileName) else { return }
        initialFilters = [toneCurveFilter]
        terminalFilter = toneCurveFilter
    }
}
