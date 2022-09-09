//
//  elements.swift
//  Learnalize
//
//  Created by Media Davarkhah on 1/17/1401 AP.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

func profileImage(pic: String, size: CGFloat = 100) -> some View {
    VStack {
        if let url = URL(string: pic) {
            WebImage(url:url)
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipped()
                .cornerRadius(100)
                .foregroundColor(Color("accent"))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: -8, y: -8)
        } else {
            Image("profile")
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipped()
                .cornerRadius(100)
                .foregroundColor(Color("accent"))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: -8, y: -8)
        }
    }
}



func textField(placeholder: String, input: Binding<String>, isEmpty: Bool) -> some View {

    TextField("", text: input)
        .placeholder(when: isEmpty, placeholder: {
            Text(placeholder).foregroundColor(.gray)
        })
        .padding()
        .background(.white)
        .cornerRadius(10)
        //.padding()
        .font(.body)
        .foregroundColor(.black)
        .accentColor(.black)
}

func secureField(placeholder: String, input: Binding<String>, isEmpty: Bool) -> some View {
    SecureField("", text: input, prompt: Text(placeholder))
        .placeholder(when: isEmpty, placeholder: {
            Text(placeholder).foregroundColor(.gray)
        })
        .padding()
        .background(.white)
        .cornerRadius(10)
        //.padding()
        .font(.body)
        
        .foregroundColor(.black)
        .accentColor(.black)
    
    
}
struct ImagePicker: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Binding var selectedImage: UIImage
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
struct LoadingView: View {
    var color: Color
    var body: some View {
        ZStack {
            color
                .opacity(0.8)
                .ignoresSafeArea()
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(2)
        }
    }
}

struct SearchBar: View {
    var placeholder: String
    
    @Binding var text: String
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField(placeholder, text: $text)
            if text != "" {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.medium)
                    .foregroundColor(Color(.systemGray3))
                    .padding(3)
                    .onTapGesture {
                        withAnimation {
                            self.text = ""
                          }
                    }
            }
        }
        .padding(10)
        .background(backgroundColor)
        .cornerRadius(12)
        .padding(.vertical, 10)
    }
    var backgroundColor: Color {
      if colorScheme == .dark {
           return Color(.systemGray5)
       } else {
           return Color(.systemGray6)
       }
    }
}



