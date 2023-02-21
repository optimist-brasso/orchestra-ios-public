//
//  SoundRecordingManager.swift
//  Orchestra
//
//  Created by Prakash Chandra Awal on 7/5/22.
//

import UIKit
import AVFoundation
import AudioToolbox
//
protocol SoundRecordingDelegate: NSObject {
    func soundRecordingStopped()
    func canNowStartRecording()
}
//
//struct RecordingOption: Comparable {
//    let name: String
//    fileprivate let dataSourceName: String
//    static func < (lhs: RecordingOption, rhs: RecordingOption) -> Bool {
//        lhs.name < rhs.name
//    }
//}
//
//enum Orientation: Int {
//    case unknown = 0
//    case portrait = 1
//    case portraitUpsideDown = 2
//    case landscapeLeft = 4
//    case landscapeRight = 3
//}
//
//fileprivate extension Orientation {
//    // Convenience property to retrieve the AVAudioSession.StereoOrientation.
//    var inputOrientation: AVAudioSession.StereoOrientation {
//        return AVAudioSession.StereoOrientation(rawValue: rawValue)!
//    }
//
//    init(_ interfaceOrientation: UIInterfaceOrientation) {
//        self.init(rawValue: interfaceOrientation.rawValue)!
//    }
//}
//
//
//class SoundRecordingManager: NSObject {
//
//    //MARK: - Properties
//    var view: UIView?
//    var audioEngine = AVAudioEngine()
//    var recordedFile: AVAudioFile?
//    var recordingSession = AVAudioSession.sharedInstance()
//    var isRecording: Bool = false
//    var audiofile: URL?
//    var fileName = "audio_recorded_file.wav"
//    var recordedAudioData: Data?
//    var recordingFormat: AVAudioFormat?
//    var inputFormat: AVAudioFormat!
//    var recordingSettings: [String: Any]?
//    var audioQuality = AVAudioQuality.medium.rawValue
//    var mixer : AVAudioMixerNode!
//
//    private var windowOrientation: UIInterfaceOrientation {
//        return view?.window?.windowScene?.interfaceOrientation ?? .unknown
//    }
//
//    var isStereoSupported = false
//
//    var recordingOptions = [RecordingOption]()
//
//    weak var delegate: SoundRecordingDelegate?
//
//    //MARK: - Initializer
//    override init() {
//        super.init()
//        setupAudioSession()
//        //        enableBuiltInMic()
//        //        setRecordingOptions()
//        updateRecordingSettings()
//    }
//
//    //MARK: - Methods
//
//    private func enableBuiltInMic() {
//        // Get the shared audio session.
//        let session = AVAudioSession.sharedInstance()
//
//        // Find the built-in microphone input.
//        guard let availableInputs = session.availableInputs,
//              let builtInMicInput = availableInputs.first(where: { $0.portType == .builtInMic }) else {
//            print("The device must have a built-in microphone.")
//            return
//        }
//
//        // Make the built-in microphone input the preferred input.
//        do {
//            try session.setPreferredInput(builtInMicInput)
//        } catch {
//            print("Unable to set the built-in mic as the preferred input.")
//        }
//    }
//
//    private func setRecordingOptions() {
//        let front = AVAudioSession.Orientation.front
//        let back = AVAudioSession.Orientation.back
//        let bottom = AVAudioSession.Orientation.bottom
//
//        let session = AVAudioSession.sharedInstance()
//        guard let dataSources = session.preferredInput?.dataSources else { return }
//
//        var options = [RecordingOption]()
//        dataSources.forEach { dataSource in
//            switch dataSource.orientation {
//            case front:
//                options.append(RecordingOption(name: "Front Stereo", dataSourceName: front.rawValue))
//            case back:
//                options.append(RecordingOption(name: "Back Stereo", dataSourceName: back.rawValue))
//            case bottom:
//                options.append(RecordingOption(name: "Mono", dataSourceName: bottom.rawValue))
//            default: ()
//            }
//        }
//        // Sort alphabetically
//        options.sort()
//
//        recordingOptions = options
//
//    }
//
//    private func setupConnections() {
//
//        mixer = AVAudioMixerNode()
//
//        let inputNode = audioEngine.inputNode
//        inputFormat = inputNode.outputFormat(forBus: 0)
//
//        //        let mixerFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: inputFormat.sampleRate, channels: 1, interleaved: false)
//
//        //        let mainMixerNode = audioEngine.mainMixerNode
//
//
//        //        audioEngine.connect(mixer, to: mainMixerNode, format: mixerFormat)
//
//
//        //        inputFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: recordingSession.sampleRate, channels: 1, interleaved: true)
//
//        try? audioEngine.inputNode.setVoiceProcessingEnabled(true)
//        audioEngine.prepare()
//    }
//
//    func askingForPermission() {
//
//        recordingSession.requestRecordPermission() { [unowned self] allowed in
//            DispatchQueue.main.async {
//                if allowed {
//                    self.delegate?.canNowStartRecording()
//                } else {
//                    // failed to record!
//                    if let bundleId = Bundle.main.bundleIdentifier,
//                       let url = URL(string: "\(UIApplication.openSettingsURLString)&path=MICROPHONE/\(bundleId)"),
//                       UIApplication.shared.canOpenURL(url) {
//                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                    }
//
//                    self.stopRecording(with: false)
//                }
//            }
//        }
//    }
//
//    func setupAudioSession() {
//        do {
//            try recordingSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
//            try recordingSession.setActive(true)
//        } catch{
//            print(error.localizedDescription)
//        }
//
//    }
//
//    //MARK: START RECORDING
//    func startRecording() {
//        setupConnections()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            do {
//                try self.audioEngine.start()
//            } catch {
//                print(error.localizedDescription)
//            }
//
//            let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//
//            let outputFormat = self.audioEngine.outputNode.outputFormat(forBus: 0)
//            print(outputFormat, "out put format---------->>>>")
//
//            //            let tapNode: AVAudioNode = self.mixer
//            //            let format = tapNode.outputFormat(forBus: 0)
//
//
//            self.recordedFile = try? AVAudioFile(forWriting: documentURL.appendingPathComponent(self.fileName),
//                                                 settings:  self.recordingFormat!.settings)
//            self.audiofile = documentURL.appendingPathComponent(self.fileName)
//
//
//            //convert the sample rate
//
//            self.audioEngine.inputNode.removeTap(onBus: 0)
//            self.audioEngine.inputNode.installTap(onBus: 0,
//                                                  bufferSize: 4096,
//                                                  format: self.inputFormat,
//                                                  block: { [weak self] (buffer: AVAudioPCMBuffer!, time: AVAudioTime!) -> Void in
//                guard let self = self else {return}
//
//                let inputCallback: AVAudioConverterInputBlock = { inNumPackets, outStatus in
//                    outStatus.pointee = AVAudioConverterInputStatus.haveData
//                    return buffer
//                }
//
//
//
//                let capacity = AVAudioFrameCount(self.recordingFormat!.sampleRate) * buffer.frameLength / AVAudioFrameCount(buffer.format.sampleRate)
//                let convertedBuffer = AVAudioPCMBuffer(pcmFormat: self.recordingFormat!, frameCapacity: capacity)!
//                convertedBuffer.frameLength = convertedBuffer.frameCapacity
//
//                let converter = AVAudioConverter(from: self.inputFormat , to: self.recordingFormat!)!
//                converter.sampleRateConverterQuality = .max
//                converter.sampleRateConverterAlgorithm = AVSampleRateConverterAlgorithm_Normal
//
//                var error: NSError? = nil
//                let status = converter.convert(to: convertedBuffer, error: &error, withInputFrom: inputCallback)
//                assert(status != .error)
//
//                print(buffer, "original data ------->>")
//                print(convertedBuffer, "converted data ----->>")
//                print(convertedBuffer.format, "formate rate ------->")
//                //                print(status.rawValue, "status raw value --->")
//                //
//                self.isRecording = true
//
//                if let file = self.recordedFile {
//                    do {
//                        try file.write(from: convertedBuffer)
//                    }
//                    catch let error {
//                        print("Write failed: \(error)")
//                    }
//                }
//
//
//            })
//        }
//    }
//
//
//    //MARK: - STOP RECORDING
//    func stopRecording(with success: Bool) {
//        //        guard let filePlayer = audioFilePlayer else {return}
//        //        filePlayer.stop()
//
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.audioEngine.stop()
//            self.audioEngine.reset()
//
//
//        }
//
//        isRecording = false
//        recordedFile = nil
//        if success {
//            convertToData()
//            delegate?.soundRecordingStopped()
//        }
//    }
//
//    private func convertToData() {
//        DispatchQueue.global(qos: .userInitiated).async {
//            do {
//                guard let url = self.audiofile else {return}
//                let data = try Data(contentsOf: url)
//                self.recordedAudioData = data
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//    private func updateRecordingSettings() {
//        if let settings = Cacher().value(type: RecordingSettings.self, forKey: .recordingSettings) {
//            fileName = "audio_recorded_file.\(settings.fileFormat ?? "wav")"
//
//            switch settings.encodingQuality ?? "Medium" {
//            case "Low":
//                audioQuality = AVAudioQuality.low.rawValue
//            case "Medium":
//                audioQuality = AVAudioQuality.medium.rawValue
//            case  "High":
//                audioQuality = AVAudioQuality.high.rawValue
//            default:
//                audioQuality = AVAudioQuality.medium.rawValue
//            }
//
//            let bitRate = settings.bitRate?.replacingOccurrences(of: "kbps", with: "") ?? "16"
//            let sampleRate = settings.samplingRate?.replacingOccurrences(of: "Hz", with: "").replacingOccurrences(of: ",", with: "") ?? "8000"
//
//
//            // This method used for changing mono
//            // to stereo or vice versa
//            //            if !recordingOptions.isEmpty {
//            //                if settings.channel == "Stereo" {
//            //                    selectRecordingOption(recordingOptions[0], orientation: Orientation(windowOrientation))
//            //
//            //                }
//            //                else {
//            //                    selectRecordingOption(recordingOptions[2], orientation: Orientation(rawValue: 1)!)
//            //                }
//            //
//            //            }
//
//
//            recordingFormat = AVAudioFormat(settings: [
//                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
//                AVSampleRateKey: Double(sampleRate),
//                AVNumberOfChannelsKey: 1,
//                AVEncoderAudioQualityKey: audioQuality
//            ])
//
//
////            recordingFormat = AVAudioFormat(commonFormat: .pcmFormatInt32,
////                                            sampleRate: Double(sampleRate) ?? 48000,
////                                            channels: 2,
////                                            interleaved: false)
//
//        }
//    }
//
//
//    func selectRecordingOption(_ option: RecordingOption, orientation: Orientation) {
//
//        // Find the built-in microphone input's data sources,
//        // and select the one that matches the specified name.
//        guard let preferredInput = recordingSession.preferredInput,
//              let dataSources = preferredInput.dataSources,
//              let newDataSource = dataSources.first(where: { $0.dataSourceName == option.dataSourceName }),
//              let supportedPolarPatterns = newDataSource.supportedPolarPatterns else {
//
//            return
//        }
//
//        do {
//            isStereoSupported = supportedPolarPatterns.contains(.stereo)
//            // If the data source supports stereo, set it as the preferred polar pattern.
//            if isStereoSupported {
//                // Set the preferred polar pattern to stereo.
//                try newDataSource.setPreferredPolarPattern(.stereo)
//            }
//
//            // Set the preferred data source and polar pattern.
//            try preferredInput.setPreferredDataSource(newDataSource)
//
//            // Update the input orientation to match the current user interface orientation.
//            try recordingSession.setPreferredInputOrientation(orientation.inputOrientation)
//
//        } catch {
//            print("Unable to select the \(option.dataSourceName) data source.")
//        }
//
//    }
//}



