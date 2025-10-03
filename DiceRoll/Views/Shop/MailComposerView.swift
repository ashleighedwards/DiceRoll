//
//  MailComposerView.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 03/10/2025.
//

import SwiftUI
import MessageUI

struct MailComposerView: UIViewControllerRepresentable {
    let to: [String]
    let subject: String
    let body: String
    @Environment(\.dismiss) private var dismiss

    final class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let parent: MailComposerView
        init(_ parent: MailComposerView) { self.parent = parent }
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            controller.dismiss(animated: true) { self.parent.dismiss() }
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIViewController(context: Context) -> UIViewController {
        if MFMailComposeViewController.canSendMail() {
            let vc = MFMailComposeViewController()
            vc.setToRecipients(to)
            vc.setSubject(subject)
            vc.setMessageBody(body, isHTML: false)
            vc.mailComposeDelegate = context.coordinator
            return vc
        } else {
            let subjectEnc = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let bodyEnc = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let addr = to.first ?? ""
            let addrEnc = addr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let urlString = "mailto:\(addrEnc)?subject=\(subjectEnc)&body=\(bodyEnc)"
            let host = UIHostingController(rootView:
                VStack(spacing: 12) {
                    Text("Mail isn’t configured on this device.")
                        .font(.headline)
                    Button("Open Mail") {
                        if let url = URL(string: urlString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    Button("Close") { dismiss() }
                }
                .padding()
            )
            return host
        }
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

