import SwiftUI
import AVKit

struct WelcomeVideoView: View {
    @Binding var showWelcomeVideo: Bool

    var body: some View {
        ZStack {
            VideoPlayer(player: AVPlayer(url: videoURL()))
                .onDisappear {
                    showWelcomeVideo = false
                }
                .ignoresSafeArea()

            VStack {
                Spacer()
                Button(action: {
                    showWelcomeVideo = false
                }) {
                    Text("Skip")
                        .font(.headline)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }

    func videoURL() -> URL {
        guard let url = Bundle.main.url(forResource: "Welcome", withExtension: "mp4") else {
            fatalError("Welcome video not found in the Resources folder. Ensure the file name matches exactly.")
        }
        return url
    }
}
