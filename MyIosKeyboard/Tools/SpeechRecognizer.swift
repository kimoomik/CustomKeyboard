//
//  SpeechRecognizer.swift
//  MyIosKeyboard
//
//  Created by Mediana Abdelkarim on 30/05/2023.
//

import Speech

protocol SpeechRecognizerDelegate: AnyObject {
    func speechRecognitionDidStart()
    func speechRecognitionDidFinish(withText text: String)
    func speechRecognitionDidCancel()
    func speechRecognitionDidFail(withError error: Error)
}

class SpeechRecognizer: NSObject, SFSpeechRecognizerDelegate {
    weak var delegate: SpeechRecognizerDelegate?
    
    private let speechRecognizer: SFSpeechRecognizer
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine: AVAudioEngine
    
    override init() {
        speechRecognizer = SFSpeechRecognizer(locale: Locale.current)!
        audioEngine = AVAudioEngine()
        
        super.init()
        
        speechRecognizer.delegate = self
    }
    
    func startRecognition() throws {
        let inputNode = audioEngine.inputNode
//        else {
//            throw SpeechRecognitionError.audioEngineInputNodeNotFound
//        }
        
        let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
//        else {
//            throw SpeechRecognitionError.requestCreationFailed
//        }
        
        self.recognitionRequest = recognitionRequest
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            
            var isFinal = false
            
            if let result = result {
                isFinal = result.isFinal
                
                // Process the recognized text
                let recognizedText = result.bestTranscription.formattedString
                self.delegate?.speechRecognitionDidFinish(withText: recognizedText)
            }
            
            if error != nil || isFinal {
                self.stopRecognition()
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        delegate?.speechRecognitionDidStart()
    }
    
    func stopRecognition() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        
        recognitionRequest = nil
        recognitionTask = nil
        
        delegate?.speechRecognitionDidFinish(withText: "")
    }
    
    func cancelRecognition() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        
        recognitionRequest = nil
        recognitionTask = nil
        
        delegate?.speechRecognitionDidCancel()
    }
    
    // MARK: - SFSpeechRecognizerDelegate
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        // Handle availability changes if needed
    }
}

enum SpeechRecognitionError: Error {
    case audioEngineInputNodeNotFound
    case requestCreationFailed
}
