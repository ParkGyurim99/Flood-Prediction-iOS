//
//  RelatedInformation.swift
//  Flood Prediction
//
//  Created by Park Gyurim on 2022/06/20.
//

import Foundation

struct RelatedData : Hashable {
    var title : String
    var link : String
    
    static let dummies = [ RelatedData(title: "자연재난행동요령(침수) [국민재난안전포털]",
                                       link: "https://www.safekorea.go.kr/idsiSFK/neo/sfk/cs/contents/prevent/prevent21.html?menuSeq=126"),
                           RelatedData(title: "재난안전 - 홍수 및 태풍 발생시 대처요령",
                                       link: "https://m.post.naver.com/viewer/postView.nhn?volumeNo=17438482&memberNo=19462446"),
                           RelatedData(title: "가옥 침수 시 대피요령 : KBS 뉴스",
                                       link: "https://news.kbs.co.kr/news/view.do?ncd=4512904"),
                           RelatedData(title: "여름철 침수피해, 상황별 맞춤 대응법은? : 행정안전부",
                                       link: "https://www.mois.go.kr/frt/bbs/type010/commonSelectBoardArticle.do?bbsId=BBSMSTR_000000000008&nttId=42409") ]
}



