//
//  ProfileViewController.swift
//  CFFA
//
//  Created by Cristian Bularu on 3/13/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class ProfileViewController: CustomViewController, StoryboardInstantiable {
    static var storyboardName: String = "ProfileViewController"
    
    @IBOutlet weak var profilePhotoImageView: CustomImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var circleIndicatorView: CustomView!
    @IBOutlet weak var postsCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    
    @IBOutlet var controllButtons: [UIButton]!
    
    @IBOutlet weak var controllStackView: UIStackView!
    @IBOutlet weak var indicatorLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bigCollectionView: UICollectionView!
    
    @IBOutlet weak var rightTopButton: UIButton! {
        didSet {
            rightTopButton.setImage(self.isVisiting ? #imageLiteral(resourceName: "moreIcon") : #imageLiteral(resourceName: "settingsIcon") , for: .normal)
        }
    }
    @IBOutlet weak var mainButton: CustomButton! {
        didSet {
            if self.isVisiting {
                mainButton.backgroundColor = UIColor.init(rgb: 0x522CB5)
                mainButton.setTitleColor(.white, for: .normal)
                mainButton.borderColor = .clear
            } else {
                mainButton.backgroundColor = .clear
                mainButton.setTitleColor(UIColor.init(rgb: 0x262628), for: .normal)
                mainButton.borderColor = UIColor(rgb: 0xE9E9ED)
            }
        }
    }
    
    private var isVisiting: Bool = false
    private var userId: String = ""
    //private var selectedControllTag = 0
    
    private var profileVisit: ProfileWithPosts? {
        didSet {
            DispatchQueue.main.async {
                self.nameLabel.text = self.profileVisit!.fullName
                self.postsCountLabel.text = "\(self.profileVisit!.postsCount)"
                self.followersCountLabel.text = "\(self.profileVisit!.subscribersCount)"
                self.followingCountLabel.text = "\(self.profileVisit!.subscriptionsCount)"
                PhotoManager.getImage(photoType: .ProfileIcon, photoName: "\(self.profileVisit!.id)", photoSize: .Original, extension: self.profileVisit!.extension ?? ".jpg") { (image, name, response, errors) in
                    DispatchQueue.main.async {
                        if image != nil {
                            self.profilePhotoImageView.image = image
                        }
                        self.bigCollectionView.reloadData()
                    }
                }
            }
        }
    }
    private var indexProfile: IndexProfileWithPosts? {
        didSet {
            DispatchQueue.main.async {
                self.nameLabel.text = self.indexProfile!.fullName
                self.postsCountLabel.text = "\(self.indexProfile!.postsCount)"
                self.followersCountLabel.text = "\(self.indexProfile!.subscribersCount)"
                self.followingCountLabel.text = "\(self.indexProfile!.subscriptionsCount)"
                PhotoManager.getImage(photoType: .ProfileIcon, photoName: "\(self.indexProfile!.id)", photoSize: .Original, extension: self.indexProfile!.extension ?? ".jpg") { (image, name, response, errors) in
                    DispatchQueue.main.async {
                        if image != nil {
                            self.profilePhotoImageView.image = image
                        }
                        self.bigCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    static func instantiateWith(userId: String, parentViewController: CustomViewController) -> ProfileViewController {
        let profileViewController = ProfileViewController.instantiate()
        profileViewController.parentCustomViewController = parentViewController
        profileViewController.canPushPost = parentViewController.canPushPost
        profileViewController.canPushProfile = false
        profileViewController.isVisiting = userId != UDefaults.authenInfo?.id
        profileViewController.userId = userId
        return profileViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        bigCollectionView.register(UINib(nibName: ProfileBigCell.identifier, bundle: nil), forCellWithReuseIdentifier: ProfileBigCell.identifier)
        fetch()
        
    }
    
    
    
    private func fetch() {
        if isVisiting {
            for btn in controllButtons {
                if btn.titleLabel!.text != "Posts" {
                    btn.isHidden = true
                }
            }
            UserActions.Guest(userId: userId) { (responseType, profile) in
                if responseType == .Ok {
                    self.profileVisit = profile
                    DispatchQueue.main.async {
                        self.mainButton.setTitle(profile!.subscribed ? "Unfollow" : "Follow", for: .normal)
                    }
                }
            }
        } else {
            self.mainButton.setTitle("Edit Profile", for: .normal)
            UserActions.Profile() { (responseType, profile) in
                if responseType == .Ok {
                    self.indexProfile = profile
                }
            }
        }
    }
    
    var onlyOnce = true
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if onlyOnce {
            let rectFirst = controllStackView.convert(controllButtons.first!.frame, to: self.view)
            let firstX  = rectFirst.origin.x + rectFirst.width/2 - circleIndicatorView.frame.width/2
            self.indicatorLeadingConstraint.constant = firstX
            onlyOnce = false
        }
    }
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func mainButtonAction(_ sender: UIButton) {
        guard UDefaults.authenInfo != nil else {return}//TODO: Inform about unauthentification
        if self.isVisiting {
            if self.profileVisit!.subscribed {
                UserActions.UnSubscribe(userId: self.profileVisit!.id) { (response) in
                    if response == .Ok {
                        DispatchQueue.main.async {
                            self.mainButton.setTitle("Follow", for: .normal)
                        }
                    }
                }
            } else {
                UserActions.Subscribe(userId: self.profileVisit!.id) { (response) in
                    if response == .Ok {
                        DispatchQueue.main.async {
                            self.mainButton.setTitle("Unfollow", for: .normal)
                        }
                    }
                }
            }
        } else {
            print("edit profile")
        }
    }
    
    @IBAction func controllAction(_ sender: UIButton) {
        for button in controllButtons {
            button.isSelected = false
        }
        sender.isSelected = true
        bigCollectionView.scrollToItem(at: IndexPath(row: sender.tag, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isVisiting ? 1 : 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileBigCell.identifier, for: indexPath) as! ProfileBigCell
        switch indexPath.row {
        case 0:
            if isVisiting {
                cell.setUp(self, postsSketches: postToRef(profileVisit?.posts))
            } else {
                cell.setUp(self, postsSketches: postToRef(indexProfile?.posts))
            }
        case 1:
            if !isVisiting {
                cell.setUp(self, postsSketches: postToRef(indexProfile?.favoritePosts))
            }
        default:
            if !isVisiting {
                cell.setUp(self, postsSketches: sketchToRef(indexProfile?.sketches))
            }
        }
        return cell
    }
    
    private func postToRef(_ posts: [PostOnly]?) -> [PostSketchRef] {
        var postsSketches = [PostSketchRef]()
        for post in posts ?? [PostOnly]() {
            postsSketches.append(PostSketchRef(post))
        }
        return postsSketches
    }
    
    private func sketchToRef(_ sketches: [Sketch]?) -> [PostSketchRef] {
        var postsSketches = [PostSketchRef]()
        for sketch in sketches ?? [Sketch]() {
            postsSketches.append(PostSketchRef(nil, sketch))
        }
        return postsSketches
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        for button in controllButtons {
            button.isSelected = false
        }
        let button = controllButtons.first { (button) -> Bool in
            return button.tag == currentPage
        }
        button?.isSelected = true
        self.indicatorLeadingConstraint.constant = calculateWidth(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.circleIndicatorView.frame = CGRect(origin: CGPoint(x: calculateWidth(scrollView), y: circleIndicatorView.frame.origin.y), size: circleIndicatorView.frame.size)
    }
    
    private func calculateWidth(_ scrollView: UIScrollView) -> CGFloat {
           let factor = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.bounds.width)
           
           let rectFirst = controllStackView.convert(controllButtons.first!.frame, to: self.view)
           let firstX  = rectFirst.origin.x + rectFirst.width/2 - circleIndicatorView.frame.width/2
           
           let rectLast = controllStackView.convert(controllButtons.last!.frame, to: self.view)
           let lastX  = rectLast.origin.x + rectLast.width/2 - circleIndicatorView.frame.width/2
           let diff = (lastX - firstX) * factor
           
           return firstX + diff
       }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 50, height: collectionView.frame.height)
    }
}
