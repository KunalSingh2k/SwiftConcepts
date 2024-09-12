//: [Previous](@previous)

import Foundation

// To create a new porperty owned by the current view use _@State for value types and @StateObject for reference types.

// Refer to value created elseWhere use  _@Binding for value types, and either _@ObservedObject or _@EnvironmentObject for reference types.

//MARK: - Property Wrappers that are sources of truth
/// Creates and manages the values directly

//MARK: - _@AppStorage
/// reads and writes values from UserDefaults. This owns its data
 
//MARK: - _@FetchRequest
/// starts a Core Data fetch request for a particular entity. This owns its data

//MARK: - _@GestureState
/// stores values associated with a gesture that is currently in progress, such as how far you have swiped, except it will be reset to its default value when the gesture stops. This owns its data

//MARK: - _@Namespace
/// creates an animation namespace to allow matched geometry effects, which can be shared by other views. This owns its data.

//MARK: - _@NSApplicationDelegateAdaptor
/// is used to create and register a class as the app delegate for a macOS app. This owns its data.
//MARK: - _@Published
/// is attached to properties inside an ObservableObject, and tells SwiftUI that it should refresh any views that use this property when it is changed. This owns its data.

//MARK: - _@ScaledMetric
/// reads the user’s Dynamic Type setting and scales numbers up or down based on an original value you provide. This owns its data

//MARK: - _@SceneStorage
/// lets us save and restore small amounts of data for state restoration. This owns its data

//MARK: - _@State
/// lets us manipulate small amounts of value type data locally to a view. This owns its data.

//MARK: - _@StateObject
///  is used to store new instances of reference type data that conforms to the ObservableObject protocol. This owns its data.

//MARK: - _@UIApplicationDelegateAdaptor
/// is used to create and register a class as the app delegate for an iOS app. This owns its data

"------------------------------------------------------------------------------------------"

//MARK: - Property Wrappers that are not sources of truth
/// These get thier values from somewhere else

//MARK: - _@Binding
/// refers to value type data owned by a different view. Changing the binding locally changes the remote data too. This does not own its data

//MARK: - _@Environment
///  lets us read data from the system, such as color scheme, accessibility options, and trait collections, but you can add your own keys here if you want. This does not own its data
//MARK: - _@EnvironmentObject
/// reads a shared object that we placed into the environment. This does not own its data
//MARK: - _@FocusedBinding
/// is designed to watch for values in the key window, such as a text field that is currently selected. This does not own its data.

//MARK: - _@FocusedValue
/// is a simpler version of @FocusedBinding that doesn’t unwrap the bound value for you. This does not own its data.

//MARK: - _@ObservedObject
/// refers to an instance of an external class that conforms to the ObservableObject protocol. This does not own its data




