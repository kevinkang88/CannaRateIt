//
//  ImageViewContainer.swift
//  CannaRateIt
//
//  Created by Dong Kang on 9/23/19.
//  Copyright © 2019 Yooniverse. All rights reserved.
//

import Foundation
import SwiftUI

struct ImageView: View {
    @ObservedObject var imageLoader: ImageLoader
    @State var image: UIImage = UIImage()

    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }

    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
				.clipped()
				.background(Color.white)
        }.onReceive(imageLoader.didChange) { data in
            self.image = UIImage(data: data) ?? UIImage()
        }
    }
}
