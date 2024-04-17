//
//  CommentsDisplayModel.swift
//  AssignmentForLocalStorage
//
//  Created by admin on 17/04/24.
//

import Foundation

struct CommentsDisplayModel {
    private var commentObj: Comments
    public let userId: String?
    public let userName: String?
    
    // Get Variables
    public var comment: String { return commentObj.comment ?? ""}
    public var id: String { return commentObj.id ?? ""}
    public var likeIds: [String] { return commentObj.likeIds?.split(separator: ",").compactMap({ str in
        return "\(str)"
    }) ?? []}
    public var postId: String { return commentObj.postId ?? ""}
    public var isLike: Bool { return likeIds.contains(AuthUser.user?.id ?? "")}
    public var createdAt: String {
        let formate = DateFormatter()
        formate.dateFormat = "dd/MMM/YY hh:mm a"
        let date = Date(timeIntervalSince1970: Double(commentObj.createdAt ?? "0") ?? 0)
        return formate.string(from: date)
    }
    
    init(comment: Comments, userId: String?, userName: String?) {
        self.commentObj = comment
        self.userId = userId
        self.userName = userName
    }
    
    mutating func like() {
        if (likeIds.contains(AuthUser.user?.id ?? "") ) {
            var likeIds = self.likeIds
            let index = likeIds.firstIndex(of: AuthUser.user?.id ?? "") ?? -1
            
            if (index >= 0) {
                likeIds.remove(at: index)
                commentObj.likeIds = likeIds.joined(separator: ",")
                CoreDataManager.insatnce.updateObject(object: commentObj)
            }
        } else {
            var likeIds = self.likeIds
            likeIds.append(AuthUser.user?.id ?? "")
            commentObj.likeIds = likeIds.joined(separator: ",")
            CoreDataManager.insatnce.updateObject(object: commentObj)
        }
    }
}
