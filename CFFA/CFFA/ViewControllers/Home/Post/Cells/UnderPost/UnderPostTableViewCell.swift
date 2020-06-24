//
//  UnderPostTableViewCell.swift
//  CFFA
//
//  Created by Cristian Bularu on 3/3/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class UnderPostTableViewCell: UITableViewCell {
    static let identifier = "UnderPostTableViewCell"
    static let minHeight = 75+20+70
    
    //@IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var downVotesLabel: UILabel!
    @IBOutlet weak var upVotesLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var downVoteButton: UIButton!
    @IBOutlet weak var upVoteButton: UIButton!
    
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var creationTime: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileIcon: CustomImageView!
    private var presenter: UIViewController!
    private var moreHandler: (()->())?
    private var profileHandler: (()->())?
    private var post: PostFullWithCommentsRef!
    
    func setUp(presenter: UIViewController, initial: PostFullWithCommentsRef, moreHandler: @escaping(()->()), profileHandler: @escaping(()->())) {
        self.moreHandler = moreHandler
        self.profileHandler = profileHandler
        self.post = initial
        self.presenter = presenter
                
        self.profileName.text = post.post.user.fullName
        self.creationTime.text = post.post.creationTime.description
        self.postTitleLabel.text = post.post.title
        self.descriptionLabel.text = post.post.bodyText
        self.upVotesLabel.text = "\(post.post.underPost.upVotes)"
        self.downVotesLabel.text = "\(post.post.underPost.downVotes)"
        //self.commentsLabel.text = "\(post.post.underPost.comments)"
        self.favoriteButton.isSelected = post.post.underPost.favorite ?? false
        
        self.upVoteButton.isSelected = post.post.underPost.viewerVote == true
        self.downVoteButton.isSelected = post.post.underPost.viewerVote == false
        let nameIn = self.post.post.user.id
        PhotoManager.getImage(photoType: .ProfileIcon, photoName: nameIn, photoSize: .Small, extension: self.post.post.user.extension ?? ".jpg") { (image, nameOut, response, error) in
            DispatchQueue.main.async {
                if image != nil && nameIn == nameOut {
                    self.profileIcon.image = image
                }
            }
        }
    }
    
    @IBAction func pushProfile() {
        profileHandler?()
    }
    
    @IBAction func moreAction() {
        moreHandler?()
    }
    
    @IBAction func upVote() {
        if !upVoteButton.isSelected {
            PostActions.UpVote(postId: post.post.id) { (response) in
                if response == .Ok {
                    DispatchQueue.main.async {
                        self.upVoteButton.isSelected = true
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
    
    @IBAction func downVote() {
        if !downVoteButton.isSelected {
            PostActions.DownVote(postId: post.post.id) { (response) in
                if response == .Ok {
                    DispatchQueue.main.async {
                        self.downVoteButton.isSelected = true
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
    
//    @IBAction func comment() {
//
//    }
    
    @IBAction func favorite() {
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
    
    @IBAction func tryIt() {
        SketchCopyViewController.instanciateWith(sketchId: post.post.sketch.id, ext: post.post.sketch.extension, presentOn: presenter)
    }
}
