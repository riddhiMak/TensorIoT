//
//  DatabaseManager.swift
//  TensorIoT
//
//  Created by Riddhi Makwana on 04/10/23.
//

import Foundation
import FirebaseDatabase

struct FirebaseCollections {
    static let FUsers = "USERS"
}

extension DatabaseManager{
    public enum DatabaseManagerError: Error{
        case failedToFetch
    }
}

class DatabaseManager{
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    
    static func toSafeEmail(with email: String) -> String{
        var result = email.replacingOccurrences(of: ".", with: "")
        result = result.replacingOccurrences(of: "@", with: "")
        return result
    }
    
    public func insertUser(with user: User, completion: @escaping(Bool) -> Void){
        let ref = database.child(FirebaseCollections.FUsers)
        ref.child(user.safeEmail).setValue(["username": user.username, "bio": user.bio,"password":user.password,"email":user.email], withCompletionBlock: { [weak self] error, _ in
            
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }

    public func fetchDataFromDatabase(tName : String , child: String, completion: @escaping(Result<Any, Error>) -> Void){
        database.child("\(tName)/\(child)").observe(.value) { snapshot in
            guard let value = snapshot.value else {
                completion(.failure(DatabaseManagerError.failedToFetch))
                return
            }
            completion(.success(value))
        }
       
    }
    
    public func userExists(with email: String, completion: @escaping((Bool) -> Void)){
        let safeEmail = DatabaseManager.toSafeEmail(with: email)
        
        database.child("\(FirebaseCollections.FUsers)/\(safeEmail)").observeSingleEvent(of: .value, with: {snapshot in
            guard snapshot.value as? [String: Any] != nil else{
                completion(false)
                return
            }
            
            completion(true)
        })
    }
}
