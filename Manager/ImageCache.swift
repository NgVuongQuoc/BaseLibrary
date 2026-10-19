//
//  ImageCache.swift
//  BaseLibrary
//
//  Created by Nguyen Vuong Quoc on 12/6/26.
//

import Foundation

public class ImageCache {
    
    public static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    public func image(for url: URL, completionHandler: @escaping (Result<UIImage, Error>) -> Void) {
        if let imageInCache = cache.object(forKey: url.absoluteString as NSString) {
            completionHandler(.success(imageInCache))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [unowned self] data, _, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            guard let data = data else { return }
            guard let image = UIImage(data: data)?.resizedToMB(MB: 0.9) else { return }
            self.cache.setObject(image, forKey: url.absoluteString as NSString)
            completionHandler(.success(image))
        }
        task.resume()
    }
}
