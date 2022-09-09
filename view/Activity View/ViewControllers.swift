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
import ReplayKit
//import ReplayKit.broadcast
enum Role: String {case guest, host, privilegedGuest}
class RoomController: UIViewController, UIGestureRecognizerDelegate {
    // MARK: -Properties
    var shouldSetLocalVideo = false
    let muteAudioImage = UIImage(systemName: "mic.slash.fill")
    let unmuteAudioImage = UIImage(systemName: "mic.fill")
    
    let muteVideoImage = UIImage(systemName: "video.slash.fill")
    let unmuteVideoImage = UIImage(systemName: "video.fill")
    
    var defaultHeightConstraint: NSLayoutConstraint!
    var defaultWidthConstraint: NSLayoutConstraint!
    var zoomedHeightConstraint: NSLayoutConstraint!
    var zoomedWidthConstraint: NSLayoutConstraint!
    
    var config: HMSConfig!
    var collectionView: UICollectionView!
    var hmsSDK = HMSSDK.build()
    var trackViewMap = [HMSTrack: HMSVideoView]()
    var localPeer: HMSLocalPeer?
    var raisedHandUsers = [String]()
    
    var activity: Activity
    var token: String
    var message: String?
    var participant: Participant?

    
    // MARK: - initializers
    init(activity: Activity, token: String,participant: Participant? = nil) {
        self.activity = activity
        self.token = token
        
        
        super.init(nibName: nil, bundle: nil)
        
        config = HMSConfig(authToken: token)
       
        if let participant = participant {
            self.participant = participant
//            participant.peerId = config.userID
            print("config.userID\(config.userID)")
//            participant.storePeerId(activityId: activity.uid, id: config.userID) 
            // add participant to the activity
           
                participant.joinActivity(activityId: activity.uid)
                activity.increaseParticipantsNumber()
               
                
            
        }
        hmsSDK = HMSSDK.build { sdk in
            sdk.appGroup = "group.mediadh.App.Learnalize"
        }
        
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: -UIElements
    lazy var broadcasterPickerContainer: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y:0, width: 44, height: 44)
        return v
    }()
    lazy var LocalVideoView: HMSVideoView = {
        let video = HMSVideoView()
        video.backgroundColor = .black
        return video
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = activity.name
        label.textColor = UIColor(Colors.accent)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    lazy var leaveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Leave", for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(leaveButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 4
        return button
    }()
    
    lazy var endButton: UIButton = {
        let button = UIButton()
        button.setTitle("end", for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(endButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 4
        return button
    }()
    lazy var noAccessLabel: UILabel = {
        let label = UILabel()
        label.text = "No Access!"
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var requestPermissionButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(
            pointSize: 50, weight: .medium, scale: .default)
        let image = UIImage(systemName: "hand.raised", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(requestPermissionTapped), for: .touchUpInside)
        button.tintColor = .systemYellow
        button.imageView?.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        return button
    }()
    
    lazy var audioButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        button.setBackgroundImage(UIImage(systemName: "mic.fill"), for: .normal)
        button.tintColor = UIColor(named: activity.tagColor)
        button.addTarget(self, action: #selector(muteAudioTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var videoButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        button.setBackgroundImage(UIImage(systemName: "video.fill"), for: .normal)
        button.tintColor = UIColor(named: activity.tagColor)
        button.addTarget(self, action: #selector(muteVideoTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    lazy var backgroundView: UIView = {
        let myView = UIView()
        myView.backgroundColor = UIColor(named: activity.tagColor)
        return myView
    }()
    
    lazy var broadcastPicker: RPSystemBroadcastPickerView = {
        
        let frame = CGRect(x: 0, y:0, width: 44 , height: 44)
        let systemBroadcastPicker = RPSystemBroadcastPickerView(frame: frame)
        systemBroadcastPicker.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin]
        systemBroadcastPicker.preferredExtension = "com.mediadh.App.Learnalize.broadcast"
        systemBroadcastPicker.showsMicrophoneButton = false
        
        for view in systemBroadcastPicker.subviews {
            if let button = view as? UIButton {
                let color = UIColor(named: activity.tagColor)!
                let configuration = UIImage.SymbolConfiguration(pointSize: 100)
                let image = UIImage(systemName: "rectangle.on.rectangle", withConfiguration: configuration)?.withTintColor(color, renderingMode: .alwaysOriginal)
                button.setImage(image, for: .normal)
            }
        }
        
        return systemBroadcastPicker
    }()
    
    lazy var content: UIView = {
        let view = UIView()
        view.backgroundColor = .white
//        view.layer.borderColor = UIColor(Colors.white).cgColor
//        view.layer.borderWidth = 2
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    // MARK: -Button targets
    @objc func leaveButtonTapped() {
        hmsSDK.leave()
        // remove participant from activity

        if let participant = participant {
            participant.leaveActivity(activityId: activity.uid)
            activity.decreaseParticipantsNumber()
        }
        
        self.dismiss(animated: true)
    }
    @objc func endButtonTapped() {
        if localPeer?.role?.permissions.endRoom == true {
            activity.deactivate()
            hmsSDK.endRoom(reason: "it's enough for today!")
            self.dismiss(animated: true)
        } else {
            print("you are not alowed to end this room")
        }
    }
    @objc func sendMessageTapped() {
        if let  message = message {
            hmsSDK.sendBroadcastMessage(type: "chat", message: message) { msg, error in
                guard let msg = msg, error == nil else { return }
                print("message form \(msg.sender?.name ?? "N/A") was sent successfully!")
                
            }
        }
    }
    
//     should be called from main queue
    @objc func muteAudioTapped() {
        print("muteVideoTapped")
        if audioButton.backgroundImage(for: .normal) == unmuteAudioImage {
            hmsSDK.localPeer?.localAudioTrack()?.setMute(true)
            audioButton.setBackgroundImage(muteAudioImage, for: .normal)
            print("audio got muted")
        } else {
            hmsSDK.localPeer?.localAudioTrack()?.setMute(false)
            audioButton.setBackgroundImage(unmuteAudioImage, for: .normal)
            print("audio got unmuted")
        }
    }
   
    @objc func muteVideoTapped() {
        print("muteVideoTapped")
        if videoButton.backgroundImage(for: .normal) == unmuteVideoImage {
            hmsSDK.localPeer?.localVideoTrack()?.setMute(true)
            videoButton.setBackgroundImage(muteVideoImage, for: .normal)
            print("video got muted")
        } else {
            hmsSDK.localPeer?.localVideoTrack()?.setMute(false)
            videoButton.setBackgroundImage(unmuteVideoImage, for: .normal)
            print("video got unmuted")
        }
      
    }
    
    @objc func requestPermissionTapped() {
        
        if let participant = participant {
            
            let config = UIImage.SymbolConfiguration(
                pointSize: 50, weight: .medium, scale: .default)
            let image = UIImage(systemName: "hand.raised.fill", withConfiguration: config)
            requestPermissionButton.setImage(image, for: .normal)
            
            participant.requestPermission(activityId: activity.uid)
            
            let alert = UIAlertController(title: "asked for permission", message: "Your request was sent to the host, please be patient!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { alert in
                self.noAccessLabel.text = "wait!"
            }
            alert.addAction(okAction)
            self.present(alert, animated: true)
            
        }
        
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: activity.tagColor)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.customTBLTConstraint(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        collectionViewInit()
        
        preview(config: config)
        
      
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapVideo(_:)))
//        tapGesture.delegate = self
//
//        tapGesture.numberOfTapsRequired = 1
//        tapGesture.numberOfTouchesRequired = 1
        
//        LocalVideoView.addGestureRecognizer(tapGesture)
//        LocalVideoView.isUserInteractionEnabled = true
        
        if participant == nil {
            FireStoreManager.shared.checkForPermissions(activityId: activity.uid) { users, error in
                guard let users = users, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self.raisedHandUsers = users
                    print("raised hand users: \(self.raisedHandUsers)")
                    
                    self.collectionView.reloadData()
                }
                
            }
        
        }
        
        activity.acivityEnded { ended in
            if ended == true {
                self.dismiss(animated: true)
            }
        }
        activity.participantLeft { left in
            if left {
                print("a participant has left the room")
                self.collectionView.reloadData()
            }
        }

        
    }
    
