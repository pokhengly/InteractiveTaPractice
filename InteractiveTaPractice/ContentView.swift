//
//  ContentView.swift
//  InteractiveTaPractice
//
//  Created by KAK-LY on 18/1/25.
//

import SwiftUI

struct ContentView: View {
    @State private var activeTab: TabItem = .home
    var body: some View {
        /// This Project support iOS 17 as well
        ZStack(alignment: .bottom) {
            if #available(iOS 18, *) {
                TabView(selection: $activeTab) {
                    /// Replace with your Tab view's
                    ForEach(TabItem.allCases, id: \.rawValue) { tab in
                        Tab.init(value: tab) {
                            Text(tab.rawValue)
                            /// Must hide the native tab bar
                                .toolbarVisibility(.hidden, for: .tabBar)
                        }
                    }
                }
            }else {
                TabView(selection: $activeTab) {
                    /// Replace with your Tab view's
                    ForEach(TabItem.allCases, id: \.rawValue) { tab in
                        Text(tab.rawValue)
                            .tag(tab)
                        /// Must hide the native tab bar
                            .toolbar(.hidden, for: .tabBar)
                    }
                    
                }
                
            }
            
            
            InteractiveTabBar(activeTab: $activeTab)
            
        }
    }
}


/// Interactive Tab bar
struct InteractiveTabBar: View {
    @Binding var activeTab: TabItem
    /// View Properties
    @Namespace private var animation
    /// Storing the locations of the tab buttons so that can be used to identify the currently dragged tab
    @State private var tabButtonLocations: [CGRect] = Array(repeating: .zero, count: TabItem.allCases.count)
    /// By using this, we can animate the chnages in the tab bar without animationg the actual tab view. when the gesture is released, the chnages are pushed to the tab view
    @State private var activeDraggingTab: TabItem?
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.rawValue) { tab in
                TabButton(tab)
            }
        }
        .frame(height: 50)
        .padding(.horizontal, 15)
        .padding(.bottom, 10)
        .background(.background.shadow(.drop(color: .primary.opacity(0.2), radius: 5)))
        .coordinateSpace(.named("TABBAR"))
    }
    
    
    /// Each Individual Tab Button View
    @ViewBuilder
    func TabButton(_ tab: TabItem) -> some View {
        let isActive = (activeDraggingTab ?? activeTab) == tab
        
        VStack(spacing: 6) {
            Image(systemName: tab.symbolImage)
                .symbolVariant(.fill)
                .frame(width: isActive ? 50: 25, height: isActive ? 50 : 25)
                .background {
                    if isActive {
                        Circle()
                            .fill(.blue.gradient)
                        // animation cycle interaction smooth with tabbar
                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    }
                }
            /// Now, let's make it as a interactive tab bar
                .contentShape(.rect)
                .gesture(
                    DragGesture(coordinateSpace: .named("TABBAR"))
                        .onChanged { value in
                            let location = value.location
                            /// Checking if the location falls within any stored locatons; if so, switching to the approperate index
                            if let index = tabButtonLocations.firstIndex(where: { $0.contains(location)
                                }) {
                                withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                                    activeDraggingTab = TabItem.allCases[index]
                                }
                            }
                        }.onEnded { _ in
                            /// pushing chnages to the actual tab view
                            if let activeDraggingTab {
                                
                            }
                            activeDraggingTab = nil
                            
                        },
                    /// This will immediately become false once the tab is moved, so chnage this to check the actual tab value insteat of the dragged value
                    isEnabled: activeTab == tab
                )
            /// This gives use the elevation we needed to push the active tab
                .frame(width: 25, height: 25, alignment: .bottom)
                .foregroundStyle(isActive ? .white : .primary)
            
            Text(tab.rawValue)
                .font(.caption2)
                .foregroundStyle(isActive ? .blue : .gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onGeometryChange(for: CGRect.self, of: {
            $0.frame(in: .named("TABBAR"))
        }, action: { newValue in
            tabButtonLocations[tab.index] = newValue
        })
        .contentShape(.rect)
        .onTapGesture {
            withAnimation(.snappy) {
                activeTab = tab
            }
        }
    }
}

#Preview {
    ContentView()
}

enum TabItem: String, CaseIterable {
    case home = "Home"
    case search = "Search"
    case notification = "Notifications"
    case setting = "Settings"

    
    var symbolImage: String {
        switch self {
        case .home: "house"
        case .search: "magnifyingglass"
        case .notification: "bell"
        case .setting: "gearshape"
        }
    }
    
    var index: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}
