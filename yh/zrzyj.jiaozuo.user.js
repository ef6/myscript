// ==UserScript==
// @name         焦作市自然资源交易系统显示单价
// @description  焦作市自然资源网上交易系统显示单价
// @author       evan
// @namespace    https://ef6.github.io
// @license      GPL3.0
// @date         2022.01.18
// @modified     2022.02.10
// @version      1.2.0
// @icon         http://zrzyj.jiaozuo.gov.cn/favicon.ico
// @match        http*://jy.zrzyj.jiaozuo.gov.cn*/trade-engine/trade/resources*
// @match        http*://jy.zrzyj.jiaozuo.gov.cn*/trade-engine/trade/collectiveresources*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
    function displayMu(){
        console.log("DOMNodeInserted");
        Array.from(document.querySelectorAll(".resource-list"))
          .forEach((Elem) => {
            if(! Elem.querySelector(".hasMu") && Elem.querySelector("span[ng-bind*=CRMJ]") && Elem.querySelector("span[ng-bind*=ZGBJ]")){
            let mj=Elem.querySelector("span[ng-bind*=CRMJ]").innerText;
            let jg=Elem.querySelector("span[ng-bind*=ZGBJ]").innerText.slice(1);
            if(mj>0 && jg>0){
                let dj=(jg*10000)/mj;
                let djm=dj/15;
                let el = document.createElement('a');
                el.className="hasMu font-bold";
                el.innerHTML=String.format("<i>{0} 元/㎡</i><a>&nbsp;</a><i>{1} 万元/亩</i>",dj.toFixed(0),djm.toFixed(1));
                Elem.querySelector(".resource-list-header").append(el)
            }
            }
        });
    }
    document.querySelector(".land-list-container").addEventListener("DOMNodeInserted", displayMu);
})();
