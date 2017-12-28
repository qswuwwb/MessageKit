/*
 MIT License

 Copyright (c) 2017 MessageKit

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit

open class MediaMessageCell: MessageCollectionViewCell<UIImageView> {

    // MARK: - Properties

    open lazy var playButtonView: PlayButtonView = {
        let playButtonView = PlayButtonView()
        playButtonView.frame.size = CGSize(width: 35, height: 35)
        return playButtonView
    }()

    open lazy var durationView: UILabel = {
        let durationView = UILabel()
        durationView.text = "10''"
        durationView.font = UIFont.systemFont(ofSize: 14)
        durationView.textColor = .darkGray
        durationView.sizeToFit()
        return durationView
    }()
    
    open lazy var unReadView: UIView = {
        let unreadView = UIView()
        unreadView.layer.cornerRadius = 3
        unreadView.backgroundColor = UIColor.red
        return unreadView
    }()
    
    var constraintLeft: NSLayoutConstraint?
    var constraintRight: NSLayoutConstraint?
    
    var isAudioFromMe: Bool = true {
        didSet {
            guard let left = constraintLeft,
                let right = constraintRight else {
                return
            }
            left.isActive = isAudioFromMe
            right.isActive = !isAudioFromMe
        }
    }
    // MARK: - Methods

    private func setupPlayButtonConstraints() {
        playButtonView.translatesAutoresizingMaskIntoConstraints = false

        let centerX = playButtonView.centerXAnchor.constraint(equalTo: centerXAnchor)
        let centerY = playButtonView.centerYAnchor.constraint(equalTo: centerYAnchor)
        let width = playButtonView.widthAnchor.constraint(equalToConstant: playButtonView.bounds.width)
        let height = playButtonView.heightAnchor.constraint(equalToConstant: playButtonView.bounds.height)

        NSLayoutConstraint.activate([centerX, centerY, width, height])
    }
    
    private func setupDurationConstraints() {
        unReadView.translatesAutoresizingMaskIntoConstraints = false
        
        unReadView.widthAnchor.constraint(equalToConstant: 6).isActive = true
        unReadView.heightAnchor.constraint(equalToConstant: 6).isActive = true
        unReadView.centerXAnchor.constraint(equalTo: durationView.centerXAnchor, constant: 2).isActive = true
        unReadView.topAnchor.constraint(equalTo: durationView.bottomAnchor, constant: 4).isActive = true
    }
    
    private func setupUnReadViewConstraints() {
        durationView.translatesAutoresizingMaskIntoConstraints = false
        
        constraintRight = durationView.leadingAnchor.constraint(equalTo: messageContentView.trailingAnchor, constant: 8)
        constraintLeft = durationView.trailingAnchor.constraint(equalTo: messageContentView.leadingAnchor, constant: -8)
        durationView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -8).isActive = true
    }

    override func setupSubviews() {
        super.setupSubviews()
        messageContentView.clipsToBounds = false
        messageContainerView.clipsToBounds = false
        messageContentView.addSubview(playButtonView)
        messageContentView.addSubview(durationView)
        messageContentView.addSubview(unReadView)
        setupPlayButtonConstraints()
        setupDurationConstraints()
        setupUnReadViewConstraints()
    }

    override open func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        switch message.data {
        case .photo(let image):
            messageContentView.image = image
            playButtonView.isHidden = true
            unReadView.isHidden = true
            durationView.isHidden = true
        case .video(_, let image):
            messageContentView.image = image
            playButtonView.isHidden = false
        case .audio(let duration, let isMe, let isRead):
            durationView.text = "\(duration)''"
            isAudioFromMe = isMe
            unReadView.isHidden = isRead
            durationView.isHidden = false
            messageContentView.image = isMe ? #imageLiteral(resourceName: "bubble_sound_me_3"): #imageLiteral(resourceName: "bubble_sound_other_3")
            messageContentView.animationImages = isMe ? [#imageLiteral(resourceName: "bubble_sound_me_1"), #imageLiteral(resourceName: "bubble_sound_me_2"), #imageLiteral(resourceName: "bubble_sound_me_3")]: [#imageLiteral(resourceName: "bubble_sound_other_1"), #imageLiteral(resourceName: "bubble_sound_other_2"), #imageLiteral(resourceName: "bubble_sound_other_3")]
            messageContentView.animationDuration = 1
            playButtonView.isHidden = true
        default:
            break
        }
    }

}