//    @objc func tapVideo(_ sender: UITapGestureRecognizer) {
//        defaultWidthConstraint.isActive.toggle()
//        defaultHeightConstraint.isActive.toggle()
//        
//        zoomedHeightConstraint =  LocalVideoView.heightAnchor.constraint(equalToConstant: 500)
//         zoomedWidthConstraint =
//         LocalVideoView.widthAnchor.constraint(equalToConstant: 500)
//        zoomedHeightConstraint.isActive = true
//        zoomedWidthConstraint.isActive = true
//       
//    }
    
    
   

  
    
    override func viewDidLayoutSubviews() {
        setupGeneralUI()

        
        // UI based on role
        guard let participant = participant else {
            setupHostUI()
            return
        }

        switch participant.role  {
            
        case .host:
            setupHostUI()
            break
        case .guest:
            setupGuestUI()
            break
        case .privilegedGuest:
            setupPrivilegedGuestUI()
            break
        
            
        }
        
        
    }
    
    //MARK: -Helpers
    fileprivate func setupHostUI() {
        // show end activity button
        view.addSubview(endButton)
        endButton.translatesAutoresizingMaskIntoConstraints = false
        endButton.customTBLTConstraint(top: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor,topConst: 3, trailingConst: 3)
        endButton.customHeightWidthConstraint(height: 30, width: 100)
        
        
        view.addSubview(audioButton)
        audioButton.translatesAutoresizingMaskIntoConstraints = false
        audioButton.customTBLTConstraint(top: LocalVideoView.safeAreaLayoutGuide.topAnchor, leading: LocalVideoView.leadingAnchor, topConst: 2, leadingConst: 2)
        view.addSubview(videoButton)
        videoButton.translatesAutoresizingMaskIntoConstraints = false
        videoButton.customTBLTConstraint(top: LocalVideoView.topAnchor, trailing: LocalVideoView.trailingAnchor, topConst: 2, trailingConst: 2)
        // show make privileged button
        
        // show the text informing the host that the user wants to become privileged
        
        // everything is enabled
//        view.addSubview(broadcastPicker)
//        broadcastPicker.translatesAutoresizingMaskIntoConstraints = false
//        broadcastPicker.customXYConstraint(x: content.centerXAnchor, y: content.centerYAnchor)
//
        view.addSubview(broadcastPicker)
        broadcastPicker.translatesAutoresizingMaskIntoConstraints = false
        broadcastPicker.customTBLTConstraint(top: content.topAnchor,bottom: content.bottomAnchor, leading: content.leadingAnchor, trailing: content.trailingAnchor, topConst: 50,bottomConst: 50, leadingConst: 10, trailingConst: 10)
    
        
        
        
    }
    fileprivate func setupGuestUI() {
        // show leave activity button
        view.addSubview(leaveButton)
        leaveButton.customTBLTConstraint(top: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor,topConst: 3, trailingConst: 3)
        leaveButton.customHeightWidthConstraint(height: 30, width: 100)
      
        // show request permission button
        view.addSubview(requestPermissionButton)
        requestPermissionButton.translatesAutoresizingMaskIntoConstraints = false
        requestPermissionButton.customTBLTConstraint(top: leaveButton.bottomAnchor, trailing: view.trailingAnchor, topConst: 3, trailingConst: 3)
       
        LocalVideoView.addSubview(noAccessLabel)
        noAccessLabel.translatesAutoresizingMaskIntoConstraints = false
        noAccessLabel.customXYConstraint(x: LocalVideoView.centerXAnchor, y: LocalVideoView.centerYAnchor)
        
        
        
    }
    fileprivate func setupPrivilegedGuestUI() {
//        setupLocalVideoView()
        requestPermissionButton.isHidden = true
        noAccessLabel.isHidden = true
        // show leave activity button
        // leave
        view.addSubview(leaveButton)
        leaveButton.customTBLTConstraint(top: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor,topConst: 3, trailingConst: 3)
        leaveButton.customHeightWidthConstraint(height: 30, width: 100)
        
        // hide request permission button
        requestPermissionButton.isHidden = true
        // interaction with video and audio button is allowed
        view.addSubview(audioButton)
        audioButton.translatesAutoresizingMaskIntoConstraints = false
        audioButton.customTBLTConstraint(top: LocalVideoView.topAnchor, leading: LocalVideoView.leadingAnchor, topConst: 2, leadingConst: 2)
        
        view.addSubview(videoButton)
        videoButton.translatesAutoresizingMaskIntoConstraints = false
        videoButton.customTBLTConstraint(top: LocalVideoView.topAnchor, trailing: LocalVideoView.trailingAnchor, topConst: 2, trailingConst: 2)
        // screen share
        view.addSubview(broadcastPicker)
        broadcastPicker.translatesAutoresizingMaskIntoConstraints = false
        broadcastPicker.customTBLTConstraint(top: content.topAnchor,bottom: content.bottomAnchor, leading: content.leadingAnchor, trailing: content.trailingAnchor, topConst: 50,bottomConst: 50, leadingConst: 10, trailingConst: 10)
    
        
    }
    
    fileprivate func setupGeneralUI() {
        // general
//        view.addSubview(backgroundView)
//        backgroundView.translatesAutoresizingMaskIntoConstraints = false
//        backgroundView.customTBLTConstraint(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        // UILabel
        view.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        
        //        UICollectionView
        view.addSubview(collectionView)
        collectionView.customTBLTConstraint(top: content.bottomAnchor,bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottomConst: 0, leadingConst: 0, trailingConst: 0)
//        collectionView.customHeightWidthConstraint(height: 200)
        //        view.addSubview(stackView)
        
        // local video
        view.addSubview(LocalVideoView)
        LocalVideoView.translatesAutoresizingMaskIntoConstraints = false
        LocalVideoView.customTBLTConstraint(top: view.safeAreaLayoutGuide.topAnchor, leading:  view.leadingAnchor, topConst: 10, leadingConst: 10)
        LocalVideoView.layer.cornerRadius = 10
        LocalVideoView.customHeightWidthConstraint(height: 100, width: 100)
        
       
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.customTBLTConstraint(top: view.safeAreaLayoutGuide.topAnchor , leading: LocalVideoView.trailingAnchor, topConst: 20)
        titleLabel.customXYConstraint(x: view.centerXAnchor)
        
        
      
        
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "YOU"
        nameLabel.customTBLTConstraint(top: LocalVideoView.topAnchor, topConst: 5)
        nameLabel.customXYConstraint(x: LocalVideoView.centerXAnchor)
        
        
        
        
        content.customXYConstraint(x: view.centerXAnchor, y: view.centerYAnchor)
        content.customTBLTConstraint(top: LocalVideoView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, topConst: 20, leadingConst: 10, trailingConst: 10)
       
    }
    
    
   
 
    fileprivate func preview(config: HMSConfig) {
        self.hmsSDK.preview(config: config, delegate: self)
    }
    fileprivate func joinRoom(config: HMSConfig) {
        self.hmsSDK.join(config: config, delegate: self)
    
        
    }
    fileprivate func collectionViewInit() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(VideoCollectionCell.self, forCellWithReuseIdentifier: String(describing:VideoCollectionCell.self))
        collectionView.frame = view.bounds
    }
    
    fileprivate func checkRole(role: HMSRole) -> Role? {
        if role.permissions.mute!,
           role.permissions.removeOthers!,
           role.permissions.changeRole!,
           role.permissions.endRoom!,
           role.permissions.unmute! {
            return .host
        } else if role.permissions.hlsStreaming! {
            return .guest
        } else if role.permissions.mute!{
            return .privilegedGuest
        }
        return nil
    }
    
  
    
    
    
    
}

