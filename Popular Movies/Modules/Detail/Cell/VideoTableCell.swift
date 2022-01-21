//
//  VideoTableCell.swift
//  Popular Movies
//
//  Created by devmac on 20.01.2022.
//

import UIKit
import youtube_ios_player_helper

final class VideoTableCell: BaseTableViewCell {
    
    private var isPlaying = false
    
    private lazy var videoView: YTPlayerView = {
        var view = YTPlayerView()
        view.delegate = self
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    func configure(with urlString: String) {
        videoView.load(withVideoId: urlString)
    }
    
    func playStopVideo() {
        switch isPlaying {
        case true:
            videoView.pauseVideo()
            isPlaying = false
        case false:
            videoView.playVideo()
            isPlaying = true
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        self.backgroundColor = .white
        self.addSubview(videoView)
        
        NSLayoutConstraint.activate([
            videoView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            videoView.topAnchor.constraint(equalTo: self.topAnchor),
            videoView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

extension VideoTableCell: YTPlayerViewDelegate {}
