//
//  FormTextFieldView.swift
//  GreenerBox
//
//  Created by Linda Yeung on 10/18/20.
//

import SwiftUI
import UIKit
import Combine





struct TextView: UIViewRepresentable {
    var placeHolderText: String
    let placeHolderColor: UIColor = .tertiaryLabel
    @Binding var text: String
    @Binding var isEditing: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<TextView>) {
     
    }
    
    func makeUIView(context: UIViewRepresentableContext<TextView>) -> UITextView {
        
        let textView = UITextView()
        textView.isEditable = true
        textView.font = UIFont(name: Styles.standardFontFamily, size: 18)
        textView.text = placeHolderText
        textView.textColor = placeHolderColor
        textView.backgroundColor = .clear
        textView.isScrollEnabled = true
        
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let toolbarButton = UIBarButtonItem(title: "Done", style: .done, target: context.coordinator, action: #selector(context.coordinator.userTappedDone))
        toolbarButton.tintColor = Styles.mainColor1
        
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.barTintColor = .secondarySystemBackground
        toolbar.setItems([flexibleSpace, toolbarButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        textView.inputAccessoryView = toolbar
        
        
        textView.delegate = context.coordinator
        
        return textView
    }

    
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView
        
        init(_ textView: TextView) {
            self.parent = textView
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            if textView.text != parent.placeHolderText {
                textView.textColor = .label
            }
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == parent.placeHolderText {
                textView.text = ""
                textView.textColor = parent.placeHolderColor
            }
            else {
                parent.text = textView.text
                textView.textColor = .label
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                textView.text = parent.placeHolderText
                textView.textColor = parent.placeHolderColor
            }
        }
        
        @objc func userTappedDone() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            parent.isEditing = false
        }
  
    }
}





struct InputTextFieldStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        VStack {
            content
            Rectangle()
                .fill(Color(Styles.mainColor3))
                .frame(height: 1)
        }
        
    }
}

extension View {
    func inputTextFieldStyle() -> some View { return self.modifier(InputTextFieldStyle()) }
}





struct FormMultilineTextFieldView: View {
    var size: CGSize
    var formLabel: String
    var placeHolder: String
    @Binding var text: String
    @Binding var isEditing: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(formLabel)
                .fontWeight(.medium)
                .font(.custom(Styles.standardFontFamily, size: 20))
                .foregroundColor(Color(Styles.mainColor2))
                .offset(x: 10)
            
            TextView(placeHolderText: placeHolder, text: $text, isEditing: $isEditing)
                .frame(height: size.height * 0.11)
                .padding(.vertical, 10)
                .padding(.horizontal, 17.5)
                .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color(Styles.mainColor2), lineWidth: 1.5))
                .onTapGesture(count: 1, perform: {
                    isEditing = true
                })
                
               
        }
        .padding(.horizontal, size.width * 0.1)
    }
}

struct FormTextFieldView_Previews: PreviewProvider {
    @State static var text: String = ""
    
    static var previews: some View {
        GeometryReader{ geometry in
            VStack {
                TextField("Email", text: .constant("Email"))
                    .inputTextFieldStyle()
                
                FormMultilineTextFieldView(size: geometry.size, formLabel: "Description", placeHolder: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum", text: $text, isEditing: .constant(true))
            }
        }
        
    }
}
