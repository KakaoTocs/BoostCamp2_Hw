import Foundation

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

func JsonParsing(text: String, studentsInfo: inout Dictionary<String, Any>) -> Array<Any> {
    let fileData = text.data(using: String.Encoding.utf8)
    var students: Array<Any>? = nil
    
    do {
        students = try JSONSerialization.jsonObject(with: fileData!) as? Array<Any>
        
        for i in 0...(students?.count)!-1 {
            var studentInfo = students?[i] as? [String: Any]
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
    return students!
}

func ScoreToClass(score: Int) -> String{
    switch score/10*10 {
    case 100, 90:
        let scoreClass = "A"
        return scoreClass
    case 80:
        let scoreClass = "B"
        return scoreClass
    case 70:
        let scoreClass = "C"
        return scoreClass
    case 60:
        let scoreClass = "D"
        return scoreClass
    default:
        let scoreClass = "F"
        return scoreClass
    }
}

func CheckTestScore(students: Array<Any>, studentsInfo: Dictionary<String, Any>) -> String {
    var writeText: String = ""
    var passStudent = [String]()
    
    var sum: Float = 0
    for score in studentsInfo.values{
        sum += score as! Float
    }
    
    let totalScore = String(format: "%.2f", sum/(Float((students.count))))
    writeText.append("성적결과표\n\n전체 평균 : \(totalScore)\n\n개인별 학점\n")
    
    let studentsInfoKey = studentsInfo.keys.sorted(by: <)
    for keys in studentsInfoKey {
        let name = (keys as NSString).utf8String
        let score = Int(studentsInfo[keys] as! Float)
        let scoreClass = ScoreToClass(score: score)
        
        if scoreClass <= "C" {
            passStudent.append(keys)
        }
        
        let text:String = String(format: "%-11s: %@\n", name!, scoreClass)
        writeText.append(text)
    }
    
    writeText.append("\n수료생\n")
    for i in 0...(passStudent.count-1) {
        writeText.append(passStudent[i])
        
        if i < (passStudent.count-1) {
            writeText.append(", ")
        }
    }
    
    return writeText
}

func WriteJsonFIle(fileName: String, writeDirectoryPath: URL, writeText: String) {
    let writeFilePath = writeDirectoryPath.appendingPathComponent(fileName)
    
    do {
        try writeText.write(to: writeFilePath, atomically: false, encoding: String.Encoding.utf8)
    } catch {
        print(Error.self)
    }
}

func main(){
    let readFileName = "students.json"
    let writeFileName = "result.txt"
    var studentsInfo: Dictionary<String, Any> = [String: Any]()
    
    //Set fileUrl
    var dir = FileManager.default.urls(for: .userDirectory, in: .localDomainMask).first
    dir?.appendPathComponent(NSUserName())
    
    //json file read to String
    let readText = ReadJsonFile(fileName: readFileName, directoryPath: dir!)
    let students = JsonParsing(text: readText, studentsInfo: &studentsInfo)
    let writeText = CheckTestScore(students: students, studentsInfo: studentsInfo)
    
    //write result
    WriteJsonFIle(fileName: writeFileName, writeDirectoryPath: dir!, writeText: writeText)
}

main()
