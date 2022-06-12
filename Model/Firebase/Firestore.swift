//
//  Firestore.swift
//  Learnalize
//
//  Created by Media Davarkhah on 2/19/1401 AP.
//

import Firebase
import FirebaseFirestore
import FirebaseStorage
import SwiftUI
import FirebaseFirestoreSwift

class FireStoreManager {
    
    static let shared = FireStoreManager()
    let auth: Auth
    let firestore: Firestore
    let storage: Storage
    private init() {
         auth = Auth.auth()
         storage = Storage.storage()
         firestore = Firestore.firestore()
    }
    
    
//    func downloadImage(link: String, completionHandler: @escaping (UIImage?, Error?) -> Void) {
//        guard let url = URL(string: link) else {
//            return
//        }
//        URLSession.shared.dataTask(with: url) { data, _ ,error in
//            if let data = data, error == nil {
//                let picture = UIImage(data: data)
//                completionHandler(picture, nil)
//            } else {
//                completionHandler(nil, error)
//            }
//        }
//    }
//    
    
    func fetchUser(userId: String, completionHandler: @escaping (_ user: User?, _ error: Error?) -> Void) {
        
       
        let docRef = firestore.collection("users").document(userId)
  
        docRef.getDocument { (document, error) in
            
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {

                    print("data", data)

                    let email = data["email"] as? String ?? ""
                    let fullname = data["fullName"] as? String ?? ""
                    let picture = data["picture"] as? String ?? ""
                    let username = data["username"] as? String ?? ""


                    let user = User(fullName: fullname, picture: picture, email: email, password: "N/A", username: username, id: userId)
                    completionHandler(user, nil)
                }
                
               
            }
        }
    }
    
    func save(image: UIImage, completionHandler: @escaping (URL?, Error?) -> Void){
        
        guard let uid = auth.currentUser?.uid else { return }
        let ref = storage.reference(withPath: uid)
        let imageData = image.jpegData(compressionQuality: 0.5)
        guard let imageData = imageData else { return }
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completionHandler(nil,error)
                return
            }
            
            ref.downloadURL { url, error in
                if let error = error {
                    completionHandler(nil,error)
                    return
                }
                completionHandler(url,nil)
            }
        }
                
    }
    func editPicture(url: String) {
        if let id = auth.currentUser?.uid {
            let docid = firestore.collection("users").document(id).documentID
            firestore.collection("users").document(docid).updateData(["picture":url])
        }
        
    }
    func save(user: User, with imageData: String, completionHandler: @escaping (Bool, Error?) -> Void){
       
        guard let uid = FireStoreManager.shared.auth.currentUser?.uid else { return }
        let userData = ["fullName": user.fullName, "picture": imageData,"email": user.email,"password": user.password,"username": user.username,"id":uid]

//
        FireStoreManager.shared.firestore.collection("users").document(uid).setData(userData) { error in
            if let error = error {
                completionHandler(true, error)
                return
            }

            completionHandler(true, nil)
        }
        
       
        
    }
    
    func save(activity: Activity, completionHandler: @escaping (Bool, Error?) -> Void){
       
        guard let uid = FireStoreManager.shared.auth.currentUser?.uid else { return }
       
        let userData = [
            "uid": activity.uid,
            "name": activity.name,
            "description": activity.description,
            "participantsLimit": activity.participantsLimit,
            "creationDate": activity.creationDate!,
            "hostId": activity.hostId!
        ] as [String : Any]
      
    
        FireStoreManager.shared.firestore.collection("activities").document(activity.uid).setData(userData) { error in
            if let error = error {
                completionHandler(true, error)
                return
            }
           
            completionHandler(true, nil)
        }
    }
   
    func fetchActivities(filter hostId: String, completionHandler: @escaping ([Activity]?, Error?) -> Void) {
        let docRefs = firestore.collection("activities").whereField("hostId", in: [hostId]).limit(to: 10)
        docRefs.getDocuments { querySnapshot, error in
            guard error == nil else {
                completionHandler(nil,error)
                print("Error getting documents: \(error?.localizedDescription)")
                return
            }
            
            var activities = [Activity]()
            let docs = querySnapshot!.documents
            activities = docs.compactMap { queryDocumentSnapshot -> Activity? in
                
                do {
                    return try queryDocumentSnapshot.data(as: Activity.self)
                    
                } catch {
                    print(error)
                    completionHandler(nil,error)
                    return nil
            
                }
            }
            completionHandler(activities,nil)         
        }
    }
    func searchActivity(by name: String, completionHandler: @escaping ([Activity]?, Error?) -> Void) {
        let docRefs = firestore.collection("activities").whereField("name", in: [name]).limit(to: 10)
        docRefs.getDocuments { querySnapshot, error in
            guard error == nil else {
                completionHandler(nil,error)
                print("Error getting documents: \(error?.localizedDescription)")
                return
            }
            
            var activities = [Activity]()
            let docs = querySnapshot!.documents
            activities = docs.compactMap { queryDocumentSnapshot -> Activity? in
                
                do {
                    return try queryDocumentSnapshot.data(as: Activity.self)
                    
                } catch {
                    print(error)
                    completionHandler(nil,error)
                    return nil
            
                }
            }
            completionHandler(activities,nil)
        }
    }
    
    func searchUser(by username: String, completionHandler: @escaping ([User]?, Error?) -> Void) {
        let docRefs = firestore.collection("users").whereField("username", in: [username]).limit(to: 5)
        
        docRefs.getDocuments { querySnapshot, error in
            guard error == nil else {
                completionHandler(nil,error)
                print("Error getting documents: \(error?.localizedDescription)")
                return
            }
            var users = [User]()
            if let docs = querySnapshot?.documents {
                users = docs.compactMap { queryDocumentSnapshot -> User? in
                    do {
                        return try queryDocumentSnapshot.data(as: User.self)
                    } catch {
                        print(error)
                        completionHandler(nil,error)
                        return nil
                    }
                }
                completionHandler(users,nil)
            }
            
        }
    }

}
