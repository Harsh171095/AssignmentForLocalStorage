//
//  CreatePostVC.swift
//  AssignmentForLocalStorage
//
//  Created by admin on 16/04/24.
//

import UIKit
import Photos

class CreatePostVC: UIViewController {

    @IBOutlet private weak var txtTitle: UITextField!
    @IBOutlet private weak var viewWhatsYourThoughts: UIView!
    @IBOutlet private weak var lblWhatsYourThoughtsPlaceholder: UILabel!
    @IBOutlet private weak var txtWhatsYourThoughts: UITextView!
    @IBOutlet private weak var lblWhatsYourThoughtsCount: UILabel!
    @IBOutlet private weak var collImages: UICollectionView!
    
    // Variables
    private let maxNotes = 150
    private let imagePicker = UIImagePickerController()
    private var arrImages: [UIImage] = [UIImage(named: "add-image")!]
    
    
    // Lifrcycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewWhatsYourThoughts.layer.borderWidth = 0.5
        viewWhatsYourThoughts.layer.borderColor = UIColor.lightGray.cgColor
        viewWhatsYourThoughts.layer.cornerRadius = 5
        
        collImages.register(UINib(nibName: "ImagesCell", bundle: nil), forCellWithReuseIdentifier: "ImagesCell")
        
        imagePicker.delegate = self
    }
    
    
    // Actions
    @IBAction private func clickOnAddPost() {
        let valid = txtTitle.text?.isValidPostTitle
        if (valid?.status == false) {
            showAlert(message: valid?.message ?? "")
        } else if (arrImages.count == 1) {
            showAlert(message: "Please Select Image")
        }
        else {
            createPost()
        }
    }
    
    // Supports
    private func btnClicked() {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({[weak self] status in
                if status == .authorized{
                    if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                        print("Button capture")
                        DispatchQueue.main.async {[weak self] in
                            self?.imagePicker.delegate = self
                            self?.imagePicker.sourceType = .savedPhotosAlbum
                            self?.imagePicker.allowsEditing = false
                            
                            self?.present(self!.imagePicker, animated: true, completion: nil)
                        }
                    }
                } else {
                    showAlert(message: "Please Give Access For Photolibrary For Select Meadi")
                }
            })
        }
        else if (photos == .authorized) {
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                print("Button capture")
                DispatchQueue.main.async {[weak self] in
                    self?.imagePicker.delegate = self
                    self?.imagePicker.sourceType = .savedPhotosAlbum
                    self?.imagePicker.allowsEditing = false
                    
                    self?.present(self!.imagePicker, animated: true, completion: nil)
                }
            }
        }
    }
    
    // DB calls
    private func createPost() {
//        Posts
        var imageNames: [String] = []
        if arrImages.count > 1 {
            arrImages.removeFirst()
            let manager = AppFileManager.instance
            for i in 0..<arrImages.count {
                if let filename = manager.save(image: arrImages[i]) {
                    imageNames.append(filename)
                }
            }
        }
        if let postObj: Posts = CoreDataManager.insatnce.createObject() {
            postObj.id = UUID().uuidString.lowercased()
            postObj.userId = AuthUser.user?.id
            postObj.title = txtTitle.text
            postObj.notes = txtWhatsYourThoughts.text
            postObj.likeIds = ""
            postObj.images = imageNames.joined(separator: ",")
            CoreDataManager.insatnce.updateObject(object: postObj)
            showAlert(title: "Success", message: "Post Created Successfully.")
            txtTitle.text = ""
            txtWhatsYourThoughts.text = ""
            arrImages = [UIImage(named: "add-image")!]
            collImages.reloadData()
        }
    }
}
extension CreatePostVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if newText.count <= maxNotes {
            lblWhatsYourThoughtsPlaceholder.isHidden = newText.count > 0
            lblWhatsYourThoughtsCount.text = "\(newText.count)/\(maxNotes)"
            return true
        }
        return false
    }
}

extension CreatePostVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as? NSString)?.replacingCharacters(in: range, with: string) ?? ""
        
        if (newText.count <= 30) {
            return true
        }
        return false
    }
}
extension CreatePostVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as? ImagesCell {
            
            cell.setImage(arrImages[indexPath.row],index: indexPath.row ,canShowCancel: indexPath.row != 0) {[weak self] index in
                if (index != 0) {
                    self?.arrImages.remove(at: index)
                    self?.collImages.reloadData()
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
}
extension CreatePostVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            btnClicked()
        }
    }
}
extension CreatePostVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
}

extension CreatePostVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
        
        arrImages.append(image)
        collImages.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: { () -> Void in
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        arrImages.append(image)
        collImages.reloadData()
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
        
       
    }
}
