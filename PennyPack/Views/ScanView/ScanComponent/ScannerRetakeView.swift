import Foundation
import SwiftUI

struct ScannerRetakeView: View {
    @ObservedObject var scanViewModel: ScanViewModel
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    var body: some View {
        if scanViewModel.isPicture {
            VStack {
                if let image = scanViewModel.recentImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 360, height: 350)
                        .cornerRadius(11)
                        .padding(.top, 86)
                }
                Button(action: {
                    scanViewModel.isPicture = false
                    scanViewModel.reset()
                }, label: {
                    ZStack {
                        Circle()
                            .foregroundColor(.pGray)
                            .frame(width: 50, height: 50)
                        Image(systemName: "camera.rotate.fill")
                            .resizable()
                            .frame(width: 28, height: 22)
                            .foregroundColor(.white)
                    }
                })
            }
        } else {
            VStack {
                scanViewModel.cameraManager.cameraPreview.ignoresSafeArea()
                    .overlay(
                        RoundedRectangle(cornerRadius: 11)
                            .stroke(Color.white.opacity(0.5), lineWidth: 3)
                    )
                    .onAppear {
                        scanViewModel.cameraManager.configure()
                    }
                    .gesture(MagnificationGesture()
                        .onChanged { val in
                            scanViewModel.cameraManager.zoom(factor: val)
                        }
                        .onEnded { _ in
                            scanViewModel.cameraManager.zoomInitialize()
                        }
                    )
                    .frame(width: 360, height: 350)
                    .cornerRadius(11)
                    .padding(.top, 86)
                Button(action: {
                    /// 1. 카메라 버튼 클릭
                    scanViewModel.cameraManager.capturePhoto { image in
                        /// 5. Camera Model에서 사진이 찍히면, completion을 호출하면서 image로 찍힌 사진을 전달해줌. recentImage 설정
                        DispatchQueue.main.async {
                            self.scanViewModel.recentImage = image
                            print("Image captured and set to recentImage")
                            scanViewModel.isPicture = true

                            let coordinator = makeCoordinator()
                            coordinator.recognizeText(in: image)
                        }
                    }
                }, label: {
                    ZStack {
                        Circle()
                            .foregroundColor(.pBlue)
                            .frame(width: 50, height: 50)
                        Image(systemName: "camera.fill")
                            .resizable()
                            .frame(width: 28, height: 22)
                            .foregroundColor(.white)
                    }
                })
                .onChange(of: scanViewModel.recentImage) { _, newImage in
                   /// 6. recentImage의 변화에 따라 아래 코드 실행. coordinator에 recognizeText로 이미지에 있는 텍스트 인식 기능 구현
                }
            }
        }
    }
}
