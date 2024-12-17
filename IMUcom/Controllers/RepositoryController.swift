import Foundation

class RepositoryController: ObservableObject {
    @Published var files: [URL] = [] // List of available JSON files
    @Published var tableData: [CSVModel] = [] // Decoded table data
    @Published var selectedFile: URL? = nil // Currently selected file

    init() {
        fetchJSONFiles()
    }

    /// Fetch all JSON files from the app's Documents Directory
    func fetchJSONFiles() {
        let fileManager = FileManager.default
        let documentsURL = getDocumentsDirectory()

        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            files = fileURLs.filter { $0.pathExtension == "json" } // Filter JSON files
        } catch {
            print("Error fetching files: \(error.localizedDescription)")
            files = []
        }
    }

    /// Load content of the selected JSON file
    func loadFileContent(file: URL) {
        do {
            let jsonData = try Data(contentsOf: file)
            let decoder = JSONDecoder()
            tableData = try decoder.decode([CSVModel].self, from: jsonData)
            selectedFile = file
        } catch {
            print("Error loading file content: \(error.localizedDescription)")
            tableData = []
            selectedFile = nil
        }
    }

    /// Deselect the currently selected file
    func deselectFile() {
        selectedFile = nil
        tableData = []
    }

    /// Get Documents Directory Path
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
