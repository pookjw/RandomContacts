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
    @Published public var numberCountFor82: String = "3"
    @Published public var numberCountFor1: String = "3"
    
    public var error: Swift.Error? = nil
    @Published public var isAlertPresented: Bool = false
    
    public enum Error: Swift.Error, LocalizedError {
        case inputError
        
        public var errorDescription: String? {
            switch self {
            case .inputError:
                return "Cannot convert input value to integer format!"
            }
        }
    }
    
    public func saveContacts() throws {
        let saveRequest: CNSaveRequest = .init()
        guard let intFor82 = Int(numberCountFor82) else {
            throw Error.inputError
        }
        guard let intFor1 = Int(numberCountFor1) else {
            throw Error.inputError
        }
        
        (0..<intFor82).forEach { _ in
            let contact = CNMutableContact()
            let randomGivenName: String = String.randomHangul(digits: 1)
            let randomFamilyName: String = String.randomHangul(digits: 2)
            let randomNumber: String = "+82 10-\(String.ramdomInt(digits: 4))-\(String.ramdomInt(digits: 4))"
            
            contact.givenName = randomGivenName
            contact.familyName = randomFamilyName
            contact.nickname = "RandomContacts"
            contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: randomNumber))]
            saveRequest.add(contact, toContainerWithIdentifier: nil)
        }
        
        (0..<intFor1).forEach { _ in
            let contact = CNMutableContact()
            let randomGivenName: String = String.randomEnglish(digits: 5)
            let randomFamilyName: String = String.randomEnglish(digits: 8)
            let randomNumber: String = "+1 (\(String.ramdomInt(digits: 3))) \(String.ramdomInt(digits: 3))-\(String.ramdomInt(digits: 4))"
            
            contact.givenName = randomGivenName
            contact.familyName = randomFamilyName
            contact.nickname = "RandomContacts"
            contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberiPhone, value: CNPhoneNumber(stringValue: randomNumber))]
            saveRequest.add(contact, toContainerWithIdentifier: nil)
        }
        
        try CNContactStore().execute(saveRequest)
    }
    
    public func deleteContacts() throws {
        let contactStore: CNContactStore = .init()
        let keysToFetch: [CNKeyDescriptor] = [CNContactNicknameKey as CNKeyDescriptor]
        let containers: [CNContainer] = try contactStore.containers(matching: nil)
        let saveRequest: CNSaveRequest = .init()
        var contacts: [CNContact] = []
        
        for container in containers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            let contact = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch)
            contacts.append(contentsOf: contact)
        }
        
        for contact in contacts {
            if contact.nickname == "RandomContacts" {
                saveRequest.delete(contact.mutableCopy() as! CNMutableContact)
            }
        }
        
        try contactStore.execute(saveRequest)
    }
}
