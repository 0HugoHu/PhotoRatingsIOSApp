//
//  ContentView.swift
//  PhotoRatings
//
//  Created by Hugooooo on 9/21/24.
//

import SwiftUI

struct ContentView: View {
    @State private var images: [ImageStruct] = []
    @State private var currentIndex: Int = 0
    @State private var imagesLoaded: Bool = false
    @State private var remainingImages: Int = 10
    
    var body: some View {
        VStack {
            if imagesLoaded {
                TabView(selection: $currentIndex) {
                    ForEach(0..<images.count, id: \.self) { index in
                        Image(uiImage: images[index].image)
                            .resizable()
                            .scaledToFit()
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(maxHeight: 600)
                
                RatingsView(rateAction: rateImage, image: images[currentIndex])
            } else {
                Text("Loading images...\(remainingImages)")
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
            
            if let imageList = try? JSONDecoder().decode([ImageList].self, from: data) {
                self.images = []
                self.remainingImages = imageList.count
                
                for image in imageList {
                    guard let imageURL = URL(string: PC_IP + GET_IMAGE + "/\(image.partition)/\(image.filename)") else { continue }
                    
                    loadImage(from: imageURL, filename: image.filename, partition: image.partition, retries: 3)
                }
            }
        }
        
        task.resume()
    }
    
    
    func loadImage(from url: URL, filename: String, partition: String, retries: Int) {
        let imageTask = URLSession.shared.dataTask(with: url) { imageData, response, error in
            if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.images.append(ImageStruct(image: uiImage, filename: filename, partition: partition))
                    self.remainingImages -= 1
                    if self.images.count == self.remainingImages {
                        self.imagesLoaded = true
                    }
                }
            } else {
                if retries > 0 {
                    print("Retrying image load for \(filename)...")
                    loadImage(from: url, filename: filename, partition: partition, retries: retries - 1)
                } else {
                    print("Failed to load image: \(filename) after retries")
                }
            }
        }
        
        imageTask.resume()
    }
    
    
    
    
    func rateImage(name: String, partition: String, rating: Int) {
        deleteCurrentImage()
        
        guard let url = URL(string: PC_IP + RATE_IMAGE) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["image_name": name, "rating": rating, "partition": partition]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Error sending rating:", error)
            } else {
                print("Rating sent successfully!")
            }
        }
        
        task.resume()
    }
    
    
    func deleteCurrentImage() {
        guard currentIndex < images.count else { return }
        
        images.remove(at: currentIndex)
        
        if images.isEmpty {
            self.imagesLoaded = false
            self.remainingImages = 10
            loadImagesFromPC()
        } else if currentIndex >= images.count {
            currentIndex = images.count - 1
        }
    }
    
    
}


#Preview {
    ContentView()
}
