//
//  ViewController.swift
//  BipTheGuy
//
//  Created by Brishti Saha on 2/22/21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var audioPlayer: AVAudioPlayer!
    var imagePickerController = UIImagePickerController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
    }
    func playSound(name:String) {
        
        if let sound = NSDataAsset(name: "\(name)"){
            do{
                try audioPlayer = AVAudioPlayer(data: sound.data)
                audioPlayer.play()
            }catch{
                print("Error: \(error.localizedDescription) Could not initizialize AVAudioPlayer object")
            }
        }else{
            print("Error: Could not read data from file \(name)")
        }
    }
    
    func showAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func photoOrCameraPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) {(_) in self.accessPhotoLibrary() }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) {(_) in self.accessCamera() }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)

    }
    
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        
        let originalImageFrame = imageView.frame
        let imageWidthShrink: CGFloat = 20
        let imageHeightShrink: CGFloat = 20
        let smallerImageFrame = CGRect( x: imageView.frame.origin.x + imageWidthShrink , y: imageView.frame.origin.y + imageHeightShrink,
            width: imageView.frame.width - (2 * imageWidthShrink),
            height: imageView.frame.height - (2 * imageHeightShrink))
        
        playSound(name: "punchSound")

        imageView.frame = smallerImageFrame
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10.0, options: [], animations: {self.imageView.frame = originalImageFrame})
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)

    }
    
    func accessPhotoLibrary() {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)

    }
    
    func accessCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            present(imagePickerController, animated: true, completion: nil)
        }else{
            showAlert(title: "Camera Not Available", message: "There is no camera available on this device.")
        }
    }
}
