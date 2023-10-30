//
//  Presenter.swift
//  EmployeInfo
//
//  Created by Stoyan Kostov on 30.10.23.
//

import Foundation

private struct Employee: CustomStringConvertible {
    let id: Int
    let projectID: Int
    let period: DateInterval

    var description: String {
        "\(id), \(projectID), \(period)"
    }
}

private final class Project: CustomStringConvertible {
    let id: Int
    var employees: [Employee]

    internal init(id: Int, employees: [Employee]) {
        self.id = id
        self.employees = employees
    }

    var description: String {
        "\(id), \(employees)"
    }
}

final class Presenter {
    private weak var viewController: ViewControllerInput?

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        formatter.timeZone = TimeZone(identifier: "GMT")
        return formatter
    }()

    init(viewController: ViewControllerInput) {
        self.viewController = viewController
    }

    func processCSVFile(at url: URL) {
        if let rawFileContents = handleCSVFile(url: url) {
            let models = mapToModels(models: rawFileContents)
            let projects = mapToProjects(models: models)
            let overlap = findBiggestOverlap(from: projects)
            viewController?.display(viewModel: .init(
                firstEmployeeID: overlap.firstID,
                secondEmployeeID: overlap.secondID,
                projectID: overlap.projectID,
                daysWorkedTogether: overlap.daysWorked
            ))
        }
    }
}

private extension Presenter {
    func handleCSVFile(url: URL) -> [[String]]? {
        guard let contentsOfFile = try? String(contentsOf: url) else {
            return nil
        }
        var result: [[String]] = []
        let rows = contentsOfFile.components(separatedBy: "\n")
        rows.forEach { row in
            let columns = row.components(separatedBy: ",")
            var cells: [String] = []

            columns.forEach { column in
                let cell = column
                    .replacingOccurrences(
                        of: " ",
                        with: ""
                    )
                if cell != "" {
                    cells.append(cell)
                }
            }

            result.append(cells)
        }

        // Remove columns naming
        if !result.isEmpty {
            result.removeFirst()
        }
        return result
    }

    func mapToModels(models: [[String]]) -> [Employee] {
        models.compactMap { model in
            guard
                let id = model[safe: 0],
                let projectId = model[safe: 1],
                let dateFromString = model[safe: 2],
                let dateFrom = parseDateFrom(string: dateFromString)
            else {
                return nil
            }

            var dateTo: Date?

            if let date = model[safe: 3] {
                dateTo = parseDateFrom(string: date)
            }

            let today = Date.now

            return Employee(
                id: Int(id) ?? -1,
                projectID: Int(projectId) ?? -1,
                period: .init(start: dateFrom, end: dateTo ?? today)
            )
        }
    }

    func mapToProjects(models: [Employee]) -> [Project] {
        var projects: [Project] = []

        models.forEach { model in
            if let project = projects.first(where: { $0.id == model.projectID }) {
                project.employees.append(model)
            } else {
                projects.append(.init(id: model.projectID, employees: [model]))
            }
        }

        return projects
    }

    typealias Overlap = (firstID: Int, secondID: Int, projectID: Int, daysWorked: UInt)
    func findBiggestOverlap(from projects: [Project]) -> Overlap {
        var biggestOverlap: Overlap = (0, 0, 0, 0)

        projects.forEach { project in
            project.employees.enumerated().forEach { index, lhsEmployee in
                for j in (index + 1) ..< project.employees.count {
                    guard
                        let rhsEmployee = project.employees[safe: j],
                        doPeriodsOverlap(lhs: lhsEmployee.period, rhs: rhsEmployee.period)
                    else {
                        continue
                    }

                    let daysWorkedTogether = intersection(lhs: lhsEmployee.period, rhs: rhsEmployee.period)

                    if biggestOverlap.daysWorked < daysWorkedTogether {
                        biggestOverlap = (lhsEmployee.id, rhsEmployee.id, project.id, daysWorkedTogether)
                    }
                }
            }
        }

        return biggestOverlap
    }

    func doPeriodsOverlap(lhs: DateInterval, rhs: DateInterval) -> Bool {
        let lhsRange = lhs.start ... lhs.end
        let rhsRange = rhs.start ... rhs.end
        return lhsRange.overlaps(rhsRange)
    }

    func intersection(lhs: DateInterval, rhs: DateInterval) -> UInt {
        guard let duration = lhs.intersection(with: rhs) else {
            return .zero
        }

        return daysBetween(dateFrom: duration.start, dateTo: duration.end)
    }

    func parseDateFrom(string: String) -> Date? {
        let dateFormats = ["yyyy-MM-dd", "MM/dd/yyyy", "dd/MM/yyyy", "yyyy-MM-dd'T'HH:mm:ssZ"]
        guard let date = parseDate(from: string, withFormats: dateFormats) else {
            return nil
        }
        return date
    }

    func daysBetween(dateFrom: Date, dateTo: Date) -> UInt {
        let calendar = Calendar(identifier: .gregorian)

        let from = calendar.startOfDay(for: dateFrom)
        let to = calendar.startOfDay(for: dateTo)

        return UInt(calendar.dateComponents([.day], from: from, to: to).day ?? 0)
    }

    func parseDate(from dateString: String, withFormats formats: [String]) -> Date? {
        for format in formats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
        }
        return nil
    }
}

private extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
