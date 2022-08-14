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

class RoomController: UIViewController, UIGestureRecognizerDelegate {
    // MARK: -Properties
   
    
    var defaultHeightConstraint: NSLayoutConstraint!
    var defaultWidthConstraint: NSLayoutConstraint!
    var zoomedHeightConstraint: NSLayoutConstraint!
    var zoomedWidthConstraint: NSLayoutConstraint!
    
    var config: HMSConfig!
    var collectionView: UICollectionView!
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
        config = HMSConfig(authToken: token)
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
        return v
    }()
    lazy var LocalVideoView: HMSVideoView = {
        let video = HMSVideoView()
        return video
    }()
    
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
        button.layer.cornerRadius = 4
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
 
    let muteAudioImage = UIImage(systemName: "mic.slash.fill")
    let unmuteAudioImage = UIImage(systemName: "mic.fill")
    
    let muteVideoImage = UIImage(systemName: "video.slash.fill")
    let unmuteVideoImage = UIImage(systemName: "video.fill")
    
    
    
    lazy var audioButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        button.setBackgroundImage(UIImage(systemName: "mic.fill"), for: .normal)
        button.addTarget(self, action: #selector(muteAudioTapped), for: .touchUpInside)
        return button
    }()

    lazy var videoButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        button.setBackgroundImage(UIImage(systemName: "video.slash.fill"), for: .normal)
        button.addTarget(self, action: #selector(muteAudioTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    lazy var backgroundView: UIView = {
        let myView = UIView()
        myView.backgroundColor = UIColor(named: activity.tagColor)
        return myView
    }()
//
//    lazy var shareScreenButton: UIButton = {
//        var button = UIButton()
//        button.setTitle("Share My Screen", for: .normal)
//        button.addTarget(self, action: #selector(prepareSystemBroadcaster), for: .touchUpOutside)
//        button.backgroundColor = .red
//        button.layer.cornerRadius = 10
//        return button
//    }()
//    lazy var broadcastPicker: RPSystemBroadcastPickerView = {
//        let picker = RPSystemBroadcastPickerView()
//        picker.preferredExtension = "com.mediadh.App.Learnalize"
//        return picker
//    }()
    
    lazy var content: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
