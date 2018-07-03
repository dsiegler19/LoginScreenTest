//
//  ImagePickerViewController.swift
//  loginScreen
//
//  Created by Siegler, Dylan on 6/25/18.
//  Copyright © 2018 Wyant, Benjamin. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit

class ImagePickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {
    
    @IBOutlet weak var imageView: UIImageView!

    let imagePicker = UIImagePickerController()
    
    var responseData = Data()
    
    @IBAction func loadImageButtonTapped(_ sender: Any) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // If the selected thing is a video, upload it
        if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {
            
            // Get the data from the disc
            let videoData = try? Data(contentsOf: videoURL)
            
            let baseURL = URL(string: "http://localhost:5000/")!
            let videoTestURL = baseURL.appendingPathComponent("media_test")
            
            // Encode the data into base 64 (with compression the string isn't too long)
            let data = ["video_str": videoData?.base64EncodedString()]
            
            // Make the post request
            var request = URLRequest(url: videoTestURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let jsonData = try! JSONSerialization.data(withJSONObject: data, options: [])
            
            request.httpBody = jsonData
            
            // Upload the data
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                print("Uploaded video")
                
            }
                        
            task.resume()
            
        }
        
        // If the selected thing is an image, do the same thing
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            // Set the image view
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            
            // Resize the image
            let downsampledImage = pickedImage.resizeImage(image: pickedImage, targetSize: CGSize(width: pickedImage.size.width / 4, height: pickedImage.size.height / 4))
            
            // Send the image to the server
            let imageData = UIImagePNGRepresentation(downsampledImage)
            let imageStr = imageData?.base64EncodedString()
            
            let data = ["image_string": imageStr]
            
            let baseURL = URL(string: "http://localhost:8080/")!
            let imageTestURL = baseURL.appendingPathComponent("media_test")
            
            var request = URLRequest(url: imageTestURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let jsonData = try! JSONSerialization.data(withJSONObject: data, options: [])
            
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                print("Uploaded image")
                
            }
            
            task.resume()
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if let error = error {
            
            print("Session \(session) encountered error \(error.localizedDescription)")
            
        }
        
        else {
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = Date()
            let dateString = dateFormatter.string(from: date)
            print("Upload completed successfully with response \(String(data: responseData, encoding: String.Encoding.utf8) ?? "<decoding error>") at \(dateString)")
            
        }
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        let uploadProgress: Double = Double(totalBytesSent) / Double(totalBytesExpectedToSend)
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        let interval = date.timeIntervalSince1970
        print("Session \(session) uploaded \(uploadProgress * 100)% at \(dateString)")
        print(interval)
        
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        print("Session \(session) received response \(response)")
        completionHandler(URLSession.ResponseDisposition.allow)
        
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        responseData.append(data)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imagePicker.delegate = self

    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()

    }

}
