//
//  VideoCollectionCell.swift
//  Learnalize
//
//  Created by Media Davarkhah on 5/9/1401 AP.
//

import UIKit
import HMSSDK

class VideoCollectionCell: UICollectionViewCell {
    var constraint1: NSLayoutConstraint!
    var constraint2: NSLayoutConstraint!
    var remotePeer: HMSRemotePeer!
    var video: HMSVideoView!
    var hmsSDK: HMSSDK!
//    let muteAudioImage = UIImage(systemName: "mic.slash.fill")
//    let unmuteAudioImage = UIImage(systemName: "mic.fill")
//
//    let muteVideoImage = UIImage(systemName: "video.slash.fill")
//    let unmuteVideoImage = UIImage(systemName: "video.fill")
    
    override var reuseIdentifier: String?{
        return String(describing: VideoCollectionCell.self)
    }
    lazy var emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
//    lazy var audioButton: UIButton = {
//        let button = UIButton()
//        button.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
//        button.setBackgroundImage(UIImage(systemName: "mic.fill"), for: .normal)
//        button.addTarget(self, action: #selector(muteAudioTapped), for: .touchUpInside)
//        return button
//    }()
//
//    lazy var videoButton: UIButton = {
//        let button = UIButton()
//        button.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
//        button.setBackgroundImage(UIImage(systemName: "video.fill"), for: .normal)
//        button.addTarget(self, action: #selector(muteVideoTapped), for: .touchUpInside)
//        return button
//    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    lazy var raisedHandImage: UIImageView = {
       let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(
            pointSize: 30, weight: .medium, scale: .default)
        let image = UIImage(systemName: "hand.raised.fill", withConfiguration: config)
        imageView.image = image
        imageView.tintColor = .systemYellow
        return imageView
    }()
    lazy var allowButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(
            pointSize: 20, weight: .medium, scale: .default)
        let image = UIImage(systemName: "checkmark.square.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
    
        button.addTarget(self, action: #selector(allowButtonTapped), for: .touchUpInside)
        button.tintColor = .systemGreen
        button.layer.cornerRadius = 3
        return button
        
    }()
    lazy var disallowButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(
            pointSize: 20, weight: .medium, scale: .default)
        let image = UIImage(systemName: "x.square.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(disallowButtonTapped), for: .touchUpInside)
        button.tintColor = .systemRed
        button.layer.cornerRadius = 3
        return button
    }()
    //     should be called from main queue
   
    
    
    @objc func allowButtonTapped() {
        if let remotePeer = remotePeer {
            print( "available roles: ")
            
            for i in hmsSDK.roles {
                print(i.name)
            }
                        
            var privilegedGuest: HMSRole
            // from guest to privileged guest
            if self.hmsSDK.roles[0].name == "privileged-guest" {
                privilegedGuest = self.hmsSDK.roles[0]
            } else if self.hmsSDK.roles[1].name == "privileged-guest" {
                privilegedGuest = self.hmsSDK.roles[1]
            } else  {
                privilegedGuest = self.hmsSDK.roles[2]
            }
            
            
            hmsSDK.changeRole(for: remotePeer, to: privilegedGuest, force: true) { res, error in
                print("for peer \(remotePeer.peerID)")
                print(" to \(privilegedGuest.name)")
                guard error == nil, res else {
                    
                    print("could not change the role")
                    return
                }
                print("successfully changed the role")
                
                self.allowButton.isHidden = true
                self.raisedHandImage.isHidden = true
                
                    // TODO: remove from permission list
                
            }
        }
    }
    @objc func disallowButtonTapped() {
        if let remotePeer = remotePeer {
            print( "available roles: ")
            
            for i in hmsSDK.roles {
                print(i.name)
            }
            var guest: HMSRole
            // from guest to privileged guest
            if self.hmsSDK.roles[0].name == "guest" {
                guest = self.hmsSDK.roles[0]
            } else if self.hmsSDK.roles[1].name == "guest" {
                guest = self.hmsSDK.roles[1]
            } else  {
                guest = self.hmsSDK.roles[2]
            }
            
                        
            
            hmsSDK.changeRole(for: remotePeer, to: guest, force: true) { res, error in
               
                print("for peer \(remotePeer.peerID)")
                print(" to \(guest.name)")
                
                guard error == nil, res else {
                    
                    print("could not change the role")
                    return
                }
                print("successfully changed the role")
                
                self.allowButton.isHidden = true
                self.raisedHandImage.isHidden = true
                self.disallowButton.isHidden = true
                
                // TODO: remove from permission list
                
            }
        }
        
    }
    
   
    func configure(hmsSDK: HMSSDK ,videoView: HMSVideoView? = nil, remotePeer: HMSRemotePeer?, raised: Bool = false, activity: Activity) {
        self.hmsSDK = hmsSDK
      
        print("fetching participants name with id:\(remotePeer?.peerID ?? "N/A")")
        activity.fetchParticipant(with: remotePeer?.peerID ?? "N/A") { user, error in
            guard let user = user, error == nil else {
                return
            }
            self.nameLabel.text = user.username
        }
        
        var assignedView = emptyView
        if let videoView = videoView {
          
            assignedView = videoView
//            assignedView.addSubview(audioButton)
//            audioButton.translatesAutoresizingMaskIntoConstraints = false
//            audioButton.customTBLTConstraint(top: assignedView.topAnchor, leading: assignedView.leadingAnchor, topConst: 2, leadingConst: 2)
//
//
//            assignedView.addSubview(videoButton)
//            videoButton.translatesAutoresizingMaskIntoConstraints = false
//            videoButton.customTBLTConstraint(top: assignedView.topAnchor, trailing: assignedView.trailingAnchor, topConst: 2, trailingConst: 2)
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
        nameLabel.text = remotePeer?.name
        nameLabel.numberOfLines = 0
        nameLabel.customTBLTConstraint(top: assignedView.topAnchor, topConst: 5)
        nameLabel.customXYConstraint(x: assignedView.centerXAnchor)
        
        
        if raised {
            assignedView.addSubview(raisedHandImage)
            raisedHandImage.translatesAutoresizingMaskIntoConstraints = false
            raisedHandImage.customXYConstraint(x: assignedView.centerXAnchor, y: assignedView.centerYAnchor)
            
            contentView.addSubview(allowButton)
            allowButton.translatesAutoresizingMaskIntoConstraints = false
            allowButton.customTBLTConstraint(top: raisedHandImage.bottomAnchor, bottom: assignedView.bottomAnchor, leading: assignedView.leadingAnchor, topConst: 2,bottomConst: 2, leadingConst: 2)
          // allowButton.customXYConstraint(x: assignedView.centerXAnchor)
             
            
            contentView.addSubview(disallowButton)
            disallowButton.translatesAutoresizingMaskIntoConstraints = false
            disallowButton.customTBLTConstraint(top: raisedHandImage.bottomAnchor, bottom: assignedView.bottomAnchor, trailing: assignedView.trailingAnchor,topConst: 2,bottomConst: 2, trailingConst: 2)
           // disallowButton.customXYConstraint(x: assignedView.centerXAnchor)
             
            
        }
    }
}
