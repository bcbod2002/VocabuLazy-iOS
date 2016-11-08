//
//  WCWordPlaySentenceView.swift
//  Swallow
//
//  Created by Goston on 2015/12/16.
//  Copyright © 2015年 WishCan. All rights reserved.
//

import UIKit


// -------------------------------------------------------------------------------------------------
// MARK: - Define
// Define color
private let Sentence_Background_Color = UIColor(red: (197.0 / 255.0), green: (159.0 / 255.0), blue: (57.0 / 255.0), alpha: 1.0)


// -------------------------------------------------------------------------------------------------
// MARK: - WCWordPlaySentenceViewDelegate
protocol WCWordPlaySentenceViewDelegate {
    /**
     WCWordPlaySentenceView begin scroll with finger
     
     - parameter sentenceView: WCWordPlaySentenceView
     */
    func sentenceViewBeginScrollWithFinger(_ sentenceView: WCWordPlaySentenceView)
    
    /**
     WCWordPlaySentenceView did end scroll animation and scroll to item
     
     - parameter sentenceView: WCWordPlaySentenceView
     - parameter itemNumber:   Item number
     */
    func sentenceView(_ sentenceView: WCWordPlaySentenceView, didScrollToItem itemNumber: Int)
}

class WCWordPlaySentenceView: UIView, UIScrollViewDelegate {
    
    
    // -------------------------------------------------------------------------------------------------
    // MARK: - Variables
    // UI components
    fileprivate var backgroundScrollView: UIScrollView!
    fileprivate var pageControl: UIPageControl?
    
    // Sentence content view
    fileprivate var sentenceContentViewArray: [WCWordPlaySentenceContentView] = [WCWordPlaySentenceContentView]()
    
    // MARK: - WCVocabularyModel
    var playSentences: WCVocabularyModel {
        get {
            return self.playSentences
        }
        set(sentences) {
            self.playSentences = sentences
            initialSentenceContentView(with: sentences.englishSentenceArray as! [String], chinsesSentence: sentences.chineseSentenceArray as! [String])
        }
    }
    
    var delegate: WCWordPlaySentenceViewDelegate?
    
    
    // -------------------------------------------------------------------------------------------------
    // MARK: - Initial
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Create ")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        // Background scroll view
        backgroundScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        backgroundScrollView.backgroundColor = UIColor.clear
        backgroundScrollView.isPagingEnabled = true
        backgroundScrollView.isScrollEnabled = true
        backgroundScrollView.showsHorizontalScrollIndicator = false
        backgroundScrollView.showsVerticalScrollIndicator = false
        backgroundScrollView.delegate = self
        
        // Page control
        pageControl = UIPageControl(frame: CGRect(x: bounds.midX - (bounds.width / 2 / 2), y: bounds.height - 10, width: bounds.width / 2, height: 10))
        pageControl?.currentPageIndicatorTintColor = Sentence_Background_Color
        pageControl?.pageIndicatorTintColor = UIColor.gray
        
        addSubview(backgroundScrollView)
        addSubview(pageControl!)
    }
    
    convenience init(frame: CGRect, engSentenceArray: [String], chiSentenceArray: [String]) {
        self.init(frame: frame)
        initialSentenceContentView(with: engSentenceArray, chinsesSentence: chiSentenceArray)
    }
    
    // -------------------------------------------------------------------------------------------------
    // MARK: - Initial Sentence content view
    fileprivate func initialSentenceContentView(with englishSentence:[String], chinsesSentence:[String]) {
        if (englishSentence.count == chinsesSentence.count) {
            // Add english and chinese sentences label
            backgroundScrollView.contentSize = CGSize(width: CGFloat(englishSentence.count) * backgroundScrollView.bounds.width, height: backgroundScrollView.bounds.height)
            
            for i in 0...englishSentence.count - 1 {
                let sentenceContentView = WCWordPlaySentenceContentView(frame: CGRect(x: CGFloat(i) * self.bounds.width, y: 0, width: self.bounds.width, height: self.bounds.height))
                sentenceContentView.setEnglishSentenceString(englishSentence[i])
                sentenceContentView.setChineseSentenceString(chinsesSentence[i])
                sentenceContentViewArray.append(sentenceContentView)
                backgroundScrollView.addSubview(sentenceContentView)
            }
            
            // Set page control page number
            pageControl?.numberOfPages = englishSentence.count
        }
    }
    
    
    // -------------------------------------------------------------------------------------------------
    // MARK: - Set Vocabulary
    /**
     Set WCVocabularyModel
     
     - parameter vocabulary: WCVocabularyModel
     */
    func setVocabulary(_ vocabulary: WCVocabularyModel) {
        if (sentenceContentViewArray.count > 0) {
            for sentenceContentView in sentenceContentViewArray {
                sentenceContentView.removeFromSuperview()
            }
            sentenceContentViewArray.removeAll()
        }
        initialSentenceContentView(with: vocabulary.englishSentenceArray as! [String], chinsesSentence: vocabulary.chineseSentenceArray as! [String])
    }
    
    
    // -------------------------------------------------------------------------------------------------
    // MARK: - Scroll background scroll view
    /**
     Scroll to sentence
     
     - parameter itemNumber:  Sentence number
     - parameter isAnimation: Do animation or not
     */
    func scrollToSentence(with itemNumber:Int, isAnimation: Bool) {
        let scrollContentOffset = CGPoint(x: backgroundScrollView.bounds.width * CGFloat(itemNumber), y: 0)
        backgroundScrollView.setContentOffset(scrollContentOffset, animated: isAnimation)
        pageControl?.currentPage = itemNumber
        
        if isAnimation {
            delegate?.sentenceView(self, didScrollToItem: itemNumber)
        }
    }
    
    
    // -------------------------------------------------------------------------------------------------
    // MARK: - UIScrollView delegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.sentenceViewBeginScrollWithFinger(self)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentItemNumber = lround(Double(scrollView.contentOffset.x) / Double(scrollView.bounds.width))
        pageControl?.currentPage = currentItemNumber
        delegate?.sentenceView(self, didScrollToItem: currentItemNumber)
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
