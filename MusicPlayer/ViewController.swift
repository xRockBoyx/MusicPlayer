//
//  ViewController.swift
//  MusicPlayer
//
//  Created by 黃威愷 on 2019/11/21.
//  Copyright © 2019 iOSClub. All rights reserved.
//

import UIKit

import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var Music_Title: UILabel!
    
    @IBOutlet weak var Slider: UISlider!
    
    @IBOutlet weak var AlbumCover: UIImageView!
    
    let playList = ["What's_wrong","Heaven","You_complete_me"]
    
    var path = Bundle.main.path(forResource: "What's_wrong", ofType: "mp3")
    var player = AVAudioPlayer()
    
    var index = 0
    
    var timer:Timer?
    
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.setBackgroundImage(UIImage(named: "Play"), for: .normal)
        
        startTimer()
        
        // Do any additional setup after loading the view.
    }
    
    @objc func updateSlider(){
        Slider.maximumValue = Float(player.duration)
        Slider.value = Float(player.currentTime)
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateSlider), userInfo: nil, repeats: true)
        
    }
    
    func stopTimer(){
        timer?.invalidate()
    }
    
    func setSong(mode:String){
        if (mode == "Next"){
            index = (index + 1) % 3
        }
        else{
            if(index - 1 < 0){
                index = 2
            }else{
                index = (index - 1) % 3
            }
        }
        
        path = Bundle.main.path(forResource: playList[index], ofType: "mp3")
    }
    
    func setAlbumCover(number:Int){
        AlbumCover.image = UIImage(named: playList[number])
    }
    func setTitle(number:Int){
        Music_Title.text = playList[number]
        Music_Title.sizeToFit()
    }
    
    @IBAction func Play(_ sender: Any) {
        let url = URL(fileURLWithPath: path!)
        if (player.isPlaying){
            playButton.setBackgroundImage(UIImage(named: "Play"), for: .normal)
            player.pause()
        }
        else{
            do{
                if(player.currentTime == 0){
                    player = try AVAudioPlayer(contentsOf: url)
                    
                }
                playButton.setBackgroundImage(UIImage(named: "Pause"), for: .normal)
                player.play()
                
            }catch{
                print("Read file Error!")
            }
        }
    }
    @IBAction func Next(_ sender: Any) {
        setSong(mode: "Next")
        setAlbumCover(number: index)
        setTitle(number: index)
        let url = URL(fileURLWithPath: path!)
        do{
            player = try AVAudioPlayer(contentsOf: url)
            playButton.setBackgroundImage(UIImage(named: "Pause"), for: .normal)

            Slider.minimumValue = 0
            Slider.maximumValue = Float(player.duration)
            
            player.play()
        }catch{
            print("Read file Error!")
        }
    }
    @IBAction func Back(_ sender: Any) {
        setSong(mode: "Back")
        
        setAlbumCover(number: index)
        setTitle(number: index)
        let url = URL(fileURLWithPath: path!)
        do{
            player = try AVAudioPlayer(contentsOf: url)
            playButton.setBackgroundImage(UIImage(named: "Pause"), for: .normal)
            
            Slider.minimumValue = 0
            Slider.maximumValue = Float(player.duration)

            player.play()
        }catch{
            print("Read file Error!")
        }
    }
    @IBAction func sliderChange(_ sender: UISlider) {
        sender.isContinuous = false
        stopTimer()
        player.currentTime = TimeInterval(Slider.value)
        player.play()
        
        startTimer()
    }
}

