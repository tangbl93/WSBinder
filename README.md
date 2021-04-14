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


