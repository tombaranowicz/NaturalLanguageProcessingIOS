//
//  ViewController.swift
//  Natural Language Processing Sample
//
//  Created by Tomasz Baranowicz on 26/11/2019.
//  Copyright © 2019 Tomasz Baranowicz. All rights reserved.
//

import UIKit
import NaturalLanguage

class ViewController: UIViewController {

    @IBOutlet weak var mesageTextView: UITextView?
    
    @IBOutlet weak var spamLabel: UILabel?
    @IBOutlet weak var sentimentLabel: UILabel?

    @IBAction func sendMessage(sender: UIButton) {
        guard let message = self.mesageTextView?.text else {
            return
        }
        
        detectSpam(message: message)
        detectSentiment(message: message)
    }

    private func detectSpam(message: String) {
        do {
            let spamDetector = try NLModel(mlModel: SPAMClassifier().model)
            guard let prediction = spamDetector.predictedLabel(for: message) else {
                print("Failed to predict result")
                return
            }
            
            spamLabel?.text = "spam status: \(prediction == "spam" ? "SPAM" : "NOT SPAM")"
        } catch {
            fatalError("Failed to load Natural Language Model: \(error)")
        }
    }
    
    // range -1.0 (negative) to 1.0 (positive)
    private func detectSentiment(message: String) {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = message
        
        let (sentiment, _) = tagger.tag(at: message.startIndex, unit: .paragraph, scheme: .sentimentScore)
        
        // it supports 7 languages: English, French, Italian, German, Spanish, Portuguese, and simplified Chinese.
        guard let sentimentScore = sentiment?.rawValue else {
            return
        }
        
        sentimentLabel?.text = "sentiment score: \(sentimentScore)"
    }
}

