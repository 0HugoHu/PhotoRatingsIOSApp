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
    let specialRatings = [(-1, "Worst", Color.red), (5, "Best", Color.green)]
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                ForEach(specialRatings, id: \.0) { rating, label, color in
                    Button(action: {
                        rateAction(image.filename, image.partition, rating)
                    }) {
                        Text(label)
                            .frame(width: rating == -1 ? 180 : 80, height: 50)
                            .background(color)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .withHapticFeedback(style: .rigid)
                }
            }
            
            HStack(spacing: 20) {
                ForEach(ratingOptions, id: \.self) { rating in
                    Button(action: {
                        rateAction(image.filename, image.partition, rating)
                    }) {
                        Text("Rate \(rating)")
                            .frame(width: 80, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .withHapticFeedback(style: .medium)
                }
            }
        }
        .padding()
    }
}
