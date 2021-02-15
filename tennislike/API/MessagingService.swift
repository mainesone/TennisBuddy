//
//  MessagingService.swift
//  tennislike
//
//  Created by Maik Nestler on 22.12.20.
//

import Firebase

typealias FirestoreCompletion = ((Error?) -> Void)?

struct MessagingService {
    static let shared = MessagingService()
    
    func fetchConversations(completion: @escaping([Conversation]) -> Void) {
        var conversations = [Conversation]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_MATCHES_MESSAGES.document(uid).collection("recent-messages").order(by: "timestamp")
        
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)
                
                Service.fetchUser(withUid: message.chatPartnerId) { user in
                    let conversation = Conversation(user: user, message: message)
                    conversations.append(conversation)
                    completion(conversations)
                }
            })
        }
    }
    
    func fetchMessages(forUser user: User, completion: @escaping([Message]) -> Void) {
        var messages = [Message]()
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_MATCHES_MESSAGES.document(currentUid).collection(user.uid).order(by: "timestamp")
        
        query.addSnapshotListener { (querySnapshot, err) in
            querySnapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionary = change.document.data()
                    messages.append(Message(dictionary: dictionary))
                    completion(messages)
                }
            })
        }
    }
    
    func uploadMessage(_ message: String, to user: User, completion: FirestoreCompletion) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
          
          let data = ["text": message,
                      "fromId": currentUid,
                      "toId": user.uid,
                      "timestamp": Timestamp(date: Date())] as [String : Any]
          
        COLLECTION_MATCHES_MESSAGES.document(currentUid).collection(user.uid).addDocument(data: data) { (err) in
            COLLECTION_MATCHES_MESSAGES.document(user.uid).collection(currentUid)
                .addDocument(data: data, completion: completion)
          }
        
        COLLECTION_MATCHES_MESSAGES.document(currentUid).collection("recent-messages").document(user.uid).setData(data)
        COLLECTION_MATCHES_MESSAGES.document(user.uid).collection("recent-messages").document(currentUid).setData(data)
    }
}
