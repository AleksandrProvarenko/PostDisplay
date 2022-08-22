//
//  PostDetailsViewController.swift
//  PostsDisplay
//
//  Created by Alex Provarenko on 01.08.2022.
//

import UIKit

class PostDetailsViewController: UIViewController {
    
    var viewModel = IdPostViewModel()
    var posts: PostMain?
    

    var imageHeaderView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    var  titleLabelDetails: UILabel = {
        let label = UILabel()
        label.text = "Alex Provarenko"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    var postTextDetailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "When we think of famous bands, we have an image of each member’s distinctive roles. More often than not, every member has clearly defined roles that they stick to from beginning to end."
        label.tintColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    
    var likeCountLabel: UILabel = {
        let likeLabel = UILabel()
        likeLabel.translatesAutoresizingMaskIntoConstraints = false
        likeLabel.text = "33"
        likeLabel.font = .systemFont(ofSize: 16, weight: .regular)
        likeLabel.textColor = .systemGray
        return likeLabel
    }()
    
    var dateCountLabel: UILabel = {
        let dateCount = UILabel()
        dateCount.translatesAutoresizingMaskIntoConstraints = false
        dateCount.text = "25 days ago"
        dateCount.font = .systemFont(ofSize: 16, weight: .regular)
        dateCount.textColor = .systemGray
        return dateCount
    }()
    
    var scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Post Details"
        view.addSubview(scrollView)
        scrollView.addSubview(imageHeaderView)
        scrollView.addSubview(titleLabelDetails)
        scrollView.addSubview(postTextDetailsLabel)
        scrollView.addSubview(likeButton)
        scrollView.addSubview(likeCountLabel)
        scrollView.addSubview(dateCountLabel)
    
        configureConstraints()
        setupScrollView()
        configureButtons()
        
        viewModel.postIdViewModel(postId: posts!.postID ) { post in
            DispatchQueue.main.async {
                self.setPost(posts: post)
            }
        }
        
    }
    
    func setPost(posts: PostId) {
        titleLabelDetails.text = posts.title
        postTextDetailsLabel.text = posts.text
        dateCountLabel.text = posts.curentDate

        let url = URL(string: posts.postImage)
        if let data = try? Data(contentsOf: url!) {
            imageHeaderView.image = UIImage(data: data)
        }

        if self.likeCountLabel == likeCountLabel {
            let likes = posts
            likeCountLabel.text = String(likes.likesCount)
        }
        
    }
    
    func configureButtons() {
         likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
     }
    
    @objc private func didTapLike() {
        if likeButton.tag == 0 {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.tintColor = .systemRed
            likeButton.tag = 1
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tag = 0
            likeButton.tintColor = .systemGray
        }
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            imageHeaderView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageHeaderView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageHeaderView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageHeaderView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageHeaderView.heightAnchor.constraint(equalToConstant: 350),
            
            titleLabelDetails.topAnchor.constraint(equalTo: imageHeaderView.bottomAnchor, constant: 25),
            titleLabelDetails.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15),
            titleLabelDetails.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -15),
 
            postTextDetailsLabel.topAnchor.constraint(equalTo: titleLabelDetails.bottomAnchor, constant: 25),
            postTextDetailsLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15),
            postTextDetailsLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -15),
 
            likeButton.topAnchor.constraint(equalTo: postTextDetailsLabel.bottomAnchor, constant: 15),
            likeButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,constant: 15),
            likeButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        
            likeCountLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 5),
            likeCountLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            likeButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
    
            dateCountLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -15),
            dateCountLabel.centerYAnchor.constraint(equalTo: likeCountLabel.centerYAnchor),
            dateCountLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            
        ])
        
    }
    
    func setupScrollView() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }
    
}
