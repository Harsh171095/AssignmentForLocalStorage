//
//  ImagesCell.swift
//  AssignmentForLocalStorage
//
//  Created by admin on 17/04/24.
//

import UIKit

class ImagesCell: UICollectionViewCell {

    @IBOutlet private weak var imagePost: UIImageView!
    @IBOutlet private weak var btnCancel: UIButton!
    @IBOutlet private weak var constTop: NSLayoutConstraint!
    @IBOutlet private weak var constRight: NSLayoutConstraint!
    
    private var clickOnCancel: ((Int)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
    }

    func setImage(_ image: UIImage,index: Int,canShowCancel: Bool = true, clickOnCancel:  ((Int)->())? = nil) {
        imagePost.image = image
        imagePost.contentMode = .scaleAspectFill
        btnCancel.isHidden = !canShowCancel
        btnCancel.tag = index
        self.clickOnCancel = clickOnCancel
    }
    
    func setPostImage(_ filename: String) {
        constTop.constant = 0
        constRight.constant = 10
        self.backgroundColor = .clear
        btnCancel.isHidden = true
        imagePost.image = AppFileManager.instance.load(fileName: filename.trimmingCharacters(in: .whitespacesAndNewlines))
        imagePost.contentMode = .scaleAspectFill
    }
    
    @IBAction private func clickOn_cancel() {
        clickOnCancel?(btnCancel.tag)
    }
}
