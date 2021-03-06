//
//  MockReusableView.swift
//  EZSource_Example
//
//  Created by Alex Hmelevski on 2018-06-04.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

@testable import EZSource

final class MockReusableView: UITableViewHeaderFooterView, ReusableView, Configurable {
    typealias Model = String
    
    private(set) var models: [String] = []
    
    func configure(with model: String) {
        models.append(model)
    }
}
