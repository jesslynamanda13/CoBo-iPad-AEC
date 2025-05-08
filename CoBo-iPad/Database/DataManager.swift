////
////  DataManager.swift
////  CoBo-iPad
////
////  Created by Amanda on 05/05/25.
////
//
//import Foundation
//
//final class DataManager {
//    
//    static func getUsersData() -> [User] {
//        return [
//            User(name: "Evan Lokajaya",  role: UserRole.learner, email: "lokajaya414@gmail.com"),
//            User(name: "Jesslyn Amanda Mulyawan", role: UserRole.learner, email: "jesslynmulyawan@gmail.com"),
//            User(name: "Emmanuel Rieno Bobba", role: UserRole.learner, email: "emmanuelbobba3@gmail.com"),
//            User(name: "Callista Andreane", role: UserRole.learner, email: "menotcallista@gmail.com"),
//            User(name: "Kelvin Alexander Bong", role: UserRole.learner, email: "kelvinbong3010@gmail.com"),
//            User(name: "Ammar Sufyan", role: UserRole.learner, email: "ammarsfyn@gmail.com"),
//            User(name: "Richard Wijaya Harianto", role: UserRole.learner, email: "richardharianto04@gmail.com"),
//            User(name: "Wiwi Oktriani", role: UserRole.learner, email: "wiwioktriani1111@gmail.com"),
//            User(name: "Sufi Arifin", role: UserRole.learner, email: "zv.180279@gmail.com"),
//            User(name: "Louis Octavianus", role: UserRole.learner, email: "luisoktt@gmail.com"),
//            User(name: "Alvin Justine", role: UserRole.learner, email: "faajustin04@gmail.com"),
//            User(name: "Brayent Cahyadi", role: UserRole.learner, email: "brayentcahyadi@gmail.com"),
//            User(name: "Georgius Kenny Gunawan", role: UserRole.learner, email: "ggunawan25@bsd.idserve.net")
//        ]
//    }
//    
//    static func getTimeslotsData() -> [Timeslot] {
//        return [
//            Timeslot(startHour: 8.0, endHour: 9.167),
//            Timeslot(startHour: 9.417, endHour: 10.584),
//            Timeslot(startHour: 10.84, endHour: 12.0),
//            Timeslot(startHour: 13.0, endHour: 14.167),
//            Timeslot(startHour: 14.417, endHour: 15.584),
//            Timeslot(startHour: 15.84, endHour: 17.0),
//        ]
//    }
//    
//    static func getBookingData() -> [Booking] {
//        return [
//            Booking(
//                name: "Lokajaya's Meeting",
//                coordinator: DataManager.getUsersData()[0],
//                purpose: BookingPurpose.groupDiscussion,
//                date: Date(),
//                participants: [],
//                timeslot: DataManager.getTimeslotsData()[1],
//                collabSpace: DataManager.getCollabSpacesData()[0],
//                status: BookingStatus.notCheckedIn,
//                checkInCode:"111111"
//            ),
//            Booking(
//                name: "Lokajaya's Meeting",
//                coordinator: DataManager.getUsersData()[0],
//                purpose: BookingPurpose.groupDiscussion,
//                date: Date(),
//                participants: [],
//                timeslot: DataManager.getTimeslotsData()[1],
//                collabSpace: DataManager.getCollabSpacesData()[1],
//                status: BookingStatus.notCheckedIn,
//                checkInCode:"908462"
//            )
//        ]
//    }
//    
//    // TODO: for booking log
//    static func getBookingDataByDate(_ date: Date) -> [Booking] {
//        return []
//    }
//    
//    static func getCollabSpacesData() -> [CollabSpace] {
//        // TODO: add image
//        return [
//            CollabSpace(
//                name: "Collab - 02",
//                capacity: 8,
//                whiteboardAmount: 0,
//                tableWhiteboardAmount: 1,
//                tvAvailable: true,
//                image: "collab-02-img"
//            ),
//            CollabSpace(
//                name: "Collab - 03",
//                capacity: 8,
//                whiteboardAmount: 0,
//                tableWhiteboardAmount: 1,
//                tvAvailable: true,
//                image: "collab-03-img"
//            ),
//            CollabSpace(
//                name: "Collab - 03A",
//                capacity: 8,
//                whiteboardAmount: 0,
//                tableWhiteboardAmount: 1,
//                tvAvailable: false,
//                image: "collab-03a-img"
//            ),
//            CollabSpace(
//                name: "Collab - 04",
//                capacity: 8,
//                whiteboardAmount: 0,
//                tableWhiteboardAmount: 0,
//                tvAvailable: true,
//                image: "collab-04-img"
//            ),
//            CollabSpace(
//                name: "Collab - 05",
//                capacity: 8,
//                whiteboardAmount: 0,
//                tableWhiteboardAmount: 0,
//                tvAvailable: true,
//                image: "collab-05-img"
//            ),
//            CollabSpace(
//                name: "Collab - 07A",
//                capacity: 8,
//                whiteboardAmount: 1,
//                tableWhiteboardAmount: 0,
//                tvAvailable: true,
//                image: "collab-07-img"
//            )
//            
//        ]
//    }
//}
