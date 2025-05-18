//
//  DisableBackSwipeGesture.swift
//  CoBo-iPad
//
//  Created by Amanda on 16/05/25.
//

import SwiftUI

struct DisableBackSwipeGesture: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        DispatchQueue.main.async {
            controller.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
