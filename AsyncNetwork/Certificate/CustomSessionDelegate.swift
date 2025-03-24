//
//  CustomSessionDelegate.swift
//  AsyncNetwork
//
//  Created by Ali Mert Ozhayta [Obssteknolojileri] on 18.12.2024.
//

import Foundation

class CustomSessionDelegate: NSObject, URLSessionDelegate {

    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        guard let serverTrust = challenge.protectionSpace.serverTrust,
              let certPath = Bundle.main.path(forResource: "certificate", ofType: "cer"),
              let localCertData = NSData(contentsOfFile: certPath) else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        // Get server certificate
        if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, .zero),
            let serverCertData = SecCertificateCopyData(serverCertificate) as Data? {

            // compare the certificates
            if localCertData.isEqual(to: serverCertData) {
                let credential = URLCredential(trust: serverTrust)
                completionHandler(.useCredential, credential)
                return
            }
        }

        // if certificates don't match, cancel the challange
        completionHandler(.cancelAuthenticationChallenge, nil)
    }
}
