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
            
            if let imageList = try? JSONDecoder().decode([ImageList].self, from: data) {
                self.images = []
                var imageLoadTasks: [URLSessionDataTask] = []
                
                for image in imageList {
                    guard let imageURL = URL(string: PC_IP + GET_IMAGE + "/\(image.partition)/\(image.filename)") else { continue }
                    
                    let imageTask = URLSession.shared.dataTask(with: imageURL) { imageData, _, _ in
                        guard let imageData = imageData, let uiImage = UIImage(data: imageData) else { return }
                        self.images.append(ImageStruct(image: uiImage, filename: image.filename, partition: image.partition))
                        if self.images.count == imageList.count {
                            self.imagesLoaded = true
                        }
                        
                    }
                    imageLoadTasks.append(imageTask)
                }
                imageLoadTasks.forEach { $0.resume() }
                
            }
        }
        task.resume()
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
            loadImagesFromPC()
        } else if currentIndex >= images.count {
            currentIndex = images.count - 1
        }
    }
    
    
}


#Preview {
    ContentView()
}
