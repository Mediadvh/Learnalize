//
//  VideoCollectionCell.swift
//  Learnalize
//
//  Created by Media Davarkhah on 5/9/1401 AP.
//

import UIKit
import HMSSDK

class VideoCollectionCell: UICollectionViewCell {
    var remotePeer: HMSRemotePeer!
    var video: HMSVideoView!
    var hmsSDK: HMSSDK!
    let muteAudioImage = UIImage(systemName: "mic.slash.fill")
    let unmuteAudioImage = UIImage(systemName: "mic.fill")
    
    let muteVideoImage = UIImage(systemName: "video.slash.fill")
    let unmuteVideoImage = UIImage(systemName: "video.fill")
    
    override var reuseIdentifier: String?{
        return String(describing: VideoCollectionCell.self)
    }
    
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
//            remotePeer.remoteVideoTrack()?.isMute()
    
            hmsSDK.localPeer?.localVideoTrack()?.setMute(true)
            videoButton.setBackgroundImage(unmuteVideoImage, for: .normal)
        } else {
            hmsSDK.localPeer?.localVideoTrack()?.setMute(false)
            videoButton.setBackgroundImage(muteVideoImage, for: .normal)
        }
      
    }

    func configure(hmsSDK: HMSSDK ,videoView: HMSVideoView, remotePeer: HMSRemotePeer) {
       
        self.remotePeer = remotePeer
        
        contentView.backgroundColor = .clear
        
        contentView.addSubview(videoView)
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.customTBLTConstraint(top: contentView.topAnchor, leading:  contentView.leadingAnchor, topConst: 10, leadingConst: 10)
        videoView.customHeightWidthConstraint(height: 100 , width: 100)
        videoView.layer.cornerRadius = 10
        
        videoView.addSubview(audioButton)
        audioButton.translatesAutoresizingMaskIntoConstraints = false
        audioButton.customTBLTConstraint(top: videoView.topAnchor, leading: videoView.leadingAnchor, topConst: 2, leadingConst: 2)
        
        videoView.addSubview(videoButton)
        videoButton.translatesAutoresizingMaskIntoConstraints = false
        videoButton.customTBLTConstraint(top: videoView.topAnchor, trailing: videoView.trailingAnchor, topConst: 2, trailingConst: 2)
        
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = remotePeer.name
        nameLabel.numberOfLines = 0
        nameLabel.customTBLTConstraint(top: videoView.topAnchor, topConst: 5)
        nameLabel.customXYConstraint(x: videoView.centerXAnchor)
        
        
    }
}
