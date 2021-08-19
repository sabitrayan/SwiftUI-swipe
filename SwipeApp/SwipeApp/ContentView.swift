//
//  ContentView.swift
//  SwipeApp
//
//  Created by ryan on 8/19/21.
//

import SwiftUI
import SwipeableView
import AVFoundation


struct Example {
    static var leftActions = [
        Action(title: "Номер 1", iconName: "pencil", bgColor: .black, action: {}),
        Action(title: "Номер 2", iconName: "doc.text", bgColor: .green, action: {}),
        Action(title: "Номер 3", iconName: "doc.text.fill", bgColor: .blue, action: {}),
    ]
    static var rightActions = [
        Action(title: "Delete", iconName: "trash", bgColor: .red, action: {})
    ]
}

class PlayViewModel {
    private var audioPlayer: AVAudioPlayer!
    func play() {
        let sound = Bundle.main.path(forResource: "Burkit", ofType: "mp3")
        self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        self.audioPlayer.play()
    }
}

var player: AVAudioPlayer?


struct PressedButtonStyle: ButtonStyle {
    let touchDown: () -> ()
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.gray : Color.blue)
            .background(configuration.isPressed ? self.handlePressed() : Color.clear)
    }

    private func handlePressed() -> Color {
        touchDown()
        return Color.clear
    }
}


struct ContentView: View {
    @State private var pressed = false

    var container = SwManager()
    let vm = PlayViewModel()


    var body: some View {
        NavigationView {
        GeometryReader { reader in
            ScrollView {
                VStack (alignment: .center, spacing: 10){
                    Spacer()
                    SwipeableView(content: {
                        Text("Swipe to see actions")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.gray)

                    },
                    leftActions: Example.leftActions,
                    rightActions: Example.rightActions,
                    rounded: false)
                    .frame(height: 90)
                    .onLongPressGesture(minimumDuration: 100.0, maximumDistance: .infinity, pressing: { pressing in
                                        self.pressed = pressing
                                        if pressing {
                                            self.vm.play()
                                            print("My pressed starts")
                                        } else {
                                            print("My pressed ends")
                                        }
                    }, perform: {})
                }.padding()
            }
        }
        .navigationTitle("SwipeApp by Ryan")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