//MARK: -UICollectionView protocols
extension RoomController:UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("number of peers in the room is \(hmsSDK.remotePeers?.count ?? 0)")
        return hmsSDK.remotePeers?.count ?? 0
       
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing:VideoCollectionCell.self), for: indexPath) as! VideoCollectionCell
        
        print("accessing \(indexPath.row)rd peer")
        print("track view map: \(trackViewMap)")
        
        var video: (key: HMSTrack, value: HMSVideoView)?
        var remotePeer: HMSRemotePeer?
        print("trackViewMap.count \(trackViewMap.count)")
        if !trackViewMap.isEmpty && trackViewMap.count > indexPath.row  {
            print("track is not empty")
             video = trackViewMap[indexPath.row]
             remotePeer = hmsSDK.remotePeers![indexPath.row]
        }
    
    
       
        
        
        if raisedHandUsers.contains(remotePeer?.peerID ?? "N/A") {
            cell.configure(hmsSDK: hmsSDK,videoView: video?.value, remotePeer: remotePeer, raised: true, activity: activity)
        } else {
            if let video = video {
                cell.configure(hmsSDK: hmsSDK,videoView: video.value, remotePeer: remotePeer, raised: false, activity: activity)
            } else {
                cell.configure(hmsSDK: hmsSDK,videoView: nil, remotePeer: remotePeer, raised: false, activity: activity)

            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150  , height: 150  )
   
    }

}

