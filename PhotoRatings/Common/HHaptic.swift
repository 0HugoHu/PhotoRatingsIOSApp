//
//  HHaptic.swift
//  PhotoRatings
//
//  Created by Hugooooo on 9/28/24.
//

import UIKit

class HHaptics {
    static let shared = HHaptics()
    
    private init() { }

    func play(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
    }
    
    func notify(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
    }
}

