

import UIKit
import AVFoundation

class Scan_Product: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    // MARK: Outlets & Variables
    
    @IBOutlet weak var scanView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var barCode: UITextField!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var scanned_ProductId = String()
    
    // MARK: Controller's Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
         barCode.placeholderColor(color: UIColor.white)
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        // previewLayer.frame = scanView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        // view.layer.addSublayer(previewLayer)
        // scanView.layer.addSublayer(previewLayer)
        self.scanView.layer.insertSublayer(previewLayer, at: 0)
        
        captureSession.startRunning()
    }
   
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
            previewLayer.removeFromSuperlayer()
        }
        self.captureSession.stopRunning()
        dismiss(animated: true)
    }
    
    func found(code: String) { }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: IB's Action
 
    @IBAction func gallery(_ sender: UIButton) {
        
    }
    
    
    @IBAction func isFlashOn(_ sender: UIButton) {
        
    }

     @IBAction func back(_ sender: UIButton) {
         self.navigationController?.popViewController(animated: true)
     }
    
}