//    @objc func shareScreenTapped() {
//        view.addSubview(broadcastPicker)
//        broadcastPicker.translatesAutoresizingMaskIntoConstraints = false
//        broadcastPicker.customXYConstraint(x: view.centerXAnchor, y: view.centerYAnchor)
//    }
  
    
//     should be called from main queue
    @objc func muteAudioTapped() {
        if videoButton.backgroundImage(for: .normal) == muteAudioImage {
            hmsSDK.localPeer?.localAudioTrack()?.setMute(true)
            audioButton.setBackgroundImage(unmuteAudioImage, for: .normal)
        } else {
            hmsSDK.localPeer?.localAudioTrack()?.setMute(false)
            audioButton.setBackgroundImage(muteAudioImage, for: .normal)
        }
    }
   
    @objc func muteVideoTapped() {
        if videoButton.backgroundImage(for: .normal) == videoButton {
            hmsSDK.localPeer?.localVideoTrack()?.setMute(true)
            videoButton.setBackgroundImage(unmuteVideoImage, for: .normal)
        } else {
            hmsSDK.localPeer?.localVideoTrack()?.setMute(false)
            videoButton.setBackgroundImage(muteVideoImage, for: .normal)
        }
      
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewInit()
        prepareSystemBroadcaster()
        preview(config: config)
        
      
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapVideo(_:)))
        tapGesture.delegate = self
        
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        
        LocalVideoView.addGestureRecognizer(tapGesture)
        LocalVideoView.isUserInteractionEnabled = true
        
      
        
    }
    
    @objc func tapVideo(_ sender: UITapGestureRecognizer) {
        defaultWidthConstraint.isActive.toggle()
        defaultHeightConstraint.isActive.toggle()
        
        zoomedHeightConstraint =  LocalVideoView.heightAnchor.constraint(equalToConstant: 500)
         zoomedWidthConstraint =
         LocalVideoView.widthAnchor.constraint(equalToConstant: 500)
        zoomedHeightConstraint.isActive = true
        zoomedWidthConstraint.isActive = true
       
    }
    
    
   

    
    override func viewDidLayoutSubviews() {
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.customTBLTConstraint(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        // UILabel
        view.addSubview(titleLabel)
        titleLabel.customTBLTConstraint(top: view.safeAreaLayoutGuide.topAnchor , leading: view.leadingAnchor, trailing: view.trailingAnchor, topConst: 20)
        view.addSubview(leaveButton)
        leaveButton.customTBLTConstraint(top: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor,topConst: 3, trailingConst: 3)
        leaveButton.customHeightWidthConstraint(height: 30, width: 100)
        
//        UICollectionView
        view.addSubview(collectionView)
        collectionView.customTBLTConstraint(bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottomConst: 0, leadingConst: 0, trailingConst: 0)
        collectionView.customHeightWidthConstraint(height: 200)
//        view.addSubview(stackView)
        
        // local video
        view.addSubview(LocalVideoView)
        LocalVideoView.translatesAutoresizingMaskIntoConstraints = false
        LocalVideoView.customTBLTConstraint(top: view.topAnchor, leading:  view.leadingAnchor, topConst: 10, leadingConst: 10)
        LocalVideoView.layer.cornerRadius = 10
        // default constraint
       defaultHeightConstraint =  LocalVideoView.heightAnchor.constraint(equalToConstant: 100)
        defaultWidthConstraint =
        LocalVideoView.widthAnchor.constraint(equalToConstant: 100)
        
        defaultHeightConstraint.isActive = true
        defaultWidthConstraint.isActive = true
        
        // zoomed constraint
       
        
//        zoomedHeightConstraint.isActive = true
//        zoomedWidthConstraint.isActive = true

        
        
        view.addSubview(audioButton)
        audioButton.translatesAutoresizingMaskIntoConstraints = false
        audioButton.customTBLTConstraint(top: LocalVideoView.topAnchor, leading: LocalVideoView.leadingAnchor, topConst: 2, leadingConst: 2)
        view.addSubview(videoButton)
        videoButton.translatesAutoresizingMaskIntoConstraints = false
        videoButton.customTBLTConstraint(top: LocalVideoView.topAnchor, trailing: LocalVideoView.trailingAnchor, topConst: 2, trailingConst: 2)
        
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "YOU"
        nameLabel.customTBLTConstraint(top: LocalVideoView.topAnchor, topConst: 5)
        nameLabel.customXYConstraint(x: LocalVideoView.centerXAnchor)
        
        
        
        view.addSubview(content)
        content.customXYConstraint(x: view.centerXAnchor, y: view.centerYAnchor)
        content.customHeightWidthConstraint(height: view.frame.height - 250, width: view.frame.width - 50)
        
//        content.addSubview(shareScreenButton)
//        shareScreenButton.translatesAutoresizingMaskIntoConstraints = false
//        shareScreenButton.customXYConstraint(x: content.centerXAnchor, y: content.centerYAnchor)
        
    }
    
   
    
    
    //MARK: -Helpers
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
    
    // broadcast
    func prepareSystemBroadcaster() {
        print("tapped screen share")
        let frame = CGRect(x: 0, y:0, width: 44, height: 44)
        let systemBroadcastPicker = RPSystemBroadcastPickerView(frame: frame)
        systemBroadcastPicker.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin]
        systemBroadcastPicker.preferredExtension = "com.mediadh.App.Learnalize.broadcast"
        systemBroadcastPicker.showsMicrophoneButton = false
        
        for view in systemBroadcastPicker.subviews {
            if let button = view as? UIButton {
                
                let configuration = UIImage.SymbolConfiguration(pointSize: 24)
                let image = UIImage(systemName: "rectangle.on.rectangle", withConfiguration: configuration)?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
                button.setImage(image, for: .normal)
            }
        }
        
        broadcasterPickerContainer.addSubview(systemBroadcastPicker)
        systemBroadcastPicker.translatesAutoresizingMaskIntoConstraints = false
        systemBroadcastPicker.customXYConstraint(x: broadcasterPickerContainer.centerXAnchor, y: broadcasterPickerContainer.centerYAnchor)
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
        let remotePeer = hmsSDK.remotePeers![indexPath.row]
        cell.configure(hmsSDK: hmsSDK,videoView: video.value, remotePeer: remotePeer)
        
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
       
        videoView.setVideoTrack(track)
//        videoView.heightAnchor.constraint(equalTo: videoView.widthAnchor, multiplier: 9.0/16.0).isActive = true
//        stackView.addArrangedSubview(videoView)
        trackViewMap[track] = videoView
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    
    func removeVideoView(for track: HMSVideoTrack) {
        print("a participant has left")
        trackViewMap[track]?.removeFromSuperview()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
// MARK: - HMSPreviewListener
extension RoomController: HMSPreviewListener  {
    
    func onPreview(room: HMSRoom, localTracks: [HMSTrack]) {
        print("preview is running...")
        let localTrack = (hmsSDK.localPeer?.videoTrack)!
        LocalVideoView.setVideoTrack(localTrack)

        joinRoom(config: config)
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
