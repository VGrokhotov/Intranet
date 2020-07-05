//
//  DocumentsViewController.swift
//  Intranet
//
//  Created by Владислав on 05.07.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

class DocumentsViewController: UIDocumentBrowserViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let action = UIDocumentBrowserAction(identifier: "Share", localizedTitle: "Share in Intranet", availability: .init(arrayLiteral: .menu, .navigationBar)) { [weak self] (urls) in
            
            self?.dismiss(animated: true, completion: nil)
        }
        action.image = UIImage.init(systemName: "paperplane.fill")
        action.supportsMultipleItems = false
        action.supportedContentTypes = allowedContentTypes
        
        
        customActions = [action]
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        print(documentURLs)
    }
    
}
