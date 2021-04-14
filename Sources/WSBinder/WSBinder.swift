//
//  WSBinder.swift
//

import Foundation

public class WSBinder<T: AnyObject>: NSObject {
    public typealias Action = (_ instance: T) -> Void

    init(_ instance: T?) {
        super.init()
        self.instance = instance
    }
    weak var instance: T? = nil
}
