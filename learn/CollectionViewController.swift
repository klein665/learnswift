//
//  CollectionViewController.swift
//  learn
//
//  Created by ByteDance on 7/11/25.
//

import Foundation
import UIKit

var itemList = item_list()
let sema = DispatchSemaphore(value: 0)
class CollectionViewController : UIViewController , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout
{
    lazy var collectionview: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        cv.backgroundColor = .systemBackground
        return cv
    }()
    let layout = UICollectionViewFlowLayout()
    var data : [item] = []
    let refresh = UIRefreshControl()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStub()
        setupview()
        self.loadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(data.count,10)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Mycell", for: indexPath) as! CollectionCell
        if indexPath.item < data.count
        {
            cell.setup(item: data[indexPath.item])
        }
        else
        {
            cell.setupdefault()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var p = CGSize()
        
        p.width = (collectionView.frame.width - 20)/2
        if indexPath.item < data.count
        {
            let imageHeight = p.width * (data[indexPath.item].cover_image.size.height / data[indexPath.item].cover_image.size.width)
            
            let titleFont = UIFont.systemFont(ofSize: 18)
            let authorFont = UIFont.systemFont(ofSize: 15)

            let labelheight = calculateLabelHeight(text: data[indexPath.item].title, font: titleFont) + calculateLabelHeight(text: data[indexPath.item].author_name, font: authorFont)
            p.height = imageHeight + labelheight
        }
        else
        {
            p.height = 200
        }
        return p
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detail = DetailVC()
        navigationController?.pushViewController(detail, animated: true)
    }
}
extension CollectionViewController{
    func loadData()
    {
        let dispatchGroup = DispatchGroup()
        recfrominet(dispatchgroup: dispatchGroup)
        sema.wait()
        print("itemList.Sum = \(itemList.Sum)")
        for ts in 0..<itemList.Sum
        {
            let item_index = itemList.ilist[ts] as! [String : Any]
            let title = item_index["title"] as! String
            let author = item_index["author"] as? [String : Any]
            let author_name = author?["name"]
            let cover_url = item_index["cover_url"] as! String
            let cover_width = item_index["cover_width"] as! CGFloat
            let cover_height = item_index["cover_height"] as! CGFloat
            let url = URL(string: cover_url)!
            dispatchGroup.enter()
            URLSession.shared.dataTask(with: url) { data, response, error in
                print("self.data.count = \(self.data.count)")
                defer{dispatchGroup.leave()}
                if let data = data, let image = UIImage(data: data) {
                    var itemd = item(title: title, author_name: author_name as! String, cover_url: cover_url, cover_image: image, cover_width: cover_width, cover_height: cover_height)
                    DispatchQueue.main.async {
                        self.data.append(itemd)
                        print("self.data.count = \(self.data.count)")
                    }
                }
            }.resume()
        }
        dispatchGroup.notify(queue: .main)
        {
            self.collectionview.reloadData()
        }
    }

    func setupview()
    {
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionview = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.register(CollectionCell.self, forCellWithReuseIdentifier: "Mycell")
        refresh.addTarget(self, action: #selector(refreshdata), for: .valueChanged)
        collectionview.refreshControl = refresh
        view.addSubview(collectionview)
    }
    @objc func refreshdata()
    {
        self.data = []
        self.loadData()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5)
        {
            self.collectionview.refreshControl?.endRefreshing()
            self.collectionview.reloadData()
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y;
        let contentheight = scrollView.contentSize.height;
        let visableheight = scrollView.frame.size.height;
        if offsetY > contentheight - visableheight - 10
        {
            loadData()
        }
    }
    func calculateLabelHeight(text: String, font: UIFont) -> CGFloat {
        let maxWidth = self.collectionview.frame.size.width/2 - 20
        let constraintSize = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)

        let boundingBox = text.boundingRect(
            with: constraintSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )

            return ceil(boundingBox.height)
        }
}

