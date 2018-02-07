//
//  ViewController.swift
//  CT_RESTAPI
//
//  Created by thcanh on 3/2/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//

import UIKit
import RxSwift
import CT_RESTAPI

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        testAPI()
//        testBoltsFlowWithRxSwift()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        testAPIWithResponseArray()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func testAPI() {
        let apiManager = RESTApiClient(subPath: "login", functionName: "", method: .POST, endcoding: .URL)
        apiManager.setQueryParam(LoginParam(email: "hoangcanhsek6@gmail.com", password: "Hoangcanh1").dictionary)
        let obserable: Observable<User?> = apiManager.requestObject()
        obserable.subscribe(onNext: { (item) in
            print("Success")
        }, onError: { (error) in
            print("Error \(error)")
        }).disposed(by: disposeBag)
    }
    
    
    func testAPIWithResponseArray() {
        let apiManager = RESTApiClient(subPath: "get_categories", functionName: "", method: .POST, endcoding: .JSON)
    
        let obserable: Observable<BaseCategory?> = apiManager.requestObject()
        obserable.subscribe(onNext: { (item) in
            print("Success")
        }, onError: { (error) in
            print("Error")
        }).disposed(by: disposeBag)
    }
    
    func testBoltsFlowWithRxSwift() {
        let testBoltsObservable = Observable<Any>.just("0")
        let continueTask = Observable<Any>.just("1")
        
        testBoltsObservable.continueWithSuccessClosure { (result) -> Observable<Any> in
            return testBoltsObservable
            }.continueWithSuccessClosure { (result) -> Observable<Any> in
                return continueTask
            }.subscribe(onNext: { (value) in
                print(value)
            }).disposed(by: disposeBag)
    }
    
    
    

}

class LoginParam: Codable {
    
    @objc var email: String = "hoangcanhsek6@gmail.com"
    @objc var password: String = "hoangcanh1"
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}


struct User: Codable {
    
    var token: String
    var firstName: String
    var lastName = ""
    var message = ""
    var email = ""
    var testOptionalVariable : String?

    enum UserKeys: String, CodingKey {
        case token
        case firstName = "fname"
        case lastName = "lname"
        case message
        case email
        case testOptionalVariable
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserKeys.self)
        token = try container.decode(String.self, forKey: .token)

        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        message = try container.decode(String.self, forKey: .message)
        email = try container.decode(String.self, forKey: .email)
        testOptionalVariable = try container.decodeIfPresent(String.self, forKey: .testOptionalVariable)


    }
}

struct BaseCategory: Codable {
    var categories: [Category]
    var status: Bool
    var message: String
//    enum NestedKeys: String, CodingKey {
//        case categories
//    }
//
//    public init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: NestedKeys.self)
//        categories = try values.con
//        category_name = try categoriesValue.decode(String.self, forKey: .category_name)
//    }
}

struct Category: Codable {
    var category_id: String?
    var category_name: String?
    
}
