//
//  MissionView.swift
//  Moonshot
//
//  Created by Uriel Ortega on 10/05/23.
//

import SwiftUI

struct CrewMember {
    let role: String
    let astronaut: Astronaut
}

struct MissionView: View {
    let mission: Mission
    let crew: [CrewMember]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    MissionBadge(mission: mission, geometry: geometry)
                                        
                    MissionDetails(mission: mission)
                    
                    CrewView(crew: crew)
                }
                .padding(.bottom) // To give more space for the Home Indicator
            }
        }
        .navigationTitle(mission.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
        // .preferredColorScheme(.dark)
    }
    
    init(mission: Mission, astronauts: [String: Astronaut]) {
        self.mission = mission
        
        self.crew = mission.crew.map { member in
            if let astronaut = astronauts[member.name] {
                return CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missiong \(member.name)")
            }
        }
    }
}

struct CustomDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundColor(.lightBackground)
            .padding(.vertical)
    }
}

struct MissionBadge: View {
    let mission: Mission
    let geometry: GeometryProxy
    
    var body: some View {
        VStack {
            Image(mission.image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: geometry.size.width * 0.6) // 60% of the available screen width
                .padding(.vertical)
            
            Text(mission.detailedLaunchDate)
                .font(.subheadline)
        }
    }
}

struct CrewView: View {
    let crew: [CrewMember]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(crew, id: \.role) { crewMember in
                    NavigationLink {
                        AstronautView(astronaut: crewMember.astronaut)
                    } label: {
                        HStack {
                            Image(crewMember.astronaut.id)
                                .resizable()
                                .frame(width: 104, height: 72)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(.white, lineWidth: 2)
                                )
                            
                            VStack(alignment: .leading) {
                                Text(crewMember.astronaut.name)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                
                                Text(crewMember.role)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal) // Horizontal padding between astronauts
                    }
                }
            }
        }
    }
}

struct MissionDetails: View {
    let mission: Mission

    var body: some View {
        VStack(alignment: .leading) {
            CustomDivider()
            
            Text("Mission Highlights")
                .font(.title.bold())
                .padding(.bottom, 5)
            
            Text(mission.description)
            
            CustomDivider()
            
            Text("Crew")
                .font(.title.bold())
                .padding(.bottom, 5)
        }
        .padding(.horizontal)
    }
}

// MARK: Previews

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        MissionView(mission: missions[2], astronauts: astronauts)
            .preferredColorScheme(.dark)
    }
}

