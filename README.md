# WSBinder

## Strongify


```swift
let binder = WSBinder(self)

closure {
    binder.strongify { (strongSelf) in
        ...
    }
}
```

equals to: 

```swift
closure { [weak self] in
    guard let strongSelf = self else { return }
    ....
}
```

## Throttler

- throttle
- debounce

```
let binder = WSBinder(self)
let dispatchQueue = DispatchQueue.global(qos: .userInitiated)

self.view.whenTapped {
    
    binder.throttle(threshold: 3, dispatchQueue: dispatchQueue, context: "throttle") { (strongSelf) in
        NSLog("throttle")
    }
    
    binder.debounce(threshold: 3, dispatchQueue: dispatchQueue, context: "debounce") { (strongSelf) in
        NSLog("debounce")
    }
}
```

