

# FAJsonParser

[![Version](https://img.shields.io/cocoapods/v/FAJsonParser.svg?style=flat)](http://cocoapods.org/pods/FAJsonParser)
[![License](https://img.shields.io/cocoapods/l/FAJsonParser.svg?style=flat)](http://cocoapods.org/pods/FAJsonParser)
[![Platform](https://img.shields.io/cocoapods/p/FAJsonParser.svg?style=flat)](http://cocoapods.org/pods/FAJsonParser)

## About

FAJsonParser can fill your JSON date to your object matching JSON keys with proparty names or getter name.  
FAJsonParser use ObjC runtime to parse data, so you need to use @objc in swift4.  
you can use inheritance FAJsonParser can detect superclasses.   
FAJsonParser can parse NSObject only.
Save and load object from UserDefaults by key.
JsonParser can fill JSON values to your property even different types between them by casting (String to Int / Int to String)

### declare property

#### ObjC
1 - you can use property name as JSON key               
```ruby
@property (nonatomic,retain) NSString *text;  
 ``` 
2 - you can use getter name as JSON key               
```ruby
@property (nonatomic,retain,getter=created_at) NSString *createdAt; 
  ```
3 - you must use setter name to declare Array element type  
```ruby
@property (nonatomic,retain,setter=Url:) NSArray *urls; 
  ```
4 - use NSNumber as element type for number types (Int,Float,Long ... ect)  
```ruby
@property (nonatomic,retain,setter=NSNumber:) NSArray *marks; 
```
#### Swift4
1 - you must add @objc with class name to class as will for objC runtime can handle class info  
```ruby
@objc (FAObject_Swift) class FAObject_Swift: NSObject {}
```
2 - you can use property name as JSON key               
```ruby
@objc var text = "" 
  ```
3 - you can use getter name as JSON key               
```ruby
@objc (created_at)
var createdAt = ""
  ```
4 - you must use this format for Array to declare Array element Type ("JSON Key"$"Class name"), make a deal with your backend partner to do not use $ splitter in any JSON key ;)   
```ruby
@objc (urls$Url)
var urls = Array<Url>()
  ```
5 - use NSNumber as element type "Class name" for number types (Int,Float,Long ... ect)   
```ruby
@objc (marks$NSNumber)
var marks = Array<Int>()
```
6 - there is some proparty names can't use or override in NSObject, you must use this format to set getter name for this proprty ("JSON Key"$"Proprty name")  
```ruby
@objc (description$Description)
var Description = ""
```
## How to use

### ObjC
```ruby
    // parse JSON to object
    FAObject *object = [FAObject new];
    NSError *error;
    [dict FillThisObject:object Error:&error];
    
    if (!error) {
        // Save object in UserDefaults
        NSLog(@"Object saved ? %@",[object SaveWithKey:@"objectKey"]  ? @"YES" : @"NO");
        
        //load object from UserDefaults
        FAObject *newObject = [FAObject new];
        NSLog(@"Object loaded ? %@",[newObject LoadWithKey:@"objectKey"]  ? @"YES" : @"NO");
        
        // generate dictionary from object
        NSDictionary *dictFromObject = [newObject Dictionary:&error];
        if (!error)
        {
            NSLog(@"%@", dictFromObject.description);
        }
    }
```

### Swift4
```ruby
    // parse JSON to object
    let object = FAObject_Swift()
    
    // fill JSON to object
    dict.fillThisObject(object)
    
    // Save object in UserDefaults
    print("Object saved ? \(object.save(withKey: "objectKey_swift") ? "True" : "False")")
    
    //load object from UserDefaults
    let newObject = FAObject_Swift()
    print("Object loaded ? \(newObject.load(withKey: "objectKey_swift") ? "True" : "False")")
    
    // generate dictionary from object
    let dictFromObject = newObject.dictionary()
    
    // print dictionary
    print(dictFromObject?.description ?? "")
```
## Installation

FAJsonParser is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'FAJsonParser'
```

## Author

fadizant, fadizant@yahoo.com

## License

FAJsonParser is available under the MIT license. See the LICENSE file for more info.

