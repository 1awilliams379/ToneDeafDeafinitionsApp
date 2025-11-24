//
//  MP3 Lease .swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/20/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation
import PDFKit
import FirebaseDatabase

class MP3Lease {
    
    static let shared = MP3Lease()
    
    var beatName = ""
    var producerLegalList:[String] = []
    var legalReplacement = ""
    var prodBy = ""
    
    
    func getLeaseAgreement(nameofbeat: String, producers: [String],completion: @escaping (NSMutableData) -> Void) {
        beatName = nameofbeat
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.getProducerData(producerArray: producers, completion: {[weak self] names,legals in
                guard let strongSelf = self else {return}
                strongSelf.setLegalString(names: names, legals: legals)
                strongSelf.setProdBy(names: names)
                
                strongSelf.fetchURL(completion: { url in
                    
                    strongSelf.startDownload(leaseurl: url, completion: { data in
                        
                        completion(data)
                    })
                })
            })
        }
    }
    
    func startDownload(leaseurl: String,completion: @escaping (NSMutableData) -> Void) {
        DispatchQueue.global().async {[weak self] in
            guard let strongSelf = self else {return}
            if let pdf = PDFDocument(url: URL(string: leaseurl)!) {
                let pageCount = pdf.pageCount
                let documentContent = NSMutableAttributedString()

                for i in 0 ..< pageCount {
                    guard let page = pdf.page(at: i) else { continue }
                    guard let pageContent = page.attributedString else { continue }
                    documentContent.append(pageContent)
                }
                strongSelf.setLeaseText(lease: NSAttributedString(attributedString: documentContent), completion: { data in
                    
                    completion(data)
                })
                
            }
        }
        
        
    }
    
    
    
    func setLeaseText(lease: NSAttributedString,completion: @escaping (NSMutableData) -> Void) {
        DispatchQueue.global().async {[weak self] in
            guard let strongSelf = self else {return}
            let date =  getCurrentLocalDate()
            // Set new attributed string
            let newlease = lease.stringWithString(stringToReplace: "%ORDER_DATE%", replacedWithString: date).stringWithString(stringToReplace: "%BEAT_NAME%", replacedWithString: strongSelf.beatName).stringWithString(stringToReplace: "%CLIENT_NAME%", replacedWithString: currentAppUser.name).stringWithString(stringToReplace: "%LICENSOR_LEGALS%", replacedWithString: strongSelf.legalReplacement).stringWithString(stringToReplace: "%PROD_BY%", replacedWithString: strongSelf.prodBy)
            print(newlease)
            let pdfData = strongSelf.createPDFwithAttributedString(newlease)
            completion(pdfData)
        }
    }
        
        func createPDFwithAttributedString(_ currentText: NSAttributedString) -> NSMutableData {
            let pdfData = NSMutableData()

            // Create the PDF context using the default page size of 612 x 792.
            UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, nil)

            let framesetter = CTFramesetterCreateWithAttributedString(currentText)

            var currentRange = CFRangeMake(0, 0);
            var currentPage = 0;
            var done = false;

            repeat {
                // Mark the beginning of a new page.
                UIGraphicsBeginPDFPageWithInfo(CGRect(x: 0, y: 0, width: 612, height: 792), nil);

                // Draw a page number at the bottom of each page.
                currentPage += 1;

                // Render the current page and update the current range to
                // point to the beginning of the next page.
                renderPagewithTextRange(currentRange: &currentRange, framesetter: framesetter)

                // If we're at the end of the text, exit the loop.
                if (currentRange.location == CFAttributedStringGetLength(currentText)){
                    done = true;
                }
            } while (!done);

            // Close the PDF context and write the contents out.
            UIGraphicsEndPDFContext();
            return pdfData
        }

        func renderPagewithTextRange (currentRange: inout CFRange,  framesetter: CTFramesetter) {
            // Get the graphics context.
            if let currentContext = UIGraphicsGetCurrentContext(){

                // Put the text matrix into a known state. This ensures
                // that no old scaling factors are left in place.
                currentContext.textMatrix = CGAffineTransform.identity;

                // Create a path object to enclose the text. Use 72 point
                // margins all around the text.
                let frameRect = CGRect(x: 72, y: 72, width: 468, height: 648);
                let framePath = CGMutablePath();
                framePath.addRect(frameRect)

                // Get the frame that will do the rendering.
                // The currentRange variable specifies only the starting point. The framesetter
                // lays out as much text as will fit into the frame.
                let frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, nil);

                // Core Text draws from the bottom-left corner up, so flip
                // the current transform prior to drawing.
                currentContext.translateBy(x: 0, y: 792);
                currentContext.scaleBy(x: 1.0, y: -1.0);

                // Draw the frame.
                CTFrameDraw(frameRef, currentContext);

                // Update the current range based on what was drawn.
                currentRange = CTFrameGetVisibleStringRange(frameRef);
                currentRange.location += currentRange.length;
                currentRange.length = 0;
            }
        }
        
    func setProdBy(names: [String]) {
        switch names.count {
        case 1:
            prodBy = "Produced by \(names[0])"
        case 2:
            prodBy = "Produced by \(names[0]) & \(names[1])"
        default:
            let last = names.last!
            var newarr = names
            newarr.remove(at: names.count-1)
            prodBy = "Produced by \(newarr.joined(separator: ", ")) & \(last)"
        }
    }
    
    func setLegalString(names: [String], legals: [String]) {
        switch names.count {
        case 1:
            legalReplacement = "and \(legals[0]), also professionally known as “\(names[0])” and/or “\(names[0]) Productions” and/or “\(names[0]) Beats”"
        case 2:
            legalReplacement = "and \(legals[0]), also professionally known as “\(names[0])” and/or “\(names[0]) Productions” and/or “\(names[0]) Beats”, and \(legals[1]), also professionally known as “\(names[1])” and/or “\(names[1]) Productions” and/or “\(names[1]) Beats”"
        default:
            producerLegalList = []
            for i in 0..<names.count {
                let bot = "and \(legals[i]), also professionally known as “\(names[i])” and/or “\(names[i]) Productions” and/or “\(names[i]) Beats”"
                producerLegalList.append(bot)
            }
            legalReplacement = producerLegalList.joined(separator: ", ")
        }
    }
    
    func fetchURL(completion: @escaping (String) -> Void) {
        Database.database().reference().child("App Documentation").child("MP3 Lease Agreement").observeSingleEvent(of: .value, with: { snap in
            let url = snap.value as! String
            completion(url)
            return
        })
    }
        
    func getProducerData(producerArray:[String], completion: @escaping (Array<String>,Array<String>) -> Void) {
        var producerNameData:Array<String> = []
        var producerLegals:Array<String> = []
        var val = 0
        for producer in producerArray {
            let word = producer.split(separator: "Æ")
            let id = word[0]
            DatabaseManager.shared.fetchPersonData(person: String(id), completion: { result in
                switch result {
                case .success(let selectedProducer):
                    producerNameData.append(selectedProducer.name!)
                    guard let legal = selectedProducer.legalName else {return}
                    producerLegals.append(legal)
                    //producerimageURLs.append(selectedProducer.spotifyProfileImageURL)
                    val+=1
                    if val == producerArray.count {
                        completion(producerNameData,producerLegals)
                    }
                case .failure(let err):
                    print("youyouerr", err)
                }
            })
        }
        
    }
}

extension NSAttributedString {
    func stringWithString(stringToReplace: String, replacedWithString newStringPart: String) -> NSMutableAttributedString
    {
        let mutableAttributedString = mutableCopy() as! NSMutableAttributedString
        let mutableString = mutableAttributedString.mutableString
        while mutableString.contains(stringToReplace) {
            let rangeOfStringToBeReplaced = mutableString.range(of: stringToReplace)
            mutableAttributedString.replaceCharacters(in: rangeOfStringToBeReplaced, with: newStringPart)
        }
        return mutableAttributedString
    }
}

