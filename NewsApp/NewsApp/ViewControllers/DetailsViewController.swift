//
//  DetailsViewController.swift
//  NewsApp
//
//  Created by Bedri Doğan on 17.03.2022.
//

import UIKit
import AVFoundation
import AVKit
import Moya

class DetailsViewController: UIViewController {
    var playerViewController = AVPlayerViewController()
    var playerView = AVPlayer()
    
    @IBOutlet weak var detailsTitleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var loadingButton: UIButton!
    @IBOutlet weak var spot: UILabel!
    
    var selectedNew: NewsDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        
    }
    
    func getData(){
        if let selectedSpot = selectedNew?.spot{
            self.spot.text = selectedSpot
        }
        if let selecteTitle = selectedNew?.title{
            self.detailsTitleLabel.text = selecteTitle
        }
        self.playButton.isHidden = true
        self.imageView.backgroundColor = .gray
        self.loadingButton.isHidden = false
        
        if let selectedVideoURL = selectedNew?.videoURL{
            if let url = URL(string: "\(selectedVideoURL.dropLast(14))") {
                self.getthumbnailFromImage(url: url) { (thumbImage) in
                    self.imageView.backgroundColor = nil
                    self.imageView.image = thumbImage
                    self.loadingButton.isHidden = true
                    self.playButton.isHidden = false
                }
            } else {
                self.loadingButton.isHidden = true
                self.imageView.backgroundColor = .gray
                self.imageView.image = UIImage(named: "noVideo")
            }
        }
    }
    func playVideo(){
        if let selectedVideoURL = selectedNew?.videoURL{
            let url : URL = URL(string: "\(selectedVideoURL.dropLast(14))")!
            playerView = AVPlayer(url: url as URL)
            playerViewController.player = playerView
            
            self.present(playerViewController, animated: true) {
                self.playerViewController.player?.play()
            }
        }
    }
    @IBAction func videoPlayActionButton(_ sender: Any) {
        playVideo()
    }
    

    func getthumbnailFromImage(url: URL, completion: @escaping ((_ image:UIImage?)->Void)){
        DispatchQueue.global().async {
            let asset = AVAsset(url: url)
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            
            let thumbNailTime = CMTimeMake(value: 7, timescale: 1)
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumbNailTime, actualTime: nil)
                let thumbImage = UIImage(cgImage: cgThumbImage)
                
                DispatchQueue.main.async {
                    completion(thumbImage)
                }
            } catch {
                    print(error.localizedDescription)
                }
            }
        }
    
    
    @IBAction func linkButtonClicked(_ sender: Any) {
        
        if let selectedLink = selectedNew?.webUrl {
            UIApplication.shared.openURL(URL(string: "\(selectedLink)")!)
        }
    }
    
    
    
    
    
    
}