class SoundRecordingManager: NSObject {

    //MARK: Properties
    var recordingSession = AVAudioSession.sharedInstance()
    var audioRecorder: AVAudioRecorder?
    var isRecording: Bool = false
    weak var delegate: SoundRecordingDelegate?
    var audiofile: URL?
    var recordedAudioData: Data?
    var fileName = "audio_recorded_file.wav"
    var recordSettings: [String: Any]?
    var fileFomate: String = "wav"

    
    //MARK: Initializers
    override init() {
        super.init()
        setupAudioSession()
        updateRecordingSettings()
    }

    //MARK: Methods

    private func setupAudioSession() {
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try recordingSession.setActive(true)
        }
        catch {
            print("Audio Session Error: \(error.localizedDescription)")
        }
    }

    func requestPermission() {
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.delegate?.canNowStartRecording()
                    } else {
                        // failed to record!
                        if let bundleId = Bundle.main.bundleIdentifier,
                           let url = URL(string: "\(UIApplication.openSettingsURLString)&path=MICROPHONE/\(bundleId)"),
                           UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }

                        self.stopRecording(with: false)
                    }
                }
            }
    }

    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent(fileName)
        audiofile = audioFilename

        guard let recordSettings = recordSettings else {
            stopRecording(with: false)
            return
        }
        
