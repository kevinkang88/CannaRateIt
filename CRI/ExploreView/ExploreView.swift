//
//  ContentView.swift
//  CRI
//
//  Created by Dong Kang on 3/18/20.
//  Copyright © 2020 Yooniverse. All rights reserved.
//

import SwiftUI
import CryptoKit
import Foundation
import AuthenticationServices

import Firebase
import FirebaseStorage
import PartialSheet
import GoogleSignIn
import Fuzzy

struct ExploreView: View {
	
    @ObservedObject var selectedCategoryStore = SelectedCategoryStore()
	
    @ObservedObject var viewModel = ExploreViewModel()
	
	@State var showAddProductSheet = false
	
	@State var shiftUpSearchBar = false
	
	@State var searchBarOffset: CGFloat = 0.0
					
	var socialLogin = SocialLogin()
	
		
	init() {
		// To remove only extra separators below the list:
		UITableView.appearance().tableFooterView = UIView()

		// To remove all separators including the actual ones:
		UITableView.appearance().separatorStyle = .none
	}
				
    var body: some View {
		NavigationView {
			ZStack(alignment: .bottom) {
				
				VStack(alignment: .leading) {

					if self.shiftUpSearchBar {

						VStack(alignment: .center) {
							HStack {
								Text("Search something").foregroundColor(Color.gray.opacity(0.5)).frame(height: 65.0, alignment: .leading).padding()
								Spacer()
								VStack {
									Image("search").renderingMode(.template).resizable().frame(width: 20, height: 20).foregroundColor(Color.white).padding()
								}.frame(width: 65, height: 65).background(Color("Blue"))
							}.frame(width: UIScreen.main.bounds.width - 30.0, height: 65).background(Color.gray.opacity(0.2)).cornerRadius(15).offset(y: self.searchBarOffset)
						}.padding(.horizontal, 15.0).onTapGesture {
							withAnimation(.easeIn) {
								self.shiftUpSearchBar = false
							}
						}.padding(.top, 40.0)
						
						HStack {
							Spacer()
							Button(action: {
								self.viewModel.attemptToShowProfileView = true
							}) {
								ZStack {
									Image("anon-user").renderingMode(.template).resizable().frame(width: 30.0, height: 30.0).foregroundColor(Color.gray.opacity(0.3))
									}.frame(width: 44.0, height: 44.0).background(Color.gray.opacity(0.2)).cornerRadius(22).padding(.trailing)
							}
						}
						
						VStack(alignment: .leading) {
							Text("Explore").font(Font.custom("AirbnbCerealApp-ExtraBold", size: 26.0))
							Text("CBD Products!").font(Font.custom("AirbnbCerealApp-Black", size: 26.0))
						}.padding(.horizontal).zIndex(1.0)
						
					} else {
						
						HStack {
							Spacer()
							Button(action: {
								self.viewModel.attemptToShowProfileView = true
							}) {
								ZStack {
									Image("anon-user").renderingMode(.template).resizable().frame(width: 30.0, height: 30.0).foregroundColor(Color.gray.opacity(0.3))
									}.frame(width: 44.0, height: 44.0).background(Color.gray.opacity(0.2)).cornerRadius(22).padding(.trailing)
							}
						}.padding(.top, 40.0)
						
						VStack(alignment: .leading) {
							Text("Explore").font(Font.custom("AirbnbCerealApp-ExtraBold", size: 26.0))
							Text("CBD Products!").font(Font.custom("AirbnbCerealApp-Black", size: 26.0))
						}.padding(.horizontal).zIndex(1.0)
						
						VStack(alignment: .center) {
							HStack {
								Text("Search something").foregroundColor(Color.gray.opacity(0.5)).frame(height: 65.0, alignment: .leading).padding()
								Spacer()
								VStack {
									Image("search").renderingMode(.template).resizable().frame(width: 20, height: 20).foregroundColor(Color.white).padding()
								}.frame(width: 65, height: 65).background(Color("Blue"))
							}.frame(width: UIScreen.main.bounds.width - 30.0, height: 65).background(Color.gray.opacity(0.2)).cornerRadius(15).offset(y: self.searchBarOffset)
						}.padding(.horizontal, 15.0).onTapGesture {
							withAnimation(.easeIn) {
								self.shiftUpSearchBar = true
							}
						}
					}

					
					Spacer().frame(height: 1)
					
					VStack(alignment: .leading) {
						CategoryPickerView(selectedCategory: $selectedCategoryStore.selectedCategory).padding().padding(.horizontal, 4.0)
									
						List {
							ForEach(self.selectedCategoryStore.sections, id: \.self) { section in
								Section(header: HStack {
									Text("\(section)".capitalized)
										.font(Font.custom("AirbnbCerealApp-Black", size: 22.0))
										.foregroundColor(.black)
										.padding()
										Spacer()
									}.background(Color.white).listRowInsets(EdgeInsets(top: 0,leading: 0,bottom: 0,trailing: 0))
								) {
									ScrollView(.horizontal, showsIndicators: false) {
										HStack(alignment: .center, spacing: 25.0) {
											ForEach(self.selectedCategoryStore.rows(section: section), id: \.id) { product in
												NavigationLink(destination: ProductDetailView(product: product)) {
													ProductCardCell(product: product).frame(width: 160, height: 230, alignment: .center)
												}.buttonStyle(PlainButtonStyle())
											}
										}.frame(height: 230)
									}
								}
							}
						}
					}
						
					Spacer(minLength: 11)
				}
			
				
				Button(action: {
					self.viewModel.attemptToAddProduct = true
				}) {
					Image("plus").resizable().renderingMode(.template).foregroundColor(Color("Blue"))
				}.frame(width: 60, height: 60, alignment: .center).padding().sheet(isPresented: self.$viewModel.showAddProductView) {
					AddProductView()
				}
				
			}.onAppear {
				self.selectedCategoryStore.selectedCategory = "edible"
				}.edgesIgnoringSafeArea(.all).navigationBarHidden(true)
				.navigationBarItems(trailing:
			Button(action: {
				print("showing profile")
			}) {
				ZStack {
					Image("anon-user").renderingMode(.template).resizable().frame(width: 30.0, height: 30.0).foregroundColor(Color.gray.opacity(0.3))
					}.frame(width: 44.0, height: 44.0).background(Color.gray.opacity(0.2)).cornerRadius(22).padding(.trailing)
			}
			)
		}.partialSheet(presented: self.$viewModel.showAuthView, backgroundColor: Color("Blue"), handlerBarColor: Color.white, enableCover: true, coverColor: Color.black.opacity(0.8), view: {
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
		}).showSearchSheet(presented: self.$shiftUpSearchBar) {
			VStack {
				VStack {
					HStack {
						CustomTextField(text: self.$viewModel.searchedText, isFirstResponder: true).padding()
						Spacer()
						VStack {
							Image("search").renderingMode(.template).resizable().frame(width: 20, height: 20).foregroundColor(Color.white).padding()
						}.onTapGesture {
							self.viewModel.search(searchQuery: self.viewModel.searchedText)
						}.frame(width: 65, height: 65).background(Color("Blue"))
					}.frame(width: UIScreen.main.bounds.width - 30.0, height: 65).background(Color.gray.opacity(0.2)).cornerRadius(15).offset(y: self.searchBarOffset)
				}.padding(.horizontal, 15.0)
				
				Spacer().frame(height: 20)
				
				VStack(alignment: .leading) {
					ForEach(self.$viewModel.searchResults.wrappedValue, id: \.self) { product in
						VStack {
							HStack {
								Text(product.name.capitalized)
									.font(Font.custom("AirbnbCerealApp-Medium", size: 14.0))
									.foregroundColor(Color.white)
									.padding()
								Text("•")
									.foregroundColor(Color.white)

								Text(product.brand.capitalized)
									.font(Font.custom("AirbnbCerealApp-Medium", size: 14.0))
									.foregroundColor(Color.white)
									.padding()
								Spacer()
							}
						
						}.padding(.horizontal)
						
					}
				}
				
				Spacer()
			}
			
		}.sheet(isPresented: self.$viewModel.showProfileView) {
			ProfileView(showProfileView: self.$viewModel.showProfileView)
		}
	}
}

