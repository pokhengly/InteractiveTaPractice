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
    }
    
    
    /// Each Individual Tab Button View
    @ViewBuilder
    func TabButton(_ tab: TabItem) -> some View {
        let isActive = activeTab == tab
        
        VStack(spacing: 6) {
            Image(systemName: tab.symbolImage)
                .symbolVariant(.fill)
                .frame(width: isActive ? 50: 25, height: isActive ? 50 : 25)
                .background {
                    if isActive {
                        Circle()
                            .fill(.blue.gradient)
                    }
                }
            /// This gives use the elevation we needed to push the active tab
                .frame(width: 25, height: 25, alignment: .bottom)
                .foregroundStyle(isActive ? .white : .primary)
            
            Text(tab.rawValue)
                .font(.caption2)
                .foregroundStyle(isActive ? .blue : .gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
}