//        guard let recordSettings = recordSettings else {
//            return
//        }
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: recordSettings)
            audioRecorder!.delegate = self
            audioRecorder!.prepareToRecord()
            audioRecorder!.record()
            isRecording = true

        } catch {
            print("recording error: \(error.localizedDescription)    --------->>")
            delegate?.soundRecordingStopped()
            stopRecording(with: false)
        }

    }

    private func updateRecordingSettings() {
        if let settings = Cacher().value(type: RecordingSettings.self, forKey: .recordingSettings) {
            fileName = "audio_recorded_file.\(settings.fileFormat?.lowercased() ?? "wav")"
            fileFomate = settings.fileFormat?.lowercased() ?? "wav"
            var audioQuality = AVAudioQuality.medium.rawValue

            switch settings.encodingQuality ?? "Medium" {
            case "Low":
                audioQuality = AVAudioQuality.low.rawValue
            case "Medium":
                audioQuality = AVAudioQuality.medium.rawValue
            case  "High":
                audioQuality = AVAudioQuality.high.rawValue
            default:
                audioQuality = AVAudioQuality.medium.rawValue
            }

            let bitRate = settings.bitRate?.replacingOccurrences(of: "kbps", with: "") ?? "16"
            let sampleRate = settings.samplingRate?.replacingOccurrences(of: "Hz", with: "").replacingOccurrences(of: ",", with: "") ?? "48000"

            let numberOfChannel = settings.channel == "Stereo" ? 2 : 1
     
            recordSettings = [
                AVFormatIDKey: kAudioFormatLinearPCM,
                AVSampleRateKey: Double(sampleRate) ?? .zero,
                AVNumberOfChannelsKey: numberOfChannel,
                AVEncoderAudioQualityKey: audioQuality,
                AVEncoderBitRateKey: Double(bitRate) ?? .zero
            ]

        }
        else {
            recordSettings = [
                AVFormatIDKey: kAudioFormatLinearPCM,
                AVSampleRateKey: 48000,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue,
                AVEncoderBitRateKey: 16
            ]
        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func stopRecording(with success: Bool) {
        DispatchQueue.global(qos: .background).async {
            self.audioRecorder?.stop()
        }
        audioRecorder = nil
        isRecording = false
        if success {
            convertToData()
            delegate?.soundRecordingStopped()
        }
    }

    private func convertToData() {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                guard let url = self.audiofile else {return}
                let data = try Data(contentsOf: url)
                self.recordedAudioData = data
            } catch {
                print(error.localizedDescription)
            }
        }
    }

}


extension SoundRecordingManager: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            stopRecording(with: false)
        }
    }
}


