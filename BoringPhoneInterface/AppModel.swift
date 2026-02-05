//
//  AppModel.swift
//  BoringPhoneInterface
//
//  Created by Akshay Patnaik on 2/3/26.
//

import Foundation

struct AppItem: Identifiable {
  let id = UUID()
  let name: String
  let urlScheme: String
  let fallbackURL: String
}

struct AppCategory: Identifiable {
  let id = UUID()
  let title: String
  let apps: [AppItem]
}

class AppData {
  static let categories: [AppCategory] = [
    // 1: CORE (Essentials)
    AppCategory(title: "Core", apps: [
      // using shortcut here
      AppItem(name: "Phone", urlScheme: "shortcuts://run-shortcut?name=openPhoneApp", fallbackURL: ""),
      AppItem(name: "Messages", urlScheme: "sms://", fallbackURL: "messages://"),
      AppItem(name: "Maps", urlScheme: "maps://", fallbackURL: ""),
      AppItem(name: "Wallet", urlScheme: "shoebox://", fallbackURL: ""),
    ]),
    
    // 2: COMMUNICATION
    AppCategory(title: "Communication", apps: [
      AppItem(name: "Mail", urlScheme: "message://", fallbackURL: "mailto://"),
      AppItem(name: "WhatsApp", urlScheme: "whatsapp://", fallbackURL: "https://whatsapp.com"),
      AppItem(name: "Discord", urlScheme: "discord://", fallbackURL: "https://discord.com"),
      AppItem(name: "Slack", urlScheme: "slack://", fallbackURL: "https://slack.com"),
      AppItem(name: "Beeper", urlScheme: "beeper://", fallbackURL: "https://beeper.com"),
      AppItem(name: "Google Chat", urlScheme: "googlechat://", fallbackURL: "https://chat.google.com"),
    ]),
    
    // 3: UTILITIES
    AppCategory(title: "Utilities", apps: [
      AppItem(name: "Weather", urlScheme: "weatherchannel://", fallbackURL: "https://weather.com"),
      AppItem(name: "Alarmy", urlScheme: "alarmy://", fallbackURL: ""),
      AppItem(name: "Spotify", urlScheme: "spotify://", fallbackURL: "https://spotify.com"),
      AppItem(name: "Brave", urlScheme: "brave://", fallbackURL: "https://brave.com"),
      AppItem(name: "Files", urlScheme: "shareddocuments://", fallbackURL: ""),
      AppItem(name: "Settings", urlScheme: "App-prefs://", fallbackURL: ""),
    ]),
    
    // 4: PRODUCTIVITY & DEV
    AppCategory(title: "Work & Dev", apps: [
      AppItem(name: "Notion", urlScheme: "notion://", fallbackURL: "https://notion.so"),
      AppItem(name: "Obsidian", urlScheme: "obsidian://", fallbackURL: "notes://"),
      // "calshow://" opens the native Apple Calendar
      // "cron://" opens Notion Calendar (formerly Cron)
      // fallback to apple calendar just in case
      AppItem(name: "Calendar", urlScheme: "cron://", fallbackURL: "calshow://"),
      AppItem(name: "GitHub", urlScheme: "github://", fallbackURL: "https://github.com"),
      AppItem(name: "ChatGPT", urlScheme: "chatgpt://", fallbackURL: "https://chatgpt.com"),
      AppItem(name: "DeepSeek", urlScheme: "deepseek://", fallbackURL: "https://deepseek.com"),
      // using shortcut here
      AppItem(name: "Gemini (beta)", urlScheme: "shortcuts://run-shortcut?name=openGeminiApp", fallbackURL: "https://gemini.google.com"),
    ]),
    
    // 5: LIFE & HOME
    AppCategory(title: "Life", apps: [
      // using shortcut here
      AppItem(name: "Home (beta)", urlScheme: "shortcuts://run-shortcut?name=openHomeAppMenu", fallbackURL: "home://"),
      AppItem(name: "Alexa", urlScheme: "alexa://", fallbackURL: ""),
      AppItem(name: "Tesla", urlScheme: "tesla://", fallbackURL: ""),
      AppItem(name: "Uber", urlScheme: "uber://", fallbackURL: ""),
      AppItem(name: "Transit", urlScheme: "transit://", fallbackURL: ""),
      // using shortcut here
      AppItem(name: "Sweatcoin (beta)", urlScheme: "shortcuts://run-shortcut?name=openSweatAppMenu", fallbackURL: ""),
      AppItem(name: "MyColorado", urlScheme: "mycolorado://", fallbackURL: "https://mycolorado.state.co.us"),
    ])
  ]
}
