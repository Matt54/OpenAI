//
//  ImagesQuery.swift
//  
//
//  Created by Sergii Kryvoblotskyi on 02/04/2023.
//

import Foundation

public struct ImagesQuery: Codable {
    /// A text description of the desired image(s). The maximum length is 1000 characters.
    public let prompt: String
    /// The number of images to generate. Must be between 1 and 10.
    public let n: Int?
    /// The size of the generated images. Must be one of 256x256, 512x512, or 1024x1024.
    public let size: String?
    /// Model used for generating image(s)
    public let model: String?
    /// Image quality
    public let quality: String?

    public init(prompt: String, n: Int?, size: String?, model: String?, quality: String?) {
        self.prompt = prompt
        self.n = n
        self.size = size
        self.model = model
        self.quality = quality
    }
    
    public init(prompt: String, settings: ImageQuerySettings) {
        self.prompt = prompt
        self.model = settings.modelName
        switch settings {
        case .dalle3(let size, let isHD):
            self.size = size.rawValue
            self.n = 1
            self.quality = isHD ? "hd" : "standard"
        case .dalle2(let size, let n):
            self.size = size.rawValue
            self.n = n
            self.quality = nil
        }
    }
}

public enum ImageQuality: String, Codable {
    case standard = "standard",
         high = "hd"
}

public enum ImageQuerySettings: Codable {
    case dalle3(size: Dalle3ImageSize, isHD: Bool),
         dalle2(size: Dalle2ImageSize, n: Int)
    
    var modelName: String {
        switch self {
        case .dalle3(_,_):
            "dall-e-3"
        case .dalle2(_,_):
            "dall-e-2"
        }
    }
}

public enum Dalle3ImageSize: String, Codable, CaseIterable {
    case square1024 = "1024x1024",
         portrait1024_1792 = "1024x1792",
         landscape1792_1024 = "1792x1024"
}

public enum Dalle2ImageSize: String, Codable, CaseIterable {
    case square256 = "256x256",
         square512 = "512x512"
}
