//
//  Throttler.swift
//

import Foundation

// 参考链接 / Reference link
// - [GCDThrottle](https://github.com/cyanzhong/GCDThrottle)
// - [在线演示效果](http://demo.nimius.net/debounce_throttle/)
// - [实现iOS中的函数节流和函数防抖](https://satanwoo.github.io/2015/09/30/Debounce-and-Throttle-in-iOS/)
// - [函数节流（Throttle）和防抖（Debounce）解析及其iOS实现](https://juejin.cn/post/6933952291142074376)
// - [All about debounce: 4 ways to achieve debounce in Swift](https://blog.tarkalabs.com/all-about-debounce-4-ways-to-achieve-debounce-in-swift-e8f8ce22f544)

private var nilContext: AnyHashable = arc4random()
// 函数节流（Throttling） && 函数防抖（Debouncing）
private var scheduledList: [AnyHashable: DispatchSourceTimer] = [:]

public extension WSBinder {
    
    // 函数节流（Throttling）
    // Throttling enforces a maximum number of times a function can be called over time
    // 函数节流的意思就是，一个函数被执行过一次以后，在一段时间内不能再次执行。比如，一个函数执行完了之后，100毫秒之内不能第二次执行。
    func throttle(threshold: TimeInterval, dispatchQueue: DispatchQueue = DispatchQueue.main, context: AnyHashable? = nil, action: @escaping Action) {
    
        let current = DispatchTime.now()
        let context = context ?? nilContext
        
        if let _ = scheduledList[context] { return }
        if let instance = self.instance { action(instance) }
        
        let scheduledItem = DispatchSource.scheduledItem(deadline: current + threshold, dispatchQueue: dispatchQueue) {
            scheduledList.removeValue(forKey: context)
        }

        scheduledList[context] = scheduledItem
    }
    
    // 函数防抖（Debouncing）
    // Debouncing enforces that a function not be called again until a certain amount of time has passed without it being called
    // 函数防抖的意思就是说一个函数在一定时间内，只能执行有限次数。
    // 二者的区别是函数防抖可能会被无限延迟。用现实乘坐公交车中的例子来说，Throttle 就是准点就发车（比如15分钟一班公交车）, Debounce 就是黑车。
    // 上了一个人以后，司机说，再等一个人，等不到，咱么10分钟后出发。但是呢，如果在10分钟内又有一个人上车，这个10分钟自动延后直到等待的10分钟内没人上车了。
    func debounce(threshold: TimeInterval, dispatchQueue: DispatchQueue = DispatchQueue.main, context: AnyHashable? = nil, action: @escaping Action) {
        
        let current = DispatchTime.now()
        let context = context ?? nilContext
        
        if let scheduledItem = scheduledList[context] {
            scheduledItem.cancel()
        }
        
        let scheduledItem = DispatchSource.scheduledItem(deadline: current + threshold, dispatchQueue: dispatchQueue) { [weak self] in
            if let strongSelf = self, let instance = strongSelf.instance {
                action(instance)
            }
            
            scheduledList.removeValue(forKey: context)
        }

        scheduledList[context] = scheduledItem
    }
}

// MARK: DispatchSource
fileprivate extension DispatchSource {

    class func scheduledItem(deadline: DispatchTime, dispatchQueue: DispatchQueue, event handler: DispatchSourceProtocol.DispatchSourceHandler?) -> DispatchSourceTimer {
        // 不清楚为什么 leeway 参数会影响到正常运行???
        let leeway: DispatchTimeInterval = .milliseconds(100)
        
        let scheduledItem = DispatchSource.makeTimerSource(flags: .strict, queue: dispatchQueue)
        
        scheduledItem.setEventHandler(handler: handler)

        scheduledItem.schedule(deadline: deadline, repeating: .infinity, leeway: leeway)
        scheduledItem.resume()
        
        return scheduledItem
    }
}
