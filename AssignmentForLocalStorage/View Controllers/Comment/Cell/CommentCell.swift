//
//  CommentCell.swift
//  AssignmentForLocalStorage
//
//  Created by admin on 17/04/24.
//

import UIKit

protocol CommentCellDelegate: LikeActionDelegate {}

class CommentCell: UITableViewCell {

    @IBOutlet private weak var viewContent: UIView!
    @IBOutlet private weak var lblUserName: UILabel!
    @IBOutlet private weak var lblComment: UILabel!
    @IBOutlet private weak var btnLike: UIButton!
    @IBOutlet private weak var lblCreatedAt: UILabel!
    
    private var delegate: CommentCellDelegate?
    private var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContent.layer.cornerRadius = 8
        
        DispatchQueue.main.async {[weak self] in
            self?.viewContent.center = self!.center
            self?.viewContent.backgroundColor = UIColor.white
            self?.viewContent.layer.shadowColor = UIColor.gray.cgColor
            self?.viewContent.layer.shadowOpacity = 1
            self?.viewContent.layer.shadowOffset = CGSize.zero
            self?.viewContent.layer.shadowRadius = 2
        }
    }

    func setData(_ data: CommentsDisplayModel,
                 indexPath: IndexPath,
                 delegate: CommentCellDelegate)
    {
        self.indexPath = indexPath
        self.delegate = delegate
        
        viewContent.isHidden = false
        lblUserName.text = data.userName
        lblComment.text = data.comment
        btnLike.setTitle(" \(data.likeIds.count > 0 ? data.likeIds.count : 0)", for: .normal)
        btnLike.setImage(UIImage(named: data.isLike ? "like_fill" : "like"), for: .normal)
        
        lblCreatedAt.text = data.createdAt
    }
    
    func animateButtom() {
        self.btnLike.imageView?.rotate()
    }
    
    // Actions
    @IBAction private func clickOnLike() {
        self.delegate?.clickOn(like: indexPath!)
    }
}
