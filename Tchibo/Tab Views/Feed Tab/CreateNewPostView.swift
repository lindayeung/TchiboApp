//
//  CreateNewPostView.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/24/21.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct Background<Content: View>: View {
    private var content: Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }

    var body: some View {
        Color.clear
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .overlay(content)
    }
}

struct CreateNewPostView: View {
    @StateObject var feedViewModel: FeedViewModel
    @State var newPostText = ""
    @Binding var creatingNewPost: Bool
    @State var image: UIImage?
    @State var showImagePicker = false
    
    let bounds = UIScreen.main.bounds
    
    
    var body: some View {
            ZStack(alignment: .top) {
                Color(Styles.primaryBackgroundColor)
                    .edgesIgnoringSafeArea(.all)
              
                ZStack {
                    VStack {
                        HStack {
                            Button(action: { creatingNewPost = false }) {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                        }
                        .foregroundColor(Color(Styles.mainColor3))
                        .padding(.top, 30)
                        
                        HeaderText(text: "New Post")
                            .padding(.vertical)
                        
                        
                        TextEditor(text: $newPostText)
                            .foregroundColor(.white)
                            .font(.custom(Styles.standardFontFamily, size: 18))
                            .frame(height: bounds.height * 0.15)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color(Styles.mainColor3), lineWidth: 2))
                            
                            .padding(.top)
                            .padding(.bottom)
                            .onTapGesture {
                                UIApplication.shared.endEditing()
                            }
                            
                        
                        
                        
                        if image != nil {
                            Button(action: { showImagePicker = true }, label: {
                                Image(uiImage: image!)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                            })
                            
                        }
                        else {
                            Button(action: {
                                showImagePicker = true
                                UIApplication.shared.endEditing()
                            }, label: {
                                ButtonView(text: "Add photo", width: 120, height: 35)
                            })
                            .sheet(isPresented: $showImagePicker) {
                                ImagePicker(showPicker: $showImagePicker, image: $image)
                            }
                        }
                        
                        
                        
                        Spacer()
                        Button(action: {
                            feedViewModel.createPost(newPostText: newPostText, newPostImage: image) {
                                DispatchQueue.main.async {
                                    creatingNewPost = false
                                    feedViewModel.isUploadingPost = false
                                }
                            }
                        }, label: {
                            ButtonView(text: "Post")
                        })
                        .padding(.bottom, 50)
                            
                            
                    }
                    .padding(.horizontal, bounds.width * Styles.tabPageMarginMultiple)
                
                    
                    if feedViewModel.isUploadingPost  {
                        uploadingPostView()
                    }
                }
                
                
            }
    }
    
    func uploadingPostView() -> some View {
        Group {
            Color(#colorLiteral(red: 0.1564444602, green: 0.1564779282, blue: 0.1564400494, alpha: 1))
                .edgesIgnoringSafeArea(.all)
                .opacity(0.8)
                .animation(.linear)
            ProgressView()
        }
    }
}

struct CreateNewPostView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewPostView(feedViewModel: FeedViewModel(), creatingNewPost: .constant(true))
    }
}
