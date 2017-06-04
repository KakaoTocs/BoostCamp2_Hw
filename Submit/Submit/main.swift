import Foundation


func main(){
    let readFileName = "students.json"
    let writeFileName = "result.txt"
    
    var studentsInfo: Dictionary<String, Any> = [String: Any]()
    //Set fileUrl
    var dir = FileManager.default.urls(for: .userDirectory, in: .localDomainMask).first
    dir?.appendPathComponent(NSUserName())
    //json file reading
    let readText = ReadJsonFile(fileName: readFileName, directoryPath: dir!)
    let jsonTemp = JsonParsing(text: readText, studentsInfo: &studentsInfo)
    WriteJsonFIle(fileName: writeFileName, writeDirectoryPath: dir!, jsonT: jsonTemp, studentsInfo: studentsInfo)
}


func ReadJsonFile(fileName: String, directoryPath: URL) -> String {
    let filePath = directoryPath.appendingPathComponent(fileName)
    var readText: String = ""
    do {
        readText = try! String(contentsOf: filePath, encoding: String.Encoding.utf8)
    }catch {
        print(Error.self)
    }
    return readText
}


func WriteJsonFIle(fileName: String, writeDirectoryPath: URL, jsonT: Array<Any>, studentsInfo: Dictionary<String, Any>) {
    let writeFilePath = writeDirectoryPath.appendingPathComponent(fileName)
    var writeText: String = ""
    var passStudent = [String]()
    
    var sum: Float = 0
    for score in studentsInfo.values{
        sum += score as! Float
    }
    
    let totalScore = String(format: "%.2f", sum/(Float((jsonT.count))))
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
    do {
        try writeText.write(to: writeFilePath, atomically: false, encoding: String.Encoding.utf8)
    } catch {
        print(Error.self)
    }
}

func JsonParsing(text: String, studentsInfo: inout Dictionary<String, Any>) -> Array<Any> {
    var subjectBoard: Set = Set<String>()
    let fileData = text.data(using: String.Encoding.utf8)
    var firstRessult: Array<Any>? = nil
    
    do {
        firstRessult = try JSONSerialization.jsonObject(with: fileData!) as? Array<Any>
        
        for i in 0...(firstRessult?.count)!-1 {
            var studentInfo = firstRessult?[i] as? [String: Any]
            var scoreSum: Float = 0
            var gradeBoard = studentInfo?["grade"] as! [String: Any]
            
            for subject: String in gradeBoard.keys {
                scoreSum += gradeBoard[subject]! as! Float
            }
            studentsInfo[String((studentInfo?["name"] as? String)!)] = scoreSum/Float(gradeBoard.count)
        }
    } catch {
        print(Error.self)
    }
    return firstRessult!
}

main()
