//
//  RatingsView.swift
//  PhotoRatings
//
//  Created by Hugooooo on 9/21/24.
//

import SwiftUI

struct RatingsView: View {
    var rateAction: (String, String, Int) -> Void
    var imageInfo: ImageInfo
    @State private var ratingOptions = [1, 2, 3]
    @State private var ratingOptionsEnhanced = [-1, 5]
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: {
                rateAction(imageInfo.filename, imageInfo.partition, 5)
            }) {
                Text("Best")
                    .frame(width: 80, height: 50)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: {
                rateAction(imageInfo.filename, imageInfo.partition, -1)
            }) {
                Text("Worst")
                    .frame(width: 180, height: 50)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        HStack(spacing: 20) {
            ForEach(ratingOptions, id: \.self) { rating in
                Button(action: {
                    rateAction(imageInfo.filename, imageInfo.partition, rating)
                }) {
                    Text("Rate \(rating)")
                        .frame(width: 80, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
    }
}
