//
//  ReturnPolicy.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 11/18/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation

import PDFKit
import FirebaseDatabase

class ReturnPolicy {
    
    static let shared = ReturnPolicy()
    
    func getReturnAgreement(completion: @escaping (NSMutableData) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let strongSelf = self else {return}
            
            strongSelf.fetchURL(completion: { url in
                
                strongSelf.startDownload(leaseurl: url, completion: { data in
                    
                    completion(data)
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
                
                completion(strongSelf.createPDFwithAttributedString(documentContent))
                
            }
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
    
    
    
    func fetchURL(completion: @escaping (String) -> Void) {
        Database.database().reference().child("App Documentation").child("Return Policy").observeSingleEvent(of: .value, with: { snap in
            let url = snap.value as! String
            completion(url)
            return
        })
    }
}
