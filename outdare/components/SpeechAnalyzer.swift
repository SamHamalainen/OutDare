//
//  SpeechAnalyzer.swift
//  outdare
//
//  Created by iosdev on 9.4.2022.
//

import Foundation
import Speech

/// Handles the Speech Recognition and publishes the recognized text.
final class SpeechAnalyzer: NSObject, ObservableObject, SFSpeechRecognizerDelegate {
    @Published var recognizedText: String?
    @Published var isProcessing: Bool = false
    
    private let audioEngine = AVAudioEngine()
    private var inputNode: AVAudioInputNode?
    private var audioSession: AVAudioSession?
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    /// Configures the audio session, creates the input node, initiates the Speech Recognizer with a given Locale, creates the request and starts the recording/recognition.
    func start() {
        audioSession = AVAudioSession.sharedInstance()
        
        //configuring a few things in the audio session e.g. other audio is silenced
        do {
            try audioSession?.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession?.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Couldn't configure the audio session properly")
        }
        inputNode = audioEngine.inputNode
        
        self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        //using apple's servers to recognize speech
        recognitionRequest?.requiresOnDeviceRecognition = false
        
        //recognizes text right from the start and updating in real life
        recognitionRequest?.shouldReportPartialResults = true
        
        //checking that everything is set up and that the locale is available on the current device
        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable, let recognitionRequest = recognitionRequest, let inputNode = inputNode
        else {
            assertionFailure("Unable to start the speech recognition!")
            return
        }
        
        speechRecognizer.delegate = self
        
        //preparing to pass live audio buffer to the request by allowing app to tap into live audio
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {(buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            recognitionRequest.append(buffer)
        }
        
        //recognition task which returns the transcript that is considered the most accurate and stops the recognition
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            self?.recognizedText = result?.bestTranscription.formattedString
            guard error != nil || result?.isFinal == true else { return }
            self?.stop()
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
            isProcessing = true
        } catch {
            print("Coudn't start audio engine!")
            stop()
        }
        
    }
    
    /// Stops the Voice-to-Speech
    func stop() {
        recognitionTask?.cancel()
        
        audioEngine.stop()
        
        inputNode?.removeTap(onBus: 0)
        try? audioSession?.setActive(false)
        audioSession = nil
        inputNode = nil
        
        isProcessing = false
        
        recognitionRequest = nil
        recognitionTask = nil
        speechRecognizer = nil
    }
    
    /// Checks the availability of the Speech Recognizer function
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            print("✅ Available")
        } else {
            print("🔴 Unavailable")
            recognizedText = "Text recognition unavailable. Sorry!"
            stop()
        }
    }
}
