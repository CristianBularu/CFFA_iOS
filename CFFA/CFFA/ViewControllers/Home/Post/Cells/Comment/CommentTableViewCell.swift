//
//  CommentTableViewCell.swift
//  CFFA
//
//  Created by Cristian Bularu on 3/3/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    static let identifier = "CommentTableViewCell"
    static let minHeight = 30 + 20 + 20

    @IBOutlet weak var upVotes: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var creationTime: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileIcon: CustomImageView!
    private var comment: CommentRef!
    private var profileHandler: (()->())?
    
    func setUp(initial: CommentRef, complition: @escaping(()->())) {
        self.comment = initial
        self.profileHandler = complition
        
        self.profileName.text = comment.comment.user.fullName
        self.creationTime.text = comment.comment.creationTime.description
        self.descriptionLabel.text = comment.comment.bodyText
        if comment.comment.viewerVoted == true {
            self.upVotes.isUserInteractionEnabled = false
            self.upVotes.setTitle("Upvoted (\(comment.comment.upVotes))", for: .normal)
        } else {
            self.upVotes.setTitle("Upvote (\(comment.comment.upVotes))", for: .normal)
        }
        let nameIn = self.comment.comment.user.id
        PhotoManager.getImage(photoType: .ProfileIcon, photoName: nameIn, photoSize: .Small, extension: self.comment.comment.user.extension ?? ".jpg") { (image, nameOut, response, error) in
            DispatchQueue.main.async {
                if nameIn == nameOut {
                    if image != nil {
                        self.profileIcon.image = image ?? #imageLiteral(resourceName: "illustrationAddPhoto")
                    } else {
                        self.profileIcon.image = #imageLiteral(resourceName: "illustrationAddPhoto")
                    }
                }
            }
        }
    }
    
    @IBAction func openProfile() {
        profileHandler?()
    }
    
    @IBAction func upVote() {
        CommentActions.UpVote(commentId: comment.comment.commentId) { (responseType) in
            if responseType == .Ok {
                DispatchQueue.main.async {
                    self.comment.comment.upVotes += 1
                    self.upVotes.setTitle("Upvoted (\(self.comment.comment.upVotes))", for: .normal)
                    self.upVotes.isUserInteractionEnabled = false
                }
            }
        }
    }
}
