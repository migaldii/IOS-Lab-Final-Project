import SwiftUI

// ─────────────────────────────────────────
// MARK: - Data Models
// ─────────────────────────────────────────

struct Article: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let publication: String
    let author: String
    let category: Category
    let imageName: String     // SF Symbol names used as placeholder images
    let isShared: Bool
}

enum Category: String, CaseIterable, Identifiable {
    case all          = "All"
    case articles     = "Articles"
    case videos       = "Videos"
    case podcasts     = "Podcasts"
    case newsletters  = "Newsletters"
    case papers       = "Papers"

    var id: String { self.rawValue }

    var icon: String {
        switch self {
        case .all:          return "square.grid.2x2"
        case .articles:     return "doc.text"
        case .videos:       return "play.rectangle"
        case .podcasts:     return "headphones"
        case .newsletters:  return "envelope"
        case .papers:       return "graduationcap"
        }
    }
}

// ─────────────────────────────────────────
// MARK: - Sample Data
// ─────────────────────────────────────────

let sampleArticles: [Article] = [
    Article(
        title: "She's Not Cleaning the House. She's Cleaning Her Head",
        subtitle: "Sometimes the mess that needs fixing isn't on the floor",
        publication: "A Thousand Little Thoughts",
        author: "keng",
        category: .articles,
        imageName: "leaf.fill",
        isShared: false
    ),
    Article(
        title: "Mankind... Descent, Ascent or Extinction?",
        subtitle: "Where did we come from? How did we get here? Where are we going?",
        publication: "The Pub",
        author: "Qwerty",
        category: .articles,
        imageName: "globe.americas.fill",
        isShared: false
    ),
    Article(
        title: "Like asymptotes, we almost had it",
        subtitle: "We had everything, but the universe had planned for us to meet — just not bound to be.",
        publication: "archivys",
        author: "archivys",
        category: .articles,
        imageName: "sparkles",
        isShared: false
    ),
    Article(
        title: "To Be or... Not To Be!",
        subtitle: "For me, it has got 'To Be' for... I am nothing without 'my Being'.",
        publication: "The Pillionaire Diary",
        author: "SK Sharma",
        category: .articles,
        imageName: "quote.bubble.fill",
        isShared: false
    ),
    Article(
        title: "How to Enhance Your Web Design Skills Effectively",
        subtitle: "Practical tips to level up your design game",
        publication: "Design Weekly",
        author: "Sarah K.",
        category: .articles,
        imageName: "paintbrush.fill",
        isShared: true
    ),
    Article(
        title: "I tried designing with Claude and Figma for 3 days — here's what I learned",
        subtitle: "An honest look at AI-assisted design workflows",
        publication: "UX Collective",
        author: "Marco T.",
        category: .articles,
        imageName: "cpu",
        isShared: true
    ),
    Article(
        title: "Google says \"Vibe Design\" is here, but it didn't pass my vibe check",
        subtitle: "A critical take on the latest design trend making rounds",
        publication: "Design Matters",
        author: "Priya M.",
        category: .articles,
        imageName: "wand.and.stars",
        isShared: true
    ),
    Article(
        title: "The Future of Spatial Audio in Podcasting",
        subtitle: "How 3D sound is changing the listening experience",
        publication: "Sound Lab",
        author: "DJ Fresh",
        category: .podcasts,
        imageName: "waveform",
        isShared: false
    ),
    Article(
        title: "SwiftUI Animations Deep Dive",
        subtitle: "Master fluid animations in your iOS apps",
        publication: "Swift Academy",
        author: "Apple Dev",
        category: .videos,
        imageName: "play.circle.fill",
        isShared: false
    ),
]

// ─────────────────────────────────────────
// MARK: - Root ContentView
// ─────────────────────────────────────────

struct ContentView: View {
    @State private var selectedCategory: Category = .all
    @State private var searchText: String = ""

    var filteredRecent: [Article] {
        let recent = sampleArticles.filter { !$0.isShared }
        if selectedCategory == .all { return recent }
        return recent.filter { $0.category == selectedCategory }
    }

