//
//  RatingsView.swift
//  PhotoRatings
//
//  Created by Hugooooo on 9/21/24.
//

import SwiftUI

struct RatingsView: View {
    var rateAction: (String, String, Int) -> Void
    var image: ImageStruct
    let ratingOptions = [1, 2, 3]
    let specialRatings = [(5, "Best", Color.green), (-1, "Worst", Color.red)]
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                ForEach(specialRatings, id: \.0) { rating, label, color in
                    Button(action: {
                        HHaptics.shared.play(.heavy)
                        rateAction(image.filename, image.partition, rating)
                    }) {
                        Text(label)
                            .frame(width: rating == -1 ? 180 : 80, height: 50)
                            .background(color)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            
            HStack(spacing: 20) {
                ForEach(ratingOptions, id: \.self) { rating in
                    Button(action: {
                        HHaptics.shared.play(.medium)
                        rateAction(image.filename, image.partition, rating)
                    }) {
                        Text("Rate \(rating)")
                            .frame(width: 80, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .padding()
    }
}
