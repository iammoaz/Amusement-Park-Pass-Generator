//
//  SoundManager.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/11/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import AudioToolbox

enum SoundType: String {
    case denied = "AccessDenied"
    case granted = "AccessGranted"
}

struct SoundManager {
    static let instance = SoundManager()
    
    private var files: [String: SystemSoundID] = [SoundType.granted.rawValue: 0, SoundType.denied.rawValue: 1]
    
    init() {
        for (file, var id) in files {
            let filePath = Bundle.main.path(forResource: file, ofType: "wav")
            let url = URL(fileURLWithPath: filePath!) as CFURL
            
            AudioServicesCreateSystemSoundID(url, &id)
            files[file] = id
        }
    }
    
    func playAccessGrantedSound() {
        AudioServicesPlaySystemSound(files[SoundType.granted.rawValue]!)
    }
    
    func playAccessDeniedSound() {
        AudioServicesPlaySystemSound(files[SoundType.denied.rawValue]!)
    }
}