//MARK: -HMSUpdateListener
extension RoomController: HMSUpdateListener {
    func on(join room: HMSRoom) {
        print("a new participant has joined the room")
        
        DispatchQueue.main.async {
            print("remote peers: \(String(describing: self.hmsSDK.remotePeers))")
            self.collectionView.reloadData()
        }
      
        
    }
    
    func on(room: HMSRoom, update: HMSRoomUpdate) {
       
    }
    
    func on(peer: HMSPeer, update: HMSPeerUpdate) {
        switch update {
        case .peerLeft:
            if let videoTrack = peer.videoTrack {
                removeVideoView(for: videoTrack)
            }
            
        case .roleUpdated:
            
            if localPeer?.role?.name == "guest" {
                setupGuestUI()
            } else {
                shouldSetLocalVideo = true
                setupPrivilegedGuestUI()
             
            }
            print("role changed")
        case .peerJoined:
            print("a new peer has joined us")
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        default:
            break
        }
    }
    
    func on(track: HMSTrack, update: HMSTrackUpdate, for peer: HMSPeer) {
        switch update {
           case .trackAdded:
            if  let videoTrack = track as? HMSVideoTrack  {
//                if !shouldSetLocalVideo {
                    addVideoView(for: videoTrack)
//                } else {
//                    setupLocalVideoView(localVideo: videoTrack)
//                }
               
            }
               
           case .trackRemoved:
               if let videoTrack = track as? HMSVideoTrack {
                   removeVideoView(for: videoTrack)
               }
        case .trackDescriptionChanged:
            if let videoTrack = track as? HMSVideoTrack {
                addVideoView(for: videoTrack)
            }
            
        case .trackUnmuted:
            setupLocalVideoView()
            setupPrivilegedGuestUI()
      
        
           default:
               break
           }
    }
    
