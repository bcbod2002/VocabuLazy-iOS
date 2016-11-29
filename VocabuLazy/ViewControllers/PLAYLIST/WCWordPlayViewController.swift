//
//  WCWordPlayViewController.swift
//  Swallow
//
//  Created by Goston on 2015/8/21.
//  Copyright (c) 2015年 WishCan. All rights reserved.
//

//FIXME: 前景背景切換 - 背景切回前景的動畫還需要修改

import UIKit
import AVFoundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


//MARK: - SpeeechType
enum SpeechType: UInt {
    case english = 0
    case chinese = 1
}

class WCWordPlayViewController: UIViewController, AVSpeechSynthesizerDelegate, WCWordPlayScrollViewDelegate, WCWordPlayTableViewDelegate, WCWordPlaySettingViewDelegate, WCWordForegroundHandlerDelegate, WCWordBackgroundHandlerDelegate, WCAddToListPopViewDelegate {
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Variables
    // Define
    fileprivate let screenSize : CGSize = UIScreen.main.bounds.size
    
    // Public variable
    var levelString: String = ""
    var foregroundLessonNumber : UInt? = 0
    var allLessonsArray: [[WCVocabularyModel]]?
    
    // Interface Builder
    @IBOutlet var playPauseButton: UIButton!
    
    
    // Model components
    fileprivate var selectedSettingContentModel : WCSettingContentModel?
    fileprivate var selectedPattern : PatternType!
    
    // View components
    fileprivate var backgroundScrollView : WCWordPlayScrollView!
    fileprivate var wordPlayTableView :WCWordPlayTableView!
    fileprivate var wordPlaySettingView : WCWordPlaySettingView! = WCWordPlaySettingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    fileprivate let grayMaskView: UIView? = UIView()
    fileprivate var popView: WCAddToListPopView?
    
    // Speech and Present data
    fileprivate var wordSpeechPlayer: WCWordSpeechPlayer?
    fileprivate var vocabularyTupleArray = [(String, String)]()
    fileprivate var sentenceTupleArray = [[(String, String)]]()
    
    // WCWordGroundHandler
    var foregroundHandler: WCWordForegroundHandler? = WCWordForegroundHandler()
    var backgroundHandler: WCWordBackgroundHandler? = WCWordBackgroundHandler()
    
    // Other
    fileprivate var appStatusOberver : NotificationCenter?
    fileprivate var isAllowPlayAudio : Bool = false
    fileprivate var isForegroundStatus : Bool = true
    fileprivate var stopTimer : Timer?
    fileprivate var presentVocabularyType = SpeechType.english
    fileprivate var isCouldPlayAudio = true // View is appear 跟 Pause Button 用
    fileprivate var isPauseButtonPress = false
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initialWordSpeechPlayer()
        initialSettingView()
        
        readLessonVocabularyData(with: Int(foregroundLessonNumber!))
        
        initialBackgroundScrollView()
        
        initialForegroundHandler()
        initialBackgroundHandler()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isCouldPlayAudio = true
        
        // Set Title
        if title?.characters.count == 0 {
            title = levelString + " - Lesson " + String(foregroundLessonNumber! + 1)
        }
        
