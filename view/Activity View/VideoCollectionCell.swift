//
//  VideoCollectionCell.swift
//  Learnalize
//
//  Created by Media Davarkhah on 5/9/1401 AP.
//

import UIKit
import HMSSDK

class VideoCollectionCell: UICollectionViewCell {
    var video: HMSVideoView!
    
    override var reuseIdentifier: String?{
        return String(describing: VideoCollectionCell.self)
    }
    
//    lazy var muteAudioButton: UIButton = {
//        let button = UIButton()
//        button.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
//        button.setBackgroundImage(UIImage(systemName: "mic.fill"), for: .normal)
//        button.setTitle("mute", for: .normal)
//        button.addTarget(self, action: #selector(muteAudioTapped), for: .touchUpInside)
//        return button
//    }()
//    lazy var unmuteAudioButton: UIButton = {
//        let button = UIButton()
//        button.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
//        button.setBackgroundImage(UIImage(systemName: "mic.slash.fill"), for: .normal)
//        button.setTitle("unmute", for: .normal)
//        button.addTarget(self, action: #selector(muteAudioTapped), for: .touchUpInside)
//        return button
//    }()
//    lazy var muteVideoButton: UIButton = {
//        let button = UIButton()
//        button.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
//        button.setBackgroundImage(UIImage(systemName: "video.slash.fill"), for: .normal)
//        button.setTitle("mute", for: .normal)
//        button.addTarget(self, action: #selector(muteAudioTapped), for: .touchUpInside)
//        return button
//    }()
//    lazy var unmuteVideoButton: UIButton = {
//        let button = UIButton()
//        button.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
//        button.setBackgroundImage(UIImage(systemName: "video.fill"), for: .normal)
//        button.setTitle("unmute", for: .normal)
//        button.addTarget(self, action: #selector(muteAudioTapped), for: .touchUpInside)
//        return button
//    }()
  
    // should be called from main queue
//    @objc func muteAudioTapped() {
//        hmsSDK.localPeer?.localAudioTrack()?.setMute(true)
//    }
//    @objc func unmuteAudioTapped() {
//        hmsSDK.localPeer?.localAudioTrack()?.setMute(false)
//    }
//    @objc func muteVideoTapped() {
//        hmsSDK.localPeer?.localVideoTrack()?.setMute(true)
//    }
//    @objc func unmuteVideoTapped() {
//        hmsSDK.localPeer?.localVideoTrack()?.setMute(false)
//    }
//
    func configure(videoView: HMSVideoView) {
       
        contentView.backgroundColor = .systemCyan
        contentView.addSubview(videoView)
        videoView.translatesAutoresizingMaskIntoConstraints = false
        
        videoView.heightAnchor.constraint(equalTo: videoView.widthAnchor, multiplier: 9.0/16.0).isActive = true
        
    }
}
