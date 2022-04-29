//
//  InputValidation.swift
//  outdare
//
//  Created by Jasmin Partanen on 30.4.2022.
//  Description: File used to validate form inputs

import Foundation


// Validate email and password inputs
func validCredentials(newEmail: String, oldPassword: String, newPassword: String) -> String? {
    if newEmail.isEmpty {
        return "Email is empty"
    }
    
    if !isValidEmail(newEmail) {
        return "Email is invalid"
    }
    
    if oldPassword.isEmpty && newPassword.isEmpty {
        return "Confirm your password"
    }
    
    if newPassword.count < 8 {
        return "Password should be at least 8 characters long"
    }
    return nil
}

// Validate location and username inputs
func validInformation(location: String, username: String) -> String? {
    if location.isEmpty {
        return "location is mandatory"
    }
    
    if username.isEmpty {
        return "Username is mandatory"
    }
    
    if username.count < 3 {
        return "Username has to be at least 3 characters long"
    }
    if location.count < 2 {
        return "Location has to be at least 2 characters long"
    }
    return nil
}

// Validate email with regex
private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
