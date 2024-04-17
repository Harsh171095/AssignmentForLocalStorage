//
//  CommentVC.swift
//  AssignmentForLocalStorage
//
//  Created by admin on 17/04/24.
//

import UIKit

class CommentVC: UIViewController {

    @IBOutlet private weak var viewContaner: UIView!
    @IBOutlet private weak var lblUserName: UILabel!
    @IBOutlet private weak var lblPostTitle: UILabel!
    @IBOutlet private weak var collImages: UICollectionView!
    @IBOutlet private weak var lblNotes: UILabel!
    @IBOutlet private weak var btnLike: UIButton!
    @IBOutlet private weak var btnComment: UIButton!
    
    
    @IBOutlet private weak var txtComment: UITextField!
    @IBOutlet private weak var lblCommentTextCount: UILabel!
    
    @IBOutlet private weak var tblComments: UITableView!
    @IBOutlet private weak var constTBLCommentsHeight: NSLayoutConstraint!
    
    private var delegate: PostCellDelegate?
    var data: PostDisplayModel!
    private var arrComment: [CommentsDisplayModel] = []
    private let maxCommentText = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getComments()
        setupData()
        tblComments.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

    }
    override func viewWillDisappear(_ animated: Bool) {
        tblComments.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
                let newsize  = newvalue as! CGSize
                constTBLCommentsHeight.constant = newsize.height
            }
        }
    }

    func setupData() {
        lblUserName.text = data.userName
        lblPostTitle.text = data.title
        lblNotes.text = data.notes
        btnLike.setTitle(" \(data.likeIds.count > 0 ? data.likeIds.count : 0)", for: .normal)
        btnLike.setImage(UIImage(named: data.isLike ? "like_fill" : "like"), for: .normal)
        btnComment.setTitle(" \((data.comment?.count ?? 0) > 0 ? (data.comment?.count ?? 0) : 0)", for: .normal)
        collImages.register(UINib(nibName: "ImagesCell", bundle: nil), forCellWithReuseIdentifier: "ImagesCell")
        
        collImages.delegate = self
        collImages.dataSource = self
        collImages.isHidden = !(data.images.count > 0)
        collImages.reloadData()
        
        tblComments.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        lblCommentTextCount.text = "\(txtComment.text?.count ?? 0)/\(maxCommentText)"
    }
    

    // Actions
    @IBAction private func clickOnBack() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction private func clickOnLike() {
        data.like()
        btnLike.imageView?.rotate()
        setupData()
    }
    @IBAction private func clickOnPostComment() {
        let validate = txtComment.text?.isValidCommentText
        
        if (validate?.status == false ) {
            showAlert(message: validate?.message ?? "")
        } else {
            postComments()
        }
        
    }
    
    // DB Calls
    func getComments() {
        let predicateCom1 = NSPredicate(format: "postId == %@", data?.id ?? "XYZ")
        if var array: [Comments] = CoreDataManager.insatnce.fetchObjects(predicates: [predicateCom1], sortDescriptors: nil)  {
            
            array = array.sorted(by: { element1, element2 in
                Double(element1.createdAt ?? "0")! > Double(element2.createdAt ?? "0")!
            })
            
            array.forEach { element in
                
                let predicate1 = NSPredicate(format: "id == %@", element.userId ?? "XYZ")
                let useData: [Users] = CoreDataManager.insatnce.fetchObjects(predicates: [predicate1], sortDescriptors: nil) ?? []
                
                var userId = ""
                var userName = ""
                if (useData.count > 0) {
                    userId = useData[0].id ?? ""
                    userName = useData[0].name ?? ""
                }
                
                arrComment.append(CommentsDisplayModel(comment: element, userId: userId, userName: userName))
            }
            DispatchQueue.main.async {
                self.tblComments.reloadData()
            }  
        }
    }
    
    func postComments() {
        
        if let newComment: Comments = CoreDataManager.insatnce.createObject() {
            newComment.id = UUID().uuidString
            newComment.comment = txtComment.text
                newComment.likeIds = ""
            newComment.postId = data.id
            newComment.userId = AuthUser.user?.id ?? ""
            newComment.createdAt = "\(Int(Date.now.timeIntervalSince1970))"
            CoreDataManager.insatnce.updateObject(object: newComment)
            data.comment?.append(newComment.id ?? "")
            arrComment.insert(CommentsDisplayModel(comment: newComment, userId: AuthUser.user?.id ?? "", userName: AuthUser.user?.name ?? ""),at: 0)
            DispatchQueue.main.async {
                self.tblComments.reloadData()
                self.setupData()
            }
            
        }
    }
}
extension CommentVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as? ImagesCell {
            
            cell.setPostImage(data?.images[indexPath.row] ?? "")
            
            return cell
        }
        return UICollectionViewCell()
    }
}
extension CommentVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if ((data?.images.count ?? 0) > 1) {
            return CGSize(width: collectionView.frame.height - 10, height: collectionView.frame.height - 10)
        }
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
}
extension CommentVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrComment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as?  CommentCell{
            cell.setData(arrComment[indexPath.row], indexPath: indexPath, delegate: self)
            return cell
        }
        return UITableViewCell()
    }
}
extension CommentVC: CommentCellDelegate {
    func clickOn(like indexPath: IndexPath) {
        arrComment[indexPath.row].like()
        if let cell = tblComments.cellForRow(at: indexPath) as? CommentCell {
            cell.setData(arrComment[indexPath.row], indexPath: indexPath, delegate: self)
            cell.animateButtom()
        }
    }
}

extension CommentVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as? NSString)?.replacingCharacters(in: range, with: string) ?? ""
        
        if (newText.count <= maxCommentText) {
            lblCommentTextCount.text = "\(newText.count)/\(maxCommentText)"
            return true
        }
        return false
    }
}
