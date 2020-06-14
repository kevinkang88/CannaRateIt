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
	
    @State var showsAlert = false
	
	init(product: Product) {
		self.product = product
	}
	
    var body: some View {
		ZStack(alignment: .top) {
			VStack {
				ZStack(alignment: .topLeading) {
					ImageView(withURL: "products/\(product.id ?? "").jpeg").frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.8, alignment: .center)
								.edgesIgnoringSafeArea(.top)
					
					HStack {
						Button(action: {
							 self.presentation.wrappedValue.dismiss()
						}) {
							Image("back-icon").renderingMode(.template).resizable().frame(width: 50, height: 50, alignment: .center).foregroundColor(Color.black)
						}
						Spacer()
						Button(action: {
							 self.showsAlert = true
						}) {
							Image("viewmore-icon").renderingMode(.template).resizable().frame(width: 50, height: 50, alignment: .center).foregroundColor(Color.black)
						}
					}.padding(.horizontal)
					
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
						Text(String(format: "%.2f", self.product.averageRating)).font(Font.custom("AirbnbCerealApp-Medium", size: 14.0)).foregroundColor(Color.white)
					}.padding(.all, 8.0).background(Color.orange).cornerRadius(10.0, corners: .allCorners)
					
					Spacer()
				}.padding(.leading)
				
				// add rating images here
				
				VStack(spacing: 20.0) {
					Group {
						BarGraph(titleLabel: "Happy", valueRatio: self.viewModel.averageHappyRating / 5.0, color: "Green")
						BarGraph(titleLabel: "Euphoric", valueRatio: self.viewModel.averageEuphoricRating / 5.0, color: "Green")
						BarGraph(titleLabel: "Relaxed", valueRatio: self.viewModel.averageRelaxedRating / 5.0, color: "Green")
						BarGraph(titleLabel: "Uplifted", valueRatio: self.viewModel.averageUpliftedRating / 5.0, color: "Green")
						BarGraph(titleLabel: "Creative", valueRatio: self.viewModel.averageCreativeRating / 5.0, color: "Green")
					}
					Group {
						BarGraph(titleLabel: "Stress", valueRatio: self.viewModel.averageStressRating / 5.0, color: "Green")
						BarGraph(titleLabel: "Anxiety", valueRatio: self.viewModel.averageAnxietyRating / 5.0, color: "Green")
						BarGraph(titleLabel: "Depression", valueRatio: self.viewModel.averageDepressionRating / 5.0, color: "Green")
						BarGraph(titleLabel: "Pain", valueRatio: self.viewModel.averagePainRating / 5.0, color: "Green")
						BarGraph(titleLabel: "Insomnia", valueRatio: self.viewModel.averageInsomniaRating / 5.0, color: "Green")
					}
					Group {
						BarGraph(titleLabel: "Dry mouth", valueRatio: self.viewModel.averageDrymouthRating / 5.0, color: "Red")
						BarGraph(titleLabel: "Dry eyes", valueRatio: self.viewModel.averageDryeyesRating / 5.0, color: "Red")
						BarGraph(titleLabel: "Paranoid", valueRatio: self.viewModel.averageParanoidRating / 5.0, color: "Red")
						BarGraph(titleLabel: "Dizzy", valueRatio: self.viewModel.averageDizzyRating / 5.0, color: "Red")
						BarGraph(titleLabel: "Anxious", valueRatio: self.viewModel.averageAnxiousRating / 5.0, color: "Red")
					}
				}.padding()
				
				HStack {
					Text("Reviews").font(Font.custom("AirbnbCerealApp-Medium", size: 20.0)).foregroundColor(Color.black).padding(.leading).padding(.top)
					Button(action: {
						self.viewModel.attemptAddReview = true
					}) {
						Image("plus").resizable().renderingMode(.template).frame(width: 30.0, height: 30.0).foregroundColor(Color.black).padding(.top)
					}.sheet(isPresented: self.$viewModel.showAddReviewView) {
						AddReview(productID: self.product.id ?? "", dataStore: AddReviewFormDataStore.shared, isVisible: self.$viewModel.showAddReviewView)
					}
					
					Spacer()
				}
				
				VStack(alignment: .leading) {
					ForEach(self.viewModel.reviewComments, id: \.self) { review in
						HStack {
							ZStack {
								Image("anon-user").renderingMode(.template).resizable().frame(width: 30.0, height: 30.0).foregroundColor(Color.gray.opacity(0.3))
							}.frame(width: 44.0, height: 44.0).background(Color.gray.opacity(0.2)).cornerRadius(22).padding(.horizontal)
							Text(review.reviewText).font(Font.custom("AirbnbCerealApp-Medium", size: 14.0)).lineLimit(nil)
							.foregroundColor(Color.black)
							Spacer()
							Image("viewmorecell-icon").renderingMode(.template).resizable().scaledToFit().frame(width: 20.0, height: 20.0).foregroundColor(Color.black.opacity(0.8)).onTapGesture {
								self.showsAlert = true
							}.padding(.trailing)
						}.padding(.vertical)
					}
				}
				
				Spacer()
			}.background(Color.white).frame(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height / 2) + 80).cornerRadius(30.0, corners: .allCorners).offset(y: (UIScreen.main.bounds.height / 2) - 80).zIndex(99)
			
			
		}.navigationBarTitle("")
		.navigationBarHidden(true)
		.navigationBarBackButtonHidden(true)
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
					let averageRating = doc.document.data()["averageRating"] as! Float
					let anxietyRating = doc.document.data()["anxietyRating"] as! Float
					let anxiousRating = doc.document.data()["anxiousRating"] as! Float
					let creativeRating = doc.document.data()["creativeRating"] as! Float
					let depressionRating = doc.document.data()["depressionRating"] as! Float
					let dizzyRating = doc.document.data()["dizzyRating"] as! Float
					let dryeyesRating = doc.document.data()["dryeyesRating"] as! Float
					let drymouthRating = doc.document.data()["drymouthRating"] as! Float
					let euphoricRating = doc.document.data()["euphoricRating"] as! Float
					let happyRating = doc.document.data()["happyRating"] as! Float
					let insomniaRating = doc.document.data()["insomniaRating"] as! Float
					let painRating = doc.document.data()["painRating"] as! Float
					let paranoidRating = doc.document.data()["paranoidRating"] as! Float
					let relaxedRating = doc.document.data()["relaxedRating"] as! Float
					let stressRating = doc.document.data()["stressRating"] as! Float
					let upliftedRating = doc.document.data()["upliftedRating"] as! Float
					let isProductCreator = doc.document.data()["isProductCreator"] as! Bool
					let lastUpdated = (doc.document.data()["lastUpdated"] as! Timestamp).dateValue() as! Date
					
					reviews.append(Review(id: id, userID: userID, productID: productID, averageRating: averageRating, reviewText: reviewText, anxietyRating: anxietyRating, anxiousRating: anxiousRating, creativeRating: creativeRating, depressionRating: depressionRating, dizzyRating: dizzyRating, dryeyesRating: dryeyesRating, drymouthRating: drymouthRating, euphoricRating: euphoricRating, happyRating: happyRating,insomniaRating: insomniaRating, painRating: painRating, paranoidRating: paranoidRating, relaxedRating: relaxedRating, stressRating: stressRating, upliftedRating: upliftedRating, isProductCreator: isProductCreator, lastUpdated: lastUpdated))
				}
				
				reviews.sort(by: { $0.lastUpdated > $1.lastUpdated})
				self.viewModel.reviewComments = reviews.filter({ !$0.isProductCreator })
				self.viewModel.reviews = reviews
				 
				self.viewModel.calculateAverageRatings(reviews: reviews)
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
						Text("Sign up with Apple")
							.font(Font.system(size: 19.0))
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
		}).alert(isPresented: self.$showsAlert) {
			Alert(title: Text("Report this content?"), message: Text(""), primaryButton: .default(Text("Report")), secondaryButton: .cancel())
		}
		
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
	
	@Published var reviewComments = [Review]()
	
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
	
	//
	
	@Published var averageAnxietyRating: Float = 0.0
	@Published var averageAnxiousRating: Float = 0.0
	@Published var averageCreativeRating: Float = 0.0
	@Published var averageDepressionRating: Float = 0.0
	@Published var averageDizzyRating: Float = 0.0
	@Published var averageDryeyesRating: Float = 0.0
	@Published var averageDrymouthRating: Float = 0.0
	@Published var averageEuphoricRating: Float = 0.0
	@Published var averageHappyRating: Float = 0.0
	@Published var averageInsomniaRating: Float = 0.0
	@Published var averagePainRating: Float = 0.0
	@Published var averageParanoidRating: Float = 0.0
	@Published var averageRelaxedRating: Float = 0.0
	@Published var averageStressRating: Float = 0.0
	@Published var averageUpliftedRating: Float = 0.0
	
	func calculateAverageRatings(reviews: [Review]) {
		var totalAnxietyRating: Float = 0.0
		var totalAnxiousRating: Float = 0.0
		var totalCreativeRating: Float = 0.0
		var totalDepressionRating: Float = 0.0
		var totalDizzyRating: Float = 0.0
		var totalDryeyesRating: Float = 0.0
		var totalDrymouthRating: Float = 0.0
		var totalEuphoricRating: Float = 0.0
		var totalHappyRating: Float = 0.0
		var totalInsomniaRating: Float = 0.0
		var totalPainRating: Float = 0.0
		var totalParanoidRating: Float = 0.0
		var totalRelaxedRating: Float = 0.0
		var totalStressRating: Float = 0.0
		var totalUpliftedRating: Float = 0.0
		
		for review in self.reviews {
			totalAnxietyRating += review.anxietyRating
			totalAnxiousRating += review.anxiousRating
			totalCreativeRating += review.creativeRating
			totalDepressionRating += review.depressionRating
			totalDizzyRating += review.dizzyRating
			totalDryeyesRating += review.dryeyesRating
			totalDrymouthRating += review.drymouthRating
			totalEuphoricRating += review.euphoricRating
			totalHappyRating += review.happyRating
			totalInsomniaRating += review.insomniaRating
			totalPainRating += review.painRating
			totalParanoidRating += review.paranoidRating
			totalRelaxedRating += review.relaxedRating
			totalStressRating += review.stressRating
			totalUpliftedRating += review.upliftedRating
		}
		
		averageAnxietyRating = totalAnxietyRating / Float(reviews.count)
		averageAnxiousRating = totalAnxiousRating / Float(reviews.count)
		averageCreativeRating = totalCreativeRating / Float(reviews.count)
		averageDepressionRating = totalDepressionRating / Float(reviews.count)
		averageDizzyRating = totalDizzyRating / Float(reviews.count)
		averageDryeyesRating = totalDryeyesRating / Float(reviews.count)
		averageDrymouthRating = totalDrymouthRating / Float(reviews.count)
		averageEuphoricRating = totalEuphoricRating / Float(reviews.count)
		averageHappyRating = totalHappyRating / Float(reviews.count)
		averageInsomniaRating = totalInsomniaRating / Float(reviews.count)
		averagePainRating = totalPainRating / Float(reviews.count)
		averageParanoidRating = totalParanoidRating / Float(reviews.count)
		averageRelaxedRating = totalRelaxedRating / Float(reviews.count)
		averageStressRating = totalStressRating / Float(reviews.count)
		averageUpliftedRating = totalUpliftedRating / Float(reviews.count)
	}
}