        // 測試不將螢幕鎖定
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // After view did appear start play audio
        initialNotificationCenter()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        appStatusOberver?.removeObserver(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        isCouldPlayAudio = false
        isAllowPlayAudio = false
        stopAudio()
        
        UIApplication.shared.endReceivingRemoteControlEvents()
        
        // 測試不將螢幕鎖定
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Initial relate function
    /**
     初始化 WCWordSpeechPlayer
     */
    fileprivate func initialWordSpeechPlayer() {
        wordSpeechPlayer = WCWordSpeechPlayer(withDelegate: self)
    }
    
    /**
     初始化前景控制
     */
    fileprivate func initialForegroundHandler() {
        foregroundHandler?.delegate = self
        foregroundHandler?.selectedContentModel = wordPlaySettingView.selectedSettingModal
        foregroundHandler?.setAllTupleArray(vocabularyTupleArray, sentenceArray: sentenceTupleArray)
    }
    
    /**
     初始化背景控制
     */
    fileprivate func initialBackgroundHandler() {
        backgroundHandler?.delegate = self
        backgroundHandler?.selectedContentModel = wordPlaySettingView.selectedSettingModal
        backgroundHandler?.setAllTupleArray(vocabularyTupleArray, sentenceArray: sentenceTupleArray)
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - NSNotificationCenter
    /**
     初始化 App 狀態觀察
     */
    fileprivate func initialNotificationCenter(){
        appStatusOberver = NotificationCenter.default
        appStatusOberver?.addObserver(self,
                                      selector: #selector(WCWordPlayViewController.appDidBecomeActive),
                                      name: NSNotification.Name.UIApplicationDidBecomeActive,
                                      object: nil)
        
        appStatusOberver?.addObserver(self,
                                      selector: #selector(WCWordPlayViewController.appDidEnterBackground),
                                      name: NSNotification.Name.UIApplicationDidEnterBackground,
                                      object: nil)
        
        appStatusOberver?.addObserver(self,
                                      selector: #selector(WCWordPlayViewController.appWillEnterForeground),
                                      name: NSNotification.Name.UIApplicationWillEnterForeground,
                                      object: nil)
    }
    
    /**
     初始化 WCWordPlayScrollView
     */
    fileprivate func initialBackgroundScrollView() {
        // Initial WCWordPlayScrollView
        let navigationBarHeight = (self.navigationController?.navigationBar.bounds.size.height)!
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let backgroundScrollViewLayout = WCWordPlayScrollViewFlowLayout()
        let bacggroundScrollViewRect = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - navigationBarHeight * 3 - statusBarHeight)
        
        backgroundScrollView = WCWordPlayScrollView(frame: bacggroundScrollViewRect, collectionViewLayout: backgroundScrollViewLayout, numberOfItems: allLessonsArray!.count)
        backgroundScrollView.scrollViewDelegate = self
        
        view.addSubview(backgroundScrollView)
        
        backgroundScrollView.scroll(toItem: Int(foregroundLessonNumber!), animated: true)
        
        if foregroundLessonNumber < 1 {
            playAudio((foregroundHandler?.playingNumber)!, and: vocabularyTupleArray)
        }
        
        isAllowPlayAudio = true
        
    }
    
    /**
     初始化 WCWordPlaySettingView
     */
    fileprivate func initialSettingView() {
        wordPlaySettingView = WCWordPlaySettingView(frame: CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: screenSize.height))
        wordPlaySettingView.delegate = self
        wordPlaySettingView.readDataFromUserDefaults()
        readWordPlaySetData()
        
        initialGrayMaskView()
    }
    
    /**
     初始化 淡灰遮罩 View
     */
    fileprivate func initialGrayMaskView() {
        grayMaskView?.frame = self.view.bounds
        grayMaskView?.backgroundColor = UIColor.gray
        grayMaskView?.alpha = 0.0
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - App status observer
    /**
     UIApplicationDidBecomeActiveNotification
     */
    @objc fileprivate func appDidBecomeActive() {
        isForegroundStatus = true
        wordPlayTableView.isForegroundStatus = isForegroundStatus
    }
    
    /**
     UIApplicationDidEnterBackgroundNotification
     */
    @objc fileprivate func appDidEnterBackground() {
        isForegroundStatus = false
        wordPlayTableView.isForegroundStatus = isForegroundStatus

        backgroundHandler?.setGroundHandler(with: foregroundHandler!)
        
        wordPlayTableView.minifyAllCell()
    }
    
    /**
     UIApplicationWillEnterForegroundNotification
     */
    @objc fileprivate func appWillEnterForeground() {
        openSentenceAndScrollToItem(backgroundScroll: (backgroundHandler?.lessonNumber)!, open: (backgroundHandler?.playingNumber)!, scroll: (backgroundHandler?.sentenceNumber)!)
        
        title = levelString + " - Lesson " + String((backgroundHandler?.lessonNumber)! + 1)
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            Thread.sleep(forTimeInterval: 0.5)
            DispatchQueue.main.async(execute: {
                self.foregroundHandler?.setGroundHandler(with: self.backgroundHandler!)
            })
        }
    }
    
