//
//  HomeCollectionTableViewCell.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/26/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class HomeCollectionTableViewCell: UITableViewCell {
    static let identifier = "HomeCollectionTableViewCell"

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var blockingView: UIView!
    var presenter: CustomViewController!
    
    var posts: [PostOnly]! {
        didSet {
            collectionView.reloadData()
            blockingView.isHidden = posts.count != 0 
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUp(posts: [PostOnly], presenter: CustomViewController) {
        self.presenter = presenter
        collectionView.delegate = self
        collectionView.dataSource =  self
        self.posts = posts
        collectionView.register(UINib(nibName: HomeCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
    }
}

extension HomeCollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
//        cell.setUp(post: posts[indexPath.row])
        cell.setUp(post: posts[indexPath.row], width: Double((self.frame.width - 65)/2.2))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
//        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        PostActions.PostGet(postId: posts[indexPath.row].id) { (responseType, post) in
            if responseType == .Ok {
                DispatchQueue.main.async {
                    let postViewController = PostViewController.instantiateWith(post: post!, parentViewController: self.presenter)
                    self.presenter.seekToPush(viewController: postViewController)
                }
            }
        }
    }
}

extension HomeCollectionTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.frame.width - 65)/2.2, height: self.frame.height-25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0,
                                 left: 25,
                                 bottom: 25,
                                 right: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
