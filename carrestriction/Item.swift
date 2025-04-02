//
//  Item.swift
//  carrestriction
//
//  Created by 萧瑟(吴建强) on 2025/4/2.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
