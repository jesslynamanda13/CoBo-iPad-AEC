//
//  BookingPurposeEnum.swift
//  CoBo-iPad
//
//  Created by Amanda on 05/05/25.
//

enum BookingPurpose: Codable, Equatable {
    case groupDiscussion
    case personalMentoring
    case meeting
    case others(String)

    var displayName: String {
        switch self {
        case .groupDiscussion:
            return "Group Discussion"
        case .personalMentoring:
            return "Personal Mentoring"
        case .meeting:
            return "Meeting"
        case .others(let custom):
            return custom
        }
    }

    enum CodingKeys: String, CodingKey {
        case type, value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "Group Discussion":
            self = .groupDiscussion
        case "Personal Mentoring":
            self = .personalMentoring
        case "Meeting":
            self = .meeting
        case "Others":
            let value = try container.decode(String.self, forKey: .value)
            self = .others(value)
        default:
            self = .others(type)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .groupDiscussion:
            try container.encode("Group Discussion", forKey: .type)
        case .personalMentoring:
            try container.encode("Personal Mentoring", forKey: .type)
        case .meeting:
            try container.encode("Meeting", forKey: .type)
        case .others(let custom):
            try container.encode("Others", forKey: .type)
            try container.encode(custom, forKey: .value)
        }
    }

    static var allPredefined: [BookingPurpose] {
        return [.groupDiscussion, .personalMentoring, .meeting]
    }
}
