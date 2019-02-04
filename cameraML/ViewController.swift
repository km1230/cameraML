//
//  ViewController.swift
//  cameraML
//
//  Created by Kavie Mo on 4/2/19.
//  Copyright © 2019 DevJunior. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //////////////////////////////////////////////////////////////////////////////////
    //MARK: Define variables and constant
    //TODO:  Define main view as UIImageView
    @IBOutlet weak var mainView: UIImageView!
    //TODO: Create ImagePickerController object
    let imagePicker = UIImagePickerController()
    //////////////////////////////////////////////////////////////////////////////////
    
    //////////////////////////////////////////////////////////////////////////////////
    //MARK: When view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: Define delegate of imagePicker
        imagePicker.delegate = self
        //TODO: Define sourceType of imagePicker
        imagePicker.sourceType = .photoLibrary
        //TODO: Disable editing after obtaining picture
        imagePicker.allowsEditing = false
        //TODO: Display instruction
        navigationItem.title = "Take image >>"
    }
    //////////////////////////////////////////////////////////////////////////////////

    //////////////////////////////////////////////////////////////////////////////////
    //MARK: When the camera button is tapped
    @IBAction func cameraBtn(_ sender: UIBarButtonItem) {
        //TODO: Open ImagePickerController
        present(imagePicker, animated: true, completion: nil)
    }
    //////////////////////////////////////////////////////////////////////////////////
    
    //////////////////////////////////////////////////////////////////////////////////
    //MARK: Image Picking
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //TODO: obtain selected image
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //TODO: show selected image on main view
            mainView.image = selectedImage
            //TODO: convert selectedImage into CIImage
            if let ciImage = CIImage(image: selectedImage) {
                //TODO: run analysis to detect object
                detectObject(targetImage: ciImage)
            }
        }
        
        //TODO: dismiss ImagePickerController
        imagePicker.dismiss(animated: true, completion: nil)
    }
    //////////////////////////////////////////////////////////////////////////////////
    
    //////////////////////////////////////////////////////////////////////////////////
    //MARK: CoreML Model
    func detectObject(targetImage : CIImage){
        //TODO: Initialise model in a container
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Model failed to initialise.")
        }
        //TODO: Define the VNCoreMLRequest
        let request = VNCoreMLRequest(model: model) { (req, err) in
            guard let result = req.results as? [VNClassificationObservation] else {
                fatalError("Request failed.")
            }
            if let firstResult = result.first {
                self.navigationItem.title = firstResult.identifier.components(separatedBy: ", ")[0]
            }
            
        }
        //TODO: set a request handler
        let handler = VNImageRequestHandler(ciImage: targetImage)
        //TODO: handle and run the request list
        do {
            try handler.perform([request])
        } catch {
            print("Handler failed.")
        }
    }
    
}

