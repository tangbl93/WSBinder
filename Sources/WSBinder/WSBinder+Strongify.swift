//
//  Strongify.swift
//

import Foundation

public extension WSBinder {
    
    func strongify(action: Action) {
        guard let instance = instance else { return }
        action(instance)
    }
}
