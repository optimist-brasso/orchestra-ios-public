//
//  FileManager+Extension.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 04/08/2022.
//

import Foundation

extension FileManager {
    
    func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true) -> [URL]? {
        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
        let fileURLs = try? contentsOfDirectory(at: documentsURL,
                                                includingPropertiesForKeys: nil,
                                                options: skipsHiddenFiles ? .skipsHiddenFiles : [])
        return fileURLs
    }
    
}
