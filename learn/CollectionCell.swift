//
//  CollectionCell.swift
//  learn
//
//  Created by ByteDance on 7/11/25.
//

import Foundation
import UIKit
import SnapKit

class CollectionCell : UICollectionViewCell{
    
    let titleLabel = UILabel()
    let ima = UIImageView()
    let authorl = UILabel()
    func setupview()
    {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
        authorl.font = UIFont.boldSystemFont(ofSize: 15)
        authorl.translatesAutoresizingMaskIntoConstraints = false
        ima.contentMode = .scaleAspectFill
        ima.clipsToBounds = true
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(ima)
        contentView.addSubview(authorl)
        
        ima.snp.makeConstraints{
            make in make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(contentView).offset(-32)
            make.height.equalTo(contentView).multipliedBy(0.75)
        }
        titleLabel.snp.makeConstraints{
            make in
            make.top.equalTo(ima.snp.bottom).offset(10)
            make.leading.equalTo(ima)
            make.trailing.equalTo(contentView).offset(-10)
        }
        authorl.snp.makeConstraints
        {
            make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(ima)
            make.trailing.equalTo(contentView).offset(-10)
        }
    }
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CollectionCell
{
    func setupdefault()
    {
        self.titleLabel.text = ""
        self.authorl.text = ""
        let image = UIImage(named: "kldl")!
        self.ima.image = image
        self.ima.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(self.contentView).offset(-32)
            let ratio = image.size.height / image.size.width
            make.height.lessThanOrEqualTo(self.ima.snp.width).multipliedBy(ratio)
        }
    }
    func setup(item : item)
    {
        self.titleLabel.text = item.title
        self.authorl.text = item.author_name
        self.ima.image = item.cover_image
        self.ima.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(self.contentView).offset(-32)
            let ratio = item.cover_image.size.height / item.cover_image.size.width
            make.height.lessThanOrEqualTo(self.ima.snp.width).multipliedBy(ratio)
        }
        
        if let tableView = self.superview as? UITableView {
            UIView.performWithoutAnimation {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
    }
}
