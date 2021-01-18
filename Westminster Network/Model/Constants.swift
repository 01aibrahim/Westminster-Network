//
//  Constants.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 04/11/2020.
//
import UIKit
import Firebase

struct Constants{
    static let courses = [" ", "Accounting","Animation","Arabic","Architectural Technology","Architecture and Environmental Design","Architecture",
                          "Biochemistry","Biological Sciences","Biomedical Sciences","Building Surveying","Business Economics","Business Information systems",
                          "Business Management","Business", "Chinese","Cognitive and Clinical Neuroscience","Computer Game Development",
                          "Computer Network Security","Computer Science", "Construction Management", "Contemporary Media Practice",
                          "Creative Writing","Criminology","Data Science and Analytics", "Designing Cities", "Digital Media","English Language",
                          "English Literature", "English", "European Legal Studies", "Fashion Business Management", "Fashion Design", "Fashion Marketing and Promotion", "Fashion", "Film", "Finance", "Fine Art Mixed Media", "French", "Graphic Communication Design", "History", "Human Nutrition", "Human Resource Management", "illustration and Visual Communication", "Master's In Law (M-Law)", "Interior Architecture", "International Business", "International Marketing", "International Relations", "Law", "Marketing Communications",
                          "Marketing Management", "Medical Sciences", "Music Production", "Pharmacology & Physiology", "Photography", "Politics and International Relations", "Politics", "Psychology", "Quantity Surveying", "Real Estate", "Smart Computer Systems", "Sociology",
                          "Software Engineering", "Spainsh", "Television Production", "Tourism", "Translation", "UWSU", "UWSU - Society","UWSU - Sports Club", "University Service"]

    //MARK:- GettingStartedViewController
    static let emailDomain = "westminster.ac.uk"
    static let inCorrectEmailDomainTitle = "Email Incorrect"
    static let inCorrectEmailDomainMessage = "The emaill address is incorrect, please ensure your using a westminster.ac.uk address."
    
    static let incorrectPasswordTitle = "Password Incorrect!"
    static let incorrectPasswordMessage = "Please ensure your password includes atleast one Uppercase, Lowercase and Number. The password must be atleast 6 characters long."
    static let passwordNotMatchingTitle = "Password doesn't match!"
    static let passwordNotMatchingMessage = "Please ensure both passwords are the same."
    static let nameIsEmptyTitle = "Name is Empty"
    static let nameIsEmptyMessage = "Please ensure you write your name"
    
    static let emailErrorMessage = "There is a problem with your email, please either create an account or re-confirm your email"
    
    static let passwordErrorMessage = "The password is invalid"
    
    static let accountDisabledErrorMessage = "Your account is disabled, you should of recieved an email with the reason."

    //MARK:- New Tweet
    
    static let tweetPlaceholder = "What are you thinking about?"
    
    
    //MARK:- Firebase
    
    static let serverKey = "AAAAdvrn9Fs:APA91bHu2O6VEVBPsY8xvlRfVwREpaJcfRXsanXmP5adk7TioLDao6UXXssFPpSHVEAQTQKFsDcRthTh38aChM-L22GIW24UPT4gf6HpDU75HElEJ1tV_GMjtYvkGYbAlURVaftLYSKV"
    
    static let AppStoreLink = "https://google.com"
        
    static let db = Firestore.firestore()
    static let storage = Storage.storage().reference()
    static let ref = Database.database().reference()

    static let defaults = UserDefaults.standard

    static let networkRequiredTitle = "Network Issue"
    static let networkRequiredMessage = "You need an internet connection, to be able to use this application, please connect to a network and try again."
    
    //Collection
    static let US = "UniversityServices"
    static let EL = "EventList"
    static let E = "Events"
    static let Users = "users"
    static let Report = "Report"
    
    
    //MARK:- University
    static let ChatBot = "https://askwest.weebly.com/#"
    static let AddEventAlertTitle = "Add an Event"
    static let AddEventAlertMessage = "Please enter details, once approved, it will be available on the page."
    
    
    //MARK:- Search
    
    static let ErrorAlertTitle = "Error"
    static let ErrorAlertMessage = "Sorry for the inconvience, please try again"

    static let ReportAlertTitle = "Why are you reporting this account"
    static let ReportAlertMessage = "What is the reason for the report, we will email you with an update."
    
    //MARK:- Arrays
    
    //University
    static var ServicesArray: [UniversityServices] = []{
        didSet {
            ServicesArray.sort { $0.Name < $1.Name }
        }
    }
    //Users
    static var UsersArray: [User] = []{
        didSet {
            UsersArray.sort { $0.name < $1.name }
        }
    }
    //Conversation list
    static var ConvoArray = [FeedConvo]()

    // Messages in Conversations
    static var ChatArray = [ConvoThread]()
    
    //Home Page feed
    static var feedArray: [FeedMessage] = []

    // Feed Comments
    static var FeedCommentArray = [ConvoThread]()

    static var EventArray: [Event] = []{
        didSet {
            EventArray.sort { $0.Name < $1.Name }
        }
    }
    

    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    
    
}

