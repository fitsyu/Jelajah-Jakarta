//
//  Video Pop Box.swift
//  Places
//
//  Created by Fitsyu on 08/12/2017.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

import AVFoundation

final class EmbeddedVideoPlayer: UIViewController
{
  @IBOutlet weak var playerView: UIView!
  
  var player: AVPlayer!
  
  var videoStringURL: String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    let videoURL = URL(string: videoStringURL)
    
    player = AVPlayer(url: videoURL!)
    //        player.volume = 1
    
    let playerLayer = AVPlayerLayer(player: player)
    
    playerLayer.frame = playerView.bounds
    playerView.layer.addSublayer(playerLayer)
    
    player.play()
  }
  
  
  func stopVideo()
  {
    player.pause()
    player = nil
  }
  
}


