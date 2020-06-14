//
//  ProfileView.swift
//  CRI
//
//  Created by Dong Kang on 4/12/20.
//  Copyright © 2020 Yooniverse. All rights reserved.
//

import SwiftUI

import Firebase

struct ProfileView: View {
	
	@Binding var showProfileView: Bool
		
	@State var signOutTriggered: Bool = false {
		didSet {
			if signOutTriggered == true {
				self.signout()
			}
		}
	}
	
    var body: some View {
		VStack {
			Button(action: {
				self.signOutTriggered = true
			}) {
                HStack {
                    Text("Sign out")
                        .font(Font.custom("AirbnbCerealApp-Medium", size: 16.0))
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
				.background(Color.red.opacity(0.7))
                .cornerRadius(20)
                .padding(.horizontal, 20)			}
		}
        
    }
	
	private func signout() {
		do {
			self.showProfileView = false
			try Auth.auth().signOut()
		} catch {
			print("yo man..")
		}
	}
}
