//
//  SoundManager.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 05/03/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import SpriteKit
import AVFoundation

enum Sound {
    case coin, overrun, click, die, win, lose
}

enum Music {
    case level, world
}

class SoundManager {
    private let playCoin = SKAction.playSoundFileNamed("coins.caf", waitForCompletion: false)
    private let playOverrun = SKAction.playSoundFileNamed("overrun.caf", waitForCompletion: false)
    private let playClick = SKAction.playSoundFileNamed("click.caf", waitForCompletion: false)
    private let playDie = SKAction.playSoundFileNamed("die.caf", waitForCompletion: false)
    private let playWin = SKAction.playSoundFileNamed("win.caf", waitForCompletion: false)
    private let playLose = SKAction.playSoundFileNamed("lose.caf", waitForCompletion: false)

    private var backgroundMusicPlayer = AVAudioPlayer()
    
    weak var currentScene: SKScene?
    
    static let sharedInstance = SoundManager()
    
    private init() {
    }
    
    func playMusic(music: Music, inScene scene: SKScene) {
        switch music {
        case .level:
            playBackgroundMusic(filename: "background level.mp3")
        case .world:
            playBackgroundMusic(filename: "background.mp3")
        }
    }
    
    func playSound(_ sound: Sound, inScene scene: SKScene) {
        switch sound {
        case .coin:
            scene.run(playCoin)
        case .overrun:
            scene.run(playOverrun)
        case .click:
            scene.run(playClick)
        case .die:
            scene.run(playDie)
        case .win:
            scene.run(playWin)
        case .lose:
            scene.run(playLose)
        }
    }
    
    func playSound(_ sound: Sound) {
        guard let currentScene = self.currentScene else { return }
        playSound(sound, inScene: currentScene)
    }
    
    func stopMusic() {
        backgroundMusicPlayer.stop()
    }
    
    private func playBackgroundMusic(filename: String) {
        let url = Bundle.main.url(forResource: filename, withExtension: nil)
        guard let newURL = url else {
            print("Could not find file: \(filename)")
            return
        }
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: newURL)
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.volume = 0.3
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
}
