import Foundation


func main(){
    let userName = "macbook"
    let readFileName = "students.json"
    let writeFileName = "result.txt"
    var readText = ""
    var writeText = ""
    let subjectBoard: Array<String> = ["operating_system", "data_structure", "algorithm", "database", "networking"]
    var passStudent = [String]()
    
    var studentsInfo: Dictionary<String, Any> = [String: Any]()
    
    if let dir = FileManager.default.urls(for: .userDirectory, in: .localDomainMask).first {
        //Read File Path
        let directoryPath = dir.appendingPathComponent(userName)
        let filePath = directoryPath.appendingPathComponent(readFileName)
        //Write File Path
        let writeDirectoryPath = dir.appendingPathComponent(userName)
        let writeFilePath = writeDirectoryPath.appendingPathComponent(writeFileName)
        
        do {
            //Reading
            readText = try! String(contentsOf: filePath, encoding: String.Encoding.utf8)
            //Encoding
            let fileData = readText.data(using: String.Encoding.utf8)
            let jsonT = try JSONSerialization.jsonObject(with: fileData!) as? [Any]
            for i in 0...(jsonT!.count)-1 {
                var json = jsonT?[i] as? [String: Any]
                
                var temp: Float = 0
                var gradeBoard = json?["grade"] as! [String: Any]
                
                for j in 0...subjectBoard.count-1 {
                    if let scoreTemp = gradeBoard[subjectBoard[j]]{
                        temp += scoreTemp as! Float
                    }
                }
                studentsInfo[String((json?["name"] as? String)!)] = temp/Float(gradeBoard.count)
            }
            //Write Submit File
            var sum: Float = 0
            for score in studentsInfo.values{
                sum += score as! Float
            }
            let totalScore = String(format: "%.2f", sum/(Float((jsonT?.count)!)))
            writeText.append("성적결과표\n\n전체 평균 : \(totalScore)\n\n개인별 학점\n")
            
            let studentsInfoKey = studentsInfo.keys.sorted(by: <)
            for keys in studentsInfoKey {
                let score = Int(studentsInfo[keys] as! Float)
                let key = (keys as NSString).utf8String
                var scoreA: String
                switch score/10*10 {
                case 100, 90:
                    scoreA = "A"
                    break
                case 80:
                    scoreA = "B"
                    break
                case 70:
                    scoreA = "C"
                    break
                case 60:
                    scoreA = "D"
                    break
                default:
                    scoreA = "F"
                    break
                }
                if score>=70 {
                    passStudent.append(keys)
                }
                let text:String = String(format: "%-11s: %@\n", key!, scoreA)
                writeText.append(text)
            }
            writeText.append("\n수료생\n")
            for i in 0...(passStudent.count-1) {
                writeText.append(passStudent[i])
                if i < (passStudent.count-1) {
                    writeText.append(", ")
                }
            }
            //Writing
            try writeText.write(to: writeFilePath, atomically: false, encoding: String.Encoding.utf8)
        } catch {
            print(Error.self)
        }
    }
}

main()
