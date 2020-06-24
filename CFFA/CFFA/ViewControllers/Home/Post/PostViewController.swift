//
//  PostViewController.swift
//  CFFA
//
//  Created by Cristian Bularu on 3/3/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class PostViewController: CustomViewController, StoryboardInstantiable {
    static var storyboardName: String = "PostViewController"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var sendCommentButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tappableView: UIView!
    private var commentsRef: [CommentRef]!
    private var postRef: PostFullWithCommentsRef!
    private var post: PostFullWithComments! {
        didSet {
            self.postRef = PostFullWithCommentsRef(post)
            self.commentsRef = [CommentRef]()
            for comment in post.comments ?? [Comment]() {
                self.commentsRef.append(CommentRef(comment))
            }
        }
    }
    
    static func instantiateWith(post:PostFullWithComments, parentViewController: CustomViewController) -> PostViewController {
        let postViewController = PostViewController.instantiate()
        postViewController.parentCustomViewController = parentViewController
        postViewController.canPushProfile = parentViewController.canPushProfile
        postViewController.canPushPost = false
        postViewController.post = post
        return postViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTextView.delegate = self
        registerCells()
        addKeyboardObservers(constraint: bottomConstraint)
    }
    
    deinit {
        removeObservers()
    }
    
    @IBAction func sendComment() {
        CommentActions.Create(postId: postRef.post.id, bodyText: commentTextView.text) { (responseType, errors) in
            if responseType == .Ok {
                DispatchQueue.main.async {
                    self.commentTextView.text = ""
                    self.isEmpty = true
                    PostActions.PostGet(postId: self.postRef.post.id) { (response, post) in
                        if response == .Ok {
                            DispatchQueue.main.async {
                                self.post = post
                                self.tableView.reloadData()
                                let lastIndexPath = IndexPath(row: self.commentsRef.count-1, section: 1)
                                self.tableView.scrollToRow(at: lastIndexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
        commentTextView.resignFirstResponder()
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapOutSide(_ sender: Any) {
        commentTextView.resignFirstResponder()
    }
    
    fileprivate func registerCells() {
        self.tableView.register(UINib(nibName: PostTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PostTableViewCell.identifier)
        self.tableView.register(UINib(nibName: UnderPostTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: UnderPostTableViewCell.identifier)
        self.tableView.register(UINib(nibName: CommentTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CommentTableViewCell.identifier)
    }
    var isEmpty = true {
        didSet {
            if isEmpty {
                sendCommentButton.isEnabled = false
            } else {
                sendCommentButton.isEnabled = true
            }
        }
    }
}

extension PostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        tappableView.isHidden = false
        if isEmpty {
            textView.text = ""
            textView.textColor = UIColor(rgb: 0x262628)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            isEmpty = true
        } else {
            isEmpty = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        tappableView.isHidden = true
        if (textView.text ?? "") == "" {
            textView.text = "Write a comment..."
            textView.textColor = UIColor(rgb: 0xAAAAAA)
            isEmpty = true
        } else {
            isEmpty = false
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == "" || textView.text.last == "\n"{
            if text == "\n" {
                return false
            }
        }
        return true
    }
}

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return commentsRef.count
//        return postRef.post.underPost.comments
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier)!
                (cell as! PostTableViewCell).setUp(post: postRef)
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: UnderPostTableViewCell.identifier)!
                (cell as! UnderPostTableViewCell).setUp(presenter: self, initial: postRef, moreHandler: {
                    print("Open More")
                }, profileHandler: {
                    let profileViewController = ProfileViewController.instantiateWith(userId: self.postRef.post.user.id, parentViewController: self)
                    self.seekToPush(viewController: profileViewController)
                })
            }
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier)!
            (cell as! CommentTableViewCell).setUp(initial: commentsRef[indexPath.row]) {
                let profileViewController = ProfileViewController.instantiateWith(userId: self.commentsRef[indexPath.row].comment.user.id, parentViewController: self)
                self.seekToPush(viewController: profileViewController)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return tableView.frame.width
            } else {
                let height = postRef.post.bodyText?.height(withConstrainedWidth: tableView.frame.width - 50, font: UIFont.systemFont(ofSize: 15)) ?? 0
                return CGFloat(UnderPostTableViewCell.minHeight) + height
            }
        } else {
            let height = commentsRef[indexPath.row].comment.bodyText.height(withConstrainedWidth: tableView.frame.width - 95, font: UIFont.systemFont(ofSize: 15))
            return CGFloat(CommentTableViewCell.minHeight) + height
        }
    }
    
}
