//
//  PostDisplayModel.swift
//  AssignmentForLocalStorage
//
//  Created by admin on 17/04/24.
//

import Foundation

struct PostDisplayModel {
    public var post: Posts?
    public var id: String {return post?.id ?? ""}
    public let userId: String?
    public let userName: String?
    public var images: [String] { return post?.images?.split(separator: ",").compactMap({ str in
        return "\(str)".trimmingCharacters(in: .whitespacesAndNewlines)
    }) ?? []}
    public var likeIds: [String] { return post?.likeIds?.split(separator: ",").compactMap({ str in
        return "\(str)"
    }) ?? []}
    public var isLike: Bool { return likeIds.contains(AuthUser.user?.id ?? "")}
    
    public var notes: String { return post?.notes ?? ""}
    public var title: String { return post?.title ?? ""}
    public var comment: [String]?
    
    init(post: Posts, userId: String?, userName: String?, comment: [String]?) {
        self.post = post
        self.userId = userId
        self.userName = userName
        self.comment = comment
    }
    
    mutating func like() {
        if (likeIds.contains(AuthUser.user?.id ?? "") ) {
            var likeIds = self.likeIds
            let index = likeIds.firstIndex(of: AuthUser.user?.id ?? "") ?? -1
            
            if (index >= 0) {
                likeIds.remove(at: index)
                post?.likeIds = likeIds.joined(separator: ",")
                CoreDataManager.insatnce.updateObject(object: post!)
            }
        } else {
            var likeIds = self.likeIds
            likeIds.append(AuthUser.user?.id ?? "")
            post?.likeIds = likeIds.joined(separator: ",")
            CoreDataManager.insatnce.updateObject(object: post!)
        }
    }
    
    
}

