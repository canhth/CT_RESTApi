# CT_RESTApi

## Description: 
Create the custom wrapper to request Webservice and mapping the response to Object(s) model. Using RxSwift inside, so if you want to implement this library, you must to have some knowledge about Reactive Programming (RxSwift).

- For support Codable Swift 4. Check out branch: `Swift4_codable`

How to use it: 
```swift
let apiManager = RESTApiClient(subPath: "login", functionName: "", method: .POST, endcoding: .JSON)

let loginParam = LoginParam(email: "abcdef@gmail.com", password: "abccba!1") // Create parameters
apiManager.setQueryParam(loginParam)

let obserable: Observable<User?> = apiManager.requestObject(keyPath: nil) // Observable
obserable.subscribe(onNext: { (user) in
   guard let user = user else { return }
   print("Success: ", user)
}, onError: { (error) in
   print("Error: ", error)
}).disposed(by: disposeBag)
```

---> Very simple, short and clear.

Refernced libs:

- [Alamofire] 
- [ObjectMapper]
- [SwiftJSON]
- [RxSwift]




