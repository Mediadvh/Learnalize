//
//  UsersList.swift
//  Learnalize
//
//  Created by Media Davarkhah on 3/19/1401 AP.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

func UserList(users: [User], selectable: Bool) -> some View {
    List {
        ForEach(users) { item in
            if selectable {
                NavigationLink(destination: ProfileView(id: item.id)) {
                    userCard(user: item)
                        .frame(width: 300, height: 100, alignment: .leading)
                }
            } else {
                userCard(user: item)
                    .frame(width: 300, height: 100, alignment: .leading)
            }
        }
    }
}

func userCard(user: User) -> some View{
    HStack(spacing: 20) {
        // let image = FireStoreManager.shared.getImage(with: user.picture)
        if let url = URL(string: user.picture) {
            WebImage(url: url)
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(100)
                .foregroundColor(Color(Colors.accent))
        } else {
            Image(uiImage: Images.profile)
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(100)
                .foregroundColor(Color(Colors.accent))
        }
        Text(user.username)
            .font(.title3)
            .foregroundColor(Color(Colors.accent))
    }
}
