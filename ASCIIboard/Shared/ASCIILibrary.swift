import Foundation

// MARK: - ASCII Art Library
// All art is stored as static data, compiled into both the main app and keyboard extension.

enum ASCIILibrary {

    // MARK: - All Categories

    static let categories: [ASCIICategory] = [
        emoticons,
        animals,
        reactions,
        symbols,
        dividers,
        art,
        textArt,
    ]

    // MARK: - Computed Helpers

    static var allItems: [ASCIIItem] {
        categories.flatMap { $0.items }
    }

    static func category(withId id: String) -> ASCIICategory? {
        categories.first { $0.id == id }
    }

    static func items(matching query: String) -> [ASCIIItem] {
        guard !query.isEmpty else { return allItems }
        let q = query.lowercased()
        return allItems.filter {
            $0.name.lowercased().contains(q) || $0.art.lowercased().contains(q)
        }
    }

    // MARK: - Category Definitions

    static let emoticons = ASCIICategory(
        id: "emoticons",
        name: "Emoticons",
        systemIcon: "face.smiling",
        items: [
            ASCIIItem(id: "shrug",       name: "Shrug",          art: "¯\\_(ツ)_/¯"),
            ASCIIItem(id: "flip",        name: "Table Flip",     art: "(╯°□°）╯︵ ┻━┻"),
            ASCIIItem(id: "unflip",      name: "Table Unflip",   art: "┬──┬ ノ( ゜-゜ノ)"),
            ASCIIItem(id: "lenny",       name: "Lenny Face",     art: "( ͡° ͜ʖ ͡°)"),
            ASCIIItem(id: "disapprove",  name: "Disapproval",    art: "ಠ_ಠ"),
            ASCIIItem(id: "happy",       name: "Happy",          art: "(◕‿◕)"),
            ASCIIItem(id: "cry",         name: "Crying",         art: "(╥﹏╥)"),
            ASCIIItem(id: "wink",        name: "Wink",           art: "(｡•̀ᴗ-)✧"),
            ASCIIItem(id: "omg",         name: "OMG",            art: "ヽ(°〇°)ﾉ"),
            ASCIIItem(id: "hug",         name: "Hug",            art: "(づ｡◕‿‿◕｡)づ"),
            ASCIIItem(id: "fight",       name: "Fight Me",       art: "(ง'̀-'́)ง"),
            ASCIIItem(id: "dance",       name: "Dance",          art: "ヾ(⌐■_■)ノ♪"),
            ASCIIItem(id: "cool",        name: "Deal With It",   art: "(•_•) ( •_•)>⌐■-■ (⌐■_■)"),
            ASCIIItem(id: "celebrate",   name: "Celebrate",      art: "٩(◕‿◕｡)۶"),
            ASCIIItem(id: "angry",       name: "Angry",          art: "щ(ಠ益ಠщ)"),
            ASCIIItem(id: "love",        name: "Love",           art: "(ɔ◔‿◔)ɔ ♥"),
            ASCIIItem(id: "confused",    name: "Confused",       art: "(•ิ_•ิ)?"),
            ASCIIItem(id: "meh",         name: "Meh",            art: "¯\\(°_o)/¯"),
            ASCIIItem(id: "bow",         name: "Bow",            art: "m(_ _)m"),
            ASCIIItem(id: "sparkle",     name: "Sparkle",        art: "(ﾉ◕ヮ◕)ﾉ*:･ﾟ✧"),
        ]
    )

    static let animals = ASCIICategory(
        id: "animals",
        name: "Animals",
        systemIcon: "pawprint.fill",
        items: [
            ASCIIItem(id: "cat1",        name: "Cat",            art: "(=^･ω･^=)"),
            ASCIIItem(id: "cat2",        name: "Cat Waving",     art: "(^._.^)ﾉ"),
            ASCIIItem(id: "bear",        name: "Bear",           art: "ʕ•ᴥ•ʔ"),
            ASCIIItem(id: "dog",         name: "Dog",            art: "V•ᴥ•V"),
            ASCIIItem(id: "bunny",       name: "Bunny",          art: "(\\_/)\n(='.'=)\n(\")_(\")" ),
            ASCIIItem(id: "fish",        name: "Fish",           art: "<°)))))><"),
            ASCIIItem(id: "owl",         name: "Owl",            art: "(◉ o ◉)"),
            ASCIIItem(id: "penguin",     name: "Penguin",        art: "( ˘▽˘)っ♨"),
            ASCIIItem(id: "shark",       name: "Shark",          art: "( •_•)O*¯`·.¸.·´¯`°Q(•_• )"),
            ASCIIItem(id: "spider",      name: "Spider",         art: "/\\(oo)/\\"),
            ASCIIItem(id: "bird",        name: "Bird",           art: "ᕙ(⇀‸↼‶)ᕗ"),
            ASCIIItem(id: "snail",       name: "Snail",          art: "@'---,---"),
            ASCIIItem(id: "cow",         name: "Cow",            art: "(^(oo)^)"),
            ASCIIItem(id: "monkey",      name: "Monkey",         art: "@(*o*)@"),
        ]
    )

