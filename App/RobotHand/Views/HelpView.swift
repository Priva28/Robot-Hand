//
//  HelpView.swift
//  RobotHand
//
//  Created by Christian on 7/3/20.
//  Copyright © 2020 Christian. All rights reserved.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(Color.init(red: 0.8, green: 0.8, blue: 0.8))
                .cornerRadius(10)
                .overlay(VStack(alignment: .leading) {
                    Text("Manual Control")
                        .font(.title)
                        .bold()
                        .padding(.leading, 10)
                    Text("Manual control gives you complete control over the whole robot hand with fine controls that allow you to set and save custom positions. Start using this mode by going to the main screen and tapping the 'Manual Control' button.")
                        .padding(10)
                })
                .frame(height: 200)
                .padding(10)
            Rectangle()
                .foregroundColor(Color.init(red: 0.8, green: 0.8, blue: 0.8))
                .cornerRadius(10)
                .overlay(VStack(alignment: .leading) {
                    Text("AR Control")
                        .font(.title)
                        .bold()
                        .padding(.leading, 10)
                    Text("AR control gives you the ability to point your devices camera at your own hand and use common gestures to control the robot hand. Current gestures include, 'Fist', 'Open Hand', 'Peace/V', 'Thumbs Up'. This mode is experimental. To start using this mode, go to the main screen and tap the 'AR Control' button.")
                        .padding(10)
                })
                .frame(height: 230)
                .padding(10)
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
