//
//  Model.swift
//  learn
//
//  Created by ByteDance on 7/9/25.
//

import Foundation
import UIKit
struct item_list
{
    var ilist : [[String : Any]] = [[:]]
    var index : Int = 0
    var Sum : Int = 0
}

struct item
{
    let title : String
    let author_name : String
    let cover_url : String
    let cover_image : UIImage
    let cover_width : CGFloat
    let cover_height : CGFloat
}

func recfrominet(dispatchgroup : DispatchGroup)
{
    dispatchgroup.enter()
    let url = URL(string: "https://test.com/1")!
    indext = indext + 1
    let urlseesion = URLSession.shared.dataTask(with: url){ data, response, error in
        defer{dispatchgroup.leave()}
        guard let data = data else{ print("error") ;return}
        let jstring = String(data: data, encoding: .utf8)
        do{
            let json = try? JSONSerialization.jsonObject(with: data) as? [String : Any]
            
            let data = json?["data"] as? [String : Any]
            let iteml = data?["item_list"] as? [[String : Any]]
            itemList.ilist = iteml!
            itemList.index = 0
            print("index = \(itemList.index)")
            itemList.Sum = itemList.ilist.count
            print("Sum = \(itemList.Sum)")
            sema.signal()
        }
    }.resume()
}