    func on(error: HMSError) {
       
        print("couldnt join room because \(error.message)")
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
       
        videoView.setVideoTrack(track)

        print("track desc: \(track.trackDescription)")
        
        if track.trackDescription == "Just a normal screen track"
        {
           
            trackViewMap[track] = videoView
        
            content.addSubview(videoView)
            videoView.translatesAutoresizingMaskIntoConstraints = false
            videoView.customTBLTConstraint(top: content.topAnchor, bottom: content.bottomAnchor, leading: content.leadingAnchor, trailing: content.trailingAnchor)
            return
        }
        
        
        
        
        trackViewMap[track] = videoView
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
        
//        Just a normal screen track
       
        
    }
    
    func removeVideoView(for track: HMSVideoTrack) {
        print("a participant has left")
        trackViewMap[track]?.removeFromSuperview()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func setupLocalVideoView(localVideo: HMSVideoTrack? = nil) {
        if  let localTrack = hmsSDK.localPeer?.videoTrack {
            LocalVideoView.setVideoTrack(localTrack)
            
            print("local peer has the role of \(hmsSDK.localPeer?.role?.name)")
            print("remote peers: \(self.hmsSDK.remotePeers)")
           
            print("available roles: ")
            for i in hmsSDK.roles {
                print(i.name)
                print("this role can do the followings: ")
                
                
                
            }
            shouldSetLocalVideo = false
        } else {
            if let localVideo = localVideo {
                print("apparently im here")
                LocalVideoView.setVideoTrack(localVideo)
                shouldSetLocalVideo = false
            }
        }
    }
}
// MARK: - HMSPreviewListener
extension RoomController: HMSPreviewListener  {
    