// make an object that listens for change of selectedCategory
class SelectedCategoryStore: ObservableObject {
	
	@Published var selectedCategory: String = "edible" {
		didSet {
			self.fetchProductsFromFirebase(selectedCategory: selectedCategory)
		}
	}
	
	@Published var loadedProducts: [String: [Product]] = [:]
	
	var sections: [String] { loadedProducts.keys.map { $0 }.sorted { firstString, secondString -> Bool in
			return firstString == "trending"
		}}
	
    func rows(section: Int) -> [Product] { loadedProducts[sections[section]]! }
	
	func rows(section: String) -> [Product] { loadedProducts[section]!}

	private func fetchProductsFromFirebase(selectedCategory: String) {
		var products = [Product]()
		let query = Firestore.firestore().collection("products").whereField("category", isEqualTo: self.selectedCategory)
		query.getDocuments { snap, err in
			if err != nil {
                print((err?.localizedDescription)!)
				return
			}
			
			for doc in (snap?.documentChanges)! {
				let id = doc.document.documentID
                let name = doc.document.data()["name"] as! String
                let brand = doc.document.data()["brand"] as! String
				let category = Product.Category(rawValue: doc.document.data()["category"] as! String) as! Product.Category
				let mainIngredient = Product.MainIngredient(rawValue: doc.document.data()["mainIngredient"] as! String) as! Product.MainIngredient
				let isTrending = doc.document.data()["isTrending"] as! Bool
				let averageRating = doc.document.data()["averageRating"] as! Float
				let updatedDate = (doc.document.data()["lastUpdated"] as! Timestamp).dateValue() as! Date
				
				products.append(Product(id: id, name: name, brand: brand, category: category, mainIngredient: mainIngredient, isTrending: isTrending, averageRating: averageRating, lastUpdated: updatedDate))
			}
						
			let trendingProducts = products.filter { product -> Bool in
				return product.isTrending
			}
			
			var result = ["trending": trendingProducts]
			
			let byLastUpdatedProducts = products.sorted { (product1, product2) -> Bool in
				return product1.lastUpdated ?? Date() > product2.lastUpdated ?? Date()
			}
			
			result["latest"] = byLastUpdatedProducts
			
			self.loadedProducts = result
		}
	}
}