    var filteredShared: [Article] {
        let shared = sampleArticles.filter { $0.isShared }
        if selectedCategory == .all { return shared }
        return shared.filter { $0.category == selectedCategory }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    // Search bar
                    SearchBar(text: $searchText)
                        .padding(.horizontal)
                        .padding(.top, 8)

                    // Category chips (horizontal scroll)
                    CategoryChipsRow(selected: $selectedCategory)
                        .padding(.top, 12)

                    // Recently Saved section
                    if !filteredRecent.isEmpty {
                        SectionHeader(title: "Recently Saved", icon: "📌")
                            .padding(.top, 24)
                            .padding(.horizontal)

                        LazyVGrid(
                            columns: [GridItem(.flexible()), GridItem(.flexible())],
                            spacing: 16
                        ) {
                            ForEach(filteredRecent) { article in
                                ArticleCard(article: article)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 12)
                    }

                    // Shared With You section
                    if !filteredShared.isEmpty {
                        SectionHeader(title: "Shared With You", icon: "🔗")
                            .padding(.top, 32)
                            .padding(.horizontal)

                        VStack(spacing: 12) {
                            ForEach(filteredShared) { article in
                                SharedArticleRow(article: article)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 12)
                    }

                    Spacer(minLength: 40)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("ReadLater")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                // Add new link button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // TODO: Add your "save new link" action here
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
        }
    }
}

// ─────────────────────────────────────────
// MARK: - Search Bar
// ─────────────────────────────────────────

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField("Search articles, videos...", text: $text)
                .font(.subheadline)
        }
        .padding(10)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

// ─────────────────────────────────────────
// MARK: - Category Chips (horizontal scroll)
// ─────────────────────────────────────────

struct CategoryChipsRow: View {
    @Binding var selected: Category

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(Category.allCases) { cat in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selected = cat
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: cat.icon)
                                .font(.caption)
                            Text(cat.rawValue)
                                .font(.subheadline.weight(.medium))
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            selected == cat
                                ? Color.accentColor
                                : Color(.secondarySystemBackground)
                        )
                        .foregroundColor(
                            selected == cat ? .white : .primary
                        )
                        .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

// ─────────────────────────────────────────
// MARK: - Section Header
// ─────────────────────────────────────────

struct SectionHeader: View {
    let title: String
    let icon: String

    var body: some View {
        HStack(spacing: 6) {
            Text(icon)
            Text(title)
                .font(.title3.bold())
        }
    }
}

// ─────────────────────────────────────────
// MARK: - Article Card (2-column grid)
// ─────────────────────────────────────────

struct ArticleCard: View {
    let article: Article

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Placeholder image with gradient
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        LinearGradient(
                            colors: [Color.accentColor.opacity(0.7), Color.accentColor.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 100)
                Image(systemName: article.imageName)
                    .font(.largeTitle)
                    .foregroundColor(.white.opacity(0.85))
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                // Publication name
                Text(article.publication)
                    .font(.caption2.weight(.semibold))
                    .foregroundColor(.accentColor)
                    .lineLimit(1)
                    .padding(.top, 8)

                // Article title
                Text(article.title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(3)
                    .foregroundColor(.primary)

                // Short subtitle
                Text(article.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .padding(.top, 2)
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 12)
        }
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }
}

// ─────────────────────────────────────────
// MARK: - Shared Article Row (full width)
// ─────────────────────────────────────────

struct SharedArticleRow: View {
    let article: Article

    var body: some View {
        HStack(alignment: .top, spacing: 14) {

            // Icon thumbnail
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.accentColor.opacity(0.12))
                    .frame(width: 56, height: 56)
                Image(systemName: article.imageName)
                    .font(.title2)
                    .foregroundColor(.accentColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(article.publication)
                    .font(.caption2.weight(.semibold))
                    .foregroundColor(.accentColor)
                Text(article.title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(2)
                Text(article.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            // Save button
            Image(systemName: "bookmark")
                .foregroundColor(.secondary)
                .padding(.top, 2)
        }
        .padding(14)
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }
}

// ─────────────────────────────────────────
// MARK: - Preview
// ─────────────────────────────────────────

#Preview {
    ContentView()
}

