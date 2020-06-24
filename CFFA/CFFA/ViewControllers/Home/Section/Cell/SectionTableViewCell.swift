//
//  SectionTableViewCell.swift
//  CFFA
//
//  Created by Cristian Bularu on 3/2/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class SectionTableViewCell: UITableViewCell {
    static let identifier = "SectionTableViewCell"
    
    @IBOutlet weak var profileViewForTap: UIView!
    
    @IBOutlet weak private var profileIcon: CustomImageView!
    @IBOutlet weak private var profileName: UILabel!
    @IBOutlet weak private var timeLabel: UILabel!
    @IBOutlet weak private var postImageView: CustomImageView!
    @IBOutlet weak private var postTitleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    
    @IBOutlet weak private var upVotesLabel: UILabel!
    @IBOutlet weak private var downVotesLabel: UILabel!
    //@IBOutlet weak private var commentsLabel: UILabel!
    
    @IBOutlet weak private var favoriteButton: UIButton!
    @IBOutlet weak private var upVoteButton: UIButton!
    @IBOutlet weak private var downVoteButton: UIButton!
    
    private var post: PostFullRef!
    private var presenter: CustomViewController!
    
    func setUp(post: PostFullRef, presenter: CustomViewController) {
        self.post = post
        self.presenter = presenter
        
        self.profileName.text = "\(post.post.user.fullName)"
        self.timeLabel.text = post.post.creationTime.description
        self.postTitleLabel.text = post.post.title
        self.descriptionLabel.text = post.post.bodyText
        self.upVotesLabel.text = "\(post.post.underPost.upVotes)"
        self.downVotesLabel.text = "\(post.post.underPost.downVotes)"
        //self.commentsLabel.text = "\(post.post.underPost.comments)"
        self.favoriteButton.isSelected = post.post.underPost.favorite ?? false
        
        self.upVoteButton.isSelected = post.post.underPost.viewerVote == true
        self.downVoteButton.isSelected = post.post.underPost.viewerVote == false
        let nameIn1 = self.post.post.user.id
        PhotoManager.getImage(photoType: .ProfileIcon, photoName: nameIn1, photoSize: .Small, extension: self.post.post.user.extension ?? ".jpg") { (image, nameOut1, response, error) in
            DispatchQueue.main.async {
                if image != nil && nameIn1 == nameOut1 {
                    self.profileIcon.image = image
                }
            }
        }
        let nameIn2 = "\(post.post.id)"
        PhotoManager.getImage(photoType: .PostPhoto, photoName: nameIn2, photoSize: .Original, extension: post.post.extension ?? ".jpg") { (image, nameOut2, response, error) in
            DispatchQueue.main.async {
                if image != nil && nameIn2 == nameOut2 {
                    self.postImageView.image = image
                }
            }
        }
    }
    
    @IBAction func tapOpenPost() {
        PostActions.PostGet(postId: post.post.id) { (responseType, post) in
            if responseType == .Ok {
                DispatchQueue.main.async {
                    let postViewController = PostViewController.instantiateWith(post: post!, parentViewController: self.presenter)
                    self.presenter.seekToPush(viewController: postViewController)
                }
            }
        }
    }
    
    @IBAction private func moreAction() {
        print("open more menu")
        //TODO: presenter present upRise menu
    }
    
    @IBAction private func profileClick() {
        let profileViewController = ProfileViewController.instantiateWith(userId: post.post.user.id, parentViewController: self.presenter)
        self.presenter.seekToPush(viewController: profileViewController)
    }
    
    @IBAction private func upVote(_ sender: UIButton) {
        if !sender.isSelected {
            PostActions.UpVote(postId: post.post.id) { (response) in
                if response == .Ok {
                    DispatchQueue.main.async {
                        sender.isSelected = true
                        self.post.post.underPost.viewerVote = true
                        self.post.post.underPost.upVotes += 1
                        self.upVotesLabel.text?.increment()
                        if self.downVoteButton.isSelected {
                            self.post.post.underPost.downVotes -= 1
                            self.downVotesLabel.text?.decrement()
                            self.downVoteButton.isSelected = false
                        }
                    }
                }
            }
        }
    }
    
    @IBAction private func downVote(_ sender: UIButton) {
        if !sender.isSelected {
            PostActions.DownVote(postId: post.post.id) { (response) in
                if response == .Ok {
                    DispatchQueue.main.async {
                        sender.isSelected = true
                        self.post.post.underPost.viewerVote = false
                        self.post.post.underPost.downVotes += 1
                        self.downVotesLabel.text?.increment()
                        if self.upVoteButton.isSelected {
                            self.post.post.underPost.upVotes -= 1
                            self.upVotesLabel.text?.decrement()
                            self.upVoteButton.isSelected = false
                        }
                    }
                }
            }
        }
    }
    
//    @IBAction private func openComments() {
//        //TODO: presenter push CommentsOnly
//    }
    
    @IBAction private func favorite(_ sender: UIButton) {
        if !self.favoriteButton.isSelected {
            PostActions.Favorite(postId: post.post.id) { (response) in
                if response == .Ok {
                    DispatchQueue.main.async {
                        self.post.post.underPost.favorite = true
                        self.favoriteButton.isSelected = true
                    }
                }
            }
        } else {
            PostActions.UnFavorite(postId: post.post.id) { (response) in
                if response == .Ok {
                    DispatchQueue.main.async {
                        self.post.post.underPost.favorite = false
                        self.favoriteButton.isSelected = false
                    }
                }
            }
        }
    }
    
    func dasdasda() {
        
    }
    
    @IBAction func tryIt() {
        //TODO: call sketch Copy Generator
        SketchCopyViewController.instanciateWith(sketchId: post.post.sketch.id, ext: post.post.sketch.extension, presentOn: presenter)

//        let sketchCopyView = SketchCopyInputView.instanciateWith(presenter: self.presenter) { (leafs, height) in
//            PdfManager.getPdfData(sketchId: 30, leafs: 30, height: 30) { (data) in
//                DispatchQueue.main.async {
//                    let pdfViewController = PdfViewController.instantiateWith(pdfData: data)
//                    self.presenter.present(pdfViewController, animated: true)
//                }
//            }
//        }
//        let popUpViewController = ReusablePopUpViewController.instantiateWith(sketchCopyView, autoDismiss: false)
//        self.presenter.present(popUpViewController, animated: false)
    }
}