class ExploreViewModel: NSObject, ObservableObject, GIDSignInDelegate {
	
	override init() {
		super.init()
		GIDSignIn.sharedInstance()?.delegate = self
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
	
	@Published var tappedAppleSignInButton = false {
		didSet {
			if tappedAppleSignInButton == true {
				self.showAppleLogin()
			}
		}
	}
	
	@Published var attemptToShowProfileView = false {
		didSet {
			if Auth.auth().currentUser != nil && attemptToShowProfileView == true {
				self.showProfileView = true
			} else {
				self.showAuthView = true
			}
		}
	}
	
	@Published var attemptToAddProduct = false {
		didSet {
			if Auth.auth().currentUser != nil && attemptToAddProduct == true {
				self.showAddProductView = true
			} else {
				self.showAuthView = true
			}
		}
	}
	
	@Published var showAddProductView: Bool = false
		
	@Published var showProfileView: Bool = false
	@Published var showAuthView: Bool = false
	
	// Search
	@Published var searchedText: String = ""
	@Published var searchResults = [Product]()
	
	func search(searchQuery: String) {
		var products = [Product]()
		let query = Firestore.firestore().collection("products")
			query.getDocuments { snap, err in
				if err != nil {
					print((err?.localizedDescription)!)
					return
				}
				
				for doc in (snap?.documentChanges)! {
					let id = doc.document.documentID
					let name = doc.document.data()["name"] as! String
					let brand = doc.document.data()["brand"] as! String
					let category = Product.Category(rawValue: doc.document.data()["category"] as! String) as! Product.Category
					let mainIngredient = Product.MainIngredient(rawValue: doc.document.data()["mainIngredient"] as! String) as! Product.MainIngredient
					let isTrending = doc.document.data()["isTrending"] as! Bool
					let averageRating = doc.document.data()["averageRating"] as! Float
					let updatedDate = (doc.document.data()["lastUpdated"] as! Timestamp).dateValue() as! Date
					
					products.append(Product(id: id, name: name, brand: brand, category: category, mainIngredient: mainIngredient, isTrending: isTrending, averageRating: averageRating, lastUpdated: updatedDate))
				}
				
				var matchedProducts = [Product]()
				for product in products {
					if Fuzzy.search(needle: searchQuery, haystack: "\(product.brand) \(product.name)") {
						matchedProducts.append(product)
					}
				}

				
				self.searchResults = matchedProducts
				
			}
	}
	
	//
	
    private var appleSignInDelegates: SignInWithAppleDelegates! = nil
	
    private var currentNonce: String? = nil
    private let onLoginEvent: ((SignInWithAppleToFirebaseResponse) -> ())? = nil

    private func showAppleLogin() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        performSignIn(using: [request])
    }

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
	
