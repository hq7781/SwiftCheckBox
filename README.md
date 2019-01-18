# SwiftCheckBox
CheckBox with Swift4.1
==================
[![Build-Status](https://api.travis-ci.org/hirohisa/PageController.svg?branch=master)](https://travis-ci.org/hirohisa/PageController)
[![CocoaPods](https://img.shields.io/cocoapods/v/PageController.svg)](https://cocoapods.org/pods/PageController)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![license](https://img.shields.io/badge/license-MIT-000000.svg)](https://github.com/hirohisa/ImageLoaderSwift/blob/master/LICENSE)

SwiftCheckBox  
![sample](/video.avi)

Requirements
----------
SwiftCheckBox  | Xcode | Swift
-------------- | ----- | -----
0.0.1 +        | 9.3.1 | 4.1


Features
----------

- [x] To inherit from [CTCheckbox](https://github.com/rizumita/CTCheckbox)
- [x] Support Swift 4.1
- [x] Not Use Xib or Storyboard File
- [x] Handling with Delegate.

Installation
----------

### CocoaPods

```ruby
pod 'SwiftCheckBox'
```

### Carthage
  To integrate PageController into your Xcode project using Carthage, specify it in your `Cartfile`:

```
github "hq7781/SwiftCheckBox" ~> 0.0.1
```



Usage
----------

**viewControllers**

Type is [ViewController], Impot SwiftheckBox

```swift
        checkbox1 = SwiftCheckBox(frame: CGRect(x: 20.0, y: 180.0, width:(self.view.frame.width - 40), height: 20.0))
        self.checkbox1.addTarget(self, action: #selector(self.checkboxDidChange(_:)), for: .valueChanged)
        self.checkbox1.hintText = "to agree Terms of service"
        _ = self.checkbox1.addLink(text: "open Websize", urlString: "http://www.enixsoft.com", color: .blue)
        self.checkbox1.setColor(.blue, forControlState: .normal)
        self.checkbox1.delegate = self
        self.view.addSubview(self.checkbox1)
```

```swift
        checkbox2 = SwiftCheckBox()
        self.checkbox2 = SwiftCheckBox(frame: CGRect(x:20.0, y: 220.0, width: (self.view.frame.width - 40), height: 20.0))
        self.checkbox2.addTarget(self, action: #selector(self.checkboxDidChange(_:)), for: .valueChanged)
        _ = self.checkbox2.addTouch(text: "open screen", target: self, action: #selector(self.checkboxTapGesture(_:)), color: .red)
        self.checkbox2.hintText = "to agree privacy"
        self.checkbox2.setColor(.red, forControlState: .normal)
        self.checkbox2.delegate = self
        self.checkboxDidChange(self.checkbox2)
        self.view.addSubview(self.checkbox2)
```


```swift
        checkbox3 = SwiftCheckBox()
        self.checkbox3 = SwiftCheckBox(frame: CGRect(x:20.0, y: 260.0, width:(self.view.frame.width - 20), height: 40.0))
        self.checkbox3.addTarget(self, action: #selector(self.checkboxDidChange(_:)), for: .valueChanged)
        self.checkbox3.addTarget(self, action: #selector(self.checkboxDidTouch(_:)), for: .touchUpInside)
        self.checkbox3.checkboxSideLength = 40.0
        self.checkbox3.hintText = "set box size to 40"
        self.checkbox3.setColor(.green, forControlState: .normal)
        self.checkboxDidChange(self.checkbox3)
        self.view.addSubview(self.checkbox3)
```

```swift
        checkbox4 = SwiftCheckBox()
        self.checkbox4 = SwiftCheckBox(frame: CGRect(x:20.0, y: 320.0, width:(self.view.frame.width - 40), height: 30.0))
        self.checkbox4.alignment = .right
        self.checkbox4.checkboxSideLength = 30.0
        self.checkbox4.hintText = "set to right"
        _ = self.checkbox4.addLink(text: "open Websize", urlString: "http://www.enixsoft.com", color: .blue)
        self.checkbox4.setColor(.green, forControlState: .normal)
        self.checkboxDidChange(self.checkbox4)
        self.view.addSubview(self.checkbox4)
```
Sample app screens
----------


    |                           Screen1                           |     |                           Screen2                           |     |                           Screen3                           |
    |-------------------------------------------------------------|-----|-------------------------------------------------------------|-----|-------------------------------------------------------------|


Source
----------
    [GitHub](https://github.com/hq7781/SwiftCheckBox.git)
    

License
----------
SwiftCheckbox is available under the MIT license. See the LICENSE file for more info.



Usage
----------
If have a probles contact to mailTo: hq7781@gmail.com
