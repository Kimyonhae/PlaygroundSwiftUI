//
//  imagePicker.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 7/20/25.
//

import SwiftUI
import PhotosUI

struct ImagePickerView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            if let imageData = selectedImageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            }else {
                Text("이미지를 선택해주세요.")
                    .foregroundColor(.gray)
            }
            
            PhotosPicker("앨범에서 이미지 선택", selection: $selectedItem, matching: .images)
                .padding()
                .onChange(of: selectedItem) {
                    Task {
                        if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                    }
                }
            }
        }
    }
}

#Preview {
    ImagePickerView()
}
