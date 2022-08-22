//
//  ViewController.swift
//  PostsDisplay
//
//  Created by Alex Provarenko on 19.07.2022.
//

import UIKit

class MainPostsViewController: UIViewController {
    
    var posts: [PostMain] = []
    var viewModel = MainPostViewModel()
    var expandedIndexSet = [Int]()
    
    private var mainPostsTableView: UITableView = {
        let table = UITableView()
        table.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Posts"
        view.addSubview(mainPostsTableView)
        contextMunu()
       
        viewModel.mainPostsViewModel {
            self.posts = self.viewModel.posts
            DispatchQueue.main.async {
                self.mainPostsTableView.reloadData()
            }
        }
        
        mainPostsTableView.delegate = self
        mainPostsTableView.dataSource = self
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainPostsTableView.frame = view.bounds
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateMainTableView()
    }
    
}

extension MainPostsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        
        let posts = posts[indexPath.row]
        cell.index = indexPath
        cell.delegate = self
        cell.set(post: posts, index: indexPath)


        if expandedIndexSet.contains(indexPath.row) {
            cell.postTextContentLabel.numberOfLines = 0
            cell.expandButton.alpha = 0.5
            cell.expandButton.setTitle("Collapse", for: .normal)
        } else {
            cell.postTextContentLabel.numberOfLines = 2
            cell.expandButton.alpha = 1
            cell.expandButton.setTitle("Expand", for: .normal)
        }

        return cell
    }
    
    enum SortBy {
        case likes
        case dates
    }
    
    private func sortPost(sort byPost: SortBy) {
        var result = [PostMain]()
        
        switch byPost {
        case .likes:
            result = posts.sorted { like1, like2 in
                like1.likesCount > like2.likesCount
            }
            
        case .dates :
            result = posts.sorted(by: { date1, date2 in
                date1.curentDate < date2.curentDate
            })
            
        }
        
        posts = result
        expandedIndexSet = []
        self.mainPostsTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PostDetailsViewController()
        let postDetails = posts[indexPath.row]
        vc.posts = postDetails
        navigationController?.pushViewController(vc, animated: true)
        mainPostsTableView.deselectRow(at: indexPath, animated: true)

    }
    
    func contextMunu() {
        let saveMenu = UIMenu(title: "Фильтрация", children: [
            UIAction(title: "по дате", image: UIImage(systemName: "")) { action in
                print("User taped date")
                self.sortPost(sort: .dates)
                
            },
            
            UIAction(title: "по лайкам", image: UIImage(systemName: "")) { action in
                 print("User taped like")
                self.sortPost(sort: .likes)
                
                },
             
              ])
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), menu: saveMenu)
        navigationItem.rightBarButtonItem = addButton
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func animateMainTableView() {
        mainPostsTableView.reloadData()
        let cells = mainPostsTableView.visibleCells
        let tableViewHeight = mainPostsTableView.bounds.height
        var delay: Double = 0
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
            
            UIView.animate(withDuration: 1, delay: delay * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                cell.transform = CGAffineTransform.identity
            }
            
            delay += 1
            
        }
    }
    
}

extension MainPostsViewController: PostTableViewCellDelegate {
    
    func postTableViewCellDidTapExpand(index: IndexPath) {

        if(expandedIndexSet.contains(index.row)) {
            expandedIndexSet.remove(at: expandedIndexSet.firstIndex(of: index.row)!)
        } else {
            expandedIndexSet.append(index.row)
        }

        mainPostsTableView.reloadRows(at: [index], with: .none)
        
    }
    
    func postTableViewCellDidTapLike() {
        print("Like")
        
    }
    
}

extension UILabel {
    func countLines() -> Int {
        guard let myText = self.text as NSString? else {
            return 0
        }
        
        let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font as Any], context: nil)
        return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }
}


