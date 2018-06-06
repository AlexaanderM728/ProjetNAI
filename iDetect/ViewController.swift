//
//  ViewController.swift
//  iDetect
//
//  Created by Aleksander Mazurek on 23.05.2018.
//  Copyright © 2018 com.Amicus. All rights reserved.
// materiały pomocnicze
// https://docs.swift.org/swift-book/LanguageGuide/StringsAndCharacters.html
//https://docs.swift.org/swift-book/LanguageGuide/Functions.html
//https://pypi.org/project/coremltools/
//https://www.youtube.com/watch?v=h2MdQoRMtlQ&t=279s
//

import UIKit
import CoreML
import Vision
import Foundation



class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageViewObject: UIImageView!
    
    @IBOutlet weak var laImageDescription: UITextView!
    
    var ImagePicker:UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ImagePicker = UIImagePickerController() //tworzenie kontorlera aparatu
        ImagePicker.delegate = self             //
        ImagePicker.sourceType = .camera        //
     

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
   
    
    
    
    @IBAction func buTakePicture(_ sender: Any) { // guzik zrob zdjecie
        present(ImagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) { //funkcja wyswietlajaca zdjecie w aplikacji
        // tworzenie zdjecia i jego przechycenie
        imageViewObject.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        //oddelegowanie imigePicker
        ImagePicker.dismiss(animated: true, completion: nil)
        pictureIdentifyML(image: (info[UIImagePickerControllerOriginalImage] as? UIImage)!)
    }
    
    func pictureIdentifyML(image:UIImage){ // funkcja do rozpoznania obiektu ze zdjecia
        //pobieranie modelu core ml
        guard let model = try? VNCoreMLModel(for: OrangeOrApple().model) else {
            fatalError("blad uczenia maszynowego")
        }
        // zadanie pobrania
        let request = VNCoreMLRequest(model: model){
            [weak self] request, error in
            
            guard let results = request.results as? [VNClassificationObservation],
                let firstResult = results.first else {
                    fatalError("nie moge pobrac wyniku")
            }
            
    
         
            
            
            DispatchQueue.main.async { // wynik rozpoznanaia
                self?.laImageDescription.text = "Pewność to: \(Int(firstResult.confidence * 100))%, \n Detekcja : \(firstResult.identifier) \n wartosci odzywcze w 100g \n  \(wart)"
                
            }
            
            
        }
        
        
        
        guard let ciImage = CIImage(image:image) else { // funkcje pilnujace poprawnosci danych 
            fatalError(" cannot convert to CIImage")
        }
        let imageHandler = VNImageRequestHandler(ciImage:ciImage)
        
        
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try imageHandler.perform([request])
            } catch {
                print("error")
            }
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            do{
                try imageHandler.perform([request])
            }catch{
                print("Error \(error)")
            }
        }
        
        
    }
    
    
}
