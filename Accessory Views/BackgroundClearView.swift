//
//  BackgroundClearView.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/31/21.
//

import Foundation
import UIKit
import SwiftUI

struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
