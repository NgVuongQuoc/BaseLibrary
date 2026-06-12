//
//  FileDownloader.swift
//  InternalSports
//
//  Created by Nguyen Vuong Quoc on 12/6/26.
//

import Foundation

public class FileDownloader {
    
    public static let shared = FileDownloader()
    
    public func loadFileSync(url: URL, completion: @escaping (String?, Error?) -> Void) {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)

        if FileManager().fileExists(atPath: destinationUrl.path) {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, nil)
        } else if let dataFromURL = NSData(contentsOf: url) {
            if dataFromURL.write(to: destinationUrl, atomically: true) {
                print("File saved [\(destinationUrl.path)]")
                completion(destinationUrl.path, nil)
            } else {
                print("Error saving file")
                let error = NSError(domain:"Error saving file", code: 1001, userInfo:nil)
                completion(destinationUrl.path, error)
            }
        } else {
            let error = NSError(domain:"Error downloading file", code: 1002, userInfo:nil)
            completion(destinationUrl.path, error)
        }
    }

    public func loadFileAsync(url: URL, toURL: URL, completion: @escaping (String?, Error?) -> Void) {
        if !FileManager().fileExists(atPath: toURL.path) {
            FileManager.default.createFile(atPath: toURL.path, contents: nil)
        }
        let destinationUrl = toURL.appendingPathComponent(url.lastPathComponent)

        if FileManager().fileExists(atPath: destinationUrl.path) {
            print("File already exists [\(destinationUrl.path)]")
            do {
                try FileManager().removeItem(atPath: destinationUrl.path)
                print("Removed exist file")
            } catch let error {
                print("Cannote remove exist file!!!")
                completion(nil, error)
            }
        }
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request, completionHandler: {
            data, response, error in
            if error == nil {
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        if let data = data {
                            if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic) {
                                completion(destinationUrl.path, error)
                            } else {
                                completion(destinationUrl.path, error)
                            }
                        } else {
                            completion(destinationUrl.path, error)
                        }
                    }
                }
            } else {
                completion(destinationUrl.path, error)
            }
        })
        task.resume()
    }
}
