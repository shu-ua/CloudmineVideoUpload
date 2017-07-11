//
//  ViewController.swift
//  CloudmineVideoUploading
//
//  Created by Bohdan Shcherbyna on 7/11/17.
//  Copyright © 2017 Bohdan Shcherbyna. All rights reserved.
//

import UIKit
import CloudMine
import Fusuma
import Photos

class ViewController: UIViewController {

    let fusumaImagePicker = FusumaViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    //MARK: - Actions
    
    @IBAction func openGalleryTouchUp(_ sender: Any) {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.selectedMode = .library
        fusuma.allowedModes = [.library]
        fusuma.modalPresentationStyle = .overFullScreen
        self.present(fusuma, animated: true, completion: nil)
    }
    
    //MARK: - CLoudMine
    
    func sendFileToCloudmine(withData data: Data) {
        CMStore.default().saveFile(with: data, additionalOptions: nil) { (response) in
            
            if response?.error != nil {
                self.displayAlert(withMessage: response!.error.localizedDescription)
            } else {
                switch response!.result {
                case .created:
                    self.displayAlert(withMessage: "created")
                case .updated:
                    self.displayAlert(withMessage: "updated")
                case .uploadFailed:
                    self.displayAlert(withMessage: response!.error.localizedDescription)
                }
            }
        }
    }
    
    func displayAlert(withMessage message:String) {
        let alert = UIAlertController(title: "CloudmineVideoUploading", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: FusumaDelegate {
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        let imageData = UIImageJPEGRepresentation(image , 0.6)!
        self.sendFileToCloudmine(withData: imageData)
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        do {
            let data = try Data(contentsOf: fileURL, options: .mappedIfSafe)
            self.sendFileToCloudmine(withData: data)
        } catch {
            print("Data error")
        }
    }
    
    func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {
        let imageData = UIImageJPEGRepresentation(image , 0.6)!
        self.sendFileToCloudmine(withData: imageData)
    }
    
    func fusumaVideoCompleted(withPHAsset phAsset: PHAsset) {
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true
        PHCachingImageManager().requestAVAsset(forVideo: phAsset, options: options, resultHandler: {(asset, audioMix, info) in
            DispatchQueue.main.async(execute: {
                do {
                    if let asset = asset as? AVURLAsset {
                        let data = try Data(contentsOf: asset.url)
                        self.sendFileToCloudmine(withData: data)
                    } else {
                        return
                    }
                } catch {
                    print(error)
                    return
                }
            })
        })

    }
    
    func fusumaCameraRollUnauthorized() {
        self.displayAlert(withMessage: "Please allow camera access")
    }
    
    func fusumaWillClosed() {

    }
}

