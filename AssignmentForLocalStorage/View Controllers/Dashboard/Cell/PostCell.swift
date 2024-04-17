//
//  PostCell.swift
//  AssignmentForLocalStorage
//
//  Created by admin on 17/04/24.
//

import UIKit

protocol PostCellDelegate: LikeActionDelegate, CommentActionDelegate{}

class PostCell: UITableViewCell {

    @IBOutlet private weak var viewContaner: UIView!
    @IBOutlet private weak var lblUserName: UILabel!
    @IBOutlet private weak var lblPostTitle: UILabel!
    @IBOutlet private weak var collImages: UICollectionView!
    @IBOutlet private weak var lblNotes: UILabel!
    @IBOutlet private weak var btnLike: UIButton!
    @IBOutlet private weak var btnComment: UIButton!
    
    
    private var delegate: PostCellDelegate?
    private var  data: PostDisplayModel?
    private var indexPath:IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
        viewContaner.layer.cornerRadius = 5
        viewContaner.backgroundColor = UIColor(named: "postBG")
    }

    func setData(_ data: PostDisplayModel, indexPath: IndexPath, delegate: PostCellDelegate) {
        self.data = data
        self.indexPath = indexPath
        self.delegate = delegate
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
            
    }
    
    func animateButtom() {
         
        self.btnLike.imageView?.rotate()
    }
    
    @IBAction private func clickOnLike() {
        self.delegate?.clickOn(like: indexPath!)
    }
    
    @IBAction private func clickOnComment() {
        self.delegate?.clickOn(comment: indexPath!)
    }
}
extension PostCell: UICollectionViewDataSource {
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
extension PostCell: UICollectionViewDelegateFlowLayout {
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
