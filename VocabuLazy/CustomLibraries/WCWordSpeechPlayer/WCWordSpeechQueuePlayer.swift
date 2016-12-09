//
//  WCWordSpeechQueuePlayer.swift
//  Swallow
//
//  Created by Goston on 2016/6/28.
//  Copyright © 2016年 WishCan. All rights reserved.
//

import AVFoundation

// ---------------------------------------------------------------------------------------------
// MARK: - WCWordSpeechQueuePlayerDelegate
@objc protocol WCWordSpeechQueuePlayerDelegate {
    @objc optional func speechPlayerDidFinishPlaying(_ speechPlayse: WCWordSpeechQueuePlayer, successfully flag: Bool)
}

class WCWordSpeechQueuePlayer: WCWordSpeechPlayer, AVSpeechSynthesizerDelegate {
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Variables
    var speechQueue: [String] = [String]()
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Initial
    required init() {
        super.init()
    }
    
    
    /// Initial with delegate
    ///
    /// - Parameter delegate: AVSpeechSynthesizerDelegate
    convenience init(withDelegate delegate: AVSpeechSynthesizerDelegate) {
        self.init()
        speechSynthesizer.delegate = delegate
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Speech action
    func startSpeechQueue(speechArray: [String]) {
        if speechArray.count > 0 {
            speechQueue = speechArray
        }
    }
    
    // MARK: - Queue action
    fileprivate func emptyQueue() {
        speechQueue.removeAll()
    }
    
    fileprivate func pushToQueue(_ value: String) {
        return speechQueue.insert(value, at: 0)
    }
    
    fileprivate func popFromQueue() -> String {
        return speechQueue.popLast()!
    }
    
    fileprivate func countOfQueue() -> Int {
        return speechQueue.count
    }
    
    fileprivate func frontOfQueue() -> String {
        return speechQueue.first!
    }
    
    fileprivate func backOfQueue() -> String {
        return speechQueue.last!
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - AVSpeechSynthesizerDelegate
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
//        <#code#>
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
//        <#code#>
    }
}
