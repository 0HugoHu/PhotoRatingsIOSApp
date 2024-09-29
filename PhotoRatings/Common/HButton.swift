//
//  HButton.swift
//  PhotoRatings
//
//  Created by Hugooooo on 9/28/24.
//

import SwiftUI

extension Button {
    func withHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) -> some View {
        self.onTapGesture {
            let impactMed = UIImpactFeedbackGenerator(style: style)
            impactMed.impactOccurred()
        }
    }
}
