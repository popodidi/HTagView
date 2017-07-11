# HTagView

<!--[![CI Status](http://img.shields.io/travis/Chang, Hao/HTagView.svg?style=flat)](https://travis-ci.org/Chang, Hao/HTagView)-->
[![Version](https://img.shields.io/cocoapods/v/HTagView.svg?style=flat)](http://cocoapods.org/pods/HTagView)
[![License](https://img.shields.io/cocoapods/l/HTagView.svg?style=flat)](http://cocoapods.org/pods/HTagView)
[![Platform](https://img.shields.io/cocoapods/p/HTagView.svg?style=flat)](http://cocoapods.org/pods/HTagView)

HTagView is a customized tag view sublassing UIView where tag could be either with cancel button or multiseletable.

### Features

- `.cancel` and `.select` tag types available (see below)
- Single / Multi selection for `.select` tags
- `HTagViewDataSource` and `HTagViewDelegte` protocols
- Customized configuration
- Supporting `@IBDesignable` and autolayout
- Specific/Auto tag width
- Specific/Auto Maximum tag width

### Demo
![](demo.gif)




## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Installation

HTagView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "HTagView"
```

### Requirements

Swift Version | HTagView Version
----- | -----
Swift 2.3 | 2.0.x
Swift 3.0 | 2.1.0 or later

## Usage
### Configure HTagView
These properties support `@IBDesignable` as well.

```swift
override func viewDidLoad(){
	super.viewDidLoad()
	//.
	//.
	//.

	// configure tagView
	tagView.delegate = self
	tagView.dataSource = self
	tagView.marg = 20
	tagView.btwTags = 20
	tagView.btwLines = 20
	tagView.tagFont = UIFont.systemFont(ofSize: 15)
	tagView.tagMainBackColor = UIColor(red: 1, green: 130/255, blue: 103/255, alpha: 1)
	tagView.tagSecondBackColor = UIColor.lightGray
	tagView.tagSecondTextColor = UIColor.darkText
	tagView.tagContentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
	tagView.tagMaximumWidth = .HTagAutoMaximumWidth
	tagView.tagBorderColor = UIColor.black.cgColor
	tagView.tagBorderWidth = 2
}
```
### Data Source
```swift
class ViewController: UIViewController, HTagViewDataSource{
	// .
	// .
	// .

    // MARK: - Data
    let data = ["Hey!","This","is","a","HTagView."]

    
    // MARK: - HTagViewDataSource
    func numberOfTags(_ tagView: HTagView) -> Int {
    	return data.count
    }
    
    func tagView(_ tagView: HTagView, titleOfTagAtIndex index: Int) -> String {
        return data[index]
    }
    
    func tagView(_ tagView: HTagView, tagTypeAtIndex index: Int) -> HTagType {
		return .select
		// return .cancel
    }
    
    func tagView(_ tagView: HTagView, tagWidthAtIndex index: Int) -> CGFloat {
        return .HTagAutoWidth
        // return 150
    }
}
```
### Delegate
```swift
class ViewController: UIViewController, HTagViewDelegate, HTagViewDataSource {
	// .
	// .
	// .

    // MARK: - HTagViewDelegate
    func tagView(_ tagView: HTagView, tagSelectionDidChange selectedIndices: [Int]) {
        print("tag with indices \(selectedIndices) are selected")
    }
    func tagView(_ tagView: HTagView, didCancelTagAtIndex index: Int) {
        print("tag with index: '\(index)' has to be removed from tagView")
        data.remove(at: index)
        tagView.reloadData()
    }
}
```
### Manually select/deselect tags
```swift
tagView.selectTagAtIndex(6)
tagView.deselectTagAtIndex(3)
```

## Author

Hao


## License

HTagView is available under the MIT license. See the LICENSE file for more info.
