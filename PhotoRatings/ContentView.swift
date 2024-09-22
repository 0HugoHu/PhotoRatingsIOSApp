//
//  ContentView.swift
//  PhotoRatings
//
//  Created by Hugooooo on 9/21/24.
//

import SwiftUI

struct ContentView: View {
    @State private var images: [UIImage] = []
    @State private var imagesInfo: [ImageInfo] = []
    @State private var currentIndex: Int = 0
    
    var body: some View {
        VStack {
            if !images.isEmpty {
                TabView(selection: $currentIndex) {
                    ForEach(0..<images.count, id: \.self) { index in
                        Image(uiImage: images[index])
                            .resizable()
                            .scaledToFit()
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(maxHeight: 400)
                
                RatingsView(rateAction: rateImage, imageInfo: imagesInfo[currentIndex])
            } else {
                Text("Loading images...")
            }
        }
        .onAppear {
            loadImagesFromPC()
        }
    }
    
    func loadImagesFromPC() {
        guard let url = URL(string: PC_IP + GET_IMAGE_LIST) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print("Response:", response ?? "No response")
            
            if let imageList = try? JSONDecoder().decode([ImageInfo].self, from: data) {
                DispatchQueue.main.async {
                    self.imagesInfo = imageList
                    self.images = []
                    
                    let imageLoadTasks: [URLSessionDataTask] = imageList.compactMap { imageInfo in
                        // Construct the URL for each image
                        guard let imageURL = URL(string: PC_IP + GET_IMAGE + "/\(imageInfo.partition)/\(imageInfo.filename)") else {
                            return nil
                        }
                        
                        return URLSession.shared.dataTask(with: imageURL) { imageData, response, error in
                            guard let imageData = imageData, error == nil else { return }
                            
                            if let uiImage = UIImage(data: imageData) {
                                DispatchQueue.main.async {
                                    self.images.append(uiImage)
                                }
                            }
                        }
                    }
                    
                    
                    imageLoadTasks.forEach { $0.resume() }
                }
            }
        }
        task.resume()
    }
    
    
    
    func rateImage(name: String, partition: String, rating: Int) {
        guard let url = URL(string: PC_IP + RATE_IMAGE) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body: [String: Any] = ["image_name": name, "rating": rating, "partition": partition]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending rating:", error)
            } else {
                print("Rating sent successfully!")
                DispatchQueue.main.async {
                    deleteCurrentImage()
                }
            }
        }
        task.resume()
    }
    
    func deleteCurrentImage() {
        if currentIndex < images.count {
            images.remove(at: currentIndex)
            imagesInfo.remove(at: currentIndex)
            
            if images.isEmpty {
                loadImagesFromPC()
            } else {
                if currentIndex >= images.count {
                    currentIndex = max(images.count - 1, 0)
                }
            }
        }
    }
    
    
}


#Preview {
    ContentView()
}
