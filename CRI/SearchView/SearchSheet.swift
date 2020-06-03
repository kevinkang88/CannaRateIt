//
//  SearchSheet.swift
//  CRI
//
//  Created by Dong Kang on 4/15/20.
//  Copyright © 2020 Yooniverse. All rights reserved.
//

import Foundation

import SwiftUI

/// This is the modifier for the Partial Sheet
struct SearchSheet<SheetContent>: ViewModifier where SheetContent: View {
    var view: () -> SheetContent
    @Binding var presented: Bool
	
	func body(content: Content) -> some View {
		ZStack {
			content
			
			if presented {

				Rectangle()
					.foregroundColor(Color.black.opacity(0.9))
					.edgesIgnoringSafeArea(.vertical)
					.zIndex(2.0)
					.onTapGesture {
						withAnimation(.easeIn) { 
							self.presented = false
						}
				}
	
				self.view().zIndex(4.0)
				
			}
			
		}
	}
}
