//
//  ProfileBigCell.swift
//  CFFA
//
//  Created by Cristian Bularu on 3/14/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class ProfileBigCell: UICollectionViewCell {
    static let identifier = "ProfileBigCell"

    @IBOutlet weak var collectionView: UICollectionView!
//    private var postOnly: [PostOnly]!
//    private var sketches: [Sketch]!
    private var postsSketches: [PostSketchRef]!
    private var presenter: CustomViewController!
    
    //private var displayingPosts = true
    
    private var isPosts: Bool = true
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUp(_ presenter: CustomViewController, postsSketches: [PostSketchRef], _ displayingPosts: Bool = true) {
        self.presenter = presenter
        self.postsSketches = postsSketches
        
        
        collectionView.register(UINib(nibName: ProfileSmallCell.identifier, bundle: nil), forCellWithReuseIdentifier: ProfileSmallCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
}

extension ProfileBigCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let post = postsSketches[indexPath.row].post {
            PostActions.PostGet(postId: post.id) { (responseType, postFull) in
                if responseType == .Ok {
                    DispatchQueue.main.async {
                        let postViewController = PostViewController.instantiateWith(post: postFull!, parentViewController: self.presenter)
                        self.presenter.seekToPush(viewController: postViewController)
                    }
                }
            }
        }
        if let sketch = postsSketches[indexPath.row].sketch {
            SketchCopyViewController.instanciateWith(sketchId: sketch.id, ext: sketch.extension, presentOn: presenter)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsSketches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileSmallCell.identifier, for: indexPath) as! ProfileSmallCell
        cell.setUp(postsSketches[indexPath.row])
        return cell
    }
}
extension ProfileBigCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 28)/3, height: (collectionView.frame.width - 28)/3)
    }
}
