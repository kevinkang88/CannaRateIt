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
				Text("sign out")
			}
		}
        
    }
	
	private func signout() {
		do {
			try Auth.auth().signOut()
			self.showProfileView = false
		} catch {
			print("yo man..")
		}
	}
}
//
//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
