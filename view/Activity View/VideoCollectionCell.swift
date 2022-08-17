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
    lazy var emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
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
    lazy var raisedHandImage: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "hand.raised.fill")
        imageView.tintColor = .systemYellow
        return imageView
    }()
    lazy var allowButton: UIButton = {
        let button = UIButton()
        button.setTitle("allow", for: .normal)
        button.addTarget(self, action: #selector(allowButtonTapped), for: .touchUpInside)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 3
        return button
        
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
    
    @objc func allowButtonTapped() {
        if let remotePeer = remotePeer {
            print( "available roles: ")
            
            for i in hmsSDK.roles {
                print(i.name)
            }
                        
            
            hmsSDK.changeRole(for: remotePeer, to: hmsSDK.roles[2], force: true) { res, error in
                guard error == nil, res else {
                    print("could not change the role")
                    return
                }
                print("successfully changed the role")
            }
        }
    }
    
    func configure(hmsSDK: HMSSDK ,videoView: HMSVideoView? = nil, remotePeer: HMSRemotePeer, raised: Bool = false) {
        self.hmsSDK = hmsSDK
      
        
        var assignedView = emptyView
        if let videoView = videoView {
            assignedView = videoView
            assignedView.addSubview(audioButton)
            audioButton.translatesAutoresizingMaskIntoConstraints = false
            audioButton.customTBLTConstraint(top: assignedView.topAnchor, leading: assignedView.leadingAnchor, topConst: 2, leadingConst: 2)
            
            assignedView.addSubview(videoButton)
            videoButton.translatesAutoresizingMaskIntoConstraints = false
            videoButton.customTBLTConstraint(top: assignedView.topAnchor, trailing: assignedView.trailingAnchor, topConst: 2, trailingConst: 2)
        }

        self.remotePeer = remotePeer
        
        contentView.backgroundColor = .clear
        contentView.addSubview(assignedView)
        assignedView.translatesAutoresizingMaskIntoConstraints = false
        assignedView.customTBLTConstraint(top: contentView.topAnchor, leading:  contentView.leadingAnchor, topConst: 10, leadingConst: 10)
        assignedView.customHeightWidthConstraint(height: 100 , width: 100)
        assignedView.layer.cornerRadius = 10
        
        
        
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = remotePeer.name
        nameLabel.numberOfLines = 0
        nameLabel.customTBLTConstraint(top: assignedView.topAnchor, topConst: 5)
        nameLabel.customXYConstraint(x: assignedView.centerXAnchor)
        
        
        if raised {
            assignedView.addSubview(raisedHandImage)
            raisedHandImage.translatesAutoresizingMaskIntoConstraints = false
            raisedHandImage.customTBLTConstraint( leading: nameLabel.trailingAnchor, leadingConst: 3)
            
            contentView.addSubview(allowButton)
            allowButton.translatesAutoresizingMaskIntoConstraints = false
            allowButton.customTBLTConstraint(top: assignedView.bottomAnchor, bottom: contentView.bottomAnchor, topConst: 2,bottomConst: 2)
            allowButton.customXYConstraint(x: assignedView.centerXAnchor)
        }
    }
}
