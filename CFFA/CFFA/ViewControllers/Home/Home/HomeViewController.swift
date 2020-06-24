//
//  HomeViewController.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/27/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class HomeViewController: CustomViewController, StoryboardInstantiable {
    static var storyboardName: String = "HomeViewController"

    @IBOutlet weak var tableView: UITableView!
    private var headerHeight:CGFloat = 60
    private var cellHeight: CGFloat = 0
    private var singleCellWidth: CGFloat = 0
    
    private var data: HomeThreads? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var beforeWillAppearComplition: (()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UDefaults.finishedBoarding {
            self.navigationController?.pushViewController(AlphaViewController.instantiate(), animated: false)
        }
        super.viewDidLoad()
        
        self.singleCellWidth = (self.view.frame.width - 65)/2.2
        self.cellHeight = singleCellWidth  * 155/140 + 57
        
        self.tableView.register(UINib(nibName: TopHeaderTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TopHeaderTableViewCell.identifier)
        self.tableView.register(UINib(nibName: SectionHeaderTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SectionHeaderTableViewCell.identifier)
        self.tableView.register(UINib(nibName: HomeCollectionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HomeCollectionTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        beforeWillAppearComplition?()
        beforeWillAppearComplition = nil
        fetch()
        super.viewWillAppear(animated)
    }
    
    func fetch() {
        let indicator = startIndicator()
        HomeActions.Threads { (responseType, homeThreads) in
            DispatchQueue.main.async {
                self.stopIndicator(loadingView: indicator)
                if responseType == .Ok {
                    self.data = homeThreads
                }
            }
        }
    }
    
    @IBAction func addSketch() {
        let upRiseMenuView = UpRiseMenuView.instantiateWith(infoText: "Create sketch", button1Text: "Customize", button2Text: "Choose from galery", button1Handler: {
            let sketchCustomizeViewController = SketchCustomizeViewController.instantiate()
            self.navigationController?.pushViewController(sketchCustomizeViewController, animated: true)
        }) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .savedPhotosAlbum
            self.present(imagePicker, animated: true)
        }
        UpRiseViewController.instantiateWith(upRiseMenuView, presentOn: self)
    }
}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        picker.dismiss(animated: true) {
            SketchFromImageViewController.instantiateWith(image, presentOn: self)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TopHeaderTableViewCell.identifier, for: indexPath) as! TopHeaderTableViewCell
            cell.setUp(path: nil, profileHandler: {
                print("profile")
                let profileViewController = ProfileViewController.instantiateWith(userId: UDefaults.authenInfo!.id, parentViewController: self)
                self.seekToPush(viewController: profileViewController)
            }, searchHandler: {
                print("search")
            }) {
                print("notif")
            }
            return cell
        }
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SectionHeaderTableViewCell.identifier, for: indexPath) as! SectionHeaderTableViewCell
            switch indexPath.section {
            case 1:
                cell.setUp(title: "Popular") {
                    HomeActions.Popular { (responseType, posts) in
                        if responseType == .Ok && posts != nil && posts?.count != 0 {
                            DispatchQueue.main.async {
                                SectionViewController.instantiateWith(sectionTitle: "Popular", posts: posts!, pushOn: self)
                            }
                        }
                    }
                }
            case 2:
                cell.setUp(title: "Fresh") {
                    HomeActions.Fresh { (responseType, posts) in
                        if responseType == .Ok && posts != nil && posts?.count != 0 {
                            DispatchQueue.main.async {
                                SectionViewController.instantiateWith(sectionTitle: "Fresh", posts: posts!, pushOn: self)
                            }
                        }
                    }
                }
            default:
                cell.setUp(title: "Feed") {
                    HomeActions.Feed { (responseType, posts) in
                        if responseType == .Ok && posts != nil && posts?.count != 0 {
                            DispatchQueue.main.async {
                                SectionViewController.instantiateWith(sectionTitle: "Feed", posts: posts!, pushOn: self)
                            }
                        }
                    }
                }
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeCollectionTableViewCell.identifier, for: indexPath) as! HomeCollectionTableViewCell
        
        switch indexPath.section {
        case 1:
            cell.setUp(posts: data?.popular ?? [PostOnly](), presenter: self)
        case 2:
            cell.setUp(posts: data?.fresh ?? [PostOnly](), presenter: self)
        default:
            cell.setUp(posts: data?.feed ?? [PostOnly](), presenter: self)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 1 ? cellHeight : headerHeight
    }
}
