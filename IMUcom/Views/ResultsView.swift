import SwiftUI

struct ResultsView: View {
    @Environment(\.dismiss) var dismiss // Dismiss the view
    @StateObject private var repository = RepositoryController() // Initialize RepositoryController

    var body: some View {
        NavigationView {
            VStack {
                // File List
                List {
                    ForEach(repository.files, id: \.self) { file in
                        Button(action: {
                            handleFileSelection(file: file)
                        }) {
                            HStack {
                                Image(systemName: "doc.text")
                                Text(file.lastPathComponent)
                                    .lineLimit(1)
                                Spacer()
                            }
                            .padding(.vertical, 5)
                            .background(file == repository.selectedFile ? Color.blue.opacity(0.3) : Color.clear) // Highlight selected file
                            .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .listStyle(PlainListStyle())
                .frame(height: 200) // Restrict file list height

                // Table Title
                if repository.selectedFile != nil {
                    Text("Contents of \(repository.selectedFile?.lastPathComponent ?? "")")
                        .font(.headline)
                        .padding()
                }

                // Scrollable Table - Only visible if a file is selected
                if !repository.tableData.isEmpty {
                    ScrollView([.horizontal, .vertical]) {
                        VStack(alignment: .leading) {
                            // Table Header
                            HStack {
                                Text("AccX").bold().frame(width: 100, alignment: .leading)
                                Text("AccY").bold().frame(width: 100, alignment: .leading)
                                Text("AccZ").bold().frame(width: 100, alignment: .leading)
                                Text("FilteredAccX").bold().frame(width: 100, alignment: .leading)
                                Text("FilteredAccY").bold().frame(width: 100, alignment: .leading)
                                Text("FilteredAccZ").bold().frame(width: 100, alignment: .leading)
                                Text("ComputedAngle").bold().frame(width: 100, alignment: .leading)
                            }
                            .padding(.horizontal)
                            .background(Color.gray.opacity(0.2))

                            Divider()

                            // Table Rows
                            ForEach(repository.tableData, id: \.computedAngle) { row in
                                HStack {
                                    Text(row.accX).frame(width: 100, alignment: .leading)
                                    Text(row.accY).frame(width: 100, alignment: .leading)
                                    Text(row.accZ).frame(width: 100, alignment: .leading)
                                    Text(row.filteredAccX).frame(width: 100, alignment: .leading)
                                    Text(row.filteredAccY).frame(width: 100, alignment: .leading)
                                    Text(row.filteredAccZ).frame(width: 100, alignment: .leading)
                                    Text(row.computedAngle).frame(width: 100, alignment: .leading)
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .border(Color.gray, width: 1)
                    .cornerRadius(8)
                    .padding()
                }

                Spacer()

                // Close Button
                Button(action: {
                    dismiss() // Close the ResultsView
                }) {
                    Text("Close")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding()
                }
            }
            .navigationTitle("Available Documents")
        }
    }

    // MARK: - Handle File Selection Logic
    private func handleFileSelection(file: URL) {
        if repository.selectedFile == file {
            repository.deselectFile()
        } else {
            repository.loadFileContent(file: file)
        }
    }
}
