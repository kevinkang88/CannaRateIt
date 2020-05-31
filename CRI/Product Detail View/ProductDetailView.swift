//
//  ProductDetailView.swift
//  CRI
//
//  Created by Dong Kang on 5/9/20.
//  Copyright © 2020 Yooniverse. All rights reserved.
//

import SwiftUI
import CryptoKit
import AuthenticationServices

import Firebase
import FirebaseStorage
import PartialSheet
import GoogleSignIn

struct ProductDetailView: View {
	
	var product: Product
	
	var socialLogin = SocialLogin()
		
    @Environment(\.presentationMode) private var presentation
		
	@ObservedObject var viewModel: ProductDetailViewModel = ProductDetailViewModel()
	
	init(product: Product) {
		self.product = product
	}
	
    var body: some View {
		ZStack(alignment: .top) {
			VStack {
				ZStack(alignment: .topLeading) {
					ImageView(withURL: "products/\(product.id ?? "").jpeg").frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.8, alignment: .center)
								.edgesIgnoringSafeArea(.top)
					
					Button(action: {
						 self.presentation.wrappedValue.dismiss()
					}) {
						Image("back-icon").renderingMode(.template).resizable().frame(width: 50, height: 50, alignment: .center).foregroundColor(Color.black)
					}.offset(y: 30.0)
				}
				
				Spacer()
			}
			
			
			ScrollView {
				
				Spacer().frame(height: 20.0)
				
				HStack {
					Text(product.name).font(Font.custom("AirbnbCerealApp-Medium", size: 20.0))
						.foregroundColor(Color.black).padding(.leading).padding(.top)
					Spacer()
				}
				
				HStack {
					Text(product.brand).font(Font.custom("AirbnbCerealApp-Light", size: 16.0))
						.foregroundColor(Color.gray).padding(.leading)
					
					Image("approval-icon").renderingMode(.template).resizable().aspectRatio(contentMode: .fit).frame(width: 20, height: 20).foregroundColor(Color.green)
					Spacer()
				}
				
				Divider().padding()
				
				HStack {
					HStack {
						Image("star").resizable().renderingMode(.template).frame(width: 16, height: 16, alignment: .center).foregroundColor(.white)
						Text("4.0").font(Font.custom("AirbnbCerealApp-Medium", size: 14.0)).foregroundColor(Color.white)
					}.padding(.all, 8.0).background(Color.orange).cornerRadius(10.0, corners: .allCorners)
					
					Spacer()
				}.padding(.leading)
				
				HStack {
					Text("Reviews").font(Font.custom("AirbnbCerealApp-Medium", size: 24.0)).foregroundColor(Color.black).padding(.leading).padding(.top)
					Button(action: {
						self.viewModel.attemptAddReview = true
					}) {
						Image("plus").resizable().renderingMode(.template).frame(width: 30.0, height: 30.0).foregroundColor(Color.black).padding(.top)
					}.sheet(isPresented: self.$viewModel.showAddReviewView) {
						AddReview(productID: self.product.id ?? "", dataStore: AddReviewFormDataStore.shared, isVisible: self.$viewModel.showAddReviewView)
					}
					
					Spacer()
				}
				
				VStack {
					ForEach(self.viewModel.reviews, id: \.self) { review in
						HStack {
							Image("anon-user")
							Text(review.reviewText)
						}
					}
				}
				
				Spacer()
			}.background(Color.white).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2).cornerRadius(30.0, corners: .allCorners).offset(y: UIScreen.main.bounds.height / 2.5)
			
			
		}.navigationBarTitle("") //this must be empty
		.navigationBarHidden(true)
		.navigationBarBackButtonHidden(true).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
		.onAppear(perform: {
			var reviews = [Review]()
			let query = Firestore.firestore().collection("reviews").whereField("productID", isEqualTo: self.product.id)
			
			query.getDocuments { snap, err in
				if err != nil {
					print(err?.localizedDescription)
					return
				}
				
				for doc in (snap?.documentChanges)! {
					let id = doc.document.documentID
					let productID = doc.document.data()["productID"] as! String
					let userID = doc.document.data()["userID"] as! String
					let reviewText = doc.document.data()["reviewText"] as! String
					let rating = doc.document.data()["rating"] as! Float
					
					reviews.append(Review(id: id, userID: userID, productID: productID, rating: rating, reviewText: reviewText))
				}
				
				self.viewModel.reviews = reviews
			}
		})
		.partialSheet(presented: self.$viewModel.showAuthView, backgroundColor: Color("OceanBlue"), handlerBarColor: Color.white, enableCover: true, coverColor: Color.black.opacity(0.8), view: {
			VStack {
				
				Button(action: {
					self.viewModel.tappedAppleSignInButton = true
					self.viewModel.tappedAppleSignInButton = false
					self.viewModel.showAuthView = false
					print("apple sign in tapped")
				}) {
					HStack {
						Image("apple-icon").renderingMode(.original).resizable().aspectRatio(contentMode: .fit).frame(width: 50, height: 50)
						Text("Sign in with Apple")
							.font(Font.custom("AirbnbCerealApp-Medium", size: 14.0))
							.foregroundColor(Color.black).padding()
					}.padding(.horizontal).padding(.vertical, 5.0).background(Color.white).cornerRadius(10.0)
				}
				
				Button(action: {
					self.viewModel.showAuthView = false
					self.socialLogin.attemptLoginGoogle()
				}) {
					HStack {
						Image("google-icon").renderingMode(.original).resizable().aspectRatio(contentMode: .fit).frame(width: 50, height: 50)
						Text("Sign in with Google")
							.font(Font.custom("AirbnbCerealApp-Medium", size: 14.0))
							.foregroundColor(Color.black).padding()
					}.padding(.horizontal).padding(.vertical, 5.0).background(Color.white).cornerRadius(10.0)
				}
			}
		})
		
	}
}

