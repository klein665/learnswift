//
//  DetailVC.swift
//  learn
//
//  Created by ByteDance on 7/18/25.
//

import Foundation
import UIKit
class DetailVC : UIViewController
{

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let imageView = UIImageView(frame: CGRect(x: 50, y: 100, width: 300, height: 600))
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "xhs")
        view.addSubview(imageView)

    }

}
