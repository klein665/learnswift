//
//  stub.swift
//  learn url
//
//  Created by ByteDance on 7/9/25.
//

import Foundation
import OHHTTPStubs
import OHHTTPStubsSwift

var indext : Int = 3;
func setupStub() {
    // 注册拦截器
    stub(condition: isHost("test.com") ) { _ in
        indext = (indext )%5+1
        var res = "t" + String(indext)
        print(res)
        let stubPath = Bundle.main.path(forResource: res, ofType: "json")!
        return HTTPStubsResponse(fileAtPath: stubPath, statusCode: 200, headers: ["Content-Type": "application/json"])
    }
}