class ProductDetailViewModel: NSObject, ObservableObject, GIDSignInDelegate {
	
	override init() {
		super.init()
		GIDSignIn.sharedInstance()?.delegate = self
	}
	
	@Published var showAddReviewView = false
	
	@Published var showAuthView = false
	
	@Published var reviews = [Review]()
	
	@Published var attemptAddReview = false {
		didSet {
			if Auth.auth().currentUser != nil && attemptAddReview == true {
				self.showAddReviewView = true
			} else {
				self.showAuthView = true
			}
		}
	}
	
	@Published var tappedAppleSignInButton = false {
		didSet {
			if tappedAppleSignInButton == true {
				self.showAppleLogin()
			}
		}
	}
	
	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
		
		if let error = error {
			print(error)
			return
		}
		
		guard let authentication = user.authentication else { return }
		
		let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
														  accessToken: authentication.accessToken)
		
		Auth.auth().signIn(with: credential) { result, error in
			print(result)
		}
	}
	
    private var appleSignInDelegates: SignInWithAppleDelegates! = nil
	
    private var currentNonce: String? = nil
	
	
    private func performSignIn(using requests: [ASAuthorizationRequest]) {
        guard let currentNonce = self.currentNonce else {
            return
        }
		appleSignInDelegates = SignInWithAppleDelegates(window: nil, currentNonce: currentNonce, onLoginEvent: { response in
			if response == .success {
				self.showAuthView = false
			}
		})
		
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = appleSignInDelegates
        authorizationController.performRequests()
    }
	
    private func showAppleLogin() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        performSignIn(using: [request])
    }
	
	private func randomNonceString(length: Int = 32) -> String {
		   precondition(length > 0)
		   let charset: Array<Character> =
		   Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
		   var result = ""
		   var remainingLength = length

		   while remainingLength > 0 {
			   let randoms: [UInt8] = (0 ..< 16).map { _ in
				   var random: UInt8 = 0
				   let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
				   if errorCode != errSecSuccess {
					   fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
				   }
				   return random
			   }

			   randoms.forEach { random in
				   if length == 0 {
					   return
				   }

				   if random < charset.count {
					   result.append(charset[Int(random)])
					   remainingLength -= 1
				   }
			   }
		   }

		   return result
	   }

	private func sha256(_ input: String) -> String {
	   let inputData = Data(input.utf8)
	   let hashedData = SHA256.hash(data: inputData)
	   let hashString = hashedData.compactMap {
	   return String(format: "%02x", $0)
	   }.joined()

	   return hashString
	}
}
