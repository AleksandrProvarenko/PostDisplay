//
//  PostsTableViewCell.swift
//  PostsDisplay
//
//  Created by Alex Provarenko on 27.07.2022.
//

import UIKit

protocol PostTableViewCellDelegate: AnyObject {
    func postTableViewCellDidTapExpand(index: IndexPath)
    func postTableViewCellDidTapLike()
}


class PostTableViewCell: UITableViewCell {
    
    static let identifier = "PostTableViewCell"
    var index = IndexPath()
    private var isExpandable = false
    var heightConstraint: NSLayoutConstraint?

    weak var delegate: PostTableViewCellDelegate?
    
    var expandButton: UIButton = {
        let button = UIButton()
        button.setTitle("Expand", for: .normal)
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4
        return button
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
    
    var  dateCountLabel: UILabel = {
        let dateCount = UILabel()
        dateCount.translatesAutoresizingMaskIntoConstraints = false
        dateCount.text = "25 days ago"
        dateCount.font = .systemFont(ofSize: 16, weight: .regular)
        dateCount.textColor = .systemGray
        return dateCount
    }()
    
     var  titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Alex Provarenko"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    var postTextContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "When we think of famous bands, we have an image of each member’s distinctive roles. More often than not, every member has clearly defined roles that they stick to from beginning to end."
        label.tintColor = .white
        label.numberOfLines = 0
        return label
    }()

    var linesControlLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.textColor = .clear
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(expandButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(postTextContentLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(likeCountLabel)
        contentView.addSubview(dateCountLabel)
        contentView.addSubview(linesControlLabel)
        configureButtons()
        configureConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        postTextContentLabel.text = nil
        postTextContentLabel.numberOfLines = 0
        dateCountLabel.text = nil
        heightConstraint?.isActive = false
        heightConstraint = nil
        expandButton.isHidden = true
        expandButton.backgroundColor = .systemBlue
        expandButton.alpha = 1
        expandButton.setTitle("Expand", for: .normal)
    }
    
    func set(post: PostMain, index: IndexPath) {
        titleLabel.text = post.title
        postTextContentLabel.text = post.previewText
        linesControlLabel.text = post.previewText
        dateCountLabel.text = post.curentDate
        self.index = index


        DispatchQueue.main.async {
            self.isExpandable = self.linesControlLabel.countLines() > 2

            if self.isExpandable {
                self.heightConstraint = self.expandButton.heightAnchor.constraint(equalToConstant: 34)
                self.expandButton.isHidden = false
            } else {
                self.heightConstraint = self.expandButton.heightAnchor.constraint(equalToConstant: 0)
                self.expandButton.isHidden = true
            }

            self.heightConstraint?.isActive = true
        }

        if self.likeCountLabel == likeCountLabel {
            let likes = post
            likeCountLabel.text = String(likes.likesCount)
        }

    }

    
   func configureButtons() {
       expandButton.addTarget(self, action: #selector(didTapExpend), for: .touchUpInside)
       likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
    }
    
    @objc private func didTapExpend() {
        delegate?.postTableViewCellDidTapExpand(index: index)
    }
    
    @objc private func didTapLike() {
        delegate?.postTableViewCellDidTapLike()
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
    

    private func configureConstraints() {

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            postTextContentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            postTextContentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            postTextContentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

            linesControlLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            linesControlLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            linesControlLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            likeButton.topAnchor.constraint(equalTo: postTextContentLabel.bottomAnchor, constant: 15),
            likeButton.leadingAnchor.constraint(equalTo: postTextContentLabel.leadingAnchor),
            
            likeCountLabel.topAnchor.constraint(equalTo: postTextContentLabel.bottomAnchor, constant: 15),
            likeCountLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 5),
            likeCountLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            
            dateCountLabel.topAnchor.constraint(equalTo: postTextContentLabel.bottomAnchor, constant: 15),
            dateCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            dateCountLabel.centerYAnchor.constraint(equalTo: likeCountLabel.centerYAnchor),

            expandButton.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 15),
            expandButton.topAnchor.constraint(equalTo: likeCountLabel.bottomAnchor, constant: 15),
            expandButton.topAnchor.constraint(equalTo: dateCountLabel.bottomAnchor, constant: 15),
            expandButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            expandButton.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])


    }
    
    required init?(coder: NSCoder) {
        fatalError()
        
    }
    
}