    static let reactions = ASCIICategory(
        id: "reactions",
        name: "Reactions",
        systemIcon: "hand.thumbsup.fill",
        items: [
            ASCIIItem(id: "yes",         name: "Yes!",           art: "(•̀ᴗ•́)و ̑̑"),
            ASCIIItem(id: "no",          name: "Nope",           art: "ᕙ(⇀‸↼‶)ᕗ"),
            ASCIIItem(id: "facepalm",    name: "Facepalm",       art: "(－‸ლ)"),
            ASCIIItem(id: "mindblown",   name: "Mind Blown",     art: "(╯°□°）╯ ︵ 🤯"),
            ASCIIItem(id: "slowclap",    name: "Slow Clap",      art: "( •_•)\n( •_•)>⌐■-■\n(⌐■_■)"),
            ASCIIItem(id: "thumbsup",    name: "Thumbs Up",      art: "（ﾉ´∀｀）ﾉ"),
            ASCIIItem(id: "wave",        name: "Wave",           art: "( ˘ ³˘)♥"),
            ASCIIItem(id: "notbad",      name: "Not Bad",        art: "( ͡~ ͜ʖ ͡°)"),
            ASCIIItem(id: "run",         name: "Running",        art: "ᕕ( ᐛ )ᕗ"),
            ASCIIItem(id: "jazz",        name: "Jazz Hands",     art: "\\(^O^)/"),
            ASCIIItem(id: "muscles",     name: "Flexing",        art: "ᕦ(ò_óˇ)ᕤ"),
            ASCIIItem(id: "ghost",       name: "Spooked",        art: "( º_º)"),
            ASCIIItem(id: "cry2",        name: "Sobbing",        art: "(;´༎ຶ ۝ ༎ຶ`)"),
        ]
    )

    static let symbols = ASCIICategory(
        id: "symbols",
        name: "Symbols",
        systemIcon: "sparkles",
        items: [
            ASCIIItem(id: "heart",       name: "Heart",          art: "♥"),
            ASCIIItem(id: "hearts",      name: "Hearts",         art: "♡ ♥ ♡ ♥ ♡"),
            ASCIIItem(id: "stars",       name: "Stars",          art: "★ ☆ ★ ☆ ★"),
            ASCIIItem(id: "sparkles",    name: "Sparkles",       art: "✦ ✧ ✦ ✧ ✦"),
            ASCIIItem(id: "music",       name: "Music Notes",    art: "♩ ♪ ♫ ♬ ♭ ♮ ♯"),
            ASCIIItem(id: "suits",       name: "Card Suits",     art: "♥ ♦ ♣ ♠"),
            ASCIIItem(id: "blocks",      name: "Blocks",         art: "░ ▒ ▓ █ ▓ ▒ ░"),
            ASCIIItem(id: "arrows",      name: "Arrows",         art: "← ↑ → ↓ ↔ ↕"),
            ASCIIItem(id: "crown",       name: "Crown",          art: "♛"),
            ASCIIItem(id: "snowflake",   name: "Snowflake",      art: "❄ ❅ ❆"),
            ASCIIItem(id: "lightning",   name: "Lightning",      art: "⚡ ⚡ ⚡"),
            ASCIIItem(id: "infinity",    name: "Infinity",       art: "∞"),
            ASCIIItem(id: "peace",       name: "Peace",          art: "☮"),
            ASCIIItem(id: "yinyang",     name: "Yin Yang",       art: "☯"),
            ASCIIItem(id: "skull",       name: "Skull",          art: "☠"),
            ASCIIItem(id: "checkmark",   name: "Check",          art: "✓"),
            ASCIIItem(id: "cross",       name: "Cross",          art: "✗"),
            ASCIIItem(id: "flower",      name: "Flower",         art: "✿"),
        ]
    )

