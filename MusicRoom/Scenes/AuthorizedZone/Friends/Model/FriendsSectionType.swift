//
//  FriendsSectionType.swift
//  MusicRoom
//
//  Created by Mariia on 06.09.2021.
//  Copyright © 2021 School21. All rights reserved.
//

enum FriendsSectionType: Int, CaseIterable {
	case friends = 0
	case invitations
	case pendingInvitations
	case possibleFriends
	
	var name: String {
		switch self {
		case .friends:
			return "Friends"
			
		case .invitations:
			return "Invitations"
			
		case .pendingInvitations:
			return "PendingInvitations"
			
		case .possibleFriends:
			return "PossibleFriends"
		}
	}
}
