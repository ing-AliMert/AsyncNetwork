//
//  TrackDetailSwiftUIView.swift
//  AsyncNetwork
//
//  Created by Ali Mert Ozhayta [Obssteknolojileri] on 18.12.2024.
//

import SwiftUI

struct TrackDetailSwiftUIView: View {
    
    let track: Track

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // MARK: Image Card
                if let imageUrl = track.strTrackThumb,
                   let url = URL(string: imageUrl) {
                    HStack {
                        CustomAsyncImage(url: url) {
                            Color.gray.opacity(0.4)
                        } image: { image in
                            image
                                .resizable()
                                .scaledToFit()
                        }
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 3, y: 3)
                        .padding(.top, 16)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
                // MARK: Album and Artist Card
                Group {
                    VStack(spacing: .zero) {
                        HStack {
                            Text("Album")
                                .bold()

                            Spacer()
                            Text(track.strAlbum)
                        }
                        .padding(16)
                        
                        Divider().padding(.leading, 16)
                        
                        HStack {
                            Text("Artist").bold()
                            Spacer()
                            Text(track.strArtist)
                        }
                        .padding(16)
                    }
                    .background(Color(UIColor.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .shadow(color: Color(UIColor.label).opacity(0.25), radius: 4, x: 1, y: 1)
                }
                .padding(.vertical, 16)

                // MARK: Description Card
                if let description = track.strDescription {
                    Group {
                        VStack(spacing: 16) {
                            Text("Description")
                                .bold()
                           
                            Divider()
                                .padding(.horizontal, -16)
                            
                            Text(description)
                        }
                        .padding(16)
                        .background(Color(UIColor.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .shadow(color: Color(UIColor.label).opacity(0.25), radius: 4, x: 1, y: 1)
                    }
                }
                
                // EmptyView that renders
                Text("")
            }
            .padding(16)
        }
        .background(Color.gray.opacity(0.25).ignoresSafeArea(edges: [.bottom, .horizontal]))
        .navigationTitle(track.strTrack)
        .overlay(Divider(), alignment: .top)
            
    }
}

// MARK: - Preview

#Preview {

    NavigationView {
        TrackDetailSwiftUIView(track: mockTrack)
            .navigationBarTitleDisplayMode(.inline)
    }
}

// TODO: implement better way to use mock

let mockTrack = Track(
    idTrack: "32823000",
    idAlbum: "2118223",
    idArtist: "112424",
    strTrack: "Billie Jean",
    strAlbum: "Thriller",
    strArtist: "Michael Jackson",
    strGenre: "Pop",
    strDescription: Optional(
        "\"Billie Jean\" is a song by American singer Michael Jackson, released by Epic Records on January 2, 1983, as the second single from Jackson\'s sixth studio album, Thriller (1982). It was written and composed by Jackson and produced by Jackson and Quincy Jones. \"Billie Jean\" blends post-disco, rhythm and blues, funk and dance-pop. The lyrics describe a woman, Billie Jean, who claims that the narrator is the father of her newborn son, which he denies. Jackson said the lyrics were based on groupies\' claims about his older brothers when he toured with them as the Jackson 5.\r\n\r\n\"Billie Jean\" reached number one on the Billboard Hot 100, topped the Billboard Hot Black Singles chart within three weeks, and became Jackson\'s fastest-rising number one single since \"ABC\", \"The Love You Save\" and \"I\'ll Be There\" in 1970, all of which he recorded as a member of the Jackson 5. Billboard ranked it as the No. 2 song for 1983. \"Billie Jean\" is certified 6× Platinum by the Recording Industry Association of America (RIAA). The song has sold over 10 million copies worldwide, making it one of the best-selling singles of all time. It was also a number one hit in the UK, Canada, France, Switzerland and Belgium for example, and reached the top ten in many other countries. \"Billie Jean\" was one of the best-selling singles of 1983, helping Thriller become the best-selling album of all time, and became Jackson\'s best-selling solo single.\r\n\r\nJackson\'s performance of \"Billie Jean\" on the TV special Motown 25: Yesterday, Today, Forever won acclaim and was nominated for an Emmy Award. It introduced a number of Jackson\'s signatures, including the moonwalk and white sequined glove, and was widely imitated. The \"Billie Jean\" music video, directed by Steve Barron, was the first video by a black artist to be aired in heavy rotation on MTV. Along with the other videos produced for Thriller, it helped establish MTV\'s cultural importance and make music videos an integral part of popular music marketing. The spare, bass-driven arrangement of \"Billie Jean\" helped pioneer what one critic called \"sleek, post-soul pop music\". It also introduced a more paranoid lyrical style for Jackson, a trademark of his later music.\r\n\r\n\"Billie Jean\" was awarded honors including two Grammy Awards and an American Music Award. In a list compiled by Rolling Stone and MTV in 2000, the song was ranked as the sixth greatest pop song since 1963. In 2004, Rolling Stone placed it at number 58 on its list of The 500 Greatest Songs of All Time and was included in the Rock and Roll Hall of Fame\'s 500 Songs That Shaped Rock and Roll. Frequently listed in magazine polls of the best songs ever made, \"Billie Jean\" was named the greatest dance record of all time by BBC Radio 2 listeners."
    ),
    strTrackThumb: Optional(
        "https://www.theaudiodb.com/images/media/track/thumb/it32dq1715070111.jpg"
    )
)
