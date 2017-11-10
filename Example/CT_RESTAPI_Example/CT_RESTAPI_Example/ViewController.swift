//
//  ViewController.swift
//  CT_RESTAPI
//
//  Created by thcanh on 3/2/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper
import SwiftyJSON
import CT_RESTAPI

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        testAPI()
        testBoltsFlowWithRxSwift()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func testAPI() {
        let apiManager = RESTApiClient(subPath: "login", functionName: "", method: .POST, endcoding: .JSON)
        let loginParam = LoginParam(email: "abcdef@gmail.com", password: "abccba!1")
        apiManager.setQueryParam(loginParam)
        let obserable: Observable<User?> = apiManager.requestObject(keyPath: nil)
        obserable.subscribe(onNext: { (user) in
            guard let user = user else { return }
            print("Success: ", user)
        }, onError: { (error) in
            print("Error: ", error)
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

class LoginParam: RESTParam {
    
    var email: String = "hoangcanhsek6@gmail.com"
    var password: String = "hoangcanh1"
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
        super.init()
    }
    
    required convenience init?(map: Map) {
        fatalError("init(map:) has not been implemented")
    }
    
    
    override open func mapping(map: Map) {
        super.mapping(map: map)
        self.email      <- map["email"]
        self.password   <- map["password"]
    }
}

struct Item: Mappable {
    private enum Key: String, CTAlamofireKey {
        case id, name
    }
    
    var id: Int = 0
    var name: String = ""
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map[Key.id]
        name <- map[Key.name]
    }
}

extension Optional {
    var isNotNil: Bool {
        switch self {
        case .none:
            return false
        default:
            return true
        }
    }
    
    var isNil: Bool {
        switch self {
        case .none:
            return true
        default:
            return false
        }
    }
}

struct Category: CTMappable {
    
    private enum Key: String, CTAlamofireKey {
        case id, name
    }
    
    let id: Int
    let name: String
    
    init?(json: JSON) {
        guard json[Key.id].int.isNotNil
            && json[Key.name].string.isNotNil else {
                return nil
        }
        
        self.id = json[Key.id].intValue
        self.name = json[Key.name].stringValue
    }
}

class User: Mappable {
    
    @objc dynamic var email = ""
    @objc dynamic var birthday = ""
    @objc dynamic var fname = ""
    @objc dynamic var lname = ""
    @objc dynamic var password = ""
    @objc dynamic var token = ""
    @objc dynamic var id = ""
    @objc dynamic var phone = ""
    @objc dynamic var gender = ""
    @objc dynamic var notification_levels = ""
    @objc dynamic var status = ""
    @objc dynamic var image = ""
    @objc dynamic var category_id = ""
    @objc dynamic var created = ""
    @objc dynamic var last_login = 0
    @objc dynamic var is_active = ""
    @objc dynamic var ip = ""
    @objc dynamic var date_activation_link_sent = ""
    @objc dynamic var sport = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        email                       <- map["email"]
        birthday                    <- map["birthday"]
        sport                       <- map["sport"]
        lname                       <- map["lname"]
        fname                       <- map["fname"]
        token                       <- map["token"]
        id                          <- map["id"]
        image                       <- map["image"]
        category_id                 <- map["category_id"]
        phone                       <- map["phone"]
        gender                      <- map["gender"]
        created                     <- map["created"]
        is_active                   <- map["is_active"]
        status                      <- map["status"]
        last_login                  <- map["last_login"]
        ip                          <- map["ip"]
        password                    <- map["password"]
        notification_levels         <- map["notification_levels"]
        date_activation_link_sent   <- map["date_activation_link_sent"]
        
    }
    
    func compareValueWith(user: User) -> Bool {
        return self.fname == user.fname
            && self.lname == user.lname
            && self.birthday == user.birthday
            && self.category_id == user.category_id
            && self.gender == user.gender
    }
    
}
