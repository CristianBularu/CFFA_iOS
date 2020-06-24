//
//  SectionViewController.swift
//  CFFA
//
//  Created by Cristian Bularu on 3/2/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

class SectionViewController: CustomViewController, StoryboardInstantiable {
    static var storyboardName: String = "SectionViewController"
    @IBOutlet weak var tableView: UITableView!
    
    private var postsRef: [PostFullRef]!
    
    private var posts: [PostFull]! {
        didSet {
            self.postsRef = [PostFullRef]()
            for post in posts {
                postsRef.append(PostFullRef(post))
            }
        }
    }
    private var sectionTitle = "Posts"
    
    static func instantiateWith(sectionTitle text: String, posts: [PostFull], pushOn: UIViewController) {
        let sectionViewController = SectionViewController.instantiate()
        sectionViewController.posts = posts
        sectionViewController.sectionTitle = text
        pushOn.navigationController?.pushViewController(sectionViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: SectionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SectionTableViewCell.identifier)
    }

    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SectionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsRef.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SectionTableViewCell.identifier) as! SectionTableViewCell
        cell.setUp(post: postsRef![indexPath.row], presenter: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190 + self.view.frame.width - 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.width, height: 60)))
        view.backgroundColor = .white
        let label = UILabel(frame: view.frame)
        label.text = self.sectionTitle
        label.textColor = .black
        label.font = label.font.withSize(14)
        label.textAlignment = .center
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}