    static let dividers = ASCIICategory(
        id: "dividers",
        name: "Dividers",
        systemIcon: "minus",
        items: [
            ASCIIItem(id: "div1",        name: "Simple Line",    art: "─────────────────────"),
            ASCIIItem(id: "div2",        name: "Double Line",    art: "═════════════════════"),
            ASCIIItem(id: "div3",        name: "Star Line",      art: "★──────────────────────★"),
            ASCIIItem(id: "div4",        name: "Wavy",           art: "〜〜〜〜〜〜〜〜〜〜〜〜"),
            ASCIIItem(id: "div5",        name: "Dotted",         art: "· · · · · · · · · · · ·"),
            ASCIIItem(id: "div6",        name: "Hearts",         art: "♥─♥─♥─♥─♥─♥─♥─♥─♥"),
            ASCIIItem(id: "div7",        name: "Decorated",      art: "~•✦•~•✦•~•✦•~•✦•~"),
            ASCIIItem(id: "div8",        name: "Bracket",        art: "«──────────────────────»"),
            ASCIIItem(id: "div9",        name: "Floral",         art: "❀ ✿ ❀ ✿ ❀ ✿ ❀ ✿ ❀"),
            ASCIIItem(id: "div10",       name: "Bold",           art: "▬▬▬▬▬▬▬▬▬▬▬▬▬▬"),
            ASCIIItem(id: "div11",       name: "Dash Dot",       art: "─ · ─ · ─ · ─ · ─ · ─"),
            ASCIIItem(id: "div12",       name: "Chevron",        art: "»»»»»»»»»»»»»»»»»»»»"),
            ASCIIItem(id: "div13",       name: "Diamonds",       art: "◇ ◆ ◇ ◆ ◇ ◆ ◇ ◆ ◇"),
            ASCIIItem(id: "div14",       name: "Tilde Stars",    art: "~*~*~*~*~*~*~*~*~*~*~"),
        ]
    )

    static let art = ASCIICategory(
        id: "art",
        name: "Art",
        systemIcon: "paintbrush.fill",
        items: [
            ASCIIItem(id: "rose",        name: "Rose",           art: "@}->--"),
            ASCIIItem(id: "butterfly",   name: "Butterfly",      art: "ɛ>-<ɜ"),
            ASCIIItem(id: "explosion",   name: "Explosion",      art: "*°•.¸¸.•°*°•.¸¸.•°*"),
            ASCIIItem(id: "spaceship",   name: "Space Ship",     art: ">>=====>"),
            ASCIIItem(id: "sword",       name: "Sword",          art: "†───────────────"),
            ASCIIItem(id: "arrow",       name: "Fancy Arrow",    art: "─────────────►"),
            ASCIIItem(id: "trophy",      name: "Trophy",         art: "( trophy )"),
            ASCIIItem(id: "mountain",    name: "Mountain",       art: "  /\\  /\\\n /  \\/  \\"),
            ASCIIItem(id: "sun",         name: "Sun",            art: " \\  |  /\n──(☀)──\n /  |  \\"),
            ASCIIItem(id: "heart_art",   name: "Heart Art",      art: "♥♥♥  ♥♥♥\n♥♥♥♥♥♥♥\n ♥♥♥♥♥\n  ♥♥♥\n   ♥"),
            ASCIIItem(id: "shooting_star", name: "Shooting Star", art: "★彡"),
            ASCIIItem(id: "magic",       name: "Magic",          art: "°꒰˃͈꒵˂͈꒱°✧"),
        ]
    )

    static let textArt = ASCIICategory(
        id: "text",
        name: "Text",
        systemIcon: "textformat",
        items: [
            ASCIIItem(id: "hi",          name: "Hi",             art: "( ´ ▽ ` )ﾉ Hi!"),
            ASCIIItem(id: "bye",         name: "Bye",            art: "( ´ ▽ ` )ﾉ Bye!"),
            ASCIIItem(id: "goodmorning", name: "Good Morning",   art: "☀ Good Morning! ☀"),
            ASCIIItem(id: "goodnight",   name: "Good Night",     art: "🌙 Good Night ★"),
            ASCIIItem(id: "loveyou",     name: "Love You",       art: "I ♥ U"),
            ASCIIItem(id: "hbd",         name: "Happy Birthday", art: "♩♪ Happy Birthday ♪♩"),
            ASCIIItem(id: "lol",         name: "LOL",            art: "(≧∇≦)/ LOL"),
            ASCIIItem(id: "omglol",      name: "OMG LOL",        art: "OMG (o_O) LOL (≧▽≦)"),
            ASCIIItem(id: "shhh",        name: "Shh",            art: "(~˘▾˘)~ ♪ shhh ♪"),
            ASCIIItem(id: "nope",        name: "Nope",           art: "ᕙ(⇀‸↼‶)ᕗ Nope."),
            ASCIIItem(id: "yolo",        name: "YOLO",           art: "ᕦ(ò_óˇ)ᕤ YOLO"),
            ASCIIItem(id: "brb",         name: "BRB",            art: "ᕕ( ᐛ )ᕗ BRB"),
        ]
    )
}
