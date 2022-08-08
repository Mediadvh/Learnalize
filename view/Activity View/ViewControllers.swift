//
//  ViewControllers.swift
//  test-this better work
//
//  Created by Media Davarkhah on 5/2/1401 AP.
//

import Foundation
import HMSSDK
import UIKit
import SwiftUI

class RoomController: UIViewController {
    // MARK: -Properties
    var collectionView:UICollectionView!
    var activity: Activity
    var userId: String
    var token: String
    var hmsSDK = HMSSDK.build()
    var trackViewMap = [HMSTrack: HMSVideoView]()
    var message: String?
    
    // MARK: - initializers
    init(activity: Activity, userId: String, token: String) {
        self.activity = activity
        self.userId = userId
        self.token = token
        super.init(nibName: nil, bundle: nil)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: -UIElements
   

//    lazy var stackView: UIStackView = {
//
//        let result = UIStackView()
//        result.axis = .horizontal
//
//        view.addSubview(result)
//        result.translatesAutoresizingMaskIntoConstraints = false
//        result.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        result.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        result.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        let heightConstraint =  result.heightAnchor.constraint(equalToConstant: 100)
//        heightConstraint.isActive = true
//        heightConstraint.priority = .defaultLow
//
//        return result
//    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = activity.name
        label.textColor = UIColor(Colors.accent)
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    lazy var leaveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Leave", for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(leaveButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    @objc func leaveButtonTapped() {
        hmsSDK.leave()
        self.dismiss(animated: true)
    }
    @objc func sendMessageTapped() {
        if let  message = message {
            hmsSDK.sendBroadcastMessage(type: "chat", message: message) { msg, error in
                guard let msg = msg, error == nil else { return }
                print("message form \(msg.sender?.name ?? "N/A") was sent successfully!")
                
            }
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewInit()
        joinRoom()
        view.backgroundColor = UIColor(named: activity.tagColor)
        
    }
    
    override func viewDidLayoutSubviews() {
        // UILabel
        view.addSubview(titleLabel)
        titleLabel.customTBLTConstraint(top: view.safeAreaLayoutGuide.topAnchor , leading: view.leadingAnchor, trailing: view.trailingAnchor, topConst: 20)
        view.addSubview(leaveButton)
        leaveButton.customTBLTConstraint(top: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor, trailingConst: 3)
        
//        UICollectionView
        view.addSubview(collectionView)
        collectionView.customTBLTConstraint(bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottomConst: 0, leadingConst: 0, trailingConst: 0)
        collectionView.customHeightWidthConstraint(height: 300)
//        view.addSubview(stackView)
        
    }
    
    
    
    
    //MARK: -Helpers
    fileprivate func joinRoom() {
        
        let config = HMSConfig(authToken: token)
        self.hmsSDK.join(config: config, delegate: self)
        
    }
    fileprivate func collectionViewInit() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .red
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(VideoCollectionCell.self, forCellWithReuseIdentifier: String(describing:VideoCollectionCell.self))
        collectionView.frame = view.bounds
    }
    
}

//MARK: -UICollectionView protocols
extension RoomController:UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hmsSDK.remotePeers?.count ?? 0
       
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing:VideoCollectionCell.self), for: indexPath) as! VideoCollectionCell
        
        let video = trackViewMap[indexPath.row]
        cell.configure(videoView: video.value)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200  , height: 200  )
   
    }

}

//MARK: -HMSUpdateListener
extension RoomController: HMSUpdateListener {
    func on(join room: HMSRoom) {
        print("a new participant has joined the room")
    }
    
    func on(room: HMSRoom, update: HMSRoomUpdate) {
        
    }
    
    func on(peer: HMSPeer, update: HMSPeerUpdate) {
        switch update {
        case .peerLeft:
            if let videoTrack = peer.videoTrack {
                removeVideoView(for: videoTrack)
            }
        default:
            break
        }
    }
    
    func on(track: HMSTrack, update: HMSTrackUpdate, for peer: HMSPeer) {
        switch update {
           case .trackAdded:
               if let videoTrack = track as? HMSVideoTrack {
                   addVideoView(for: videoTrack)
               }
           case .trackRemoved:
               if let videoTrack = track as? HMSVideoTrack {
                   removeVideoView(for: videoTrack)
               }
           default:
               break
           }
    }
    
    func on(error: HMSError) {
        print("couldnt join room")
    }
    
    func on(message: HMSMessage) {
        
    }
    
    func on(updated speakers: [HMSSpeaker]) {
        
    }
    
    func onReconnecting() {
        
    }
    
    func onReconnected() {
        
    }
    func addVideoView(for track: HMSVideoTrack) {
        let videoView = HMSVideoView()
//        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.setVideoTrack(track)
//        videoView.heightAnchor.constraint(equalTo: videoView.widthAnchor, multiplier: 9.0/16.0).isActive = true
//        stackView.addArrangedSubview(videoView)
        trackViewMap[track] = videoView
    }
    
    func removeVideoView(for track: HMSVideoTrack) {
        trackViewMap[track]?.removeFromSuperview()
    }
}
//MARK: -UIViewControllerRepresentable
struct Room: UIViewControllerRepresentable {
    var activity: Activity
    var userId: String
    var token: String
    
    func makeUIViewController(context: Context) -> RoomController {
        return RoomController(activity: activity, userId: userId, token: token)
    }
    
    func updateUIViewController(_ uiViewController: RoomController, context: Context) {
        
    }
    
    typealias UIViewControllerType = RoomController
}

