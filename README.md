# HTagView

<!--[![CI Status](http://img.shields.io/travis/Chang, Hao/HTagView.svg?style=flat)](https://travis-ci.org/Chang, Hao/HTagView)-->
[![Version](https://img.shields.io/cocoapods/v/HTagView.svg?style=flat)](http://cocoapods.org/pods/HTagView)
[![License](https://img.shields.io/cocoapods/l/HTagView.svg?style=flat)](http://cocoapods.org/pods/HTagView)
[![Platform](https://img.shields.io/cocoapods/p/HTagView.svg?style=flat)](http://cocoapods.org/pods/HTagView)

HTagView is a customized tag view sublassing UIView where tag could be either with cancel button or multiseletable.

### Features

- `.Cancel` and `.MultiSelect` types available (see below)
- Customized configuration
- Supporting storyboard and autolayout

### To Do
- Documentation

### Demo
![](demo.gif)




## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

<!--## Requirements-->

## Installation

HTagView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "HTagView"
```

## Usage
### Configure HTagView
These properties support storyboard setting as well.

```swift
override func viewDidLoad(){
	super.viewDidLoad()
	//.
	//.
	//.
	
	// configure tagView
	tagView.delegate = self
	tagView.type = .Cancel // or .MultiSelect
	tagView.marg = 20
	tagView.btwTags = 20
	tagView.btwLines = 20
	tagView.fontSize = 15
	tagView.tagMainBackColor = UIColor.blueColor()
	tagView.tagSecondBackColor = UIColor.lightGrayColor()
	tagView.tagSecondTextColor = UIColor.darkTextColor()
	tagView.tagContentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
}
```
### Set Tags
```swift
    tagView.setTagsWithTitles(["Hey!","This","is","a","HTagView."])
    tagView.selectTagWithTitles(["Hey!", "a"])
    tagView.deselectTagWithTitles(["Hey!"])
    tagView.addTagWithTitle("This")
    tagView.removeTagWithTitle("Hey!")
```
### Methods Called for User Interaction
```swift
class ViewController: UIViewController, HTagViewDelegate{
	// .
	// .
	// .
	
	// MARK: - HTagViewDelegate
	// For .MultiSelect type HTagView
    func tagView(tagView: HTagView, tagSelectionDidChange tagSelected: [String]){
        print(tagSelected)
    }
    
	// For .Cancel type HTagView	
	func tagView(tagView: HTagView, didCancelTag tagTitle: String) {
		print("tag with title: '\(tagTitle)' has been removed from tagView")
	}

}
```
## Author

Hao


## License

HTagView is available under the MIT license. See the LICENSE file for more info.
