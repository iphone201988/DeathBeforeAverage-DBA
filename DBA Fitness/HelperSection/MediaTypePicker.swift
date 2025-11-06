import UIKit
import PhotosUI
import AVFoundation

enum PickedMedia {
    case image(UIImage)
    case video(URL)
}

class MediaTypePicker: NSObject {
    
    static let shared = MediaTypePicker()
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private var completion: ((PickedMedia?) -> Void)?
    
    private override init() {
        self.pickerController = UIImagePickerController()
        super.init()
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.videoMaximumDuration = 60
        self.pickerController.videoQuality = .typeHigh
        self.pickerController.mediaTypes = ["public.image", "public.movie"]
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            pickerController.sourceType = type
            presentationController?.present(pickerController, animated: true)
        }
    }
    
    func present(from presentationController: UIViewController,
                 sourceView: UIView,
                 completion: @escaping (PickedMedia?) -> Void) {
        
        self.presentationController = presentationController
        self.completion = completion
        
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Take Photo or Video") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Photo Library", style: .default) { [unowned self] _ in
            var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
            configuration.selectionLimit = 1
            configuration.filter = .any(of: [.images, .videos])
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            
            picker.modalPresentationStyle = presentationController.modalPresentationStyle
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                let frame = sourceView.frame
                picker.popoverPresentationController?.sourceView = sourceView
                picker.popoverPresentationController?.sourceRect = CGRect(x: frame.midX, y: frame.maxY, width: 0, height: 0)
            }
            
            presentationController.present(picker, animated: true)
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let frame = sourceView.frame
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = CGRect(x: frame.midX, y: frame.maxY, width: 0, height: 0)
        }
        
        presentationController.present(alertController, animated: true)
    }
    
    private func handlePickedImage(_ image: UIImage?) {
        pickerController.dismiss(animated: true, completion: nil)
        if let img = image {
            completion?(.image(img))
        } else {
            completion?(nil)
        }
    }
    
    private func handlePickedVideo(url: URL?) {
        pickerController.dismiss(animated: true, completion: nil)
        if let url = url {
            completion?(.video(url))
        } else {
            completion?(nil)
        }
    }
}

// MARK: - Delegates
extension MediaTypePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        handlePickedImage(nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            handlePickedImage(editedImage)
        } else if let originalImage = info[.originalImage] as? UIImage {
            handlePickedImage(originalImage)
        } else if let mediaURL = info[.mediaURL] as? URL {
            handlePickedVideo(url: mediaURL)
        } else {
            handlePickedImage(nil)
        }
    }
}
extension MediaTypePicker: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let result = results.first else {
            self.completion?(nil)
            return
        }

        let provider = result.itemProvider
        
        // Handle Image
        if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
            provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                DispatchQueue.main.async {
                    if let image = object as? UIImage {
                        self?.completion?(.image(image))
                    } else {
                        self?.completion?(nil)
                    }
                }
            }
            return
        }

        // Handle Video (with correct fps and orientation)
        if let assetId = result.assetIdentifier {
            let assets = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
            guard let phAsset = assets.firstObject else {
                self.completion?(nil)
                return
            }

            let options = PHVideoRequestOptions()
            options.version = .original
            options.isNetworkAccessAllowed = true
            options.deliveryMode = .highQualityFormat

            PHImageManager.default().requestAVAsset(forVideo: phAsset, options: options) { [weak self] avAsset, _, _ in
                guard let self = self else { return }

                if let urlAsset = avAsset as? AVURLAsset {
                    DispatchQueue.main.async {
                        self.completion?(.video(urlAsset.url))
                    }
                } else {
                    DispatchQueue.main.async {
                        self.completion?(nil)
                    }
                }
            }
        } else {
            // Fallback: no assetIdentifier, use slower file representation method
            provider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { [weak self] url, _ in
                guard let self = self, let url = url else {
                    DispatchQueue.main.async {
                        self?.completion?(nil)
                    }
                    return
                }
                
                let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(url.lastPathComponent)
                try? FileManager.default.copyItem(at: url, to: tempURL)
                
                DispatchQueue.main.async {
                    self.completion?(.video(tempURL))
                }
            }
        }
    }
}
