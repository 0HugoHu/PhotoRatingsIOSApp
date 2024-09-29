//
//  HHaptic.swift
//  PhotoRatings
//
//  Created by Hugooooo on 9/28/24.
//

import SwiftUI

func triggerHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.impactOccurred()
}