    func onPreview(room: HMSRoom, localTracks: [HMSTrack]) {
        localPeer = hmsSDK.localPeer
    
        print("preview is running...")
        print("remote peers: \(hmsSDK.remotePeers!)")
//        if let remotepeers = hmsSDK.remotePeers {
//            for i in remotepeers {
//                if let track = i.videoTrack {
//                    addVideoView(for: track)
//                }
//               
//            }
//            
//        }
        if let participant = participant {
            participant.storePeerId(activityId: activity.uid,id: localPeer?.peerID ?? "")
        }
        if localPeer?.role?.name != "guest" {
            setupLocalVideoView()
        }
       
       
        
        joinRoom(config: config)
        
    
    }

}
//MARK: -UIViewControllerRepresentable
struct Room: UIViewControllerRepresentable {
    var activity: Activity
    var token: String
    var participant: Participant?
   
    
    func makeUIViewController(context: Context) -> RoomController {
        if let participant = participant {
            return RoomController(activity: activity,token: token,participant: participant)
        } else {
            return RoomController(activity: activity,token: token)
        }
        
    }
    
    func updateUIViewController(_ uiViewController: RoomController, context: Context) {
        
    }
    
    typealias UIViewControllerType = RoomController
}


//
//class TestViewController: UIViewController, UIGestureRecognizerDelegate {
//    var defaultConstraint: NSLayoutConstraint!
//    var customConstraint: NSLayoutConstraint!
//    lazy var button: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = .systemRed
//        button.setTitle("Tap Me!", for: .normal)
//        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
//        return button
//    }()
//    @objc func tapped() {
//
//        UIView.animate(withDuration: 0.9, delay: 0.8, options: .curveEaseOut) {
//            self.defaultConstraint.isActive.toggle()
//            self.customConstraint = self.button.heightAnchor.constraint(equalToConstant: 400)
//            self.customConstraint.isActive.toggle()
//            self.view.layoutIfNeeded()
//        }
//
//
//    }
//    override func viewDidLoad() {
//        view.addSubview(button)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        defaultConstraint = button.heightAnchor.constraint(equalToConstant: 100)
//        defaultConstraint.isActive = true
//
//
//
//
//    }
////    override public func updateViewConstraints() {
////        super.updateViewConstraints()
////
////        button.customHeightWidthConstraint(height: 100, width: 100)
////    }
//
//
//}
//
//struct Test: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> TestViewController {
//        return TestViewController()
//    }
//
//    func updateUIViewController(_ uiViewController: TestViewController, context: Context) {
//
//    }
//
//    typealias UIViewControllerType = TestViewController
//}
