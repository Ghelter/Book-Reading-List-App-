//
//  ContentView.swift
//  FinalProject
//
//  Created by andres siri on 11/29/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @State private var isShowingAddBookView = false
    @Query(sort: \Book.author) var books: [Book]
    @State private var bookToEdit: Book?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
           BookingCell(book: book)
                        .onTapGesture {
/* Edit */               bookToEdit = book
                        }
                }
 /* Delete */               .onDelete { indexSet in
                    for index in indexSet {
                        context.delete(books[index])
                    }
                }
            }
            .navigationTitle("Reading List")
            .frame(maxWidth: .infinity, alignment: .center)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingAddBookView = true
                    } label: {
                        Label("Add Book", systemImage: "book")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddBookView) {
                AddReadingBook()
            }
            .sheet(item: $bookToEdit) { book in
                EditReadingBook(book: book)
            }
            .overlay {
                if books.isEmpty {
                    ContentUnavailableView(
                        label: {
                            Label("Add book", systemImage: "book.open.fill")
                        },
                        description: {
                            Text("Add a book to your reading list to get started.")
                        },
                        actions: {
                            Button {
                                isShowingAddBookView = true
                            } label: {
                                Text("Add Book")
                            }
                        }
                    )
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

// MARK: - BookingCell
struct BookingCell: View {
    let book: Book

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(book.title).font(.headline)
                Text(book.author).font(.subheadline).foregroundColor(.secondary)
                Text(book.genre).font(.caption).foregroundColor(.secondary)
            }
            Spacer()
            Text(book.price, format: .currency(code: "USD"))
                .font(.subheadline)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - AddReadingBook
struct AddReadingBook: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var genre: String = ""
    @State private var price: Double = 0
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                TextField("Author", text: $author)
                TextField("Genre", text: $genre)
                TextField("Price", value: $price, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("New Book")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let book = Book(title: title, author: author, genre: genre, price: price)
                        context.insert(book)
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - EditReadingBook
struct EditReadingBook: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Bindable var book: Book
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $book.title)
                TextField("Author", text: $book.author)
                TextField("Genre", text: $book.genre)
                TextField("Price", value: $book.price, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Edit Book")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