    /**
     開啟單字的例句
     
     - parameter vocabularyNumber: 單字號碼
     - parameter sentenceNumber:   例句號碼
     */
    fileprivate func openSentenceAndScrollToItem(backgroundScroll lessonNumber: Int, open vocabularyNumber: Int, scroll sentenceNumber: Int) {
        if backgroundHandler?.lessonNumber != foregroundHandler?.lessonNumber {
            backgroundScrollView.scroll(toItem: lessonNumber, animated: false)
        }
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            Thread.sleep(forTimeInterval: 0.1)
            DispatchQueue.main.async(execute: {
                self.wordPlayTableView.tableViewScrolltoItem(vocabularyNumber, animated: false, callDelegate: false)
            })
        }
        
        //FIXME: 第一版還不用打開單字卡，因為現在的單字庫沒有例句
//        if backgroundHandler?.isSentence == true {
//            wordPlayTableView.selectItemWithItemNumberMute(vocabularyNumber)
//            wordPlayTableView.tableViewCellScrollToSentence(sentenceNumber, animated: false)
//        }
//        else {
//            wordPlayTableView.tableViewScrolltoItem(vocabularyNumber, animated: false, callDelegate: false)
//        }
    }
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Read data from WordPlaySettingView
    fileprivate func readWordPlaySetData() {
        selectedPattern = wordPlaySettingView.selectedPattern
        selectedSettingContentModel = wordPlaySettingView.selectedSettingModal
        
        // Ground Handler
        foregroundHandler?.selectedContentModel = wordPlaySettingView.selectedSettingModal
        backgroundHandler?.selectedContentModel = wordPlaySettingView.selectedSettingModal
        stopTimer?.invalidate()
        setStopTimer(Double((selectedSettingContentModel?.playTimeDetailAdjust)!))
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Read data from allLeddonArray
    /**
     讀取 單字 與 例句 的資料
     */
    fileprivate func readLessonVocabularyData(with lessonNumber: Int) {
        if lessonNumber < allLessonsArray!.count {
            let lessonVocabularyModelArray = allLessonsArray![Int(lessonNumber)]
            vocabularyTupleArray.removeAll()
            sentenceTupleArray.removeAll()
            
            let _ = lessonVocabularyModelArray.map({ (vocabularyModel) -> Void in
                
                // Create vocabulary tuple and put it in VocabularyTupleArray
                let chinese = vocabularyModel.chinese
                
                let vocabularyTuple = (vocabularyModel.english, chinese)
                vocabularyTupleArray.append(vocabularyTuple)
                
                // Create sentence tuple
                if vocabularyModel.englishSentenceArray.count == vocabularyModel.chineseSentenceArray.count {
                    // One sentence have mutiple sentence
                    var oneVocabularySentenceTupleArray = [(String, String)]()
                    oneVocabularySentenceTupleArray = Array(zip(vocabularyModel.englishSentenceArray as! [String], vocabularyModel.chineseSentenceArray as! [String]))
                    
                    sentenceTupleArray.append(oneVocabularySentenceTupleArray)
                }
            })
        }
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - WCWordPlayScrollView Delegate
    func scrollView(_ scrollView: WCWordPlayScrollView, willDisplayCell cell: WCWordPlayScrollCollectionViewCell, pageNumber: Int) {
        let cellWordPlayTableView = cell.wordPlayTableView
        
        cellWordPlayTableView?.setScrollEnable(true)
        cellWordPlayTableView?.delegate = self
        
        let lessonArray = allLessonsArray![pageNumber]
        cellWordPlayTableView?.setWCWordPlayModel(lessonArray)
        
        wordPlayTableView = cellWordPlayTableView
    }
    
    func scrollView(_ scrollView: WCWordPlayScrollView, didEndScrollDeceleratingToPage pageNumber: Int) {
        self.title = levelString + " - Lesson " + String(pageNumber + 1)
        
        readLessonVocabularyData(with: pageNumber)
        presentVocabularyType = .english
        foregroundHandler?.resetAllProperty(pageNumber, vocabularyArray: vocabularyTupleArray, sentenceArray: sentenceTupleArray)
        playAudio(0, and: vocabularyTupleArray)
        isAllowPlayAudio = true
    }
    
    func scrollViewBeginScrollWithFinger(_ scrollView: WCWordPlayScrollView) {
        isAllowPlayAudio = false
        
        stopAudio()
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - WCWordPlayTableView Delegate
    func tableView(_ tableView: WCWordPlayTableView, didSelectItemAtIndexPath indexPath: IndexPath) {
        if (tableView.cellIsAmplify != nil && tableView.cellIsAmplify == true) {
            backgroundScrollView.isScrollEnabled = false
        }
        else {
            foregroundHandler?.playedItemArray[(indexPath as NSIndexPath).row] = true
            backgroundScrollView.isScrollEnabled = true
        }
        
        stopAudio()
        isAllowPlayAudio = false
    }
    
    func tableView(_ tableView: WCWordPlayTableView, didFinishAnimationCell cell: WCWordPlayCollectionViewCell, isAmplifySentence: Bool, itemNumber: Int) {
        presentVocabularyType = .english
        //FIXME: 手動點開 會無法正常多次播放單字
        if isAmplifySentence {
            playAudio(0, and: sentenceTupleArray[itemNumber])
            foregroundHandler?.vocabularyPlayedCount = (selectedSettingContentModel?.frequencyDetailAdjiust)! + 1
        }
        else {
            foregroundHandler?.vocabularyPlayedCount = 1
            foregroundHandler?.fullPlayedSentencesArray()
            foregroundHandler?.increasePlayingNumber(isCellOpened: false)
            backgroundScrollView.isScrollEnabled = true
        }
        isAllowPlayAudio = true
    }
    
    func tableViewBeginScrollWithFinger(_ tableView: WCWordPlayTableView) {
        isAllowPlayAudio = false

        stopAudio()
        foregroundHandler?.clearAllPlayedItemsArray()
        foregroundHandler?.vocabularyPlayedCount = 1
    }
    
    func tableView(_ tableView: WCWordPlayTableView, didScrolltoItem itemNumber: Int) {
        presentVocabularyType = SpeechType.english
        playAudio(itemNumber, and: vocabularyTupleArray)
        isAllowPlayAudio = true
        foregroundHandler?.playingNumber = itemNumber
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - WCWordPlayTableView Sentence Delegate
    func tableView(_ tableView: WCWordPlayTableView, beginScrollWithFinger cell: WCWordPlayCollectionViewCell, sentenceView: WCWordPlaySentenceView) {
        stopAudio()
    }
    
    func tableView(_ tableView: WCWordPlayTableView, didScroll cell: WCWordPlayCollectionViewCell, sentencView: WCWordPlaySentenceView, to itemNumber: Int) {
        isAllowPlayAudio = true
        presentVocabularyType = .english
        foregroundHandler?.sentenceNumber = itemNumber
        playAudio(itemNumber, and: sentenceTupleArray[(foregroundHandler?.playingNumber)!])
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - WCWordPlaySettingView
    fileprivate func setStopTimer(_ minutes: Double) {
        stopTimer = Timer.scheduledTimer(timeInterval: minutes * 60, target: self, selector: #selector(WCWordPlayViewController.stopTimerStopAudio), userInfo: nil, repeats: false)
    }
    
    @objc fileprivate func stopTimerStopAudio() {
        stopAudio()
        playPauseButton.setBackgroundImage(UIImage(named: "WordPlay_Play"), for: UIControlState())
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - WCWordPlaySettingView Delegate
    func didChangeSettingModel()
    {
        readWordPlaySetData()
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: AVSpeechSynthesizer Delegate
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if isForegroundStatus == true {
            if isAllowPlayAudio == true {
                
                // 前景部分
                if presentVocabularyType == .chinese {
                    
                    if wordPlayTableView.cellIsAmplify == true {
                        // 播放例句
                        playAudio((foregroundHandler?.sentenceNumber)!, and: sentenceTupleArray[(foregroundHandler?.playingNumber)!])
                    }
                    else {
                        // 播放單字
                        playAudio((foregroundHandler?.playingNumber)!, and: vocabularyTupleArray)
                    }
                }
                else {
                    if wordPlayTableView.cellIsAmplify == true {
                        foregroundHandler?.increasePlayingNumber(isCellOpened: true)
                    }
                    else {
                        foregroundHandler?.increasePlayingNumber(isCellOpened: false)
                    }
                }
            }
        }
        else {
            
            // 背景部分
            if presentVocabularyType == .chinese {
                if backgroundHandler?.isSentence == false {
                    playAudio((backgroundHandler?.playingNumber)!, and: vocabularyTupleArray)
                }
                else {
                    playAudio((backgroundHandler?.sentenceNumber)!, and: sentenceTupleArray[(backgroundHandler?.playingNumber)!])
                }
            }
            else {
                backgroundHandler?.increasePlayingNumber()
            }
        }
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: UIButton action
    /**
     喜愛按鈕的 Action
     */
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        popAddToListPopView()
    }
    
    func popAddToListPopView() {
        let oneLessonVocabularyModelArray = allLessonsArray![(foregroundHandler?.lessonNumber)!]
        let playingVocabularyModel = oneLessonVocabularyModelArray[(foregroundHandler?.playingNumber)!]
        popView = WCAddToListPopView(
            frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height),
            selectedWord: playingVocabularyModel.identity,
            superView: self.view,
            offset: navigationController!.navigationBar.frame.height)
        popView?.delegate = self
        if isPauseButtonPress == false {
            pauseAudio()
        }
    }
    
    /**
     開始與暫停按鈕的 Action
     */
    @IBAction func playPauseButtonAction(_ sender: UIButton) {
        if wordSpeechPlayer != nil {
            if wordSpeechPlayer?.speechSynthesizer.isSpeaking == true && wordSpeechPlayer?.speechSynthesizer.isPaused == false {
                pauseAudio()
                sender.setBackgroundImage(UIImage(named: "WordPlay_Play"), for: UIControlState())
                isPauseButtonPress = true
            }
            else if wordSpeechPlayer?.speechSynthesizer.isPaused == true {
                continueAudio()
                sender.setBackgroundImage(UIImage(named: "WordPlay_Pause"), for: UIControlState())
                isPauseButtonPress = false
            }
            else if wordPlayTableView.animationLock == false {
                if wordPlayTableView.cellIsAmplify == true {
                    isCouldPlayAudio = true
                    playAudio((foregroundHandler?.sentenceNumber)!, and: sentenceTupleArray[(foregroundHandler?.playingNumber)!])
                    isPauseButtonPress = false
                }
                else {
                    isCouldPlayAudio = true
                    playAudio((foregroundHandler?.playingNumber)!, and: vocabularyTupleArray)
                    isPauseButtonPress = false
                }
                
                sender.setBackgroundImage(UIImage(named: "WordPlay_Pause"), for: UIControlState())
            }
            else {
                isCouldPlayAudio = false
                sender.setBackgroundImage(UIImage(named: "WordPlay_Play"), for: UIControlState())
                isPauseButtonPress = false
            }
        }
        else {
            playAudio((foregroundHandler?.playingNumber)!, and: vocabularyTupleArray)
            isPauseButtonPress = false
        }
    }
    
    /**
     設定按鈕的 Action
     */
    @IBAction func settingButtonAction(_ sender: UIButton) {
        wordPlaySettingView.appearAnimation(from: self.view)
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Audio Action
    /**
     播放 Speech
     */
    fileprivate func playAudio(_ itemNumber: Int, and itemsArray: [(String, String)]) {
        if isCouldPlayAudio == true {
            if itemNumber < itemsArray.count {
                let itemTuple = itemsArray[itemNumber]
                var speechString: String
                switch presentVocabularyType {
                case .english:
                    speechString = itemTuple.0
                    wordSpeechPlayer?.startSpeech(speechString: speechString, language: WCWordSpeechLanguage.English, speechSpeed: Float((selectedSettingContentModel?.speedDetailAdjust)!))
                    presentVocabularyType = .chinese
                    return
                    
                case .chinese:
                    speechString = itemTuple.1
                    wordSpeechPlayer?.startSpeech(speechString: speechString, language: .Chinese, speechSpeed: Float((selectedSettingContentModel?.speedDetailAdjust)!))
                    presentVocabularyType = .english
                    return
                }
            }
        }
    }
    
    /**
     停止 Speech
     */
    fileprivate func stopAudio() {
        wordSpeechPlayer?.stopSpeech()
    }
    
    /**
     暫停 Speech
     */
    fileprivate func pauseAudio() {
        wordSpeechPlayer?.pauseSpeech()
        isCouldPlayAudio = false
    }
    
    /**
     繼續 Speech
     */
    fileprivate func continueAudio() {
        wordSpeechPlayer?.continueSpeech()
        isCouldPlayAudio = true
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - WCWordForegroundHandlerDelegate
    func tableViewScrollAnimation(_ itemNumber: Int) {
        wordPlayTableView.tableViewScrolltoItem(itemNumber, animated: true, callDelegate: true)
    }
    
    //FIXME: 第一版還不用打開單字卡，因為現在的單字庫沒有例句
    func tableViewCellAmplifyAnimation(_ itemNumber: Int) {
//        wordPlayTableView.selectItemWithItemNumber(itemNumber)
    }
    
    func tableViewCellScrollAnimation(_ sentenceNumber: Int) {
        wordPlayTableView.tableViewCellScrollToSentence(sentenceNumber, animated: true)
    }
    
    func backgroundViewScrollAnimation(_ itemNumber: Int) {
        backgroundScrollView.scroll(toItem: itemNumber, animated: true)
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - WCWordBackgroundHandlerDelegate
    func playVocabulary(with itemNumber: Int) {
        playAudio(itemNumber, and: vocabularyTupleArray)
    }
    
    func playSentence(vocabularyNumber: Int, sentenceNumber: Int) {
        playAudio(sentenceNumber, and: sentenceTupleArray[vocabularyNumber])
    }
    
    func readVocabularyData(with lessonNumber: Int) {
        readLessonVocabularyData(with: lessonNumber)
        backgroundHandler?.setAllTupleArray(vocabularyTupleArray, sentenceArray: sentenceTupleArray)
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - WCAddToListPopViewDelegate
    func didEndRemoveAnimation() {
        if wordSpeechPlayer != nil && isPauseButtonPress == false {
            if wordSpeechPlayer?.speechSynthesizer.isSpeaking == true && wordSpeechPlayer?.speechSynthesizer.isPaused == false {
                pauseAudio()
            }
            else if wordSpeechPlayer?.speechSynthesizer.isPaused == true {
                continueAudio()
            }
            else if wordPlayTableView.animationLock == false {
                if wordPlayTableView.cellIsAmplify == true {
                    playAudio((foregroundHandler?.sentenceNumber)!, and: sentenceTupleArray[(foregroundHandler?.playingNumber)!])
                }
                else {
                    playAudio((foregroundHandler?.playingNumber)!, and: vocabularyTupleArray)
                }
            }
        }
        else {
            playAudio((foregroundHandler?.playingNumber)!, and: vocabularyTupleArray)
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
