//
//  ViewController.swift
//  Cryptanalysis
//
//  Created by Kiryl Holubeu on 10/21/18.
//  Copyright © 2018 Kiryl Holubeu. All rights reserved.
//

import Cocoa

extension NSViewController {
    
    func browseFile() -> String {
        let browse = NSOpenPanel();
        browse.title                   = "Choose a file"
        browse.showsResizeIndicator    = true
        browse.showsHiddenFiles        = false
        browse.canCreateDirectories    = true
        browse.allowsMultipleSelection = false
        browse.allowedFileTypes = ["txt"]

        if (browse.runModal() == NSApplication.ModalResponse.OK) {
            let result = browse.url
            if (result != nil) {
                return result!.path
            }
        }
        return ""
    }
    
    func dialogError(question: String, text: String) {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .critical
        alert.addButton(withTitle: "Ok")
        alert.runModal()
    }
}



class ViewController: NSViewController {
    
    func openFile() -> String  {
        let filePath = browseFile()
        do {
            return try String(contentsOfFile: filePath)
        } catch {
            return ""
        }
    }

}


