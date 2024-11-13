//
//  MailView.swift
//  MapPlanner
//
//  Created by 김성민 on 10/6/24.
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    
    @Environment(\.dismiss) var dismiss

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView
        
        init(_ parent: MailView) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            
            var toast = Toast(type: .success, title: "")
            if error != nil {
                toast.type = .error
                toast.title = "전송에 실패하였습니다"
            } else {
                switch result {
                case .sent:
                    toast.type = .success
                    toast.title = "성공적으로 전송되었습니다"
                case .cancelled:
                    toast.type = .warning
                    toast.title = "전송이 취소되었습니다"
                case .saved:
                    toast.type = .info
                    toast.title = "문의 내용이 임시로 저장되었습니다"
                case .failed:
                    toast.type = .error
                    toast.title = "전송에 실패하였습니다"
                @unknown default:
                    break
                }
            }
            
            NotificationCenter.default.post(
                name: .showToast,
                object: nil,
                userInfo: [Notification.UserInfoKey.toast: toast]
            )
            parent.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(["k2417000@naver.com"])
        vc.setSubject("[맵다이어리 문의하기]")
        let bodyString = """
                         이곳에 내용을 작성해 주세요.
                         
                         
                         ================================
                         Device Model : \(UIDevice.current.modelName)
                         Device OS : \(UIDevice.current.systemVersion)
                         App Version : \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")
                         ================================
                         """
        vc.setMessageBody(bodyString, isHTML: false)
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}
