//
//  DashboardVC.swift
//  AssignmentForLocalStorage
//
//  Created by admin on 16/04/24.
//

import UIKit

class DashboardVC: UIViewController {

    @IBOutlet private weak var lblTitle: UILabel!
    
    @IBOutlet private weak var tblList: UITableView!
    
    private var arrPost: [PostDisplayModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributes =  NSMutableAttributedString()
        
        attributes.append(NSAttributedString(string: "Hello, ", attributes: [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .title2)]))
        attributes.append(NSAttributedString(string: AuthUser.user?.name ?? "", attributes: [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .title1)]))
        
        lblTitle.attributedText = attributes
        
        tblList.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPosts()
    }
    
    // DB Calls
    func getPosts() {
        arrPost = []
        if let array: [Posts] = CoreDataManager.insatnce.fetchObjects(predicates: [], sortDescriptors: nil)  {
            
            array.forEach { element in
                let predicate1 = NSPredicate(format: "id == %@", element.userId ?? "XYZ")
                let useData: [Users] = CoreDataManager.insatnce.fetchObjects(predicates: [predicate1], sortDescriptors: nil) ?? []
                
                var userId = ""
                var userName = ""
                if (useData.count > 0) {
                    userId = useData[0].id ?? ""
                    userName = useData[0].name ?? ""
                }
                
                var comment: [String] = []
                let predicateComment1 = NSPredicate(format: "postId == %@", element.id ?? "XYZ")
                let commentsList: [Comments] = CoreDataManager.insatnce.fetchObjects(predicates: [predicateComment1], sortDescriptors: nil) ?? []
                
                comment = commentsList.compactMap { element in
                    return element.id
                }
                
                arrPost.append(PostDisplayModel(post: element,
                                                userId: userId,
                                                userName: userName,
                                                comment: comment))
            }
            
            DispatchQueue.main.async {
                self.tblList.reloadData()
            }
        }
     }
}
extension DashboardVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            cell.setData(arrPost[indexPath.row], indexPath: indexPath, delegate: self)
            return cell
        }
        return UITableViewCell()
    }
    
    
}
extension DashboardVC: PostCellDelegate {
    func clickOn(like indexPath: IndexPath) {
        arrPost[indexPath.row].like()
        if let cell = tblList.cellForRow(at: indexPath) as? PostCell {
            cell.setData(arrPost[indexPath.row], indexPath: indexPath, delegate: self)
            cell.animateButtom()
        }
    }
    
    func clickOn(comment indexPath: IndexPath) {
        let vc = CommentVC()
        vc.data = arrPost[indexPath.row]
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
