# 🧪 Potion Kitchen

A magical Flutter game where you brew potions by combining ingredients in cauldrons. Test your skills as a master alchemist in this pixel-art styled potion crafting adventure!

## 📱 Features

### Core Gameplay
- **Potion Crafting**: Combine ingredients in magical cauldrons to create unique potions
- **Recipe System**: Follow magical recipes to create the perfect potions
- **Time Management**: Balance multiple brewing potions simultaneously
- **Score System**: Earn points for successful potions and maintain your lives

### Visual Elements
- **Pixel Art Style**: Custom-designed pixel art assets for an authentic retro feel
- **Animated Effects**: 
  - Bubbling cauldrons with particle effects
  - Liquid animations
  - Shimmering effects
- **Loading Screen**: Animated potion filling sequence

### UI Components
- **Recipe Book**: View available potion recipes
- **Ingredient Inventory**: Manage your magical ingredients
- **Status Display**: Track your score and remaining lives
- **Responsive Layout**: Adapts to different screen sizes

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest version)
- Dart SDK (latest version)
- A code editor (VS Code, Android Studio, etc.)

### Installation

1. Clone the repository:
```bash
git clone [repository-url]
```

2. Navigate to the project directory:
```bash
cd potion-kitchen
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## 🎮 How to Play

1. **Start the Game**
   - Launch the app and wait for the loading screen animation
   - The game begins when the loading sequence completes

2. **Brewing Potions**
   - Check the recipe book for required ingredients
   - Drag ingredients from your inventory to the cauldrons
   - Monitor the brewing process carefully
   - Collect completed potions before they spoil

3. **Scoring**
   - Earn points for successfully completed potions
   - Maintain your lives by avoiding failed brews
   - Try to achieve the highest score possible!

## 🛠️ Technical Details

### Architecture
- **State Management**: Provider pattern for game state
- **Custom Widgets**: Pixel-perfect UI components
- **Animation System**: Custom animation controllers and painters

### Key Components
- `GameScreen`: Main game interface
- `PixelCauldron`: Custom-drawn cauldron with animations
- `PixelBackground`: Themed background with pixel art style
- `LoadingScreen`: Animated introduction sequence

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
  google_fonts: ^5.0.0
```

## 🎨 Design Elements

### Color Palette
- **Primary Colors**:
  - Saddle Brown: `#8B4513`
  - Medium Purple: `#9370DB`
  - Dark Slate Gray: `#2F4F4F`
  - Gold: `#FFD700`

### Typography
- **Headers**: Cinzel Decorative
- **Body Text**: Medieval Sharp

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Pixel art inspiration from classic RPG games
- Flutter community for widget inspiration
- Medieval font creators

## 📞 Contact

Project Link: [repository-url]

---

Made with ❤️ and ✨ magic ✨
