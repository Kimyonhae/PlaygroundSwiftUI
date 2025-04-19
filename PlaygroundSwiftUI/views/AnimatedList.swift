import SwiftUI

struct AnimatedList : View {
    @State var show = false
    
    var body: some View {
        VStack() {
            Text("Card in SwiftUI")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .font(.largeTitle)
                .padding(.top, show ? 30 : 20)
                .padding(.bottom, show ? 20 : 0)
            
                Text("Animatable cards with Spring, custom frame and some paddings. Also use SFSymbol for icon in the bottom button. Tap to button fo see fill style of this icon.")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .cornerRadius(0)
                    .lineLimit(.none)
            
            Spacer()
            
            Button(action: {
                withAnimation (.spring){
                    self.show.toggle()
                }
            }) {
                HStack {
                    Image(systemName: show ? "slash.circle.fill" : "slash.circle")
                        .foregroundColor(Color(hue: 0.498, saturation: 0.609, brightness: 1.0))
                        .font(Font.title.weight(.semibold))
                        .imageScale(.small)
                    Text(show ? "to Card" : "to Area")
                        .foregroundColor(Color(hue: 0.498, saturation: 0.609, brightness: 1.0))
                        .fontWeight(.bold)
                        .font(.title)
                        .cornerRadius(0)
                }
            }
            .padding(.bottom, show ? 20 : 15)
            
        }
        .padding()
        .padding(.top, 15)
        .frame(width: show ? 350 : 290, height: show ? 420 : 260)
        .background(Color.blue)
        .cornerRadius(30)
    }
}

#Preview {
    AnimatedList(show: true)
}
