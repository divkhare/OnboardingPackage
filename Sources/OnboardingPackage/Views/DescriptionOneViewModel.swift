//
//  DescriptionOneViewModel.swift
//
//
//  Created by Div Khare on 8/2/24.
//

import SwiftUI
import AVKit

private extension String {
    static let videoKey = "moodChart" // Change this to your video file name
    static let videoExtension = "mov"
}

class VideoPlayerViewModel: ObservableObject {
    @Published var player: AVQueuePlayer
    private var playerLooper: AVPlayerLooper?
    
    init() {
        guard let url = Bundle.module.url(forResource: String.videoKey, withExtension: String.videoExtension) else {
            fatalError("Failed to find video file: \(String.videoKey).\(String.videoExtension)")
        }
        
        let playerItem = AVPlayerItem(url: url)
        self.player = AVQueuePlayer(playerItem: playerItem)
        self.player.isMuted = true
        
        // Set up looping
        self.playerLooper = AVPlayerLooper(player: self.player, templateItem: playerItem)
    }
}

struct VideoPlayerView: View {
    @StateObject var viewModel: VideoPlayerViewModel = VideoPlayerViewModel()
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VideoPlayer(player: viewModel.player)
                    .background(.white)
                    .frame(width: .infinity)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .edgesIgnoringSafeArea(.all)
                }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                viewModel.player.play()
            } else {
                viewModel.player.pause()
            }
        }
        .onAppear {
            viewModel.player.play()
        }
        .onDisappear {
            viewModel.player.pause()
        }
    }
}

struct ContentView: View {
    var body: some View {
        ZStack {
            VideoPlayerView()
                .frame(width: 500, height: 300)
                .background(Color.clear)
//            VStack {
//                Spacer()
//                Text("Welcome to MoodTracker!")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.black.opacity(0.5))
//                    .cornerRadius(10)
//                Spacer()
//            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
