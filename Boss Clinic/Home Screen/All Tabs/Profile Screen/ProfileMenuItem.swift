//
//  ProfileMenuItem.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 07/07/26.
//

import Foundation


struct ProfileMenuItem: Identifiable {

    let id = UUID()

    let title: String

    let icon: String

    let destination: ProfileDestination
}