	 func search() {
		// get the current text and make sure it is not empty
		// setup elastic search for Products in Firestore
	}
}

struct SocialLogin: UIViewRepresentable {

    func makeUIView(context: UIViewRepresentableContext<SocialLogin>) -> UIView {
        return UIView()
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<SocialLogin>) {
    }

    func attemptLoginGoogle() {
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        GIDSignIn.sharedInstance()?.signIn()
    }
}

class SignInWithAppleDelegates: NSObject {
    private let onLoginEvent: ((SignInWithAppleToFirebaseResponse) -> ())?
    private weak var window: UIWindow!
    private var currentNonce: String? // Unhashed nonce.

    init(window: UIWindow?, currentNonce: String, onLoginEvent: ((SignInWithAppleToFirebaseResponse) -> ())? = nil) {
        self.window = window
        self.currentNonce = currentNonce
        self.onLoginEvent = onLoginEvent
    }
}

extension SignInWithAppleDelegates: ASAuthorizationControllerDelegate {
    func firebaseLogin(credential: ASAuthorizationAppleIDCredential) {
        // 3
        guard let nonce = currentNonce else {
          fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = credential.identityToken else {
          print("Unable to fetch identity token")
          return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
          print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
          return
        }
        // Initialize a Firebase credential.
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
        // Sign in with Firebase.
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if (error != nil) {
                // Error. If error.code == .MissingOrInvalidNonce, make sure
                // you're sending the SHA256-hashed nonce as a hex string with
                // your request to Apple.
                print(error?.localizedDescription)
                self.onLoginEvent?(.error)
                return
            }
            // User is signed in to Firebase with Apple.
            print("you're in")
            self.onLoginEvent?(.success)
        }
    }
    private func registerNewAccount(credential: ASAuthorizationAppleIDCredential) {
        // 1
        let userData = UserData(email: credential.email!,
                                name: credential.fullName!,
                                identifier: credential.user)

        // 2
        let keychain = UserDataKeychain()
        do {
            try keychain.store(userData)
        } catch {
            
        }
        
        // 3
        firebaseLogin(credential: credential)
    }

    private func signInWithExistingAccount(credential: ASAuthorizationAppleIDCredential) {
        self.firebaseLogin(credential: credential)
    }


    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:
            if let _ = appleIdCredential.email, let _ = appleIdCredential.fullName {
                registerNewAccount(credential: appleIdCredential)
            } else {
                signInWithExistingAccount(credential: appleIdCredential)
            }
            break
        default:
            break
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.onLoginEvent?(.error)
    }
}

