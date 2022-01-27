//
//  VideoTableCell.swift
//  Popular Movies
//
//  Created by devmac on 20.01.2022.
//

import UIKit
import youtube_ios_player_helper

final class VideoTableCell: BaseTableViewCell {
    
    // MARK: - Private properties -
    private var isPlaying = false
    
    private lazy var videoView: YTPlayerView = {
        let view = YTPlayerView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init -
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods -
    func configure(with urlString: String) {
        videoView.load(withVideoId: urlString)
    }
    
    func playPauseVideo() {
        isPlaying ? videoView.pauseVideo() : videoView.playVideo()
        isPlaying.toggle()
    }
    
    // MARK: - Private methods -
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
