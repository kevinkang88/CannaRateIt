//
//  searchSheet.swift
//  CRI
//
//  Created by Dong Kang on 4/15/20.
//  Copyright © 2020 Yooniverse. All rights reserved.
//

import SwiftUI

extension View {

	public func showSearchSheet<SheetContent: View>(
		presented: Binding<Bool>,
		view: @escaping () -> SheetContent ) -> some View {
		
		self.modifier(
			SearchSheet(
				view:view,
				presented: presented
			)
		)
	}
}
