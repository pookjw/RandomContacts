//
//  ContentViewModel.swift
//  RandomContacts
//
//  Created by Jinwoo Kim on 1/6/21.
//

import Foundation
import Combine
import Contacts

final class ContentViewModel: ObservableObject {
    @Published public var countToSave: String = "10"
    @Published public var regionCode: String = "1"
    @Published public var startingNumberWith: String = ""
    @Published public var digits: String = "10"
    @Published public var nameLangType: Int = 0 // RawValue of ContentViewModel.LangType
    @Published public var isPresetSheetPresented: Bool = false
    @Published public var isResultAlertPresented: Bool = false
    
    public var error: Swift.Error? = nil
    
    public enum Error: Swift.Error, LocalizedError {
        case inputError
        
        public var errorDescription: String? {
            switch self {
            case .inputError:
                return "Invalid count or digits!"
            }
        }
    }
    
    public enum LangType: Int, CaseIterable {
        case english = 0
        case korean
    }
    
    public func setPreset(of type: LangType) {
        switch type {
        case .english:
            regionCode = "1"
            startingNumberWith = ""
            digits = "10"
            nameLangType = 0
        case .korean:
            regionCode = "82"
            startingNumberWith = "10"
            digits = "10"
            nameLangType = 1
        }
    }
    
    public func saveContacts() throws {
        let saveRequest: CNSaveRequest = .init()
        guard let countToSave = Int(countToSave),
              let digits = Int(digits)
        else {
            throw Error.inputError
        }
        
        (0..<countToSave).forEach { _ in
            let randomGivenName: String
            let randomFamilyName: String
            
            switch LangType(rawValue: nameLangType) {
            case .english:
                randomGivenName = String.randomEnglish(digits: 5)
                randomFamilyName = String.randomEnglish(digits: 8)
            case .korean:
                randomGivenName = String.randomHangul(digits: 1)
                randomFamilyName = String.randomHangul(digits: 2)
            default:
                randomGivenName = String.randomEnglish(digits: 5)
                randomFamilyName = String.randomEnglish(digits: 8)
            }
            
            
            let randomNumber: String = {
                let region: String = regionCode.isEmpty ? "" : "+\(regionCode)"
                let result: String = "\(region) \(startingNumberWith) "
                let randomDigits: Int = digits - startingNumberWith.count
                
                guard randomDigits > 0 else { return result }
                return result + String.ramdomInt(digits: randomDigits)
            }()
            
            let contact = CNMutableContact()
            contact.givenName = randomGivenName
            contact.familyName = randomFamilyName
            contact.nickname = "RandomContacts"
            contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: randomNumber))]
            saveRequest.add(contact, toContainerWithIdentifier: nil)
        }
        
        try CNContactStore().execute(saveRequest)
    }
    
    public func deleteContacts() throws {
        let contactStore: CNContactStore = .init()
        let keysToFetch: [CNKeyDescriptor] = [CNContactNicknameKey as CNKeyDescriptor]
        let containers: [CNContainer] = try contactStore.containers(matching: nil)
        let saveRequest: CNSaveRequest = .init()
        
        for container in containers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            let contacts = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch)
            
            contacts.forEach { contact in
                if let mutableContact = contact.mutableCopy() as? CNMutableContact,
                   mutableContact.nickname == "RandomContacts" {
                    saveRequest.delete(mutableContact)
                }
            }
        }
        
        try contactStore.execute(saveRequest)
    }
}
